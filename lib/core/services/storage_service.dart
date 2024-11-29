import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:porc_app/core/utils/utilities.dart';

class StorageService {
  final _storage = FirebaseStorage.instance;

  Future<String> uploadPaymentImage(File image, String ownerId, String pigLotId) async {
    try {
      Reference ref =
          _storage.ref("images/$ownerId/$pigLotId/${Utilities.formatDateTime()}");

      final task = await ref.putFile(image);

      String downloadUrl = await task.ref.getDownloadURL();

      return downloadUrl;
    } catch (e) {
      rethrow;
    }
  }
}
