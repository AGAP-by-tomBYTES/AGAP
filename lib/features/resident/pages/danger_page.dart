import 'package:flutter/material.dart';
import 'package:agap/features/resident/pages/resident_dashboard.dart';
import 'package:agap/features/services/sos_alert_service.dart';
import 'safe_state.dart';

class DangerPage extends StatelessWidget {
  const DangerPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final Color dangerColor = const Color(0xFFE4572E);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// TOP BAR
          ColoredBox(
            color: Colors.black,
            child: SafeArea(
              bottom: false,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: const Center(
                  child: Text(
                    "RESPONDERS ALERTED    8:15 AM",
                    style: TextStyle(
                      color: Colors.orange,
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
                  const SizedBox(height: 30),

                  /// CIRCLE WITH ICON
                  Container(
                    width: 170,
                    height: 170,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: dangerColor, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: dangerColor.withValues(alpha: 0.25),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                    child: Icon(
                      Icons.warning_amber_rounded,
                      size: 70,
                      color: dangerColor,
                    ),
                  ),

                  const SizedBox(height: 30),

                  Text(
                    "Help is otw,\nEleah.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      color: dangerColor,
                    ),
                  ),

                  const SizedBox(height: 12),

                  const Text(
                    "Alert sent. Responders now have your location.",
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
                        backgroundColor: const Color(0xFFDFF3EA),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () async {
                        await SosAlertService.sendAlert('SAFE');
                        if (!context.mounted) return;

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => const SafePage()),
                        );
                      },
                      child: const Text(
                        "UNDO HELP.\nI AM SAFE NOW.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.green,
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
                        foregroundColor: dangerColor,
                        side: BorderSide(color: dangerColor.withValues(alpha: 0.35)),
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
