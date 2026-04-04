import 'package:flutter/material.dart';
import 'package:agap/features/resident/pages/send_sos.dart';
import 'package:agap/features/auth/services/auth_service.dart';
import 'package:agap/theme/color.dart';

class ResidentHomePage extends StatefulWidget {
  const ResidentHomePage({super.key});

  @override
  State<ResidentHomePage> createState() =>
      _ResidentHomePageState();
}

class _ResidentHomePageState extends State<ResidentHomePage> {
  String? displayName;

  @override
  void initState() {
    super.initState();
    debugPrint("ResidentDashboardPage initialized");
    _loadUser();
  }

  void _loadUser() {
    debugPrint("Loading current user");

    final auth = AuthService();
    final user = auth.currentUser;

    if (user != null) {
      debugPrint("User found with email ${user.email}");

      setState(() {
        displayName = user.email;
      });
    } else {
      debugPrint("No user found");

      setState(() {
        displayName = "Resident";
      });
    }
  }

  Future<void> _logout() async {
    debugPrint("Logout button pressed");

    try {
      final auth = AuthService();
      await auth.signOut();

      debugPrint("User signed out successfully");

      if (!mounted) return;

      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (route) => false,
      );
    } catch (e) {
      debugPrint("Logout error: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("ResidentDashboardPage build called");

    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: Text(
          "Welcome, ${displayName ?? "Resident"}",
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// HEADER
              const Text(
                'Emergency Dashboard',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                'Stay safe. Help is one tap away.',
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textMuted,
                ),
              ),

              const SizedBox(height: 40),

              /// SOS BUTTON (UNCHANGED UI)
              Expanded(
                child: Center(
                  child: GestureDetector(
                    onTap: () {
                      debugPrint("SOS button tapped");

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SosPage(),
                        ),
                      );
                    },
                    child: Container(
                      width: 220,
                      height: 220,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.agapOrangeDeep.withValues(alpha: 0.1),
                      ),
                      child: Center(
                        child: Container(
                          width: 180,
                          height: 180,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.agapOrangeDeep,
                          ),
                          child: const Center(
                            child: Text(
                              'SOS',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              /// INFO CARD (UNCHANGED)
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.overlayWhiteStrong,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Tap SOS only during emergencies. Your location will be sent to responders.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}