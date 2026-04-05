import 'dart:async';
import 'package:agap/core/services/supabase_service.dart';
import 'package:agap/features/resident/pages/safe_state.dart';
import 'package:agap/features/services/database/alert_dao.dart';
import 'package:agap/features/services/internet_service.dart';
import 'package:agap/features/services/models/alert.dart';
import 'package:agap/features/services/device_id.dart';
import 'package:agap/features/services/nearby_service.dart';
import 'package:flutter/material.dart';
import 'package:agap/theme/color.dart';
import 'package:uuid/uuid.dart';
import 'danger_page.dart';

class SosPage extends StatefulWidget {
  const SosPage({super.key});

  @override
  State<SosPage> createState() => _SosPageState();
}

class _SosPageState extends State<SosPage> {
  double progress = 0.0;
  Timer? _timer;

  void _startHolding() {
    progress = 0.0;

    _timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        progress += 0.02;

        if (progress >= 1) {
          timer.cancel();

           _handleSafe();

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const SafePage(),
            ),
          );
        }
      });
    });
  }

  void _stopHolding() {
    _timer?.cancel();

    setState(() {
      progress = 0.0;
    });
  }

  /* ASYNC HELPERS */
  Future<void> _handleSafe() async {
    final deviceId = await DeviceIdService.getDeviceId();

    final alert = Alert(
      id: Uuid().v4(),
      type: "SAFE",
      timestamp: DateTime.now().millisecondsSinceEpoch,
      senderId: deviceId,
      ttl: 5,
    );

    await AlertDao.insertAlert(alert);

    if (!mounted) return;
  }

  Future<void> _handleDanger() async {
    final deviceId = await DeviceIdService.getDeviceId();

    final alert = Alert(
      id: Uuid().v4(),
      type: "DANGER",
      timestamp: DateTime.now().millisecondsSinceEpoch,
      senderId: deviceId,
      ttl: 5,
      uploaded: false,
    );

    // save
    await AlertDao.insertAlert(alert);
    await NearbyService.sendToAll(alert.toJson());
    if (await hasInternet()) {
      await SupabaseService.uploadAlert(alert);
    } else {
      debugPrint('No internet, will retry later via queue.');
    }

    if (!mounted) return;
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Emergency Alert'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Center( // ✅ centers everything
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center, 
            children: [
              const Text(
                'TYPHOON ESTHER - SIGNAL NO. 3',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.agapOrange,
                ),
              ),

              const SizedBox(height: 30),

              /// BIGGER QUESTION
              const Text(
                'Are you safe?',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 56, 
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 60),

              /// HOLD BUTTON
              GestureDetector(
                onTap: () {

                  _handleDanger();

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const DangerPage(),
                    ),
                  );
                },
                onTapDown: (_) => _startHolding(),
                onTapUp: (_) => _stopHolding(),
                onTapCancel: _stopHolding,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    /// PROGRESS RING
                    SizedBox(
                      width: 200,
                      height: 200,
                      child: CircularProgressIndicator(
                        value: progress,
                        strokeWidth: 8,
                        backgroundColor: Colors.grey.shade300,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          Colors.green,
                        ),
                      ),
                    ),

                    /// INNER BUTTON
                    Container(
                      width: 160,
                      height: 160,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 12,
                            offset: Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Center(
                        child: progress > 0
                            ? const Text(
                                "Keep holding... \n Marking you safe",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              )
                            : RichText(
                                textAlign: TextAlign.center,
                                text: TextSpan(
                                  style: const TextStyle(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  children: [
                                    const TextSpan(text: "Hold for "),
                                    TextSpan(
                                      text: "SAFE",
                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                    ),
                                    const TextSpan(
                                      text: "\nTap for ",
                                      style: TextStyle(color: AppColors.agapCoral)),
                                    TextSpan(
                                      text: "DANGER",
                                      style: const TextStyle(color: AppColors.agapCoral),
                                    ),
                                  ],
                                ),
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