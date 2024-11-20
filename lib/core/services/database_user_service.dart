import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseUserService {
  final _fire = FirebaseFirestore.instance;
  final collection = "users";

  Future<void> saveUser(Map<String, dynamic> userData) async {
    try {
      await _fire.collection(collection).doc(userData["uid"]).set(userData);

      log("User saved successfully");
    } catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>?> loadUser(String uid) async {
    try {
      final res = await _fire.collection(collection).doc(uid).get();

      if (res.data() != null) {
        log("User fetched successfully");
        return res.data();
      }
    } catch (e) {
      rethrow;
    }
    return null;
  }

  Future<List<Map<String, dynamic>>?> fetchUsers(String currentUserId) async {
    try {
      final res = await _fire
          .collection(collection)
          .where("uid", isNotEqualTo: currentUserId)
          .get();

      return res.docs.map((e) {
        final data = e.data();
        data['id'] = e.id; // Agregar el ID del documento a los datos
        return data;
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchUserStream(
          String currentUserId) =>
      _fire
          .collection(collection)
          .where("uid", isNotEqualTo: currentUserId)
          .snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllUserStream() =>
      _fire
          .collection(collection)
          .snapshots();
}