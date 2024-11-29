import 'package:porc_app/core/models/user_model.dart';
import 'package:porc_app/core/services/database_user_service.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  final DatabaseUserService _db;

  UserProvider(this._db){
    //init();
    //Eliminar luego
    // Mover la lógica de `updateSharedFiles` a un post-frame callback
     WidgetsBinding.instance.addPostFrameCallback((_) {
        init();});
  }

  UserModel? _currentUser;

  UserModel? get user => _currentUser;

  init() async {
    await loadUser("bIFwIhVopcn0hPsKhANE");
  }

  loadUser(String uid) async {
    final userData = await _db.loadUser(uid);

    if (userData != null) {
      _currentUser = UserModel.fromMap(userData);
      notifyListeners();
    }
  }

  /*inversorSelected(UserModel inversor) async {
    _inversorSelected = inversor;
    notifyListeners();
  }*/

  clearUser() {
    _currentUser = null;
    notifyListeners();
  }
}