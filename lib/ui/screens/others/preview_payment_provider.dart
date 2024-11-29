import 'package:flutter/material.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class PreviewPaymentProvider extends ChangeNotifier {
  List<SharedMediaFile>? _sharedFiles;

  List<SharedMediaFile>? get sharedFiles => _sharedFiles;

  void updateSharedFiles(List<SharedMediaFile> sharedFiles) {
    _sharedFiles = sharedFiles;
    notifyListeners();
  }

  void clearSharedFiles() {
    _sharedFiles = null;
    notifyListeners();
  }
}
