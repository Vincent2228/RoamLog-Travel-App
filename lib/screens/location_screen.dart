import 'package:flutter/material.dart';

import '../models/registration_data.dart';
import '../theme/app_colors.dart';
import '../widgets/step_dots.dart';
import 'dashboard_screen.dart';

/// Step 3 (final step) of registration. Collects birthplace + current
/// city, then finishes the flow. There's no backend yet, so this just
/// clears the whole registration stack and lands on [DashboardScreen] — swap
/// [_handleFinish] for a real "create account" API call later, using
/// everything gathered in [widget.data].
class LocationScreen extends StatefulWidget {
  const LocationScreen({super.key, required this.data});

  final RegistrationData data;

  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  final _birthCityController = TextEditingController();
  final _currentCityController = TextEditingController();
  String? _errorText;

  @override
  void dispose() {
    _birthCityController.dispose();
    _currentCityController.dispose();
    super.dispose();
  }

  void _handleFinish() {
    final birthCity = _birthCityController.text.trim();
    final currentCity = _currentCityController.text.trim();

    if (birthCity.isEmpty || currentCity.isEmpty) {
      setState(() => _errorText = 'Fill in both cities to finish setting up your profile.');
      return;
    }

    setState(() => _errorText = null);

    widget.data.birthCity = birthCity;
    widget.data.currentCity = currentCity;

    // TODO: this is where you'd send widget.data to your backend to
    // actually create the account. For now we just clear the whole
    // registration stack (welcome/register/preferences/location) so the
    // back button from Home doesn't lead back into the sign-up flow.
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => DashboardScreen(interests: widget.data.interests)),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(28, 12, 28, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back, color: AppColors.navy),
                      padding: EdgeInsets.zero,
                      alignment: Alignment.centerLeft,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Where are you from?',
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: AppColors.navy),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'This helps personalize your profile and recommendations.',
                      style: TextStyle(fontSize: 14, color: AppColors.navyMuted, height: 1.4),
                    ),
                    const SizedBox(height: 32),

                    const Text(
                      'Birthplace city',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy),
                    ),
                    const SizedBox(height: 8),
                    _LocationField(controller: _birthCityController, hintText: 'e.g. Edmonton, Canada'),
                    const SizedBox(height: 20),

                    const Text(
                      'Current city',
                      style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy),
                    ),
                    const SizedBox(height: 8),
                    _LocationField(controller: _currentCityController, hintText: 'Where do you live now?'),

                    if (_errorText != null) ...[
                      const SizedBox(height: 12),
                      Text(_errorText!, style: const TextStyle(fontSize: 13, color: Colors.redAccent)),
                    ],
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(28, 0, 28, 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _handleFinish,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Finish',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const StepDots(currentStep: 2, stepCount: 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationField extends StatelessWidget {
  const _LocationField({required this.controller, required this.hintText});

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(fontSize: 15, color: AppColors.navy),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 15, color: AppColors.navyMuted.withOpacity(0.6)),
        prefixIcon: const Icon(Icons.location_on_outlined, size: 20, color: AppColors.navyMuted),
        filled: true,
        fillColor: AppColors.creamDark,
        contentPadding: const EdgeInsets.symmetric(vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.gold, width: 1.5),
        ),
      ),
    );
  }
}