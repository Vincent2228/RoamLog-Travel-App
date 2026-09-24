import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../models/city_summary.dart';
import '../theme/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import 'city_screen.dart';
import 'explore_screen.dart';
import 'friends_screen.dart';
import 'log_search_screen.dart';
import 'profile_screen.dart';

class _City {
  const _City(this.name, this.country, this.rating);
  final String name;
  final String country;
  final double rating;
}

class _CategoryInfo {
  const _CategoryInfo(this.icon, this.color, this.cities);
  final IconData icon;
  final Color color;
  final List<_City> cities;
}

// The order categories appear in when a user hasn't favorited any of them.
// Favorited categories (from registration) always float to the top, in
// this same relative order — see _orderedCategories() below.
const _categoryOrder = [
  'Food',
  'Architecture',
  'Nature',
  'Culture',
  'History',
  'Nightlife',
  'Beaches',
  'Conferences',
];

// Placeholder data only — ratings and cities here are just for layout.
// Swap this whole map for a real API call once you have city data to
// recommend from.
const Map<String, _CategoryInfo> _categoryData = {
  'Food': _CategoryInfo(Icons.restaurant_outlined, Color(0xFFB07C4A), [
    _City('Rome', 'Italy', 4.8),
    _City('Bangkok', 'Thailand', 4.7),
    _City('Istanbul', 'Türkiye', 4.7),
    _City('Tokyo', 'Japan', 4.8),
  ]),
  'Architecture': _CategoryInfo(Icons.account_balance_outlined, Color(0xFF5B6B84), [
    _City('Barcelona', 'Spain', 4.7),
    _City('Chicago', 'USA', 4.6),
    _City('Dubai', 'UAE', 4.5),
    _City('Prague', 'Czechia', 4.7),
  ]),
  'Nature': _CategoryInfo(Icons.terrain_outlined, Color(0xFF4C7A54), [
    _City('Banff', 'Canada', 4.9),
    _City('Queenstown', 'New Zealand', 4.6),
    _City('Interlaken', 'Switzerland', 4.8),
    _City('Bali', 'Indonesia', 4.7),
  ]),
  'Culture': _CategoryInfo(Icons.museum_outlined, Color(0xFFB0673F), [
    _City('Kyoto', 'Japan', 4.8),
    _City('Paris', 'France', 4.7),
    _City('Florence', 'Italy', 4.8),
    _City('Seoul', 'South Korea', 4.6),
  ]),
  'History': _CategoryInfo(Icons.castle_outlined, Color(0xFF8A5A2B), [
    _City('Rome', 'Italy', 4.8),
    _City('Athens', 'Greece', 4.6),
    _City('Cairo', 'Egypt', 4.5),
    _City('Kyoto', 'Japan', 4.7),
  ]),
  'Nightlife': _CategoryInfo(Icons.nightlife_outlined, Color(0xFF7A5C9E), [
    _City('Berlin', 'Germany', 4.6),
    _City('Bangkok', 'Thailand', 4.5),
    _City('Ibiza', 'Spain', 4.7),
    _City('Tokyo', 'Japan', 4.6),
  ]),
  'Beaches': _CategoryInfo(Icons.beach_access_outlined, Color(0xFF3E8E86), [
    _City('Bali', 'Indonesia', 4.7),
    _City('Santorini', 'Greece', 4.8),
    _City('Maldives', 'Maldives', 4.9),
    _City('Phuket', 'Thailand', 4.5),
  ]),
  'Conferences': _CategoryInfo(Icons.business_center_outlined, AppColors.navy, [
    _City('Singapore', 'Singapore', 4.6),
    _City('San Francisco', 'USA', 4.5),
    _City('London', 'UK', 4.6),
    _City('Berlin', 'Germany', 4.5),
  ]),
};

