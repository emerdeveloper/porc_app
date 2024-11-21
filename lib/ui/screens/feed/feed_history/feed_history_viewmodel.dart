import 'dart:developer';

import 'package:porc_app/core/enums/enums.dart';
import 'package:porc_app/core/models/feed_model.dart';
import 'package:porc_app/core/models/pig_lots_model.dart';
import 'package:porc_app/core/models/providers_model.dart';
import 'package:porc_app/core/models/user_model.dart';
import 'package:porc_app/core/other/base_viewmodel.dart';
import 'package:porc_app/core/services/database_feed_service.dart';

class FeedHistoryViewmodel extends BaseViewmodel {
  final DatabaseFeedService _db;

  FeedHistoryViewmodel(this._db, PigLotsModel pigLot) {
    fetchFeedHistory(pigLot);
  }

  List<FeedModel> _feedHistory = [];

  List<FeedModel> get feedHistory => _feedHistory;

  fetchFeedHistory(PigLotsModel pigLot) async {
    try {
      setstate(ViewState.loading);
      log("owner: ${pigLot.ownerId!}");
      log("id lote: ${pigLot.id!}");
      final res = await _db.fetchFeedHistory(pigLot.ownerId!, pigLot.id!);

      if (res != null && res.length != 0) {
        log("Sucessfully feed history");
        _feedHistory = res.map((e) => FeedModel.fromMap(e)).toList();
      }
    } catch (e) {
      log("Error Fetching providers: $e");
    } finally {
      setstate(ViewState.idle);
      notifyListeners();
    }
  }
}