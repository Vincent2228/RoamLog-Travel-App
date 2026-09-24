import 'package:flutter/material.dart';

import '../models/registration_data.dart';
import '../theme/app_colors.dart';
import 'preferences_screen.dart';

/// Step 1 of registration. Collects the basic account fields plus an
/// optional profile photo placeholder, then moves on to
/// [PreferencesScreen]. No backend yet — this just validates the fields
/// look reasonable and carries them forward in a [RegistrationData].
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _fullNameController = TextEditingController();
  final _usernameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  String? _errorText;

  @override
  void dispose() {
    _fullNameController.dispose();
    _usernameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleCreateAccount() {
    final fullName = _fullNameController.text.trim();
    final username = _usernameController.text.trim();
    final email = _emailController.text.trim();
    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (fullName.isEmpty || username.isEmpty || email.isEmpty || password.isEmpty) {
      setState(() => _errorText = 'Fill in every field to continue.');
      return;
    }
    if (!email.contains('@')) {
      setState(() => _errorText = 'Enter a valid email address.');
      return;
    }
    if (password != confirmPassword) {
      setState(() => _errorText = 'Passwords don\'t match.');
      return;
    }

    setState(() => _errorText = null);

    final data = RegistrationData(
      fullName: fullName,
      username: username,
      email: email,
      password: password,
    );

    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => PreferencesScreen(data: data)),
    );
  }

  void _handleAddPhoto() {
    // TODO: wire this up to image_picker (or similar) once you're ready to
    // let users actually pick a photo. For now it's just a placeholder tap.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo picker not hooked up yet')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(28, 12, 28, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              IconButton(
                onPressed: () => Navigator.of(context).pop(),
                icon: const Icon(Icons.arrow_back, color: AppColors.navy),
                padding: EdgeInsets.zero,
                alignment: Alignment.centerLeft,
              ),
              const SizedBox(height: 8),
              const Text(
                'Create your account',
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: AppColors.navy),
              ),
              const SizedBox(height: 6),
              const Text(
                'Start logging your adventures.',
                style: TextStyle(fontSize: 14, color: AppColors.navyMuted),
              ),
              const SizedBox(height: 24),

              Center(
                child: GestureDetector(
                  onTap: _handleAddPhoto,
                  child: Stack(
                    children: [
                      Container(
                        width: 96,
                        height: 96,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.creamDark,
                          border: Border.all(color: AppColors.gold.withOpacity(0.4)),
                        ),
                        child: const Icon(Icons.camera_alt_outlined, color: AppColors.navyMuted, size: 28),
                      ),
                      Positioned(
                        right: 0,
                        bottom: 0,
                        child: Container(
                          width: 28,
                          height: 28,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.gold,
                          ),
                          child: const Icon(Icons.add, color: Colors.white, size: 18),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Center(
                child: Text(
                  'Add a profile photo (optional)',
                  style: TextStyle(fontSize: 12.5, color: AppColors.navyMuted),
                ),
              ),
              const SizedBox(height: 24),

              _RegisterField(controller: _fullNameController, hintText: 'Full Name', icon: Icons.person_outline),
              const SizedBox(height: 14),
              _RegisterField(controller: _usernameController, hintText: 'Username', icon: Icons.alternate_email),
              const SizedBox(height: 14),
              _RegisterField(
                controller: _emailController,
                hintText: 'Email Address',
                icon: Icons.mail_outline,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 14),
              _RegisterField(
                controller: _passwordController,
                hintText: 'Password',
                icon: Icons.lock_outline,
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: AppColors.navyMuted,
                    size: 20,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              _RegisterField(
                controller: _confirmPasswordController,
                hintText: 'Confirm Password',
                icon: Icons.lock_outline,
                obscureText: _obscureConfirmPassword,
                suffixIcon: IconButton(
                  onPressed: () => setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
                  icon: Icon(
                    _obscureConfirmPassword ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                    color: AppColors.navyMuted,
                    size: 20,
                  ),
                ),
              ),

              if (_errorText != null) ...[
                const SizedBox(height: 12),
                Text(_errorText!, style: const TextStyle(fontSize: 13, color: Colors.redAccent)),
              ],

              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton(
                  onPressed: _handleCreateAccount,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.navy,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Create Account',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Already have an account? ',
                    style: TextStyle(fontSize: 13.5, color: AppColors.navyMuted),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Reuse this same styling pattern in other forms if you want a consistent
/// look — it's kept private/local to this file for now to avoid touching
/// your other screens.
class _RegisterField extends StatelessWidget {
  const _RegisterField({
    required this.controller,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.suffixIcon,
  });

  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: const TextStyle(fontSize: 15, color: AppColors.navy),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(fontSize: 15, color: AppColors.navyMuted.withOpacity(0.6)),
        prefixIcon: Icon(icon, size: 20, color: AppColors.navyMuted),
        suffixIcon: suffixIcon,
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