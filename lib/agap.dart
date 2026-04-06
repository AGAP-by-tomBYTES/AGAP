import 'package:flutter/material.dart';

import 'core/routes/routes.dart';
import 'core/services/navigation_service.dart';

import 'package:agap/theme/color.dart';

//root widget
//configures global theme and route
class Agap extends StatelessWidget {
  const Agap({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint("Agap: build() called");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AGAP',
      navigatorKey: NavigationService.navigatorKey,
      initialRoute: NavigationService.initialRoute,
      onGenerateRoute: (settings) {
        debugPrint("Routing to: ${settings.name}");
        debugPrint("Route arguments: ${settings.arguments}");
        return generateRoute(settings);
      },
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.agapOrange,
          primary: AppColors.agapOrange,
        ),
        scaffoldBackgroundColor: AppColors.agapOrange,
        useMaterial3: true,
      ),
    );
  }
}