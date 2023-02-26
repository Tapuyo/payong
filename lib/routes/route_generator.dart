
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:payong/splash_page.dart';
import 'package:payong/ui/main_nav.dart';
import 'package:payong/ui/mob_main.dart';

import 'routes.dart';

class RouteGenerator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    //final args = settings.arguments;

    switch (settings.name) {
      case Routes.splash:
        return CupertinoPageRoute(builder: (_) => const SplashPage());
      
      case Routes.mobMain:
        return CupertinoPageRoute(builder: (_) => const MainPage());






      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return CupertinoPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('Error'),
        ),
      );
    });
  }
}
