import 'package:flutter/material.dart';
import 'safe_state.dart';

class DangerPage extends StatelessWidget {
  const DangerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final Color dangerColor = const Color(0xFFE4572E);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          /// TOP BAR
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 12),
            color: Colors.black,
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

          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "TYPHOON ESTHER · SIGNAL NO. 3",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: Colors.black54,
                    ),
                  ),

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
                    "The responders now have your location.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54),
                  ),

                  const SizedBox(height: 6),

                  const Text(
                    "8:54 AM · Miagao, Iloilo",
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ),

          /// BOTTOM BUTTON (THUMB FRIENDLY)
          Padding(
            padding: const EdgeInsets.all(24),
            child: SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDFF3EA),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
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
          )
        ],
      ),
    );
  }
}
