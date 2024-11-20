import 'package:porc_app/core/constants/string.dart';
import 'package:porc_app/core/models/pig_lots_model.dart';
import 'package:porc_app/core/models/user_model.dart';
import 'package:porc_app/ui/screens/auth/login/login_screen.dart';
import 'package:porc_app/ui/screens/feed/feed_history/feed_history_screen.dart';
import 'package:porc_app/ui/screens/feed/feed_request_screen.dart';
import 'package:porc_app/ui/screens/home/home_screen.dart';
import 'package:porc_app/ui/screens/pig_lots/pig_lot_detail/pig_lot_detail_screen.dart';
import 'package:porc_app/ui/screens/pig_lots/pig_lots_screen.dart';
//import 'package:porc_app/ui/screens/auth/signup/signup_screen.dart';
//import 'package:porc_app/ui/screens/bottom_navigation/chats_list/chat_room/chat_screen.dart';
import 'package:porc_app/ui/screens/splash/splash_screen.dart';
//import 'package:porc_app/ui/screens/wrapper/wrapper.dart';
import 'package:flutter/material.dart';

class RouteUtils {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      //case splash:
      //  return MaterialPageRoute(builder: (context) => const SplashScreen());
      // Auth
      case login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      //Home
      case home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      case pigLots:
        return MaterialPageRoute(builder: (context) => const PigLotsScreen());
      case pigLotDetail:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
            builder: (context) => PigLotDetailScreen(
                  pigLot: args['pigLot'] as PigLotsModel,
                  inversorOwner: args['inversorOwner'] as UserModel,
                ));
      case feedRequest:
      final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (context) => FeedRequestScreen(
          pigLot: args['pigLot'] as PigLotsModel
        ));
      case feedHistory:
      final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(builder: (context) => FeedHistoryScreen(
          pigLot: args['pigLot'] as PigLotsModel
        ));
      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text("No Route Found")),
          ),
        );
    }
  }
}