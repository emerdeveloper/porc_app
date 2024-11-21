import 'dart:async';
import 'dart:developer';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

class ReceiveImages {
  final BuildContext _context;
  final Function(List<SharedMediaFile>) onMediaReceived;

  ReceiveImages(this._context, {required this.onMediaReceived}) {
       _initialize();
  }

  void _initialize() async {
    //await requestPermissions(); // Solicita permisos antes de escuchar archivos compartidos
    listenShareMediaFiles();
  }

  void listenShareMediaFiles() async {
    await requestPermissions(); // Solicita permisos antes de escuchar archivos
    log("Listening for shared media files...");

    // For sharing images while the app is in memory
    ReceiveSharingIntent.instance.getMediaStream().listen((List<SharedMediaFile> value) {
      log("Media received while app is in memory: $value");
      onMediaReceived(value);
    }, onError: (err) {
      log("getMediaStream error: $err");
    });

    // For sharing images while the app is closed
    ReceiveSharingIntent.instance.getInitialMedia().then((List<SharedMediaFile> value) {
      log("Media received on app launch: $value");
      onMediaReceived(value);

      // Tell the library that we are done processing the intent
      ReceiveSharingIntent.instance.reset();
    });
  }

Future<void> requestPermissions() async {
  // Verifica el estado del permiso de almacenamiento
  AndroidDeviceInfo build = await DeviceInfoPlugin().androidInfo;
  
  if(build.version.sdkInt >= 30) {
    var req = await Permission.manageExternalStorage.request();
    if (req.isGranted) {
      log("Permiso manageExternalStorage concedido.");
    } else {
      log("Permiso manageExternalStorage aún no concedido.");
    }
  } else {
    PermissionStatus status = await Permission.storage.request();

  if (status.isDenied) {
    log("Permiso denegado. Solicitando nuevamente...");
    await Permission.storage.request();
  }
  }


  if (await Permission.storage.isPermanentlyDenied) {
    log("Permiso denegado permanentemente. Dirigiendo a configuración...");
    // Abre la configuración de la aplicación
    await openAppSettings();
  }

}


}
