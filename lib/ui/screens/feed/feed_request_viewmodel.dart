

import 'dart:developer';

import 'package:porc_app/core/enums/enums.dart';
import 'package:porc_app/core/models/feed_model.dart';
import 'package:porc_app/core/models/pig_lots_model.dart';
import 'package:porc_app/core/other/base_viewmodel.dart';
import 'package:porc_app/core/services/database_feed_service.dart';

class FeedRequestViewmodel extends BaseViewmodel {
  final DatabaseFeedService _db;

  FeedRequestViewmodel(this._db);

  String _name = "";
  String _email = "";
  String _password = "";
  String _confirmPassword = "";


  void setName(String value) {
    _name = value;
    notifyListeners();

    log("Name: $_name");
  }

  void setEmail(String value) {
    _email = value;
    notifyListeners();

    log("Email: $_email");
  }

  setPassword(String value) {
    _password = value;
    notifyListeners();

    log("Password: $_password");
  }

  setConfirmPassword(String value) {
    _confirmPassword = value;
    notifyListeners();

    log("Confirm Password: $_confirmPassword");
  }

  save(PigLotsModel pigLot) async {
    setstate(ViewState.loading);
    try {
        FeedModel feed = FeedModel(
            pigLotId: pigLot.id!, 
            pigFeedName: "_name", 
            pigFeedPrice: 20.00, 
            paymentDate: DateTime.now(), 
            numberPackages: 20,
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