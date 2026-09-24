import 'package:flutter/material.dart';

import '../models/city_summary.dart';
import '../theme/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import 'city_screen.dart';
import 'friends_screen.dart';
import 'log_search_screen.dart';
import 'profile_screen.dart';

class _TrendingCity {
  const _TrendingCity(this.rank, this.name, this.country, this.rating, this.stat, this.color, this.icon);
  final int rank;
  final String name;
  final String country;
  final double rating;
  final String stat;
  final Color color;
  final IconData icon;
}

// Placeholder "trending" data — swap for a real query (e.g. most logged
// in the last 7 days, platform-wide) once you have a backend.
const _trending = [
  _TrendingCity(1, 'Lisbon', 'Portugal', 4.7, '+340 logs this week', Color(0xFFB0673F), Icons.location_city),
  _TrendingCity(2, 'Seoul', 'South Korea', 4.6, '+298 logs this week', Color(0xFF7A5C9E), Icons.location_city),
  _TrendingCity(3, 'Mexico City', 'Mexico', 4.5, '+265 logs this week', Color(0xFF4C7A54), Icons.location_city),
  _TrendingCity(4, 'Copenhagen', 'Denmark', 4.6, '+241 logs this week', Color(0xFF3E8E86), Icons.location_city),
  _TrendingCity(5, 'Marrakech', 'Morocco', 4.4, '+220 logs this week', Color(0xFFB07C4A), Icons.location_city),
  _TrendingCity(6, 'Vancouver', 'Canada', 4.5, '+198 logs this week', Color(0xFF5B6B84), Icons.location_city),
];

class _Collection {
  const _Collection(this.title, this.subtitle, this.cityCount, this.color, this.icon);
  final String title;
  final String subtitle;
  final int cityCount;
  final Color color;
  final IconData icon;
}

// Editorial/curated collections — distinct from a user's own custom
// lists (those live on the Profile screen). Swap for real editorial data
// once you have somewhere to manage it.
const _collections = [
  _Collection('Hidden Gems for 2026', 'Underrated spots before everyone else finds them', 14, Color(0xFF8A5A2B), Icons.auto_awesome_outlined),
  _Collection('Underrated European Cities', 'All the charm, none of the crowds', 10, Color(0xFF5B6B84), Icons.account_balance_outlined),
  _Collection('Best Cities for Solo Travel', 'Easy to navigate, easy to meet people', 12, Color(0xFF3E8E86), Icons.explore_outlined),
  _Collection('Where to Eat Your Way Through', 'Food-first itineraries only', 9, Color(0xFFB07C4A), Icons.restaurant_outlined),
];

/// Explore tab — the broad, undirected discovery surface (as opposed to
/// Home's personalized-by-interest rows). Leads with platform-wide
/// trending cities and editorial collections.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  void _handleNavSelect(int index) async {
    if (index == 0) {
      Navigator.of(context).pop();
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
    if (index == 3) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const FriendsScreen()),
      );
      return;
    }
    if (index == 4) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  void _openCity(_TrendingCity city) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CityScreen(
          summary: CitySummary(name: city.name, country: city.country, rating: city.rating, color: city.color, icon: city.icon),
        ),
      ),
    );
  }

  void _openCollection(_Collection collection) {
    // TODO: build a real collection-detail screen (list of cities in it)
    // once collections are backed by real data.
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${collection.title} — details coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Explore', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: AppColors.navy)),
                          const SizedBox(height: 4),
                          const Text(
                            'Discover what\'s happening across RoamLog',
                            style: TextStyle(fontSize: 13.5, color: AppColors.navyMuted),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            children: const [
                              Icon(Icons.local_fire_department_outlined, size: 18, color: AppColors.gold),
                              SizedBox(width: 6),
                              Text('Trending Now', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: AppColors.navy)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text('Most logged across RoamLog this week', style: TextStyle(fontSize: 12.5, color: AppColors.navyMuted)),
                          const SizedBox(height: 12),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 150,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _trending.length,
                        separatorBuilder: (context, index) => const SizedBox(width: 10),
                        itemBuilder: (context, index) {
                          final city = _trending[index];
                          return GestureDetector(
                            onTap: () => _openCity(city),
                            child: Container(
                              width: 140,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [city.color.withOpacity(0.85), city.color.withOpacity(0.5)],
                                ),
                              ),
                              child: Stack(
                                children: [
                                  Positioned(
                                    right: -8,
                                    bottom: -8,
                                    child: Icon(city.icon, size: 60, color: Colors.white.withOpacity(0.15)),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                        decoration: BoxDecoration(color: Colors.black.withOpacity(0.25), borderRadius: BorderRadius.circular(8)),
                                        child: Text('#${city.rank}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Colors.white)),
                                      ),
                                      const Spacer(),
                                      Text(city.name, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.white)),
                                      Text(city.country, style: TextStyle(fontSize: 11, color: Colors.white.withOpacity(0.85))),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          const Icon(Icons.star, size: 11, color: AppColors.goldLight),
                                          const SizedBox(width: 3),
                                          Text(city.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Colors.white)),
                                        ],
                                      ),
                                      const SizedBox(height: 2),
                                      Text(city.stat, style: TextStyle(fontSize: 9.5, color: Colors.white.withOpacity(0.8))),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: const [
                              Icon(Icons.auto_awesome_outlined, size: 18, color: AppColors.gold),
                              SizedBox(width: 6),
                              Text('Curated Collections', style: TextStyle(fontSize: 19, fontWeight: FontWeight.w600, color: AppColors.navy)),
                            ],
                          ),
                          const SizedBox(height: 2),
                          const Text('Hand-picked lists to spark your next trip', style: TextStyle(fontSize: 12.5, color: AppColors.navyMuted)),
                          const SizedBox(height: 14),
                          for (final collection in _collections) ...[
                            GestureDetector(
                              onTap: () => _openCollection(collection),
                              child: Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(color: AppColors.creamDark, borderRadius: BorderRadius.circular(16)),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 52,
                                      height: 52,
                                      decoration: BoxDecoration(color: collection.color, borderRadius: BorderRadius.circular(12)),
                                      child: Icon(collection.icon, color: Colors.white, size: 22),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(collection.title, style: const TextStyle(fontSize: 14.5, fontWeight: FontWeight.w600, color: AppColors.navy)),
                                          const SizedBox(height: 2),
                                          Text(collection.subtitle, style: const TextStyle(fontSize: 11.5, color: AppColors.navyMuted)),
                                          const SizedBox(height: 4),
                                          Text('${collection.cityCount} cities', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.gold)),
                                        ],
                                      ),
                                    ),
                                    Icon(Icons.chevron_right, size: 18, color: AppColors.navyMuted.withOpacity(0.7)),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BottomNavBar(selectedIndex: 1, onSelect: _handleNavSelect),
          ],
        ),
      ),
    );
  }
}