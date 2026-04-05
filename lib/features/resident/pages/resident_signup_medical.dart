import 'package:agap/theme/color.dart';
import 'package:flutter/material.dart';
import 'package:agap/features/resident/models/resident_data.dart';
import 'resident_signup_review.dart';
import 'package:agap/features/auth/widgets/signup_step_header.dart';

class ResidentSignupMedicalPage extends StatefulWidget {
  final ResidentData data;

  const ResidentSignupMedicalPage({super.key, required this.data});

  @override
  State<ResidentSignupMedicalPage> createState() =>
      _ResidentSignupMedicalPageState();
}

class _ResidentSignupMedicalPageState extends State<ResidentSignupMedicalPage> {
  final _conditions = TextEditingController();
  final _history = TextEditingController();
  final _allergies = TextEditingController();
  final _medications = TextEditingController();
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _conditions.text = widget.data.conditions ?? '';
    _history.text = widget.data.history ?? '';
    _allergies.text = widget.data.allergies ?? '';
    _medications.text = widget.data.medications ?? '';
  }

  @override
  void dispose() {
    _conditions.dispose();
    _history.dispose();
    _allergies.dispose();
    _medications.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _next() {
    final updatedData = ResidentData(
      email: widget.data.email,
      password: widget.data.password,
      firstName: widget.data.firstName,
      middleName: widget.data.middleName,
      lastName: widget.data.lastName,
      suffix: widget.data.suffix,
      phone: widget.data.phone,
      birthdate: widget.data.birthdate,
      sex: widget.data.sex,
      houseNo: widget.data.houseNo,
      street: widget.data.street,
      barangay: widget.data.barangay,
      municipality: widget.data.municipality,
      city: widget.data.city,
      province: widget.data.province,
      region: widget.data.region,
      postalCode: widget.data.postalCode,
      landmark: widget.data.landmark,
      householdSize: widget.data.householdSize,
      children: widget.data.children,
      elderly: widget.data.elderly,
      disabled: widget.data.disabled,
      pets: widget.data.pets,
      conditions: _conditions.text.trim().isEmpty ? null : _conditions.text.trim(),
      history: _history.text.trim().isEmpty ? null : _history.text.trim(),
      allergies: _allergies.text.trim().isEmpty ? null : _allergies.text.trim(),
      medications: _medications.text.trim().isEmpty ? null : _medications.text.trim(),
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResidentSignupReviewPage(data: updatedData),
      ),
    );
  }

  Widget _field(String label, TextEditingController controller,
      {int maxLines = 1, String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: TextField(
              controller: controller,
              maxLines: maxLines,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hint,
                hintStyle: const TextStyle(color: Colors.grey, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SignupStepHeader(
              stepLabel: "STEP 4 OF 5",
              sectionLabel: "MEDICAL",
              title: "Medical Information",
              description: "Shared only with medical responders during emergencies.",
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(28, 16, 28, 32),
                child: Column(
                  children: [
                    _field("Current Conditions", _conditions, hint: 'e.g.: diabetes, hypertension'),
                    _field("Past Medical History", _history, hint: 'e.g.: surgeries, hospitalizations'),
                    _field("Allergies", _allergies, hint: 'e.g.: peanuts, penicillin'),
                    _field("Medications", _medications, hint: 'e.g.: aspirin, insulin'),
                    
                    const SizedBox(height: 24),

                    /// SKIP/LATER INFORMATION HINT
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.blueGrey.shade50,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.help_outline_rounded, size: 20, color: Colors.blueGrey.shade600),
                          const SizedBox(width: 10),
                          const Expanded(
                            child: Text(
                              'You can update these details later in your profile. Press continue to proceed.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.black87,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // NAVIGATION BUTTONS
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () => Navigator.pop(context),
                            style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                              side: BorderSide(color: Colors.grey.shade300),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Colors.black12,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.chevron_left_rounded,
                                    size: 28,
                                    color: Colors.black,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    "BACK",
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: FilledButton(
                            onPressed: _next,
                            style: FilledButton.styleFrom(
                              backgroundColor: AppColors.agapOrange,
                              foregroundColor: Colors.white,
                              minimumSize: const Size.fromHeight(54),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(999),
                              ),
                            ),
                            child: Row(
                              children: [
                                const SizedBox(width: 12),
                                const Expanded(
                                  child: Text(
                                    "CONTINUE",
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Colors.white24,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.chevron_right_rounded,
                                    size: 28,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}