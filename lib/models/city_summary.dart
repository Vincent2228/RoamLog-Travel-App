import 'package:flutter/material.dart';

/// Minimal info passed from a city card (dashboard or profile) into
/// CityScreen. Just enough to build the header — everything else on the
/// city page (description, sub-ratings, attractions, etc.) is generated
/// as placeholder content inside CityScreen itself for now.
class CitySummary {
  const CitySummary({
    required this.name,
    required this.country,
    required this.rating,
    required this.color,
    required this.icon,
  });

  final String name;
  final String country;
  final double rating;
  final Color color;
  final IconData icon;
}