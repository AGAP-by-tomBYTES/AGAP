import 'package:flutter/material.dart';

import 'package:agap/features/auth/services/auth_service.dart';
import 'package:agap/features/resident/pages/emergency_hotlines.dart';
import 'package:agap/features/resident/widgets/resident_header.dart';
import 'package:agap/features/resident/widgets/bottom_navbar.dart';

class ResidentDashboardPage extends StatefulWidget {
  const ResidentDashboardPage({super.key});

  @override
  State<ResidentDashboardPage> createState() => _ResidentDashboardPageState();
}

class _ResidentDashboardPageState extends State<ResidentDashboardPage> {
  final int _selectedIndex = 0; // Home is active

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
      bottomNavigationBar: ResidentBottomNavBar(
        selectedIndex: _selectedIndex,
        resident: resident
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResidentHeader(resident: resident, isLoading: isLoading,),
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
                            builder: (_) => EmergencyHotlinesPage(resident: resident)),
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
    // Helper function to keep it clean
  // void _resetToHome() {
  //   setState(() => _selectedIndex = 0);
  // }
  
}

