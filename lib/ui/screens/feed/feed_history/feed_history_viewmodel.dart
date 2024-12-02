import 'dart:developer';
import 'dart:io';

import 'package:porc_app/core/enums/enums.dart';
import 'package:porc_app/core/models/feed_model.dart';
import 'package:porc_app/core/models/pig_lots_model.dart';
import 'package:porc_app/core/other/base_viewmodel.dart';
import 'package:porc_app/core/services/database_feed_service.dart';
import 'package:porc_app/core/services/storage_service.dart';

class FeedHistoryViewmodel extends BaseViewmodel {
  final DatabaseFeedService _db;
  final StorageService _storage;

  FeedHistoryViewmodel(this._db, PigLotsModel pigLot, this._storage) {
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

  savePaymentFeed(File image ) async {
    setstate(ViewState.loading);
    try {
      String? downloadUrl;
      FeedModel feedSelected = _feedHistory[_selectedIndex!];

      downloadUrl = await _storage.uploadPaymentImage(image, feedSelected.ownerId, feedSelected.pigLotId);

      FeedModel feed = FeedModel(
        paymentUrl: downloadUrl,
        pigLotId: feedSelected.pigLotId,
        ownerId: feedSelected.ownerId,
        pigFeedName: feedSelected.pigFeedName,
        pigFeedPrice: feedSelected.pigFeedPrice,
        paymentDate: DateTime.now(),
        numberPackages: feedSelected.numberPackages,
        isPaymentDone: true,
        date: feedSelected.date);


        await _db.saveFeed(feed.toMap());

      setstate(ViewState.idle);
    } catch (e) {
      setstate(ViewState.idle);
      log(e.toString());
      rethrow;
    }
  }

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