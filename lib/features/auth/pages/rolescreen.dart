import 'package:flutter/material.dart';
import 'package:agap/features/auth/widgets/role_card.dart';
import 'package:agap/features/responder/pages/signup.dart';

//brand colors
const _agapOrange = Color(0xFFF05C33);
const _agapDeepOrange = Color(0xFFD74F2A);
const _agapDark = Color(0xFF1F2328);

class RoleScreen extends StatelessWidget {
  const RoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:_agapOrange.withValues(alpha: 0.50),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/bg_fade.png',
              fit: BoxFit.cover,
            ),
          ),
          // Positioned.fill(
          //   child: ColoredBox(
          //     color: _agapOrange.withValues(alpha: 0.),
          //   ),
          // ),
          const _HeaderBackground(),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: Container(
          //     height: MediaQuery.of(context).size.height * 0.60,
          //     decoration: const BoxDecoration(
          //       color: Colors.white,
          //       borderRadius: BorderRadius.vertical(top: Radius.circular(360)),
          //     ),
          //   ),
          // ),
          // Curved white background at bottom
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.60,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(
                  top: Radius.elliptical(
                    MediaQuery.of(context).size.width * 1, // width of curve
                    220, // roundness of curve
                  ),
                ),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,  
              children: [
                const SizedBox(height: 110),
                RoleCard(
                  title:"I'm a Responder",
                  subtitle: '*For MDRRMO responders',
                  backgroundColor: _agapDark,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ResponderSignupPage(),
                      ),
                    );
                  },
                ),
                const Spacer(),
                const Spacer(),
                RoleCard(
                  title: "I'm a Resident",
                  subtitle: '*For residents',
                  backgroundColor: _agapOrange,
                  onTap: () => _showRoleMessage(context, 'Resident'),
                ),
                const Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 34),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'assets/AGAP_logo.png',
                        width: 92,
                        fit: BoxFit.contain,
                      ),
                      Text(
                        "Developed by TOMBytes for Miagao MDRRMO",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: _agapDark.withValues(alpha: 0.72),
                          fontSize: 8,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  )
                ),
              ],
              ),
            ),
          ),
        ],
      ),
    );
  }
// Simple helper to show a snackbar message when a role is tapped
//TODO: replace with actual navigation to resident flow once implemented
  void _showRoleMessage(BuildContext context, String role) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$role flow coming next.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.52,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _agapDeepOrange,
                  _agapOrange.withValues(alpha: 0.94),
                  _agapOrange.withValues(alpha: 0.82),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
