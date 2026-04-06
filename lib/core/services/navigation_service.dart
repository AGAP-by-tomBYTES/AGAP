import 'package:flutter/material.dart';

class NavigationService {
  static final navigatorKey = GlobalKey<NavigatorState>();

  static String initialRoute = '/';

  static NavigatorState get _navigator => navigatorKey.currentState ?? (throw Exception("Navigator not ready"));

  static Future<dynamic> pushNamed(String route, {Object? arguments}) {
    return _navigator.pushNamed(route, arguments: arguments);
  }

  static Future<dynamic> pushReplacement(String route, {Object? arguments}) {
    return _navigator.pushReplacementNamed(route, arguments: arguments);
  }

  static void pop() {
    _navigator.pop();
  }
}