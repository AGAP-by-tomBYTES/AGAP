import 'package:agap/core/services/weather.dart';
import 'package:agap/core/services/earthquake.dart';
import 'package:flutter/material.dart';

import 'package:agap/features/auth/services/auth_service.dart';
import 'package:agap/features/resident/pages/emergency_hotlines.dart';
import 'package:agap/features/resident/widgets/resident_header.dart';
import 'package:agap/features/resident/widgets/bottom_navbar.dart';
import 'package:agap/features/resident/services/family_service.dart';
import 'package:agap/theme/color.dart';

class ResidentDashboardPage extends StatefulWidget {
  const ResidentDashboardPage({super.key});

  @override
  State<ResidentDashboardPage> createState() => _ResidentDashboardPageState();
}

class _ResidentDashboardPageState extends State<ResidentDashboardPage> {
  final int _selectedIndex = 0; // Home is active

  Map<String, dynamic>? resident;
  bool isLoading = true;
  List<Map<String, String>> liveReports = [];

  @override
  void initState() {
    super.initState();
    _loadResident();
  }

  List<Map<String, dynamic>> familyMembers = [];

  Future<void> _loadResident() async {
    final data = await AuthService().getCurrentResident();
    final familyData = await FamilyService().getFamilyMembers();
    final reports = <Map<String, String>>[];

    try {
      final advisory = await WeatherService().getWeatherAdvisory();
      reports.add({
        'title': advisory['message'] ?? 'No live weather report available.',
        'subtitle': advisory['title'] ?? 'Weather Advisory',
      });
    } catch (_) {
      reports.add({
        'title': 'Unable to fetch live weather data.',
        'subtitle': 'Weather Advisory',
      });
    }

    try {
      final earthquakes = await EarthquakeService().getEarthquakeReports();
      reports.addAll(earthquakes);
    } catch (_) {
      reports.add({
        'title': 'Unable to fetch earthquake updates.',
        'subtitle': 'USGS',
      });
    }

    if (reports.isEmpty) {
      reports.add({
        'title': 'No live reports available.',
        'subtitle': 'AGAP',
      });
    }

    setState(() {
      resident = data;
      familyMembers = familyData;
      liveReports = reports;
      isLoading = false;
    });
  }

  List<Widget> _buildLiveReportItems() {
    if (isLoading && liveReports.isEmpty) {
      return const [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 8.0),
          child: CircularProgressIndicator(),
        ),
      ];
    }

    return List<Widget>.generate(liveReports.length, (index) {
      final report = liveReports[index];
      final widgets = <Widget>[
        _buildLiveReportItem(
          report['title'] ?? 'No live report available.',
          report['subtitle'] ?? 'AGAP',
        ),
      ];

      if (index != liveReports.length - 1) {
        widgets.add(const Divider());
      }

      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: widgets,
      );
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(16),
          ),
          child: isLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name Section
                        _buildInfoRow(
                          Icons.person, 
                          "${resident?['first_name'] ?? ''} ${resident?['last_name'] ?? ''}",
                          isHeader: true
                        ),
                        const Divider(height: 20),
                        
                        // Contact & Personal Details
                        _buildInfoRow(Icons.email, resident?['email']),
                        const SizedBox(height: 8),
                        _buildInfoRow(Icons.phone, resident?['phone']),
                        const SizedBox(height: 8),
                        _buildInfoRow(Icons.cake, resident?['birthdate']),
                        const SizedBox(height: 8),
                        
                        // Address Section
                        _buildInfoRow(
                          Icons.location_on, 
                          "${resident?['house_no'] ?? ''} ${resident?['street'] ?? ''}, ${resident?['barangay'] ?? ''}, ${resident?['city'] ?? ''}",
                          ),
                        ],
                      ),
                    ),

                  const SizedBox(height: 24),

                  _buildSectionLabel("FAMILY MEMBERS"),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        // DYNAMIC LIST START
                        if (familyMembers.isEmpty)
                          const Text("No family members added", style: TextStyle(color: Colors.grey, fontSize: 12))
                        else
                          ...familyMembers.take(4).map((member) => _buildFamilyAvatar(member)), 
                        // DYNAMIC LIST END
                        
                        const Spacer(),
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
                        color: Colors.grey.shade100,
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
                  ..._buildLiveReportItems(),
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

  Widget _buildFamilyAvatar(Map<String, dynamic> member) {
  String firstName = member['first_name'] ?? "";
  String lastName = member['last_name'] ?? "";
  String initials = "";
  
  if (firstName.isNotEmpty) initials += firstName[0].toUpperCase();
  if (lastName.isNotEmpty) initials += lastName[0].toUpperCase();

  return Container(
    margin: const EdgeInsets.only(right: 12),
    width: 50,
    height: 50,
    decoration: const BoxDecoration(
      color: Color(0xFFFFB382), // Your Agap orange/peach color
      shape: BoxShape.circle,
    ),
    child: Center(
      child: Text(
        initials,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.agapOrangeDeep, // Use your deep orange for contrast
          fontSize: 16,
        ),
      ),
    ),
  );
}

Widget _buildInfoRow(IconData icon, String? text, {bool isHeader = false}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Icon(icon, size: isHeader ? 22 : 18, color: AppColors.agapOrangeDeep),
      const SizedBox(width: 12),
      Expanded(
        child: Text(
          text ?? 'N/A',
          style: TextStyle(
            fontSize: isHeader ? 16 : 13,
            fontWeight: isHeader ? FontWeight.bold : FontWeight.w500,
            color: isHeader ? Colors.black87 : Colors.black54,
          ),
        ),
      ),
    ],
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

}

