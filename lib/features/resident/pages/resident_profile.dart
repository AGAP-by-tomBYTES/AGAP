import 'package:flutter/material.dart';
import 'package:agap/theme/color.dart';
import 'package:agap/features/resident/pages/res_dashboard.dart';
import 'package:agap/features/resident/pages/emergency_hotlines.dart';
import 'package:agap/features/resident/pages/send_sos.dart';
import 'package:agap/features/resident/pages/family_members.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final int _selectedIndex = 4;

  // Mock Data
  Map<String, dynamic> userData = {
    "firstName": "Eleah Joy",
    "middleName": "Melchor",
    "lastName": "Dela Cruz",
    "suffix": "",
    "email": "eleah.joy@email.com",
    "phone": "0912 345 6789",
    "birthdate": "05/12/1998",
    "gender": "Female",
    "houseNo": "12",
    "street": "Philadelphia St.",
    "barangay": "Bagumbayan",
    "city": "Iloilo City",
    "province": "Iloilo",
    "postalCode": "5000",
    "landmark": "Near the blue gate",
    "householdSize": 4,
    "children": 1,
    "elderly": 1,
    "disabled": 0,
    "pets": "2 Dogs",
    "conditions": "None",
    "history": "None",
    "allergies": "Peanuts, Dust",
    "medications": "None",
  };

  void _openEditSheet(String section) {
    // Controllers
    final fNameCtrl = TextEditingController(text: userData['firstName']);
    final mNameCtrl = TextEditingController(text: userData['middleName']);
    final lNameCtrl = TextEditingController(text: userData['lastName']);
    final suffixCtrl = TextEditingController(text: userData['suffix']);
    final phoneCtrl = TextEditingController(text: userData['phone']);
    final emailCtrl = TextEditingController(text: userData['email']);

    final houseCtrl = TextEditingController(text: userData['houseNo']);
    final streetCtrl = TextEditingController(text: userData['street']);
    final brgyCtrl = TextEditingController(text: userData['barangay']);
    final cityCtrl = TextEditingController(text: userData['city']);
    final provCtrl = TextEditingController(text: userData['province']);
    final zipCtrl = TextEditingController(text: userData['postalCode']);
    final landmarkCtrl = TextEditingController(text: userData['landmark']);

    final petsCtrl = TextEditingController(text: userData['pets']);
    final condCtrl = TextEditingController(text: userData['conditions']);
    final histCtrl = TextEditingController(text: userData['history']);
    final allergyCtrl = TextEditingController(text: userData['allergies']);
    final medCtrl = TextEditingController(text: userData['medications']);

    // Temporary values for counters
    int tempSize = userData['householdSize'];
    int tempChildren = userData['children'];
    int tempElderly = userData['elderly'];
    int tempDisabled = userData['disabled'];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => DraggableScrollableSheet(
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 20,
              left: 24,
              right: 24,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Edit $section",
                    style: const TextStyle(
                        fontSize: 22, fontWeight: FontWeight.bold)),
                const SizedBox(height: 20),

                if (section == "Personal Info") ...[
                  _buildEditField("First Name", fNameCtrl),
                  const SizedBox(height: 12),
                  _buildEditField("Middle Name", mNameCtrl),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildEditField("Last Name", lNameCtrl)),
                      const SizedBox(width: 12),
                      SizedBox(
                          width: 80,
                          child: _buildEditField("Suffix", suffixCtrl)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildEditField("Email Address", emailCtrl),
                  const SizedBox(height: 12),
                  _buildEditField("Phone Number", phoneCtrl),
                ],

                if (section == "Address") ...[
                  Row(
                    children: [
                      SizedBox(
                          width: 100,
                          child: _buildEditField("House No.", houseCtrl)),
                      const SizedBox(width: 12),
                      Expanded(child: _buildEditField("Street", streetCtrl)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildEditField("Barangay", brgyCtrl),
                  const SizedBox(height: 12),
                  _buildEditField("City/Municipality", cityCtrl),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(child: _buildEditField("Province", provCtrl)),
                      const SizedBox(width: 12),
                      SizedBox(
                          width: 120,
                          child: _buildEditField("Postal Code", zipCtrl)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildEditField("Landmark", landmarkCtrl),
                ],

                if (section == "Household Info") ...[
                  _counterCard(
                    label: "Household Size",
                    value: tempSize,
                    onChanged: (v) => setSheetState(() => tempSize = v),
                  ),
                  const SizedBox(height: 14),
                  _counterCard(
                    label: "Children",
                    value: tempChildren,
                    onChanged: (v) => setSheetState(() => tempChildren = v),
                  ),
                  const SizedBox(height: 14),
                  _counterCard(
                    label: "Elderly",
                    value: tempElderly,
                    onChanged: (v) => setSheetState(() => tempElderly = v),
                  ),
                  const SizedBox(height: 14),
                  _counterCard(
                    label: "Disabled",
                    value: tempDisabled,
                    onChanged: (v) => setSheetState(() => tempDisabled = v),
                  ),
                  const SizedBox(height: 14),
                  _buildEditField("Pets (optional)", petsCtrl),
                ],

                if (section == "Medical Profile") ...[
                  _buildEditField("Current Conditions", condCtrl),
                  const SizedBox(height: 12),
                  _buildEditField("Past Medical History", histCtrl),
                  const SizedBox(height: 12),
                  _buildEditField("Allergies", allergyCtrl),
                  const SizedBox(height: 12),
                  _buildEditField("Medications", medCtrl),
                ],

                const SizedBox(height: 30),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.agapCoral,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    onPressed: () {
                      setState(() {
                        if (section == "Personal Info") {
                          userData['firstName'] = fNameCtrl.text;
                          userData['middleName'] = mNameCtrl.text;
                          userData['lastName'] = lNameCtrl.text;
                          userData['suffix'] = suffixCtrl.text;
                          userData['email'] = emailCtrl.text;
                          userData['phone'] = phoneCtrl.text;
                        } else if (section == "Address") {
                          userData['houseNo'] = houseCtrl.text;
                          userData['street'] = streetCtrl.text;
                          userData['barangay'] = brgyCtrl.text;
                          userData['city'] = cityCtrl.text;
                          userData['province'] = provCtrl.text;
                          userData['postalCode'] = zipCtrl.text;
                          userData['landmark'] = landmarkCtrl.text;
                        } else if (section == "Household Info") {
                          userData['householdSize'] = tempSize;
                          userData['children'] = tempChildren;
                          userData['elderly'] = tempElderly;
                          userData['disabled'] = tempDisabled;
                          userData['pets'] = petsCtrl.text;
                        } else if (section == "Medical Profile") {
                          userData['conditions'] = condCtrl.text;
                          userData['history'] = histCtrl.text;
                          userData['allergies'] = allergyCtrl.text;
                          userData['medications'] = medCtrl.text;
                        }
                      });
                      Navigator.pop(context);
                    },
                    child: const Text("Update Profile",
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
            /// ISLAND HEADER
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 50, 24, 25),
              decoration: const BoxDecoration(
                color: AppColors.agapOrangeDeep,
                borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Hi, ${userData['firstName']}',
                          style: const TextStyle(
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      const SizedBox(height: 2),
                      Text(
                          '${userData['street']}, ${userData['barangay']}, ${userData['city']}',
                          style: TextStyle(
                              fontSize: 11,
                              color: Colors.white.withValues(alpha: 0.9))),
                    ],
                  ),
                  const Icon(Icons.notifications_none_outlined,
                      color: Colors.white, size: 28),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionHeader(
                      "PERSONAL INFORMATION", () => _openEditSheet("Personal Info")),
                  _buildInfoTile(Icons.person_outline, "Full Name",
                      "${userData['firstName']} ${userData['middleName']} ${userData['lastName']} ${userData['suffix']}"),
                  _buildInfoTile(
                      Icons.email_outlined, "Email Address", userData['email']),
                  _buildInfoTile(Icons.phone_android_outlined, "Phone Number",
                      userData['phone']),
                  _buildInfoTile(
                      Icons.cake_outlined, "Birthdate", userData['birthdate']),

                  const SizedBox(height: 24),
                  _buildSectionHeader("ADDRESS", () => _openEditSheet("Address")),
                  _buildInfoTile(Icons.location_on_outlined, "Address",
                      "${userData['houseNo']} ${userData['street']}, ${userData['barangay']}, ${userData['city']}, ${userData['province']} ${userData['postalCode']}"),
                  _buildInfoTile(
                      Icons.landscape_outlined, "Landmark", userData['landmark']),

                  const SizedBox(height: 24),
                  _buildSectionHeader(
                      "HOUSEHOLD INFO", () => _openEditSheet("Household Info")),
                  _buildHouseholdGrid(),

                  const SizedBox(height: 24),
                  _buildSectionHeader(
                      "MEDICAL PROFILE", () => _openEditSheet("Medical Profile")),
                  _buildMedicalCard(),

                  const SizedBox(height: 32),
                  _buildLogoutButton(),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, VoidCallback? onEdit) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: Colors.grey,
                  letterSpacing: 0.5)),
          if (onEdit != null)
            GestureDetector(
              onTap: onEdit,
              child: const Icon(Icons.edit_outlined,
                  size: 18, color: AppColors.agapCoral),
            )
        ],
      ),
    );
  }

  Widget _buildHouseholdGrid() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Wrap(
        spacing: 20,
        runSpacing: 15,
        children: [
          _buildCountItem("Total Size", userData['householdSize']),
          _buildCountItem("Children", userData['children']),
          _buildCountItem("Elderly", userData['elderly']),
          _buildCountItem("Disabled", userData['disabled']),
          _buildCountItem("Pets", userData['pets']),
        ],
      ),
    );
  }

  Widget _buildCountItem(String label, dynamic count) {
    return SizedBox(
      width: 80,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.bold)),
          Text(count.toString(),
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87)),
        ],
      ),
    );
  }

  Widget _buildMedicalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        children: [
          _medicalRow("Current Conditions", userData['conditions']),
          const Divider(height: 24),
          _medicalRow("Past Medical History", userData['history']),
          const Divider(height: 24),
          _medicalRow("Allergies", userData['allergies']),
          const Divider(height: 24),
          _medicalRow("Medications", userData['medications']),
        ],
      ),
    );
  }

  Widget _medicalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.black54)),
        Expanded(
            child: Text(value,
                textAlign: TextAlign.end,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.agapCoral))),
      ],
    );
  }

  Widget _buildEditField(String label, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide.none),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.agapOrangeDeep),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                        fontWeight: FontWeight.w600)),
                Text(value,
                    style: const TextStyle(
                        fontSize: 14, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutButton() {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: () {},
        icon: const Icon(Icons.logout, color: Colors.redAccent),
        label: const Text("Logout Account",
            style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          side: const BorderSide(color: Colors.redAccent),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 65,
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(40)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navItem(
              Icons.home,
              0,
              () => Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const ResidentDashboardPage()))),
          _navItem(
              Icons.call,
              1,
              () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) => const EmergencyHotlinesPage()))),
          _buildCenterSosButton(),
          _navItem(
              Icons.family_restroom,
              3,
              () => Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (_) => const FamilyPage()))),
          _navItem(Icons.person, 4, () {}),
        ],
      ),
    );
  }

  Widget _buildCenterSosButton() {
    return GestureDetector(
      onTap: () => Navigator.push(
          context, MaterialPageRoute(builder: (_) => const SosPage())),
      child: Container(
        width: 55,
        height: 55,
        decoration: BoxDecoration(
            color: AppColors.agapOrangeAlt,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.agapCoral, width: 3)),
        child: const Center(
            child: Text("SOS",
                style: TextStyle(
                    color: Colors.white, fontWeight: FontWeight.bold))),
      ),
    );
  }

  Widget _navItem(IconData icon, int index, VoidCallback onTap) {
    return GestureDetector(
        onTap: onTap,
        child: Icon(icon,
            size: 28,
            color: _selectedIndex == index ? AppColors.agapCoral : Colors.black));
  }

  Widget _counterCard(
      {required String label,
      required int value,
      required Function(int) onChanged}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 14, fontWeight: FontWeight.w600)),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                GestureDetector(
                  onTap: () {
                    if (value > 0) onChanged(value - 1);
                  },
                  child: const Icon(Icons.remove, size: 18),
                ),
                Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: Text("$value",
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ),
                GestureDetector(
                  onTap: () => onChanged(value + 1),
                  child: const Icon(Icons.add, size: 18),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}