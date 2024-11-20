

import 'dart:developer';

import 'package:porc_app/core/enums/enums.dart';
import 'package:porc_app/core/models/feed_model.dart';
import 'package:porc_app/core/models/pig_lots_model.dart';
import 'package:porc_app/core/models/providers_model.dart';
import 'package:porc_app/core/other/base_viewmodel.dart';
import 'package:porc_app/core/services/database_feed_service.dart';

class FeedRequestViewmodel extends BaseViewmodel {
  final DatabaseFeedService _db;

  FeedRequestViewmodel(this._db);

  int _numberPackages = -1;


  void setNumberPackages(String value) {
    _numberPackages = int.parse(value);
    notifyListeners();

    log("NumberPackages: $_numberPackages");
  }


  save(PigLotsModel pigLot, PigFeedModel feedSelected) async {
    setstate(ViewState.loading);
    try {
        FeedModel feed = FeedModel(
            pigLotId: pigLot.id!, 
            ownerId: pigLot.ownerId!, 
            pigFeedName: feedSelected.name, 
            pigFeedPrice: feedSelected.price, 
            paymentDate: DateTime.now(), 
            numberPackages: _numberPackages,
            isPaymentDone: false,
            date: DateTime.now()
            );

        await _db.saveFeed(feed.toMap());

      setstate(ViewState.idle);
    } catch (e) {
      setstate(ViewState.idle);
      log(e.toString());
      rethrow;
    }
  }
}