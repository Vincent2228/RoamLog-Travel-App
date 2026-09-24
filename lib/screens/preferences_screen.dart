import 'package:flutter/material.dart';

import '../models/registration_data.dart';
import '../theme/app_colors.dart';
import '../widgets/step_dots.dart';
import 'location_screen.dart';

class _Category {
  const _Category(this.title, this.subtitle, this.icon, this.color);
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
}

// Add, remove, or edit entries here later — nothing else about this screen
// needs to change when you update the category list.
const _categories = [
  _Category('Food', 'Local cuisine, cafés and foodie spots', Icons.restaurant_outlined, Color(0xFFB07C4A)),
  _Category('Nature', 'Mountains, hiking, parks & landscapes', Icons.terrain_outlined, Color(0xFF4C7A54)),
  _Category('Architecture', 'Landmarks, design and beautiful cities', Icons.account_balance_outlined, Color(0xFF5B6B84)),
  _Category('Culture', 'Art, museums, traditions & local culture', Icons.museum_outlined, Color(0xFFB0673F)),
  _Category('Nightlife', 'Bars, music, and vibrant night scenes', Icons.nightlife_outlined, Color(0xFF7A5C9E)),
  _Category('Beaches', 'Beach days, islands and coastal vibes', Icons.beach_access_outlined, Color(0xFF3E8E86)),
  _Category('History', 'Historic sites, ancient places & heritage', Icons.castle_outlined, Color(0xFF8A5A2B)),
  _Category('Conferences', 'Conferences, events and business travel', Icons.business_center_outlined, AppColors.navy),
];

/// Step 2 of registration. Lets the user multi-select what they care about
/// when traveling, then moves on to [LocationScreen]. Selection is
/// optional — the mockup explicitly says preferences can be changed later,
/// so Continue works even with nothing selected.
class PreferencesScreen extends StatefulWidget {
  const PreferencesScreen({super.key, required this.data});

  final RegistrationData data;

  @override
  State<PreferencesScreen> createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  final Set<String> _selected = {};

  void _toggle(String title) {
    setState(() {
      if (_selected.contains(title)) {
        _selected.remove(title);
      } else {
        _selected.add(title);
      }
    });
  }

  void _handleContinue() {
    widget.data.interests = _selected;
    Navigator.of(context).push(
      MaterialPageRoute(builder: (context) => LocationScreen(data: widget.data)),
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
                padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                child: Column(
                  children: [
                    const Text(
                      'What do you love\nto explore?',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: AppColors.navy, height: 1.25),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Select your travel interests to get\npersonalized city recommendations.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 14, color: AppColors.navyMuted, height: 1.4),
                    ),
                    const SizedBox(height: 24),
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _categories.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 12,
                        crossAxisSpacing: 12,
                        childAspectRatio: 0.85,
                      ),
                      itemBuilder: (context, index) {
                        final category = _categories[index];
                        final selected = _selected.contains(category.title);
                        return _CategoryCard(
                          category: category,
                          selected: selected,
                          onTap: () => _toggle(category.title),
                        );
                      },
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'You can update your preferences anytime',
                      style: TextStyle(fontSize: 12.5, color: AppColors.navyMuted),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _handleContinue,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.navy,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                        elevation: 0,
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Continue', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          SizedBox(width: 10),
                          Icon(Icons.arrow_forward, size: 18),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const StepDots(currentStep: 1, stepCount: 3),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category, required this.selected, required this.onTap});

  final _Category category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        decoration: BoxDecoration(
          color: selected ? category.color.withOpacity(0.08) : AppColors.creamDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: selected ? category.color : Colors.transparent, width: 1.5),
        ),
        padding: const EdgeInsets.all(14),
        child: Stack(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(category.icon, color: category.color, size: 28),
                const Spacer(),
                Text(
                  category.title,
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: category.color),
                ),
                const SizedBox(height: 4),
                Text(
                  category.subtitle,
                  style: const TextStyle(fontSize: 11.5, color: AppColors.navyMuted, height: 1.3),
                ),
              ],
            ),
            if (selected)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 22,
                  height: 22,
                  decoration: BoxDecoration(shape: BoxShape.circle, color: category.color),
                  child: const Icon(Icons.check, size: 14, color: Colors.white),
                ),
              ),
          ],
        ),
      ),
    );
  }
}