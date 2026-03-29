import 'package:flutter/material.dart';

import 'package:agap/theme/color.dart';

class RoleScreenBackground extends StatelessWidget {
  const RoleScreenBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned.fill(
          child: Image.asset(
            'assets/bg_fade.png',
            fit: BoxFit.cover,
          ),
        ),
        const _HeaderBackground(),
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.60,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(
                top: Radius.elliptical(
                  MediaQuery.of(context).size.width,
                  220,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _HeaderBackground extends StatelessWidget {
  const _HeaderBackground();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.52,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.agapOrangeAlt,
              AppColors.agapOrange.withValues(alpha: 0.94),
              AppColors.agapOrange.withValues(alpha: 0.82),
            ],
          ),
        ),
      ),
    );
  }
}
