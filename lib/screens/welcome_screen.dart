import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// First screen shown when the app launches.
///
/// The logo, wordmark, tagline, hero art, and "Welcome to RoamLog" copy are
/// all baked into a single image (assets/images/welcome_background.png) —
/// this widget just displays that image and adds the real, tappable
/// buttons underneath it.
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({
    super.key,
    required this.onGetStarted,
    required this.onLogin,
  });

  final VoidCallback onGetStarted;
  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Matches the cream tone of the image so there's no visible seam
      // where the image ends and the rest of the screen begins.
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Image.asset(
                'assets/images/welcome_background.png',
                width: double.infinity,
                fit: BoxFit.fitWidth,
                errorBuilder: (context, error, stackTrace) => Container(
                  height: 400,
                  alignment: Alignment.center,
                  color: AppColors.creamDark,
                  child: const Padding(
                    padding: EdgeInsets.all(24),
                    child: Text(
                      'Add welcome_background.png to assets/images/\n'
                      'and list it in pubspec.yaml',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.navyMuted),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(28, 8, 28, 20),
                child: Column(
                  children: [
                    _GetStartedButton(onPressed: onGetStarted),
                    const SizedBox(height: 14),
                    _LoginPrompt(onLogin: onLogin),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _GetStartedButton extends StatelessWidget {
  const _GetStartedButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navy,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          elevation: 0,
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.explore_outlined, size: 20),
            SizedBox(width: 10),
            Text(
              'Get Started',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoginPrompt extends StatelessWidget {
  const _LoginPrompt({required this.onLogin});

  final VoidCallback onLogin;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Already have an account? ',
          style: TextStyle(fontSize: 13.5, color: AppColors.navyMuted),
        ),
        GestureDetector(
          onTap: onLogin,
          child: const Text(
            'Log in',
            style: TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: AppColors.gold,
              decoration: TextDecoration.underline,
              decorationColor: AppColors.gold,
            ),
          ),
        ),
      ],
    );
  }
}