import 'package:agap/features/auth/widgets/signup_field.dart';
import 'package:agap/theme/color.dart'; // Uncommented to use AppColors
import 'package:flutter/material.dart';
import 'package:agap/features/resident/models/resident_data.dart';
import 'package:agap/features/auth/widgets/signup_step_header.dart';
import 'resident_signup_medical.dart';

class ResidentSignupHouseholdPage extends StatefulWidget {
  final ResidentData data;

  const ResidentSignupHouseholdPage({super.key, required this.data});

  @override
  State<ResidentSignupHouseholdPage> createState() =>
      _ResidentSignupHouseholdPageState();
}

class _ResidentSignupHouseholdPageState
    extends State<ResidentSignupHouseholdPage> {
  final _pets = TextEditingController();
  final _scrollController = ScrollController();

  int householdSize = 1;
  int children = 0;
  int elderly = 0;
  int disabled = 0;

  @override
  void initState() {
    super.initState();
    householdSize = widget.data.householdSize;
    children = widget.data.children;
    elderly = widget.data.elderly;
    disabled = widget.data.disabled;
    _pets.text = widget.data.pets ?? '';
  }

  @override
  void dispose() {
    _pets.dispose();
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
      householdSize: householdSize,
      children: children,
      elderly: elderly,
      disabled: disabled,
      pets: _pets.text.trim().isEmpty ? null : _pets.text.trim(),
      conditions: widget.data.conditions,
      history: widget.data.history,
      allergies: widget.data.allergies,
      medications: widget.data.medications,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResidentSignupMedicalPage(data: updatedData),
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
              stepLabel: 'STEP 3 OF 5',
              sectionLabel: 'HOUSEHOLD',
              title: 'Your Household',
              description:
                  'Helps responders plan resources and prioritize vulnerable members.',
            ),
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(28, 22, 28, 20),
                child: Column(
                  children: [
                    _CounterCard(
                      label: "Household Size",
                      value: householdSize,
                      onChanged: (v) => setState(() => householdSize = v),
                    ),
                    const SizedBox(height: 14),
                    _CounterCard(
                      label: "Children",
                      value: children,
                      onChanged: (v) => setState(() => children = v),
                    ),
                    const SizedBox(height: 14),
                    _CounterCard(
                      label: "Elderly",
                      value: elderly,
                      onChanged: (v) => setState(() => elderly = v),
                    ),
                    const SizedBox(height: 14),
                    _CounterCard(
                      label: "Persons with Disability",
                      value: disabled,
                      onChanged: (v) => setState(() => disabled = v),
                    ),
                    const SizedBox(height: 14),
                    SignupField(
                      label: 'Pets (optional)',
                      hint: 'e.g.: dog, cat, etc.',
                      controller: _pets,
                      keyboardType: TextInputType.text,
                      validator: (v) => null,
                    ),
                    
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
                              backgroundColor: AppColors.agapOrangeDeep,
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
                                    'CONTINUE',
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

class _CounterCard extends StatelessWidget {
  final String label;
  final int value;
  final Function(int) onChanged;

  const _CounterCard({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  void _decrement() {
    if (value > 0) onChanged(value - 1);
  }

  void _increment() {
    onChanged(value + 1);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _decrement,
                icon: const Icon(Icons.remove_circle_outline, color: Colors.redAccent),
              ),
              SizedBox(
                width: 30,
                child: Text(
                  "$value",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                onPressed: _increment,
                icon: const Icon(Icons.add_circle_outline, color: Colors.green),
              ),
            ],
          ),
        ],
      ),
    );
  }
}