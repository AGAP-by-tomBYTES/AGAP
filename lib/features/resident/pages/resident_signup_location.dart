import 'package:flutter/material.dart';
import 'package:agap/features/resident/models/resident_data.dart';
import 'package:agap/features/auth/widgets/signup_field.dart';
import 'package:agap/features/auth/widgets/signup_step_header.dart';
// import 'package:agap/theme/color.dart';
import 'resident_signup_household.dart';

class ResidentSignupLocationPage extends StatefulWidget {
  final ResidentData data;

  const ResidentSignupLocationPage({super.key, required this.data});

  @override
  State<ResidentSignupLocationPage> createState() =>
      _ResidentSignupLocationPageState();
}

class _ResidentSignupLocationPageState
    extends State<ResidentSignupLocationPage> {
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

    debugPrint("Location page initialized with received data");
    debugPrint(widget.data.toJson().toString());

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
    debugPrint("User tapped continue on location step");

    if (!_formKey.currentState!.validate()) {
      debugPrint("Location form validation failed");
      return;
    }

    debugPrint("Location form validation passed");

    debugPrint("Collected location input values");
    debugPrint("House: ${_houseCtrl.text}");
    debugPrint("Street: ${_streetCtrl.text}");
    debugPrint("Barangay: ${_barangayCtrl.text}");
    debugPrint("Municipality: ${_municipalityCtrl.text}");
    debugPrint("City: ${_cityCtrl.text}");
    debugPrint("Province: ${_provinceCtrl.text}");
    debugPrint("Postal Code: ${_postalCtrl.text}");
    debugPrint("Landmark: ${_landmarkCtrl.text}");

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

    debugPrint("Updated ResidentData after location step");
    debugPrint(updatedData.toJson().toString());

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
                                hint: 'e.g.: Paguntalan Street.',
                                controller: _streetCtrl,
                                validator: (v) =>
                                    v == null || v.isEmpty ? 'Required' : null,
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
                                controller: _barangayCtrl,
                                validator: (v) =>
                                    v == null || v.isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SignupField(
                                label: 'Municipality',
                                controller: _municipalityCtrl,
                                validator: (v) =>
                                    v == null || v.isEmpty ? 'Required' : null,
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
                                controller: _cityCtrl,
                                validator: (v) =>
                                    v == null || v.isEmpty ? 'Required' : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SignupField(
                                label: 'Province',
                                controller: _provinceCtrl,
                                validator: (v) =>
                                    v == null || v.isEmpty ? 'Required' : null,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        SignupField(
                          label: 'Postal Code',
                          controller: _postalCtrl,
                          validator: (v) =>
                              v == null || v.isEmpty ? 'Required' : null,
                        ),
                        const SizedBox(height: 14),
                        SignupField(
                          label: 'Landmark (optional)',
                          controller: _landmarkCtrl,
                        ),
                        const SizedBox(height: 22),
                        FilledButton(
                          onPressed: _next,
                          child: const Text('CONTINUE'),
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