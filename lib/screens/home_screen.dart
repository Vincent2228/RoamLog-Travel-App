import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Placeholder landing screen after a successful login. Replace the body
/// with your real home feed / city discovery UI when you're ready — this
/// just proves the navigation works end to end.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      appBar: AppBar(
        backgroundColor: AppColors.cream,
        elevation: 0,
        title: const Text(
          'RoamLog',
          style: TextStyle(color: AppColors.navy, fontWeight: FontWeight.w600),
        ),
        iconTheme: const IconThemeData(color: AppColors.navy),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.explore_outlined, size: 56, color: AppColors.gold),
              const SizedBox(height: 16),
              const Text(
                "You're logged in!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.navy),
              ),
              const SizedBox(height: 8),
              const Text(
                'This is a placeholder home screen — build out your\n'
                'city feed, search, and profile from here.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.navyMuted),
              ),
            ],
          ),
        ),
      ),
    );
  }
}