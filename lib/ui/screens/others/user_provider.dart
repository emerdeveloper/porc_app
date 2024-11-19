import 'package:porc_app/core/models/user_model.dart';
import 'package:porc_app/core/services/database_user_service.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final DatabaseUserService _db;

  UserProvider(this._db);

  UserModel? _currentUser;
  UserModel? _inversorSelected;

  UserModel? get user => _currentUser;
  UserModel? get inversor => _inversorSelected;

  loadUser(String uid) async {
    final userData = await _db.loadUser(uid);

    if (userData != null) {
      _currentUser = UserModel.fromMap(userData);
      notifyListeners();
    }
  }

  inversorSelected(UserModel inversor) async {
    _inversorSelected = inversor;
    notifyListeners();
  }

  clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}