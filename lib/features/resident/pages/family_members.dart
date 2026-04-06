import 'package:flutter/material.dart';
import 'package:agap/theme/color.dart';

import 'package:agap/features/resident/services/family_service.dart';
import 'package:agap/features/resident/widgets/birthdate_format.dart'; 
import 'package:agap/features/resident/widgets/resident_header.dart';
import 'package:agap/features/resident/widgets/bottom_navbar.dart';


class FamilyPage extends StatefulWidget {
  final Map<String, dynamic>? resident;

  const FamilyPage({super.key, required this.resident});

  @override
  State<FamilyPage> createState() => _FamilyPageState();
}

class _FamilyPageState extends State<FamilyPage> {
  final int _selectedIndex = 3;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final FamilyService _familyService = FamilyService();

  List<Map<String, dynamic>> familyMembers = [];
  bool isLoading = true;

  String? nextOfKinId;

  @override
  void initState() {
    super.initState();
    _loadFamily();
  }

  Future<void> _loadFamily() async {
    final data = await _familyService.getFamilyMembers();

    if (!mounted) return;

    setState(() {
      familyMembers = data;
      isLoading = false;
    });
  }

  void _showDeleteMemberDialog() {
    final dialogNavigator = Navigator.of(context);

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
              final fullName = "${member['first_name']} ${member['last_name']}";
              debugPrint(member.toString());
              return ListTile(
                leading: const Icon(Icons.person_remove, color: Colors.red),
                title: Text(fullName),
                subtitle: Text(member['relationship'] ?? ""),
                onTap: () async {
                  await _familyService.deleteFamilyMember(
                    member['id'],
                    member['is_registered'],
                  );
                  await _loadFamily();

                  if (!mounted) return;

                  dialogNavigator.pop();
                },
              );
            },
          ),
        ),
      ),
    );
  }

  void _openMemberSheet({Map<String, dynamic>? member}) {
    final bool isEditing = member != null;
    final sheetNavigator = Navigator.of(context);
    // final int? indexToUpdate = isEditing ? familyMembers.indexOf(member) : null;
    // final String oldMemberId = isEditing ? "${member['firstName']} ${member['lastName']}" : "";

    final fNameCtrl = TextEditingController(text: member?['first_name'] ?? '');
    final lNameCtrl = TextEditingController(text: member?['last_name'] ?? '');
    final bDateCtrl = TextEditingController(text: member?['birthdate'] ?? '');
    final relCtrl = TextEditingController(text: member?['relationship'] ?? '');
    final phoneCtrl = TextEditingController(text: member?['phone'] ?? '');
    final condCtrl = TextEditingController(text: member?['conditions'] ?? '');
    final histCtrl = TextEditingController(text: member?['history'] ?? '');
    final allergCtrl = TextEditingController(text: member?['allergies'] ?? '');
    final medCtrl = TextEditingController(text: member?['medications'] ?? '');

    bool isNextOfKin = false;

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
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (!_formKey.currentState!.validate()) return;
                      if (isEditing) {
                        await _familyService.updateFamilyMember(
                          id: member['id'],
                          firstName: fNameCtrl.text,
                          lastName: lNameCtrl.text,
                          relationship: relCtrl.text,
                          phone: phoneCtrl.text,
                          birthdate: bDateCtrl.text,
                          conditions: condCtrl.text,
                          history: histCtrl.text,
                          allergies: allergCtrl.text,
                          medications: medCtrl.text,
                          isNextOfKin: isNextOfKin,
                        );
                      } else {
                              await _familyService.addFamilyMember(
                                firstName: fNameCtrl.text,
                                lastName: lNameCtrl.text,
                                relationship: relCtrl.text,
                                phone: phoneCtrl.text,
                                birthdate: bDateCtrl.text,
                                conditions: condCtrl.text,
                                history: histCtrl.text,
                                allergies: allergCtrl.text,
                                medications: medCtrl.text,
                                isNextOfKin: isNextOfKin,
                              );
                            }
                            await _loadFamily();
                            if (!mounted) return;

                            setState(() {
                              if (isNextOfKin) {
                                  nextOfKinId = "${fNameCtrl.text} ${lNameCtrl.text}";
                            } else if (nextOfKinId ==
                                 "${fNameCtrl.text} ${lNameCtrl.text}") {
                                  nextOfKinId = null;
                            }
                          });

                    if (!mounted) return;

                      sheetNavigator.pop();
                    },
                    child: Text(
                      isEditing ? "Update Member Information"  : "Save Member Information", style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ),
                ],
            ),
          ),
        ),
        ),
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      bottomNavigationBar: ResidentBottomNavBar(
        selectedIndex: _selectedIndex,
        resident: widget.resident
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ResidentHeader(resident: widget.resident, isLoading: false),

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

  Widget _buildMemberTile(Map<String, dynamic> member) {
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
                        Text("${member['first_name']} ${member['last_name']}", 
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
                    Text(member['relationship']!, style: const TextStyle(color: Colors.grey, fontSize: 13)),
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
              _buildInfoSnippet("Birthdate", member['birthdate']),
              _buildInfoSnippet("Phone Number", member['phone']),
              _buildInfoSnippet("Current Conditions", member['conditions']),
              _buildInfoSnippet("Allergies", member['allergies']),
              _buildInfoSnippet("Medications", member['medications']),
              _buildInfoSnippet("Past Medical History", member['history']),
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
}
