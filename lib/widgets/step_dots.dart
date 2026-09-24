import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Small step indicator reused across the registration screens.
/// [currentStep] is 0-indexed.
class StepDots extends StatelessWidget {
  const StepDots({super.key, required this.currentStep, required this.stepCount});

  final int currentStep;
  final int stepCount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(stepCount, (i) {
        final active = i == currentStep;
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: active ? 18 : 7,
          height: 7,
          decoration: BoxDecoration(
            color: active ? AppColors.gold : AppColors.dotInactive,
            borderRadius: BorderRadius.circular(4),
          ),
        );
      }),
    );
  }
}