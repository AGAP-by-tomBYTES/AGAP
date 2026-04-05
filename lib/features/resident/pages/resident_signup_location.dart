import 'package:flutter/material.dart';
import 'package:agap/features/resident/models/resident_data.dart';
import 'package:agap/features/auth/widgets/signup_field.dart';
import 'package:agap/features/auth/widgets/signup_step_header.dart';
import 'package:agap/theme/color.dart'; // Ensure this path is correct
import 'resident_signup_household.dart';

class ResidentSignupLocationPage extends StatefulWidget {
  final ResidentData data;

  const ResidentSignupLocationPage({super.key, required this.data});

  @override
  State<ResidentSignupLocationPage> createState() =>
      _ResidentSignupLocationPageState();
}

class _ResidentSignupLocationPageState extends State<ResidentSignupLocationPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  final _houseCtrl = TextEditingController();
  final _streetCtrl = TextEditingController();
  final _barangayCtrl = TextEditingController();
  final _municipalityCtrl = TextEditingController();
  final _cityCtrl = TextEditingController();
  final _provinceCtrl = TextEditingController();
  final _postalCtrl = TextEditingController();
  final _landmarkCtrl = TextEditingController();

  @override
  void dispose() {
    _scrollController.dispose();
    _houseCtrl.dispose();
    _streetCtrl.dispose();
    _barangayCtrl.dispose();
    _municipalityCtrl.dispose();
    _cityCtrl.dispose();
    _provinceCtrl.dispose();
    _postalCtrl.dispose();
    _landmarkCtrl.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _houseCtrl.text = widget.data.houseNo ?? '';
    _streetCtrl.text = widget.data.street ?? '';
    _barangayCtrl.text = widget.data.barangay;
    _municipalityCtrl.text = widget.data.municipality ?? '';
    _cityCtrl.text = widget.data.city;
    _provinceCtrl.text = widget.data.province;
    _postalCtrl.text = widget.data.postalCode ?? '';
    _landmarkCtrl.text = widget.data.landmark ?? '';
  }

  void _next() {
    if (!_formKey.currentState!.validate()) return;

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
      houseNo: _houseCtrl.text,
      street: _streetCtrl.text,
      barangay: _barangayCtrl.text,
      municipality: _municipalityCtrl.text,
      city: _cityCtrl.text,
      province: _provinceCtrl.text,
      region: widget.data.region,
      postalCode: _postalCtrl.text,
      landmark: _landmarkCtrl.text,
      householdSize: widget.data.householdSize,
      children: widget.data.children,
      elderly: widget.data.elderly,
      disabled: widget.data.disabled,
      pets: widget.data.pets,
      conditions: widget.data.conditions,
      history: widget.data.history,
      allergies: widget.data.allergies,
      medications: widget.data.medications,
    );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResidentSignupHouseholdPage(data: updatedData),
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
              stepLabel: 'STEP 2 OF 5',
              sectionLabel: 'LOCATION',
              title: 'Your location',
              description: 'Your address helps responders locate you quickly.',
            ),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                radius: const Radius.circular(999),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(28, 22, 28, 20),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: SignupField(
                                label: 'House No.',
                                hint: 'e.g.: Bldg/Floor/Unit (optional)',
                                controller: _houseCtrl,
                                validator: (v) => null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SignupField(
                                label: 'Street',
                                hint: 'e.g.: Paguntalan',
                                controller: _streetCtrl,
                                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: SignupField(
                                label: 'Barangay',
                                hint: 'e.g.: Bolho',
                                controller: _barangayCtrl,
                                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SignupField(
                                label: 'Municipality',
                                hint: 'e.g.: Miagao',
                                controller: _municipalityCtrl,
                                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: [
                            Expanded(
                              child: SignupField(
                                label: 'City',
                                hint: 'e.g.: Iloilo',
                                controller: _cityCtrl,
                                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SignupField(
                                label: 'Province',
                                hint: 'e.g.: Iloilo',
                                controller: _provinceCtrl,
                                validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SignupField(
                          label: 'Postal Code',
                          hint: 'e.g.: 5020',
                          controller: _postalCtrl,
                          keyboardType: TextInputType.number,
                          validator: (v) => v == null || v.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 14),
                        SignupField(
                          label: 'Landmark (optional)',
                          hint: 'e.g.: in front of sulu garden, etc.',
                          controller: _landmarkCtrl,
                        ),
                        const SizedBox(height: 18),
                        
                        // INFO BANNER
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: Colors.red.shade50,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.red.shade200),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Icon(Icons.info_outline_rounded, color: Colors.red, size: 28),
                              const SizedBox(height: 10),
                              const Text(
                                'Your address is only shared with authorized LGU emergency responders',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black87,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 22),

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
                                      width: 40, height: 40,
                                      decoration: const BoxDecoration(color: Colors.black12, shape: BoxShape.circle),
                                      child: const Icon(Icons.chevron_left_rounded, size: 28, color: Colors.black),
                                    ),
                                    const SizedBox(width: 12),
                                    const Expanded(
                                      child: Text(
                                        "BACK",
                                        textAlign: TextAlign.right,
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: Colors.black),
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
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                    Container(
                                      width: 40, height: 40,
                                      decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                                      child: const Icon(Icons.chevron_right_rounded, size: 28, color: Colors.white),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}