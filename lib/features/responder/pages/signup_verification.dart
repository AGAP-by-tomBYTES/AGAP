//PART 2 SIGNUP VERIFICATION

import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:agap/features/responder/widgets/signup_step_header.dart';
import 'package:agap/features/responder/widgets/verification_upload_card.dart';
import 'package:agap/theme/color.dart';

class ResponderSignupVerificationPage extends StatefulWidget {
  const ResponderSignupVerificationPage({
    super.key,
    this.idDocumentTitle = 'Employee ID',
    this.idUploadDescription =
        'Upload a clear photo of your employee ID\nto verify you as an authorized responder',
    this.idNumberLabel = 'Employee ID number',
    this.idNumberHint = 'e.g. MDRRMO-23102B',
  });

  final String idDocumentTitle;
  final String idUploadDescription;
  final String idNumberLabel;
  final String idNumberHint;

  @override
  State<ResponderSignupVerificationPage> createState() =>
      _ResponderSignupVerificationPageState();
}

class _ResponderSignupVerificationPageState
    extends State<ResponderSignupVerificationPage> {
  final _scrollController = ScrollController();
  final _employeeIdController = TextEditingController();
  final _imagePicker = ImagePicker();
  String? _selectedRole;
  Uint8List? _employeeIdImageBytes;
  String? _employeeIdImageName;

  static const _roleOptions = [
    'Incident Commander',
    'Operations Officer',
    'Medic',
    'Search and Rescue',
    'Communications Officer',
  ];

  @override
  void dispose() {
    _scrollController.dispose();
    _employeeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            const SignupStepHeader(
              stepLabel: 'STEP 2 OF 2',
              sectionLabel: 'VERIFICATION',
              title: 'Verify your ID',
              description:
                  'Enter your employee ID details to complete verification.',
            ),
            Expanded(
              child: Scrollbar(
                controller: _scrollController,
                thumbVisibility: true,
                radius: const Radius.circular(999),
                child: SingleChildScrollView(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(24, 40, 24, 28),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VerificationUploadCard(
                        onTap: _pickEmployeeIdImage,
                        title: widget.idDocumentTitle,
                        description: widget.idUploadDescription,
                        imageBytes: _employeeIdImageBytes,
                        imageName: _employeeIdImageName,
                      ),
                      const SizedBox(height: 28),
                      Text(
                        widget.idNumberLabel,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextFormField(
                        controller: _employeeIdController,
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: widget.idNumberHint,
                          hintStyle: const TextStyle(
                            color: AppColors.inputHint,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 16,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                              width: 1.4,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: AppColors.agapOrangeDeep,
                              width: 1.6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 14),
                      const Text(
                        'Responder Role',
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownButtonFormField<String>(
                        value: _selectedRole,
                        items: _roleOptions
                            .map(
                              (role) => DropdownMenuItem<String>(
                                value: role,
                                child: Text(role),
                              ),
                            )
                            .toList(),
                        onChanged: (value) {
                          setState(() {
                            _selectedRole = value;
                          });
                        },
                        icon: const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          color: AppColors.dropdownIcon,
                        ),
                        style: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Select role',
                          hintStyle: const TextStyle(
                            color: AppColors.inputHint,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 16,
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: AppColors.border,
                              width: 1.4,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(14),
                            borderSide: const BorderSide(
                              color: AppColors.agapOrangeDeep,
                              width: 1.6,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 64),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              style: OutlinedButton.styleFrom(
                                foregroundColor: AppColors.agapOrangeDeep,
                                side: const BorderSide(
                                  color: AppColors.agapOrangeDeep,
                                  width: 2,
                                ),
                                minimumSize: const Size.fromHeight(54),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              child: const Text(
                                'BACK',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            flex: 2,
                            child: FilledButton(
                              onPressed: _handleCreateProfile,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.agapNavy,
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(54),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(999),
                                ),
                              ),
                              child: Row(
                                children: [
                                  const SizedBox(width: 8),
                                  const Expanded(
                                    child: Text(
                                      'CREATE PROFILE',
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
                                      color: AppColors.overlayWhiteMedium,
                                      shape: BoxShape.circle,
                                    ),
                                    alignment: Alignment.center,
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
            ),
          ],
        ),
      ),
    );
  }

  void _handleCreateProfile() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Responder profile creation is ready for backend.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _pickEmployeeIdImage() async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library_outlined),
                title: const Text('Choose from gallery'),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.gallery);
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_camera_outlined),
                title: const Text('Take a photo'),
                onTap: () {
                  Navigator.of(context).pop(ImageSource.camera);
                },
              ),
            ],
          ),
        );
      },
    );

    if (source == null) {
      return;
    }

    final image = await _imagePicker.pickImage(
      source: source,
      imageQuality: 88,
    );

    if (image == null) {
      return;
    }

    final bytes = await image.readAsBytes();
    setState(() {
      _employeeIdImageBytes = bytes;
      _employeeIdImageName = image.name;
    });
  }
}
