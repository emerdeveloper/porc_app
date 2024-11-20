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

  Future<List<Map<String, dynamic>>?> fetchFeedHistory(String ownerId, String pigLotId) async {
    try {
      final res = await _fire
          .collection(collection)
          .where("pigLotId", isEqualTo: pigLotId)
          .where("ownerId", isEqualTo: ownerId)
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

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchFeedHistoryStream(String currentUserId) =>
      _fire
          .collection(collection)
          .where("pigLotId", isEqualTo: currentUserId)
          .snapshots();
}