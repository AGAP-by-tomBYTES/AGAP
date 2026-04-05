import 'package:flutter/material.dart';
import 'package:agap/features/resident/models/resident_data.dart';
import 'package:agap/features/auth/services/auth_service.dart';
import 'resident_test_page.dart';
import 'package:agap/features/auth/widgets/signup_step_header.dart';

class ResidentSignupReviewPage extends StatelessWidget {
  final ResidentData data;

  const ResidentSignupReviewPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final repo = AuthService();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [

            /// FULL WIDTH HEADER
            const SignupStepHeader(
              stepLabel: "STEP 5 OF 5",
              sectionLabel: "REVIEW",
              title: "Review and Confirm",
              description:
                  "Make sure everything looks right before we create your profile.",
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: ListView(
                  children: [

                    const SizedBox(height: 16),

                    _section("ACCOUNT DETAILS", [
                      _item("Name",
                          "${data.firstName} ${data.middleName ?? ''} ${data.lastName} ${data.suffix ?? ''}"),
                      _item("Email", data.email),
                      _item("Phone", data.phone),
                      _item("Birthdate", data.birthdate),
                      _item("Gender", data.sex),
                    ]),

                    _section("LOCATION DETAILS", [
                      _item("House No.", data.houseNo ?? "N/A"),
                      _item("Street", data.street),
                      _item("Barangay", data.barangay),
                      _item("Municipality", data.municipality),
                      _item("City", data.city),
                      _item("Province", data.province),
                      _item("Zip Code", data.postalCode),
                      _item("Landmark", data.landmark ?? "N/A"),
                    ]),

                    _section("HOUSEHOLD DETAILS", [
                      _item("Household Size", "${data.householdSize}"),
                      _item("Children", "${data.children}"),
                      _item("Elderly", "${data.elderly}"),
                      _item("PWD", "${data.disabled}"),
                      _item("Pets", data.pets ?? "None"),
                    ]),

                    _section("MEDICAL DETAILS", [
                      _item("Conditions", data.conditions ?? "-"),
                      _item("History", data.history ?? "-"),
                      _item("Allergies", data.allergies ?? "-"),
                      _item("Medications", data.medications ?? "-"),
                    ]),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            /// BUTTON ROW
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [

                  /// BACK BUTTON
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
                        children: const [

                          /// LEFT ICON
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.black12,
                            child: Icon(
                              Icons.chevron_left_rounded,
                              color: Colors.black,
                              size: 26,
                            ),
                          ),

                          SizedBox(width: 12),

                          /// RIGHT TEXT
                          Expanded(
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

                  /// CREATE PROFILE BUTTON (DARK BLUE)
                  Expanded(
                    child: FilledButton(
                      onPressed: () async {
                        await repo.signUpResident(data);
                        if (!context.mounted) return;

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const ResidentTestPage(),
                          ),
                        );
                      },
                      style: FilledButton.styleFrom(
                        backgroundColor: const Color(0xFF0D47A1), // 🔵 DARK BLUE
                        foregroundColor: Colors.white,
                        minimumSize: const Size.fromHeight(54),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: Row(
                        children: const [

                          SizedBox(width: 12),

                          Expanded(
                            child: Text(
                              "CREATE PROFILE",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ),

                          /// RIGHT ICON
                          CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white24,
                            child: Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// SECTION CARD
  Widget _section(String title, List<Widget> children) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 10),
          ...children,
        ],
      ),
    );
  }

  Widget _item(String label, dynamic value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "$label: ",
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        Expanded(
          child: Text(
            value?.toString() ?? "-",
          ),
        ),
      ],
    ),
  );
}
}