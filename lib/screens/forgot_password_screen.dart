import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// Simple "forgot password" screen. There's no backend yet, so
/// [_handleSendLink] just checks that something resembling an email was
/// typed in, then swaps the screen into a confirmation state. Replace the
/// inside of that method with a real "send reset email" API call later.
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  String? _errorText;
  bool _linkSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _handleSendLink() {
    final email = _emailController.text.trim();

    // TODO: replace this check with a real "send reset email" API call
    // once you have a backend. This just does a very basic sanity check
    // so the screen behaves like a real form.
    if (email.isEmpty || !email.contains('@')) {
      setState(() => _errorText = 'Enter a valid email address.');
      return;
    }

    setState(() {
      _errorText = null;
      _linkSent = true;
    });
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
              const SizedBox(height: 12),
              if (!_linkSent) ..._buildFormState() else ..._buildSentState(),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildFormState() {
    return [
      const Text(
        'Reset your password',
        style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: AppColors.navy),
      ),
      const SizedBox(height: 6),
      const Text(
        "Enter the email on your account and we'll send you a link to reset your password.",
        style: TextStyle(fontSize: 14, color: AppColors.navyMuted, height: 1.4),
      ),
      const SizedBox(height: 32),

      const Text(
        'Email',
        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy),
      ),
      const SizedBox(height: 8),
      TextField(
        controller: _emailController,
        keyboardType: TextInputType.emailAddress,
        style: const TextStyle(fontSize: 15, color: AppColors.navy),
        decoration: InputDecoration(
          hintText: 'you@example.com',
          hintStyle: TextStyle(fontSize: 15, color: AppColors.navyMuted.withOpacity(0.6)),
          filled: true,
          fillColor: AppColors.creamDark,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
      ),

      if (_errorText != null) ...[
        const SizedBox(height: 12),
        Text(_errorText!, style: const TextStyle(fontSize: 13, color: Colors.redAccent)),
      ],

      const SizedBox(height: 28),
      SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: _handleSendLink,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.navy,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
            elevation: 0,
          ),
          child: const Text(
            'Send reset link',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    ];
  }

  List<Widget> _buildSentState() {
    return [
      const SizedBox(height: 40),
      const Icon(Icons.mark_email_read_outlined, size: 56, color: AppColors.gold),
      const SizedBox(height: 20),
      const Text(
        'Check your email',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.navy),
      ),
      const SizedBox(height: 10),
      Text(
        "If an account exists for ${_emailController.text.trim()}, "
        "we've sent a link to reset your password.",
        style: const TextStyle(fontSize: 14, color: AppColors.navyMuted, height: 1.4),
      ),
      const SizedBox(height: 32),
      SizedBox(
        width: double.infinity,
        height: 54,
        child: OutlinedButton(
          onPressed: () => Navigator.of(context).pop(),
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.navy,
            side: const BorderSide(color: AppColors.navy),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
          ),
          child: const Text(
            'Back to log in',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ),
    ];
  }
}