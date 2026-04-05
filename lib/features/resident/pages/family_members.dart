import 'package:agap/features/resident/pages/resident_profile.dart';
import 'package:flutter/material.dart';
import 'package:agap/theme/color.dart';
import 'package:agap/features/resident/pages/res_dashboard.dart';
import 'package:agap/features/resident/pages/emergency_hotlines.dart';
import 'package:agap/features/resident/pages/send_sos.dart';
import 'package:agap/features/resident/widgets/birthdate_format.dart'; 

class FamilyPage extends StatefulWidget {
  const FamilyPage({super.key});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  final int _selectedIndex = 3;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  String? nextOfKinId = "Juan Dela Cruz";

  List<Map<String, String>> familyMembers = [
    {
      "firstName": "Maria",
      "lastName": "Clara",
      "relation": "Mother",
      "phone": "0912 345 6789",
      "birthdate": "05/12/1975",
      "conditions": "Hypertension",
      "history": "None",
      "allergies": "Peanuts",
      "medications": "Amlodipine"
    },
    {
      "firstName": "Juan",
      "lastName": "Dela Cruz",
      "relation": "Father",
      "phone": "0998 765 4321",
      "birthdate": "11/24/1970",
      "conditions": "Stable",
      "history": "Asthma",
      "allergies": "Dust",
      "medications": "Inhaler (as needed)"
    },
  ];

