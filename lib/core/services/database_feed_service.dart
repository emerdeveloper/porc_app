import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:porc_app/core/utils/utilities.dart';

class DatabaseFeedService {
  final _fire = FirebaseFirestore.instance;
  final collection = "feed";

  Future<void> saveFeed(Map<String, dynamic> feed) async {
    try {
      await _fire.collection(collection).doc(Utilities.generateId()).set(feed);

      log("Feed saved successfully");
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchUsers(String currentUserId) async {
    try {
      final res = await _fire
          .collection(collection)
          .where("uid", isNotEqualTo: currentUserId)
          .get();

      return res.docs.map((e) => e.data()).toList();
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