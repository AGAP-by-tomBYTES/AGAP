import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:agap/theme/color.dart';

class VerificationUploadCard extends StatelessWidget {
  const VerificationUploadCard({
    super.key,
    required this.onTap,
    required this.title,
    required this.description,
    this.imageBytes,
    this.imageName,
  });

  final VoidCallback onTap;
  final String title;
  final String description;
  final Uint8List? imageBytes;
  final String? imageName;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Ink(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 28),
          decoration: BoxDecoration(
            color: AppColors.uploadSurface,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: AppColors.agapOrange,
              width: 2,
            ),
          ),
          child: Column(
            children: [
              if (imageBytes == null) ...[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.agapOrange.withValues(alpha: 0.18),
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.upload_file_rounded,
                    color: AppColors.agapOrange,
                    size: 24,
                  ),
                ),
                const SizedBox(height: 18),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.agapOrangeDeep,
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  description,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 18),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.agapOrange.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: const Text(
                    'Tap to upload ID',
                    style: TextStyle(
                      color: AppColors.agapOrangeDeep,
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ] else ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.memory(
                    imageBytes!,
                    height: 170,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  imageName ?? 'Employee ID uploaded',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.agapOrangeDeep,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Tap this card if you want to replace the uploaded ID.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    height: 1.2,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
