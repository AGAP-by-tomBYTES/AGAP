import 'package:agap/features/responder/widgets/signup_field.dart';
import 'package:agap/theme/color.dart';
import 'package:flutter/material.dart';
import '../data/resident_signup_data.dart';
import 'resident_signup_medical.dart';
import 'package:agap/features/responder/widgets/signup_step_header.dart';

class ResidentSignupHouseholdPage extends StatefulWidget {
  final ResidentSignupData data;

  const ResidentSignupHouseholdPage({super.key, required this.data});

  @override
  State<ResidentSignupHouseholdPage> createState() =>
      _ResidentSignupHouseholdPageState();
}

class _ResidentSignupHouseholdPageState
    extends State<ResidentSignupHouseholdPage> {

final _pets = TextEditingController();

@override
  void dispose() {
    _pets.dispose();
    super.dispose();
  }
    

  void _next() {
    widget.data.pets =
      _pets.text.trim().isEmpty ? null : _pets.text;
      
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResidentSignupMedicalPage(data: widget.data),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.data;

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

            Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _CounterCard(
                label: "Household Size",
                value: d.householdSize,
                onChanged: (v) => setState(() => d.householdSize = v),
              ),

              const SizedBox(height: 14),

              _CounterCard(
                label: "Children",
                value: d.children,
                onChanged: (v) => setState(() => d.children = v),
              ),

              const SizedBox(height: 14),

              _CounterCard(
                label: "Elderly",
                value: d.elderly,
                onChanged: (v) => setState(() => d.elderly = v),
              ),

              const SizedBox(height: 14),

              _CounterCard(
                label: "Persons with Disability",
                value: d.disabled,
                onChanged: (v) => setState(() => d.disabled = v),
              ),

              const SizedBox(height: 14),
              SignupField(
                  label: 'Pets (optional)',
                  hint: 'e.g.: dog, cat, etc.',
                  controller: _pets,
                  keyboardType: TextInputType.text,
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                ),
              
                const SizedBox(height: 20),
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

                            /// LEFT: ARROW CIRCLE
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

                            /// RIGHT: TEXT PUSHED TO RIGHT SIDE
                            const Expanded(
                              child: Text(
                                "BACK",
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
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
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          /// LABEL
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),

          /// COUNTER CONTROLS
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(999),
              border: Border.all(color: Colors.grey.shade300),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            child: Row(
              children: [
                GestureDetector(
                  onTap: _decrement,
                  child: const Icon(Icons.remove, size: 18),
                ),

                Container(
                  width: 40,
                  alignment: Alignment.center,
                  child: Text(
                    "$value",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                GestureDetector(
                  onTap: _increment,
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