/// Main app screen shown right after registration/login completes — the
/// search + discovery feed with the bottom nav bar. Separate from
/// HomeScreen on purpose (see earlier conversation).
///
/// [interests] comes from what the user picked on PreferencesScreen during
/// registration. Every category still shows a row (this screen doesn't
/// hide anything), but favorited ones are sorted to the top.
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, this.interests = const {}});

  final Set<String> interests;

  List<String> _orderedCategories() {
    return [
      ..._categoryOrder.where(interests.contains),
      ..._categoryOrder.where((c) => !interests.contains(c)),
    ];
  }

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _selectedNavIndex = 0;

  void _handleNavSelect(int index) async {
    if (index == 4) {
      // Push (not replace) so tapping Home from ProfileScreen can just
      // pop back here instead of rebuilding the dashboard from scratch.
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
      return;
    }
    if (index == 2) {
      final result = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (context) => const LogSearchScreen()),
      );
      if (result == true && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Memory logged!')),
        );
      }
      return;
    }
    if (index == 1) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ExploreScreen()),
      );
      return;
    }
    if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const FriendsScreen()),
      );
      return;
    }
    setState(() => _selectedNavIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final orderedCategories = widget._orderedCategories();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _Header(),
                    const SizedBox(height: 20),
                    const _SearchBar(),
                    const SizedBox(height: 28),
                    for (var i = 0; i < orderedCategories.length; i++) ...[
                      if (i > 0) const SizedBox(height: 28),
                      Builder(builder: (context) {
                        final category = orderedCategories[i];
                        final info = _categoryData[category]!;
                        return _CityRow(
                          title: 'Top Cities for $category',
                          icon: info.icon,
                          color: info.color,
                          cities: info.cities,
                        );
                      }),
                    ],
                    const SizedBox(height: 12),
                  ],
                ),
              ),
            ),
            BottomNavBar(
              selectedIndex: _selectedNavIndex,
              onSelect: _handleNavSelect,
            ),
          ],
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: 'Roam',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.navy),
              ),
              TextSpan(
                text: 'Log',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w600, color: AppColors.gold),
              ),
            ],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'LOG MOMENTS. SHARE STORIES. INSPIRE JOURNEYS.',
          style: TextStyle(
            fontSize: 10.5,
            letterSpacing: 0.6,
            fontWeight: FontWeight.w600,
            color: AppColors.navyMuted.withOpacity(0.8),
          ),
        ),
      ],
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.creamDark,
        borderRadius: BorderRadius.circular(28),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 4),
      child: Row(
        children: [
          const Icon(Icons.search, color: AppColors.navyMuted, size: 22),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              // TODO: hook this up to a real city search once you have
              // a data source to search against.
              decoration: InputDecoration(
                hintText: 'Search cities, memories, users...',
                hintStyle: TextStyle(fontSize: 14.5, color: AppColors.navyMuted.withOpacity(0.7)),
                border: InputBorder.none,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
              ),
              style: const TextStyle(fontSize: 14.5, color: AppColors.navy),
            ),
          ),
          const Icon(Icons.tune, color: AppColors.navyMuted, size: 20),
        ],
      ),
    );
  }
}

class _CityRow extends StatelessWidget {
  const _CityRow({
    required this.title,
    required this.icon,
    required this.color,
    required this.cities,
  });

  final String title;
  final IconData icon;
  final Color color;
  final List<_City> cities;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 18, color: color),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: AppColors.navy),
              ),
            ),
            GestureDetector(
              // TODO: navigate to a full "see all" list for this category.
              onTap: () {},
              child: Row(
                children: [
                  Text(
                    'See All',
                    style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.navy.withOpacity(0.7)),
                  ),
                  Icon(Icons.chevron_right, size: 18, color: AppColors.navy.withOpacity(0.7)),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 190,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: cities.length,
            separatorBuilder: (context, index) => const SizedBox(width: 12),
            itemBuilder: (context, index) => _CityCard(city: cities[index], color: color, icon: icon),
          ),
        ),
      ],
    );
  }
}

/// A single city tile. Tap the small camera badge to pick a photo from
/// your device's gallery — this is just for previewing what a real photo
/// would look like in the layout; it isn't saved anywhere yet. Until a
/// photo is picked, it falls back to the colored icon placeholder.
class _CityCard extends StatefulWidget {
  const _CityCard({required this.city, required this.color, required this.icon});

  final _City city;
  final Color color;
  final IconData icon;

  @override
  State<_CityCard> createState() => _CityCardState();
}

class _CityCardState extends State<_CityCard> {
  File? _image;

  Future<void> _pickImage() async {
    // TODO: once you have real city photos (bundled assets or a backend),
    // replace this whole picker with that instead.
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 80);
    if (picked != null) {
      setState(() => _image = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: _image == null
            ? LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [widget.color.withOpacity(0.85), widget.color.withOpacity(0.5)],
              )
            : null,
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CityScreen(
                    summary: CitySummary(
                      name: widget.city.name,
                      country: widget.city.country,
                      rating: widget.city.rating,
                      color: widget.color,
                      icon: widget.icon,
                    ),
                  ),
                ),
              );
            },
            child: Stack(
              fit: StackFit.expand,
              children: [
                if (_image != null)
                  Image.file(_image!, fit: BoxFit.cover)
                else
                  Positioned(
                    right: -10,
                    bottom: -10,
                    child: Icon(widget.icon, size: 72, color: Colors.white.withOpacity(0.15)),
                  ),
                if (_image != null)
                  // Dark scrim so text stays readable over an arbitrary photo.
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black.withOpacity(0.05), Colors.black.withOpacity(0.55)],
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.city.name,
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                      ),
                      Text(
                        widget.city.country,
                        style: TextStyle(fontSize: 12, color: Colors.white.withOpacity(0.85)),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.25),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.star, size: 13, color: AppColors.goldLight),
                            const SizedBox(width: 4),
                            Text(
                              widget.city.rating.toStringAsFixed(1),
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: _pickImage,
              child: Container(
                width: 26,
                height: 26,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.black.withOpacity(0.35),
                ),
                child: const Icon(Icons.camera_alt_outlined, size: 14, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}