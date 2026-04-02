import 'package:flutter/material.dart';
import 'package:agap/features/resident/data/resident_signup_data.dart';
import 'package:agap/features/resident/pages/resident_signup_location.dart';
import 'package:agap/features/responder/widgets/auth_switch_prompt.dart';
import 'package:agap/features/responder/widgets/signup_field.dart';
import 'package:agap/features/responder/widgets/signup_step_header.dart';
import 'package:agap/features/resident/widgets/birthdate_format.dart';
import 'package:agap/theme/color.dart';
import 'package:flutter/services.dart';

class ResidentSignupPage extends StatefulWidget {
  const ResidentSignupPage({super.key});

  @override
  State<ResidentSignupPage> createState() => _ResidentSignupPageState();
}

class _ResidentSignupPageState extends State<ResidentSignupPage> {
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _middleNameController = TextEditingController();
  final _suffixController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController(text: '+63');
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _birthdateController = TextEditingController();
  String? _selectedGender;

  bool _isHiddenPassword = true;
  bool _isHiddenConfirmPassword = true;

  @override
  void dispose() {
    _scrollController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _middleNameController.dispose();
    _suffixController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _birthdateController.dispose();
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
              stepLabel: 'STEP 1 OF 5',
              sectionLabel: 'ACCOUNT',
              title: 'Create your account',
              description:
                  'Your details help us reach you faster in an emergency.',
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
                        /// FIRST + LAST NAME
                        Row(
                          children: [
                            Expanded(
                              child: SignupField(
                                label: 'First name',
                                hint: 'e.g. Juan',
                                controller: _firstNameController,
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SignupField(
                                label: 'Last name',
                                hint: 'e.g. Dela Cruz',
                                controller: _lastNameController,
                                validator: (v) => v == null || v.trim().isEmpty
                                    ? 'Required'
                                    : null,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        /// MIDDLE + SUFFIX
                        Row(
                          children: [
                            Expanded(
                              child: SignupField(
                                label: 'Middle name',
                                hint: 'e.g. Santos',
                                controller: _middleNameController,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: SignupField(
                                label: 'Suffix',
                                hint: 'e.g. Jr.',
                                controller: _suffixController,
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 14),
                      SignupField(
                      label: 'Birthdate',
                      hint: "MM/DD/YYYY", 
                      controller: _birthdateController,
                      keyboardType: TextInputType.number,
                      validator: _validateBirthdate,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly, 
                      BirthdateInputFormatter(),],
                      ),

                      const SizedBox(height: 14),

                      const Text(
                        'Gender',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Wrap(
                        spacing: 8,
                        children: [
                          _genderChip('Male'),
                          _genderChip('Female'),
                          _genderChip('Non-binary'),
                          _genderChip('Prefer not to say'),
                        ],
                      ),
         
                      const SizedBox(height: 14),
                        /// EMAIL
                        SignupField(
                          label: 'Email',
                          hint: 'e.g. juan@gmail.com',
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          validator: (v) {
                            if (v == null || v.trim().isEmpty) {
                              return 'Required';
                            }
                            if (!v.contains('@')) {
                              return 'Enter a valid email';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        /// PHONE
                        SignupField(
                          label: 'Phone number',
                          controller: _phoneController,
                          keyboardType: TextInputType.phone,
                          validator: (v) {
                            if (v == null || v.trim().length != 13 || !v.startsWith('+63')) {
                              return 'Enter a valid phone number';
                            }
                            return null;
                          },
                        ),

                        const SizedBox(height: 14),

                        /// PASSWORD
                        SignupField(
                          label: 'Password',
                          controller: _passwordController,
                          obscureText: _isHiddenPassword,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (v.length < 6) return 'Min 6 characters';
                            return null;
                          },
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isHiddenPassword = !_isHiddenPassword;
                              });
                            },
                            icon: Icon(
                              _isHiddenPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        /// CONFIRM PASSWORD
                        SignupField(
                          label: 'Confirm Password',
                          controller: _confirmPasswordController,
                          obscureText: _isHiddenConfirmPassword,
                          validator: (v) {
                            if (v == null || v.isEmpty) return 'Required';
                            if (v != _passwordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isHiddenConfirmPassword =
                                    !_isHiddenConfirmPassword;
                              });
                            },
                            icon: Icon(
                              _isHiddenConfirmPassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textMuted,
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        /// CONTINUE BUTTON
                        SizedBox(
                          width: double.infinity,
                          child: FilledButton(
                            onPressed: _handleContinue,
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
                                      fontSize: 16,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: AppColors.overlayWhiteStrong,
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

                        const SizedBox(height: 12),

                        /// LOGIN SWITCH
                        AuthSwitchPrompt(
                          promptText: 'Already have an account? ',
                          actionText: 'Log In',
                          onTap: () {
                            Navigator.of(context).pop();
                          },
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

  void _handleContinue() {
    if (!_formKey.currentState!.validate()) return;

    if (_selectedGender == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a gender'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    final data = ResidentSignupData(
      email: _emailController.text.trim(),
      password: _passwordController.text.trim(),
      firstName: _firstNameController.text.trim(),
      middleName: _middleNameController.text.trim().isEmpty
          ? null
          : _middleNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      suffix: _suffixController.text.trim().isEmpty
          ? null
          : _suffixController.text.trim(),
      phone: _phoneController.text.trim(), 
      birthdate: _birthdateController.text.trim(),
      gender: _selectedGender!,

    )
      ..birthdate = _birthdateController.text.trim()
      ..gender = _selectedGender!;

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ResidentSignupLocationPage(data: data),
      ),
    );
  }

  String? _validateBirthdate(String? value) {
    if (value == null || value.isEmpty) return 'Required';

    final parts = value.split('/');
    if (parts.length != 3) return 'Invalid format';

    final month = int.tryParse(parts[0]);
    final day = int.tryParse(parts[1]);
    final year = int.tryParse(parts[2]);

    if (month == null || month < 1 || month > 12) {
      return 'Invalid month';
    }

    if (day == null || day < 1 || day > 31) {
      return 'Invalid day';
    }

    if (year == null || year < 1900 || year > DateTime.now().year) {
      return 'Invalid year';
    }

    return null;
  }

    Widget _genderChip(String label) {
    final isSelected = _selectedGender == label;

    return ChoiceChip(
      label: Text(label, style: const TextStyle(fontSize: 12)),
      selected: isSelected,
      onSelected: (_) {
        setState(() {
          _selectedGender = label;
        });
      },
    );
  }
}

