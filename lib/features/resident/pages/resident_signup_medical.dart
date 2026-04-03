import 'package:agap/theme/color.dart';
import 'package:flutter/material.dart';
import '../data/resident_signup_data.dart';
import 'resident_signup_review.dart';
import 'package:agap/features/responder/widgets/signup_step_header.dart';

class ResidentSignupMedicalPage extends StatefulWidget {
  final ResidentSignupData data;

  const ResidentSignupMedicalPage({super.key, required this.data});

  @override
  State<ResidentSignupMedicalPage> createState() =>
      _ResidentSignupMedicalPageState();
}

class _ResidentSignupMedicalPageState
    extends State<ResidentSignupMedicalPage> {

  final _conditions = TextEditingController();
  final _history = TextEditingController();
  final _allergies = TextEditingController();
  final _medications = TextEditingController();

  @override
  void initState() {
    super.initState();
    _conditions.text = widget.data.conditions ?? '';
    _history.text = widget.data.history ?? '';
    _allergies.text = widget.data.allergies ?? '';
    _medications.text = widget.data.medications ?? '';
  }

  void _next() {
    widget.data.conditions = _conditions.text;
    widget.data.history = _history.text;
    widget.data.allergies = _allergies.text;
    widget.data.medications = _medications.text;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ResidentSignupReviewPage(data: widget.data),
      ),
    );
  }

  /// LABEL OUTSIDE + FIELD INSIDE (CLEAN FORM STYLE)
  Widget _field(String label, TextEditingController controller,
      {int maxLines = 1, String? hint}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
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
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
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
              description:
                  "Shared only with medical responders during emergencies.",
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [

                    const SizedBox(height: 16),
                    _field("Current Conditions", _conditions, hint: 'e.g.: diabetes, hypertension, etc.'),
                    _field("Past Medical History", _history, hint: 'e.g.: surgeries, hospitalizations, etc.'),
                    _field("Allergies", _allergies, hint: 'e.g.: peanuts, shellfish, etc.'),
                    _field("Medications", _medications, hint: 'e.g.: aspirin, insulin, etc.'),

                    const Spacer(),

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
            ),
          ],
        ),
      ),
    );
  }
}