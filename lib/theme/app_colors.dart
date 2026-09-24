import 'package:flutter/material.dart';

/// Brand palette pulled from the RoamLog logo and welcome screen mockup.
/// Adjust the hex values here if your final logo export differs slightly —
/// every screen should read colors from this file rather than hardcoding them.
class AppColors {
  AppColors._();

  static const Color cream = Color(0xFFF4EADA); // page background
  static const Color creamDark = Color(0xFFEDE0C9); // subtle panel tint

  static const Color navy = Color(0xFF16273F); // primary text / "Roam"
  static const Color navyMuted = Color(0xFF3A4A63); // secondary text

  static const Color gold = Color(0xFFB07C4A); // accent / "Log", stamps, links
  static const Color goldLight = Color(0xFFD9B98A);

  static const Color dotInactive = Color(0xFFD8CBB2);
}