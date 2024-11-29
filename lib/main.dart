import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:porc_app/core/services/database_user_service.dart';
import 'package:porc_app/core/utils/route_utils.dart';
import 'package:porc_app/firebase_options.dart';
import 'package:porc_app/ui/screens/home/home_screen.dart';
import 'package:porc_app/ui/screens/others/preview_payment_provider.dart';
import 'package:porc_app/ui/screens/others/receive_images.dart';
import 'package:porc_app/ui/screens/others/user_provider.dart';
import 'package:porc_app/ui/screens/pig_lots/pig_lots_list/pig_lots_screen.dart';
import 'package:porc_app/ui/screens/resume/resume_screen.dart';
import 'package:provider/provider.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

Future<void> main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _sharedFiles = <SharedMediaFile>[];
  late ReceiveImages _receiveImages;

  @override
  void initState() {
    super.initState();
    // Initialize the ReceiveImages class
    _receiveImages = ReceiveImages(
      context,
      onMediaReceived: (List<SharedMediaFile> files) {
        setState(() {
          _sharedFiles.clear();
          _sharedFiles.addAll(files);
          log(_sharedFiles.first.path);
        });
      },
    );
  }

@override
Widget build(BuildContext context) {
  return ScreenUtilInit(
    builder: (context, child) => MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserProvider(DatabaseUserService()),
        ),
        ChangeNotifierProvider(
          create: (context) => PreviewPaymentProvider(),
        ),
      ],
      child: MaterialApp(
        onGenerateRoute: RouteUtils.onGenerateRoute,
        home: _sharedFiles == null || _sharedFiles.isEmpty
            ? HomeScreen() // If no shared files, navigate to HomeScreen
            : PigLotsScreen(sharedFiles: _sharedFiles), // Navigate to PigLotsScreen if there are shared files
      ),
    ),
  );
}

}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
  }
}
