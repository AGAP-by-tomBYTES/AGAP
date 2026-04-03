import 'package:flutter/material.dart';

import 'package:agap/features/auth/services/auth_service.dart';

class ResidentHomePage extends StatefulWidget {
  const ResidentHomePage({super.key});

  @override
  State<ResidentHomePage> createState() => _ResidentHomePageState();
}

class _ResidentHomePageState extends State<ResidentHomePage> {
  String? displayName;

  @override
  void initState() {
    super.initState();
    debugPrint("ResidentHomePage: initState called");
    _loadUser();
  }

  void _loadUser() {
    debugPrint("ResidentHomePage: Loading user");

    final auth = AuthService();
    final user = auth.currentUser;

    if (user != null) {
      debugPrint("ResidentHomePage: User found -> ${user.email}");

      setState(() {
        // Temporary display (since no DB yet)
        displayName = user.email;
      });
    } else {
      debugPrint("ResidentHomePage: No user found");

      setState(() {
        displayName = "Resident";
      });
    }
  }

  Future<void> _logout() async {
    debugPrint("ResidentHomePage: Logout pressed");

    try {
      final auth = AuthService();
      await auth.signOut();

      debugPrint("ResidentHomePage: Sign out successful");

      if (!mounted) {
        debugPrint("ResidentHomePage: Not mounted, abort navigation");
        return;
      }

      debugPrint("ResidentHomePage: Navigating to /");
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (route) => false,
      );

    } catch (e) {
      debugPrint("ResidentHomePage: Logout error -> $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("ResidentHomePage: build() called");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Resident Home"),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // GREETING
            Text(
              "Welcome, ${displayName ?? "Resident"}",
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}