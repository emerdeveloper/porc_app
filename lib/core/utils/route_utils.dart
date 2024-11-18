import 'package:porc_app/core/constants/string.dart';
import 'package:porc_app/core/models/user_model.dart';
import 'package:porc_app/ui/screens/auth/login/login_screen.dart';
import 'package:porc_app/ui/screens/home/home_screen.dart';
//import 'package:porc_app/ui/screens/auth/signup/signup_screen.dart';
//import 'package:porc_app/ui/screens/bottom_navigation/chats_list/chat_room/chat_screen.dart';
import 'package:porc_app/ui/screens/splash/splash_screen.dart';
//import 'package:porc_app/ui/screens/wrapper/wrapper.dart';
import 'package:flutter/material.dart';

class RouteUtils {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case splash:
        return MaterialPageRoute(builder: (context) => const SplashScreen());
      // Auth
      case login:
        return MaterialPageRoute(builder: (context) => const LoginScreen());
      //Home
      case home:
        return MaterialPageRoute(builder: (context) => const HomeScreen());
    /*  case signup:
        return MaterialPageRoute(builder: (context) => const SignupScreen());
      case wrapper:
        return MaterialPageRoute(builder: (context) => const Wrapper());
      case chatRoom:
        return MaterialPageRoute(
            builder: (context) => ChatScreen(
                  receiver: args as UserModel,
                ));*/

      default:
        return MaterialPageRoute(
          builder: (context) => const Scaffold(
            body: Center(child: Text("No Route Found")),
          ),
        );
    }
  }
}