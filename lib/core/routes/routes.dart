import 'package:flutter/material.dart';

import 'screen_routes.dart';
import 'route_guard.dart';

import 'package:agap/features/auth/pages/logo_screen.dart';
import 'package:agap/features/auth/pages/start_page.dart';
import 'package:agap/features/auth/pages/login_page.dart';
import 'package:agap/features/auth/pages/rolescreen.dart';
import 'package:agap/features/auth/pages/signup_page.dart';
import 'package:agap/features/auth/pages/resident_signup_location.dart';

import 'package:agap/features/auth/models/resident_data.dart';

import 'package:agap/features/resident/pages/home_page.dart';
import 'package:agap/features/responder/pages/home_page.dart';


import 'package:agap/features/auth/user_role.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {

    case Routes.root:
      return MaterialPageRoute(builder: (_) => const LogoScreen());

    case Routes.start:
      return MaterialPageRoute(builder: (_) => const StartPage());

    case Routes.role:
      return MaterialPageRoute(builder: (_) => const RoleScreen());

    case Routes.login:
      if (settings.arguments is! UserRole) {
        return _error("UserRole required for Login");
      }

      return MaterialPageRoute(
        builder: (_) => LoginPage(
          role: settings.arguments as UserRole,
        ),
      );

    case Routes.residentSignupPage1:
      if (settings.arguments is! UserRole) {
        return _error("UserRole required for Signup");
      }

      return MaterialPageRoute(
        builder: (_) => ResidentSignupPage(
          role: settings.arguments as UserRole,
        ),
      );
    
    case Routes.residentSignupPage2:
      if (settings.arguments is! ResidentData) {
        return _error("ResidentData required for signup step 2");
      }

      return MaterialPageRoute(
        builder: (_) => ResidentSignupLocationPage(
          data: settings.arguments as ResidentData,
        ),
      );

    case Routes.residentDashboard:
      if (!RouteGuard.isLoggedIn()) {
        return _error("Unauthorized");
      }

      return MaterialPageRoute(
        builder: (_) => const ResidentHomePage(),
      );

     case Routes.responderDashboard:
      if (!RouteGuard.isLoggedIn()) {
        return _error("Unauthorized");
      }

      return MaterialPageRoute(
        builder: (_) => const ResponderHomePage(),
      );

    default:
      return _error("Unknown route: ${settings.name}");
  }
}

Route<dynamic> _error(String message) {
  return MaterialPageRoute(
    builder: (_) => Scaffold(
      body: Center(child: Text(message)),
    ),
  );
}