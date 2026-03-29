import 'package:flutter/material.dart';
import'package:agap/features/auth/pages/rolescreen.dart';
//brand colors
const _agapOrange = Color(0xFFF05C33);
const _agapCoral = Color(0xFFF68A67);
const _agapNavy = Color(0xFF1E2B3C);

class SplashPage extends StatelessWidget {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 24),
          child: Column(
            children: [
              const Spacer(flex: 4),
              const _SplashLogo(),
              const SizedBox(height: 20),
              Text(
                'Alert. Guide. Assist. Protect.',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 14,
                  letterSpacing: 0.2,
                ),
              ),
              const Spacer(flex: 5),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const RoleScreen(),
                      ),
                    );
                  },
                  style: FilledButton.styleFrom(
                    backgroundColor: _agapCoral,
                    foregroundColor: _agapNavy,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32),
                      side: const BorderSide(
                        color: Color(0x33FFFFFF),
                        width: 1.2,
                      ),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: const BoxDecoration(
                          color: _agapNavy,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.chevron_right_rounded,
                          color: Colors.white,
                          size: 24,
                        ),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            "Let's Get Started",
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      const Text(
                        '›››',
                        style: TextStyle(
                          color: _agapNavy,
                          fontSize: 30,
                          fontWeight: FontWeight.w300,
                          letterSpacing: -2,
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 18),
            ],
          ),
        ),
      ),
    );
  }
}

class _SplashLogo extends StatelessWidget {
  const _SplashLogo();

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/AGAP_logolight.png',
      width: 190,
      fit: BoxFit.contain,
    );
  }
}
