import 'package:flutter/material.dart';

import 'package:agap/features/auth/user_role.dart';

import 'package:agap/features/auth/widgets/role_card.dart';
import 'package:agap/features/auth/widgets/role_screen_background.dart';
import 'package:agap/features/auth/widgets/role_screen_footer.dart';
import 'package:agap/theme/color.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  void _selectRole(BuildContext context, UserRole role) {
    debugPrint("RoleScreen: Role selected -> $role");
    debugPrint("Navigating to /login with role");

    Navigator.pushNamed(
      context,'/login',
      arguments: role,
    );
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("RoleScreen: build() called");

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
                      _selectRole(context, UserRole.responder);
                    },
                  ),

                  const Spacer(),
                  const Spacer(),

                  // RESIDENT
                  RoleCard(
                    title: "I'm a Resident",
                    subtitle: '*For residents',
                    backgroundColor: AppColors.agapOrange,
                    onTap: () {
                      _selectRole(context, UserRole.resident);
                    },
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