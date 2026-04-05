import 'package:flutter/material.dart';
import 'package:agap/features/auth/services/auth_service.dart';

class RouteGuard {
  static final AuthService _authService = AuthService();

  static bool isLoggedIn() {
    final result = _authService.isLoggedIn;
    debugPrint("RouteGuard: isLoggedIn = $result");
    return result;
  }
}