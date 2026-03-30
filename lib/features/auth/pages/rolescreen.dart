import 'package:flutter/material.dart';
import 'package:agap/features/auth/widgets/role_card.dart';
import 'package:agap/features/auth/widgets/role_screen_background.dart';
import 'package:agap/features/auth/widgets/role_screen_footer.dart';
import 'package:agap/features/auth/pages/login_page.dart';
import 'package:agap/theme/color.dart';

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  RoleCard(
                    title: "I'm a Responder",
                    subtitle: '*For MDRRMO responders',
                    backgroundColor: AppColors.agapDark,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const LoginPage(
                            roleLabel: 'Responder',
                            idLabel: 'Employee ID',
                            idHint: 'e.g. MDRRMO-23102B',
                          ),
                        ),
                      );
                    },
                  ),
                  const Spacer(),
                  const Spacer(),
                  RoleCard(
                    title: "I'm a Resident",
                    subtitle: '*For residents',
                    backgroundColor: AppColors.agapOrange,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const LoginPage(
                            roleLabel: 'Resident',
                            idLabel: 'Resident ID',
                            idHint: 'e.g. MDRRMO-23102B',
                          ),
                        ),
                      );
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
