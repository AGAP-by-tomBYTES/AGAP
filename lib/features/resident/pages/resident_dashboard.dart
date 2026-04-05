import 'package:flutter/material.dart';

import 'package:agap/theme/theme.dart';

import 'package:agap/features/auth/services/auth_service.dart';
import 'package:agap/features/resident/pages/family_members.dart';
import 'package:agap/features/resident/pages/resident_profile.dart';
import 'package:agap/features/resident/pages/send_sos.dart';
import 'package:agap/features/resident/pages/emergency_hotlines.dart';


class ResidentDashboardPage extends StatefulWidget {
  const ResidentDashboardPage({super.key});

  @override
  State<ResidentDashboardPage> createState() => _ResidentDashboardPageState();
}

class _ResidentDashboardPageState extends State<ResidentDashboardPage> {
  int _selectedIndex = 0; // Home is active

  Map<String, dynamic>? resident;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResident();
  }

  Future<void> _loadResident() async {
    final data = await AuthService().getCurrentResident();

    setState(() {
      resident = data;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: _buildBottomBar(),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 50, 24, 25),
              decoration: BoxDecoration(
                color: AppColors.agapOrangeDeep,
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLoading ? 'Loading...' : 'Hi, ${resident?['first_name'] ?? 'User'}',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isLoading ? '' : '${resident?['street'] ?? ''}, ${resident?['barangay'] ?? ''}, ${resident?['city'] ?? ''}',
                        style: TextStyle(
                          fontSize: 11,
                          color: Colors.white.withValues(alpha: 0.9),
                        ),
                      ),
                    ],
                  ),
                  const Icon(Icons.notifications_none_outlined,
                      color: Colors.white, size: 28),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),

                  _buildSectionLabel("YOUR INFORMATION"),
                  Container(
                    width: double.infinity,
                    height: 180,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                  ),

                  const SizedBox(height: 24),

                  _buildSectionLabel("FAMILY MEMBERS"),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        _buildFamilyAvatar(),
                        _buildFamilyAvatar(),
                        _buildFamilyAvatar(),
                        const Spacer(),
                        const Icon(Icons.add_circle_outline,
                            size: 36, color: Colors.black87),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  _buildSectionLabel("QUICK ACTIONS"),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const EmergencyHotlinesPage()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF004D40),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.phone_in_talk,
                                color: Colors.greenAccent, size: 24),
                          ),
                          const SizedBox(width: 12),
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Emergency Hotlines",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              Text(
                                "MDRRMO • BFP • PNP",
                                style: TextStyle(
                                    fontSize: 12, color: Colors.black54),
                              ),
                            ],
                          ),
                          const Spacer(),
                          const Icon(Icons.arrow_forward_ios,
                              size: 14, color: Colors.grey),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  _buildSectionLabel("LIVE REPORT"),
                  _buildLiveReportItem(
                    "Storm Signal No. 1 raised for Iloilo",
                    "1 hour ago · PAGASA",
                  ),
                  const Divider(),
                  _buildLiveReportItem(
                    "PAGASA: Heavy rains expected tomorrow morning",
                    "3 hours ago · PAGASA",
                  ),
                  const SizedBox(height: 100), // Space for bottom bar
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.grey.shade700,
        ),
      ),
    );
  }

  Widget _buildFamilyAvatar() {
    return Container(
      margin: const EdgeInsets.only(right: 12),
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        color: Color(0xFFFFB382),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildLiveReportItem(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6.0, right: 12),
            child: Icon(Icons.circle, size: 8, color: Colors.black),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 15),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12, color: Colors.black54),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 65,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(40),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navItem(Icons.home, 0, () {
            // Already on Home
          }),
          _navItem(Icons.call, 1, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const EmergencyHotlinesPage()),
              );

              _resetToHome();
          }),
          _buildCenterSosButton(),
          _navItem(Icons.family_restroom_outlined, 3, () {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const FamilyPage()),
              );
            _resetToHome();
          }),
          _navItem(Icons.person_outline, 4, () {
             Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ProfilePage()),
              );
            _resetToHome();
          }),
        ],
      ),
    );
  }

  Widget _buildCenterSosButton() {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const SosPage()),
        );
      },
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
          color: AppColors.agapOrangeAlt,
          shape: BoxShape.circle,
          border: Border.all(
            color: AppColors.agapCoral.withValues(alpha: 1),
            width: 3,
          ),
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 8,
              offset: Offset(0, 4),
            )
          ],
        ),
        child: const Center(
          child: Text(
            "SOS",
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, int index, VoidCallback onTap) {
    final isActive = _selectedIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() => _selectedIndex = index);
        onTap();
      },
      child: Icon(
        icon,
        size: 28,
        color: isActive ? AppColors.agapCoral : Colors.black,
      ),
    );
  }

    // Helper function to keep it clean
  void _resetToHome() {
    setState(() => _selectedIndex = 0);
  }
  
}

