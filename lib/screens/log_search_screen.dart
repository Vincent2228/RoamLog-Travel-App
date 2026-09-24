import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'log_form_screen.dart';

// Placeholder city list to search against. Swap for a real city database
// or API once you have one — this is just enough to demo the search flow.
const _sampleCities = [
  ('Kyoto', 'Japan'),
  ('Tokyo', 'Japan'),
  ('Rome', 'Italy'),
  ('Florence', 'Italy'),
  ('Barcelona', 'Spain'),
  ('Banff', 'Canada'),
  ('Bali', 'Indonesia'),
  ('Paris', 'France'),
  ('Berlin', 'Germany'),
  ('Santorini', 'Greece'),
  ('Athens', 'Greece'),
  ('Singapore', 'Singapore'),
  ('London', 'UK'),
  ('Prague', 'Czechia'),
  ('Dubai', 'UAE'),
  ('Istanbul', 'Türkiye'),
];

/// First step of logging a new memory: search for (or auto-detect) the
/// city, then move on to LogFormScreen. Returns `true` up the Navigator
/// stack if a memory ends up getting submitted, so the screen that opened
/// this flow (Dashboard/Profile) knows to show a confirmation.
class LogSearchScreen extends StatefulWidget {
  const LogSearchScreen({super.key});

  @override
  State<LogSearchScreen> createState() => _LogSearchScreenState();
}

class _LogSearchScreenState extends State<LogSearchScreen> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _useCurrentLocation() async {
    // TODO: wire this up to a real location service (e.g. the geolocator
    // package) plus reverse geocoding to turn coordinates into a city
    // name. Neither is set up in this demo.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Location detection isn\'t hooked up yet')),
    );
  }

  Future<void> _selectCity(String name, String country) async {
    final result = await Navigator.of(context).push<bool>(
      MaterialPageRoute(builder: (context) => LogFormScreen(cityName: name, country: country)),
    );
    if (result == true && mounted) {
      // Bubble the success up to whoever opened this search screen.
      Navigator.of(context).pop(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? _sampleCities
        : _sampleCities.where((c) {
            final q = _query.toLowerCase();
            return c.$1.toLowerCase().contains(q) || c.$2.toLowerCase().contains(q);
          }).toList();

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: AppColors.navy),
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(width: 4),
                  const Text('Log a memory', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.navy)),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(color: AppColors.creamDark, borderRadius: BorderRadius.circular(28)),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.navyMuted, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) => setState(() => _query = value),
                        decoration: const InputDecoration(
                          hintText: 'Search for a city...',
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 14),
                        ),
                        style: const TextStyle(fontSize: 14.5, color: AppColors.navy),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              GestureDetector(
                onTap: _useCurrentLocation,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.gold, width: 1.5),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.my_location, size: 18, color: AppColors.gold),
                      SizedBox(width: 8),
                      Text('Use current location', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.gold)),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => Divider(height: 1, color: AppColors.creamDark),
                  itemBuilder: (context, index) {
                    final (name, country) = filtered[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(Icons.location_city, color: AppColors.navyMuted),
                      title: Text(name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.navy)),
                      subtitle: Text(country, style: const TextStyle(fontSize: 12.5, color: AppColors.navyMuted)),
                      onTap: () => _selectCity(name, country),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}