import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:porc_app/core/utils/utilities.dart';

class DatabasePigLotsService {
  final _fire = FirebaseFirestore.instance;
  final collection = "pigLots";

  Future<void> savePigLot(Map<String, dynamic> pigLotData) async {
    try {
      await _fire.collection(collection).doc(Utilities.generateId()).set(pigLotData);

      log("PigLot saved successfully");
    } catch (e) {
      rethrow;
    }
  }

  Future<List<Map<String, dynamic>>?> fetchPigLots(String currentUserId) async {
    try {
      final res = await _fire
          .collection(collection)
          .where("ownerId", isEqualTo: currentUserId)
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

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchPigLotsStream(
          String currentUserId) =>
      _fire
          .collection(collection)
          .where("ownerId", isEqualTo: currentUserId)
          .snapshots();

  Stream<QuerySnapshot<Map<String, dynamic>>> fetchAllPigLotsStream() =>
      _fire
          .collection(collection)
          .snapshots();
}

