import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:agap/core/routes/screen_routes.dart';
import 'package:agap/features/auth/user_role.dart';
import 'package:agap/features/auth/providers/role_provider.dart'; 

import 'package:agap/features/auth/widgets/role_card.dart';
import 'package:agap/features/auth/widgets/role_screen_background.dart';
import 'package:agap/features/auth/widgets/role_screen_footer.dart';
import 'package:agap/theme/color.dart';

class RoleScreen extends ConsumerWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.agapOrange.withValues(alpha: 0.50),
      body: Stack(
        children: [
          const RoleScreenBackground(),

          SafeArea(
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 110),

                  //RESPONDER
                  RoleCard(
                    title: "I'm a Responder",
                    subtitle: '*For MDRRMO responders',
                    backgroundColor: AppColors.agapDark,
                    onTap: () {
                      ref.read(selectedRoleProvider.notifier).state = UserRole.responder;
                      context.go(Routes.login);
                    }
                  ),

                  const Spacer(),
                  const Spacer(),

                  //RESIDENT
                  RoleCard(
                    title: "I'm a Resident",
                    subtitle: '*For residents',
                    backgroundColor: AppColors.agapOrange,
                    onTap: () {
                      ref.read(selectedRoleProvider.notifier).state = UserRole.resident;
                      context.go(Routes.login);
                    }
                  ),

                  const Spacer(),

                  const RoleScreenFooter(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}