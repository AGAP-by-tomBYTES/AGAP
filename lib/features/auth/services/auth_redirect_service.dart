import 'package:flutter/material.dart';
import 'package:agap/core/routes/screen_routes.dart';
import 'package:agap/core/services/navigation_service.dart';

import 'package:agap/features/auth/services/auth_service.dart';
import 'package:agap/features/auth/services/resident_service.dart';

//auth redirect
//checks if user is logged in
//    verification status
//    role
//redirect to correct screen
class AuthRedirectService {

  final AuthService _authService = AuthService();
  final ResidentService _residentService = ResidentService();

  Future<void> handleAuthRedirect({required bool mounted}) async {
    debugPrint("Checking authentication status");

    final user = _authService.currentUser;

    //not logged in
    if (user == null) {
      debugPrint("No user found, showing splash delay");

      await Future.delayed(const Duration(seconds: 2));
      
      if (!mounted) {
        debugPrint("Widget not mounted after delay, aborting navigation");
        return;
      }

      //redirect to role screen
      NavigationService.pushReplacement(Routes.role);
      return;
    } else {
      debugPrint("User found: ${user.id}");
      debugPrint("User verification status: ${_authService.isVerified()}");
    }

    if (_authService.isVerified()) {
      debugPrint("User verified");

      final isResponder = await _residentService.isResponder(user.id);
      if (!mounted) {
        debugPrint("Widget not mounted, aborting navigation");
        return;
      }

      if (isResponder) {
        debugPrint("responder");
        NavigationService.pushReplacement(Routes.responderDashboard);
      } else {
        debugPrint("resident");
        NavigationService.pushReplacement(Routes.residentDashboard);
      }

    } else {
      debugPrint("user not verified");

      if (!mounted) {
        debugPrint("Widget not mounted, aborting navigation");
        return;
      }

      debugPrint("Navigating to /verify");
        NavigationService.pushReplacement(Routes.start); //placeholder route muna
    }
  }
}