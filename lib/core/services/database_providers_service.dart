import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseProvidersService {
  final _fire = FirebaseFirestore.instance;
  final collection = "providers";
  final collectionPigFeed = "pigFeed";

  Future<void> saveProvider(Map<String, dynamic> userData) async {
    try {
      await _fire.collection(collection).doc(userData["uid"]).set(userData);

      log("Provider saved successfully");
    } catch (e) {
      rethrow;
    }
  }


  Future<List<Map<String, dynamic>>?> fetchAllProviders() async {
    try {
      final res = await _fire
          .collection(collection)
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

  Future<List<Map<String, dynamic>>?> fetchAllProvidersWithPigFeed() async {
    try {
      final providersSnapshot = await _fire.collection(collection).get();

      // Iterar sobre cada documento de la colección 'providers'
      final providersWithPigFeed = await Future.wait(providersSnapshot.docs.map((providerDoc) async {
        // Información del documento principal
        final providerData = providerDoc.data();

        // Obtener la subcolección 'pigFeed' de este documento
        final pigFeedSnapshot = await providerDoc.reference.collection(collectionPigFeed).get();

        // Mapear los datos de la subcolección
        final pigFeedData = pigFeedSnapshot.docs.map((e) => e.data()).toList();

        // Añadir la información de 'pigFeed' al documento principal
        return {
          ...providerData,
          'pigFeed': pigFeedData,
        };
      }).toList());

      return providersWithPigFeed;
    } catch (e) {
      rethrow;
    }
  }

}