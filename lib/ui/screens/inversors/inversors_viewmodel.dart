import 'dart:developer';

import 'package:porc_app/core/enums/enums.dart';
import 'package:porc_app/core/models/user_model.dart';
import 'package:porc_app/core/other/base_viewmodel.dart';
import 'package:porc_app/core/services/database_user_service.dart';

class InversorsViewmodel extends BaseViewmodel {
  final DatabaseUserService _db;
  final UserModel? _currentUser;

  InversorsViewmodel(this._db, this._currentUser) {
    fetchUsers();
  }

  List<UserModel> _users = [];
  List<UserModel> _filteredUsers = [];

  List<UserModel> get users => _users;
  List<UserModel> get filteredUsers => _filteredUsers;

  search(String value) {
    _filteredUsers =
        _users.where((e) => e.name!.toLowerCase().contains(value)).toList();
    notifyListeners();
  }

  fetchUsers() async {
    try {
      setstate(ViewState.loading);

      //_db.fetchUserStream(_currentUser.uid!).listen((data) { EME
      _db.fetchAllUserStream().listen((data) {
        _users = data.docs.map((e) => UserModel.fromMap(e.data())).toList();
        _filteredUsers = users;
        notifyListeners();
      });
      setstate(ViewState.idle);
    } catch (e) {
      setstate(ViewState.idle);
      log("Error Fetching inversors: $e");
    }
  }
}