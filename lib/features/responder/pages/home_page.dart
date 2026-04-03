import 'package:flutter/material.dart';

import 'package:agap/features/auth/services/auth_service.dart';

class ResponderHomePage extends StatefulWidget {
  const ResponderHomePage({super.key});

  @override
  State<ResponderHomePage> createState() => _ResponderHomePageState();
}

class _ResponderHomePageState extends State<ResponderHomePage> {
  String? displayName;

  @override
  void initState() {
    super.initState();
    debugPrint("ResponderHomePage: initState called");
    _loadUser();
  }

  void _loadUser() {
    debugPrint("ResponderHomePage: Loading user");

    final auth = AuthService();
    final user = auth.currentUser;

    if (user != null) {
      debugPrint("ResponderHomePage: User found -> ${user.email}");

      setState(() {
        // Temporary display (since no DB yet)
        displayName = user.email;
      });
    } else {
      debugPrint("ResponderHomePage: No user found");

      setState(() {
        displayName = "Responder";
      });
    }
  }

  Future<void> _logout() async {
    debugPrint("ResponderHomePage: Logout pressed");

    try {
      final auth = AuthService();
      await auth.signOut();

      debugPrint("ResponderHomePage: Sign out successful");

      if (!mounted) {
        debugPrint("ResponderHomePage: Not mounted, abort navigation");
        return;
      }

      debugPrint("ResponderHomePage: Navigating to /");
      Navigator.pushNamedAndRemoveUntil(
        context,
        '/',
        (route) => false,
      );

    } catch (e) {
      debugPrint("ResponderHomePage: Logout error -> $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("ResponderHomePage: build() called");

    return Scaffold(
      appBar: AppBar(
        title: const Text("Responder Home"),
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
              "Welcome, ${displayName ?? "Responder"}",
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