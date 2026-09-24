import 'package:flutter/material.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/welcome_screen.dart';
import 'theme/app_colors.dart';

void main() => runApp(const RoamLogApp());

class RoamLogApp extends StatelessWidget {
  const RoamLogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'RoamLog',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: AppColors.cream,
        useMaterial3: true,
      ),
      // Builder gives us a `context` from *inside* MaterialApp, where the
      // Navigator actually exists. Using the outer `build(context)` above
      // instead would throw "Navigator operation requested with a context
      // that does not include a Navigator" — this is the fix for that.
      home: Builder(
        builder: (context) {
          return WelcomeScreen(
            onGetStarted: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const RegisterScreen()),
              );
            },
            onLogin: () {
              Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const LoginScreen()),
              );
            },
          );
        },
      ),
    );
  }
}