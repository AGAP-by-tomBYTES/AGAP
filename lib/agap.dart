import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/routes/app_route.dart';
import 'package:agap/theme/color.dart';

//root widget
//configures global theme and route
class Agap extends ConsumerWidget {
  const Agap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final route = ref.watch(routeProvider);
    
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'AGAP',
      routerConfig: route,
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