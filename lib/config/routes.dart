import 'package:flutter/material.dart';

import '../screens/profile/language/language_screen.dart';

class Routes {
  static const String home = "/";
  static const String login = "/login";
  static const String profile = "/profile";
  static const String language = "/language";

  Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      // case login:
      //   return opacityRoute(LoginScreen());

      case language:
        return routeAnimation(const LanguageScreen());

      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Center(
              child: Text(
                'No path for ${settings.name}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        );
    }
  }

  routeAnimation(route) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => route,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(1, 0.0);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  opacityRoute(route) {
    return PageRouteBuilder(
      pageBuilder: (_, __, ___) => route,
      transitionDuration: Duration(milliseconds: 500),
      transitionsBuilder: (_, Animation<double> animation, __, Widget child) {
        return Opacity(
          opacity: animation.value,
          child: child,
        );
      },
    );
  }

  ///Singleton factory
  static final Routes _instance = Routes._internal();

  factory Routes() {
    return _instance;
  }

  Routes._internal();
}
