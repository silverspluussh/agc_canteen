import 'package:agc_canteen/core/theme/app_colors.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';

class BiometricGlow extends StatelessWidget {
  const BiometricGlow({super.key});

  @override
  Widget build(BuildContext context) {
    return AvatarGlow(
      glowColor: Theme.of(context).colorScheme.primary,
      glowCount: 1,
      glowRadiusFactor: 0.3,

      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(width: 1, color: AppColors.gold600),
        ),
        width: 100,
        height: 100,
        child: Center(
          child: AvatarGlow(
            glowColor: Theme.of(context).colorScheme.primary,
            glowCount: 1,
         glowRadiusFactor: 0.5,
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(width: 1, color: AppColors.gold600),
              ),
              width: 70,
              height: 70,
              child: Center(
                child: Icon(
                  Icons.fingerprint,
                  size: 50,
                  color: AppColors.gold600,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
