import 'package:flutter/material.dart';

class AppRoute {
  static const home = '/';
}

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final Widget page;
    switch (settings.name) {
      case AppRoute.home:
        page = const Placeholder();
      default:
        throw Exception('Unknown route: ${settings.name}');
    }
    return MaterialPageRoute<void>(
      builder: (context) {
        return page;
      },
    );
  }
}
