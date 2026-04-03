//dependencies
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

//auth
import 'package:agap/features/auth/providers/auth_notifier.dart';

//routes constant
import 'package:agap/core/routes/screen_routes.dart';

//pages
import 'package:agap/features/auth/pages/auth_pages.dart';
import 'package:agap/features/resident/pages/home_page.dart';
import 'package:agap/features/responder/pages/home_page.dart';

final routeProvider = Provider<GoRouter>((ref) {
  final auth = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: Routes.splash,

    redirect: (context, state) {
      final isLoggedIn = auth.isLoggedIn;
      final isVerified = auth.isVerified;
      final isResponder = auth.isResponder;

      final location = state.matchedLocation;

      final splash = Routes.splash;
      final start = Routes.start;
      final login = Routes.login;
      final role = Routes.role;
      final signup = Routes.signup;
      final verify = Routes.verify;
      final residentHome = Routes.resident;
      final responderHome = Routes.responder;

      final isAuthRoute = location == login || location == signup;

      if (!isLoggedIn) {
        if (location != start && location != login && location != signup && location != role) {
          return start;
        }
        return null;
      }

      if (!isVerified) {
        if (location != verify) {
          return verify;
        }
        return null;
      }

      if (location == splash) {
        return isResponder ? responderHome : residentHome;
      }

      if (!isResponder && location == responderHome) {
        return residentHome;
      }

      if (isResponder && location == residentHome) {
        return responderHome;
      }

      if (isAuthRoute) {
        return isResponder ? responderHome : residentHome;
      }

      return null;
    },

    routes: [
      GoRoute(path: Routes.splash, builder: (_, _) => const SplashPage()),
      GoRoute(path: Routes.start, builder: (_, _) => const StartPage()),
      GoRoute(path: Routes.role, builder: (_, _) => const RoleScreen()),
      GoRoute(path: Routes.login, builder: (_, _) => const LoginPage()),
      GoRoute(path: Routes.signup, builder: (_, _) => const SignupPage()),
      GoRoute(path: Routes.verify, builder: (_, _) => const VerifyPage()),
      GoRoute(path: Routes.resident, builder: (_, _) => const ResidentHomePage()),
      GoRoute(path: Routes.responder, builder: (_, _) => const ResponderHomePage()),
    ],
  );
});