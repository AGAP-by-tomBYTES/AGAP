import 'package:flutter/material.dart';
import 'package:agap/features/resident/pages/resident_dashboard.dart';
import 'package:agap/features/services/models/alert_type.dart';
import 'package:agap/features/services/sos_alert_service.dart';
import 'danger_page.dart';

class SafePage extends StatelessWidget {
  const SafePage({super.key});

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
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Center(
                  child: Text(
                    "STATUS REPORTED    8:15 AM",
                    style: TextStyle(
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
                    "You’re safe,\nEleah.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Your household and responders\nhave been notified.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "8:54 AM · Miagao, Iloilo",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
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
