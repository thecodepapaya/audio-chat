import 'package:audio_chat/src/home_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  AppRoutes._();
  static Route routes(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (context) {
        switch (settings.name) {
          case HomePage.route:
            return const HomePage();
          default:
            return const HomePage();
        }
      },
    );
  }
}
