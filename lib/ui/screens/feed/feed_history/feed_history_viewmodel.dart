import 'dart:developer';

import 'package:porc_app/core/enums/enums.dart';
import 'package:porc_app/core/models/feed_model.dart';
import 'package:porc_app/core/models/pig_lots_model.dart';
import 'package:porc_app/core/other/base_viewmodel.dart';
import 'package:porc_app/core/services/database_feed_service.dart';

class FeedHistoryViewmodel extends BaseViewmodel {
  final DatabaseFeedService _db;

  FeedHistoryViewmodel(this._db, PigLotsModel pigLot) {
    fetchFeedHistory(pigLot);
  }

  int? _selectedIndex;
  List<FeedModel> _feedHistory = [];
  Map<String, List<FeedModel>> _groupedByFeedName = {};

  List<bool> _expanded = [];
  List<bool> get expanded => _expanded;

  List<FeedModel> get feedHistory => _feedHistory;
  Map<String, List<FeedModel>> get groupedByFeedName => _groupedByFeedName;
  // Getter para obtener el índice seleccionado
  int? get selectedIndex => _selectedIndex;

  int get totalPackages =>
      _feedHistory.fold(0, (sum, feed) => sum + feed.numberPackages);

  double get totalPrice => _feedHistory.fold(
        0.0,
        (sum, feed) => sum + (feed.pigFeedPrice * feed.numberPackages),
      );

  fetchFeedHistory(PigLotsModel pigLot) async {
    try {
      setstate(ViewState.loading);
      log("owner: ${pigLot.ownerId!}");
      log("id lote: ${pigLot.id!}");
      final res = await _db.fetchFeedHistory(pigLot.ownerId!, pigLot.id!);

      if (res != null && res.isNotEmpty) {
        log("Sucessfully feed history");
        // Transformar y agrupar en un solo paso
      _feedHistory = res.map((e) => FeedModel.fromMap(e)).toList();

        _groupedByFeedName = {};
        for (var feed in _feedHistory) {
          _groupedByFeedName
              .putIfAbsent(feed.pigFeedName, () => [])
              .add(feed);
        }
        // Inicializar el estado de expansión para cada grupo
        _expanded = List.generate(_groupedByFeedName.length, (_) => false);
      }
    } catch (e) {
      log("Error Fetching providers: $e");
    } finally {
      setstate(ViewState.idle);
      notifyListeners();
    }
  }

/*  Map<String, List<FeedModel>> _groupFeedsByName(List<FeedModel> feeds) {
    return feeds.fold<Map<String, List<FeedModel>>>(
      {},
      (map, feed) {
        map.putIfAbsent(feed.pigFeedName, () => []).add(feed);
        return map;
      },
    );
  }*/

  void toggleExpanded(int index) {
    _expanded[index] = !_expanded[index];
    notifyListeners();
  }

  // Método para seleccionar/deseleccionar un elemento
  void selectFeed(int index) {
    if (_feedHistory[index].isPaymentDone == false) {
      // Alternar la selección del índice
      _selectedIndex = (_selectedIndex == index) ? null : index;
      notifyListeners();
    }
  }
}