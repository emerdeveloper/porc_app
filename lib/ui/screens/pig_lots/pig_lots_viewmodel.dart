import 'dart:developer';

import 'package:porc_app/core/enums/enums.dart';
import 'package:porc_app/core/models/pig_lots_model.dart';
import 'package:porc_app/core/models/user_model.dart';
import 'package:porc_app/core/other/base_viewmodel.dart';
import 'package:porc_app/core/services/database_pig_lots_services.dart';

class PigLotsViewmodel extends BaseViewmodel {
  final DatabasePigLotsService _db;
  final UserModel _currentUser;

  PigLotsViewmodel(this._db, this._currentUser) {
    fetchPigLots();
  }

  List<PigLotsModel> _pigLots = [];
  List<PigLotsModel> _filteredPigLots = [];

  List<PigLotsModel> get pigLots => _pigLots;
  List<PigLotsModel> get filteredPigLots => _filteredPigLots;

  search(String value) {
    _filteredPigLots =
        _pigLots.where((e) => e.loteName!.toLowerCase().contains(value)).toList();
    notifyListeners();
  }

  fetchPigLots() async {
    try {
      setstate(ViewState.loading);
      log(_currentUser.uid!);
      _db.fetchPigLotsStream(_currentUser.uid!).listen((data) {
        _pigLots = data.docs.map((e) => PigLotsModel.fromMap(e.data())).toList();
        _filteredPigLots = pigLots;
        notifyListeners();
      });
      setstate(ViewState.idle);
    } catch (e) {
      setstate(ViewState.idle);
      log("Error Fetching Pig lots: $e");
    }
  }
}