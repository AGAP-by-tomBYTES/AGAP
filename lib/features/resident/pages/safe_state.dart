import 'package:flutter/material.dart';
import 'package:agap/features/resident/pages/resident_dashboard.dart';
import 'package:agap/features/services/models/alert_type.dart';
import 'package:agap/features/services/sos_alert_service.dart';
import 'danger_page.dart';
import 'package:intl/intl.dart'; // Ensure this is imported

class SafePage extends StatefulWidget {
  const SafePage({super.key});

  @override
  State<SafePage> createState() => _SafePageState();
}

class _SafePageState extends State<SafePage> {
  late final String formattedTime;

  @override
  void initState() {
    super.initState();
    // Initialize time once when the page loads
    formattedTime = DateFormat('hh:mm a').format(DateTime.now());
  }

  @override
  Widget build(BuildContext context) {
    final Color safeColor = const Color(0xFF12B76A);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// TOP GREEN BAR
          ColoredBox(
            color: safeColor,
            child: SafeArea(
              bottom: false,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Center(
                  child: Text(
                    "STATUS REPORTED    $formattedTime", // Dynamic time here
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  /// CIRCLE
                  Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: safeColor, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: safeColor.withValues(alpha: 0.25),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.check_rounded,
                      size: 70,
                      color: safeColor,
                    ),
                  ),

                  const SizedBox(height: 30),

                  const Text(
                    "You’re safe.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "The responders have been notified.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "$formattedTime · Miagao, Iloilo", // Dynamic time here too
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 36),

                  SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFDE2E1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await SosAlertService.sendAlert(AlertTypes.danger);
                        if (!context.mounted) return;

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const DangerPage(),
                          ),
                        );
                      },
                      child: const Text(
                        "UNDO SAFE.\nI AM IN DANGER NOW.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        foregroundColor: safeColor,
                        side: BorderSide(color: safeColor.withValues(alpha: 0.35)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ResidentDashboardPage(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "CONFIRM.\nEMERGENCY IS RESOLVED.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}