  void _showDeleteMemberDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Remove Family Member"),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: familyMembers.length,
            itemBuilder: (context, index) {
              final member = familyMembers[index];
              final fullName = "${member['firstName']} ${member['lastName']}";
              return ListTile(
                leading: const Icon(Icons.person_remove, color: Colors.red),
                title: Text(fullName),
                subtitle: Text(member['relation'] ?? ""),
                onTap: () {
                  setState(() {
                    if (nextOfKinId == fullName) nextOfKinId = null;
                    familyMembers.removeAt(index);
                  });
                  Navigator.pop(context);
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _openMemberSheet({Map<String, String>? member}) {
    final bool isEditing = member != null;
    final int? indexToUpdate = isEditing ? familyMembers.indexOf(member) : null;
    final String oldMemberId = isEditing ? "${member['firstName']} ${member['lastName']}" : "";

    final fNameCtrl = TextEditingController(text: member?['firstName'] ?? '');
    final lNameCtrl = TextEditingController(text: member?['lastName'] ?? '');
    final bDateCtrl = TextEditingController(text: member?['birthdate'] ?? '');
    final relCtrl = TextEditingController(text: member?['relation'] ?? '');
    final phoneCtrl = TextEditingController(text: member?['phone'] ?? '');
    final condCtrl = TextEditingController(text: member?['conditions'] ?? '');
    final histCtrl = TextEditingController(text: member?['history'] ?? '');
    final allergCtrl = TextEditingController(text: member?['allergies'] ?? '');
    final medCtrl = TextEditingController(text: member?['medications'] ?? '');

    bool isNextOfKin = nextOfKinId == oldMemberId;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(25))),
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => DraggableScrollableSheet(
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) => SingleChildScrollView(
            controller: scrollController,
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 20,
              top: 20, left: 24, right: 24,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(isEditing ? "Edit Family Member" : "Add Family Member", 
                    style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildTextField(
                          "First Name", 
                          controller: fNameCtrl,
                          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          "Last Name", 
                          controller: lNameCtrl,
                          validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: isNextOfKin ? AppColors.agapCoral.withValues(alpha: 0.1) : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("Set as Next of Kin", style: TextStyle(fontWeight: FontWeight.bold)),
                        Switch(
                          value: isNextOfKin,
                          activeThumbColor: AppColors.agapCoral,
                          onChanged: isNextOfKin ? null : (val) {
                            setSheetState(() => isNextOfKin = val);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildTextField(
                    "Birthdate", 
                    hint: "MM/DD/YYYY", 
                    controller: bDateCtrl, 
                    isBirthdate: true,
                    validator: (v) => (v == null || v.isEmpty) ? 'Required' : null,
                  ),
                  const SizedBox(height: 15),
                  _buildTextField("Relationship", hint: "e.g., Father, Mother, Sibling", controller: relCtrl),
                  const SizedBox(height: 15),
                  _buildTextField("Phone Number", hint: "e.g., 0912 345 6789", controller: phoneCtrl),
                  const SizedBox(height: 15),
                  _buildTextField("Current Conditions", hint: "e.g., Diabetes, Hypertension", controller: condCtrl),
                  const SizedBox(height: 15),
                  _buildTextField("Past Medical History", hint: "e.g., Heart Disease, Asthma", controller: histCtrl),
                  const SizedBox(height: 15),
                  _buildTextField("Allergies", hint: "e.g., Penicillin, Shellfish", controller: allergCtrl),  
                  const SizedBox(height: 15),
                  _buildTextField("Medications", hint: "e.g., Aspirin, Insulin", controller: medCtrl),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.agapCoral,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          Map<String, String> updatedMember = {
                            "firstName": fNameCtrl.text,
                            "lastName": lNameCtrl.text,
                            "relation": relCtrl.text,
                            "phone": phoneCtrl.text,
                            "birthdate": bDateCtrl.text,
                            "conditions": condCtrl.text,
                            "history": histCtrl.text,
                            "allergies": allergCtrl.text,
                            "medications": medCtrl.text,
                          };

                          setState(() {
                            if (isEditing && indexToUpdate != null) {
                              familyMembers[indexToUpdate] = updatedMember;
                            } else {
                              familyMembers.add(updatedMember);
                            }

                            if (isNextOfKin) {
                              nextOfKinId = "${fNameCtrl.text} ${lNameCtrl.text}";
                            } else if (nextOfKinId == oldMemberId) {
                              nextOfKinId = null;
                            }
                          });
                          Navigator.pop(context);
                        }
                      },
                      child: Text(isEditing ? "Update Member Information" : "Save Member Information", 
                        style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ),
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
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 50, 24, 25),
              decoration: const BoxDecoration(
                color: AppColors.agapOrangeDeep,
                borderRadius: BorderRadius.only(
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
                      const Text(
                        'Hi, Eleah',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Philadelphia St., Bagumbayan, Iloilo, PH',
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
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 24),
                  _buildSectionLabel("HOUSEHOLD MEMBERS"),
                  
                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _openMemberSheet(),
                          child: Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.add_circle_outline, color: AppColors.agapCoral),
                                SizedBox(width: 12),
                                Text("Add member", 
                                  style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black87)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      GestureDetector(
                        onTap: _showDeleteMemberDialog,
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.agapCoral.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: AppColors.agapCoral),
                          ),
                          child: const Icon(Icons.delete_outline, color: Colors.red),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),
                  for (var member in familyMembers) 
                      _buildMemberTile(member),
                  const SizedBox(height: 100), 
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMemberTile(Map<String, String> member) {
    bool isKin = nextOfKinId == "${member['firstName']} ${member['lastName']}";

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isKin ? AppColors.agapCoral : Colors.grey.shade200, width: isKin ? 1.5 : 1),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFFFE0D1),
                child: Icon(Icons.person, color: AppColors.agapOrangeDeep),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text("${member['firstName']} ${member['lastName']}", 
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                        if (isKin) ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(color: AppColors.agapCoral, borderRadius: BorderRadius.circular(6)),
                            child: const Text("NEXT OF KIN", style: TextStyle(color: Colors.white, fontSize: 8, fontWeight: FontWeight.bold)),
                          )
                        ]
                      ],
                    ),
                    Text(member['relation']!, style: const TextStyle(color: Colors.grey, fontSize: 13)),
                  ],
                ),
              ),
              IconButton(
                onPressed: () => _openMemberSheet(member: member),
                icon: const Icon(Icons.edit_outlined, size: 20, color: AppColors.agapCoral),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: AppColors.agapCoral), 
          ),
          const Text("PERSONAL INFORMATION", style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: AppColors.agapCoral)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 20,
            runSpacing: 10,
            children: [
              _buildInfoSnippet("Birthdate", member['birthdate']!),
              _buildInfoSnippet("Phone Number", member['phone']!),
              _buildInfoSnippet("Current Conditions", member['conditions']!),
              _buildInfoSnippet("Allergies", member['allergies']!),
              _buildInfoSnippet("Medications", member['medications']!),
              _buildInfoSnippet("Past Medical History", member['history']!),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoSnippet(String label, String value) {
    return SizedBox(
      width: 120,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: Colors.grey.shade600)),
    );
  }

  Widget _buildTextField(String label, {
    String? hint, 
    TextEditingController? controller, 
    bool isBirthdate = false,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: isBirthdate ? TextInputType.number : TextInputType.text,
          inputFormatters: isBirthdate ? [BirthdateInputFormatter()] : null,
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: AppColors.lightCard,
            errorStyle: const TextStyle(height: 0.8),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
            focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.agapCoral, width: 1)),
            errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1)),
            focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.red, width: 1)),
          ),
        ),
      ],
    );
  }

  Widget _buildBottomBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      height: 65,
      decoration: BoxDecoration(color: Colors.grey.shade200, borderRadius: BorderRadius.circular(40)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _navItem(Icons.home, 0, () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ResidentDashboardPage()))),
          _navItem(Icons.call, 1, () => Navigator.push(context, MaterialPageRoute(builder: (_) => const EmergencyHotlinesPage()))),
          _buildCenterSosButton(),
          _navItem(Icons.family_restroom, 3, () {}),
          _navItem(Icons.person, 4, () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (_) => const ProfilePage()),
              );
          }),
        ],
      ),
    );
  }

  Widget _buildCenterSosButton() {
    return GestureDetector(
      onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SosPage())),
      child: Container(
        width: 55, height: 55,
        decoration: BoxDecoration(color: AppColors.agapOrangeAlt, shape: BoxShape.circle, border: Border.all(color: AppColors.agapCoral, width: 3)),
        child: const Center(child: Text("SOS", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
      ),
    );
  }

  Widget _navItem(IconData icon, int index, VoidCallback onTap) {
    return GestureDetector(onTap: onTap, child: Icon(icon, size: 28, color: _selectedIndex == index ? AppColors.agapCoral : Colors.black));
  }
}