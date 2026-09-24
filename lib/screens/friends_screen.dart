import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../widgets/bottom_nav_bar.dart';
import 'explore_screen.dart';
import 'find_friends_screen.dart';
import 'friend_requests_screen.dart';
import 'log_search_screen.dart';
import 'profile_screen.dart';

// Same 8 categories used when logging a memory (see log_form_screen.dart) —
// keeping these in sync means a rated memory always displays the same way
// it was rated.
const _categoryIcons = {
  'Food': Icons.restaurant_outlined,
  'Nature': Icons.terrain_outlined,
  'Architecture': Icons.account_balance_outlined,
  'Culture': Icons.museum_outlined,
  'Nightlife': Icons.nightlife_outlined,
  'Beaches': Icons.beach_access_outlined,
  'History': Icons.castle_outlined,
  'Conferences': Icons.business_center_outlined,
};

class _FriendActivity {
  const _FriendActivity({
    required this.friendName,
    required this.username,
    required this.timeAgo,
    required this.city,
    required this.country,
    required this.overallRating,
    required this.subRatings,
    required this.review,
    required this.tags,
    required this.photoCount,
    required this.has3DScan,
  });

  final String friendName;
  final String username;
  final String timeAgo;
  final String city;
  final String country;
  final double overallRating;
  final Map<String, int> subRatings;
  final String review;
  final String tags;
  final int photoCount;
  final bool has3DScan;
}

// Placeholder feed data — swap for a real query (friends' recent memories,
// sorted by date) once you have a backend.
const _activities = [
  _FriendActivity(
    friendName: 'Isabella Rossi',
    username: '@isabellarossi',
    timeAgo: '2 days ago',
    city: 'Kyoto',
    country: 'Japan',
    overallRating: 4.9,
    subRatings: {'Food': 5, 'Nature': 5, 'Architecture': 4, 'Culture': 5, 'Nightlife': 3, 'Beaches': 2, 'History': 5, 'Conferences': 2},
    review: 'Absolutely magical. The culture, the people, the food — everything was unforgettable.',
    tags: '#culture #temples #food',
    photoCount: 6,
    has3DScan: true,
  ),
  _FriendActivity(
    friendName: 'Lucas Martin',
    username: '@lucasmartin',
    timeAgo: '5 days ago',
    city: 'Barcelona',
    country: 'Spain',
    overallRating: 4.6,
    subRatings: {'Food': 4, 'Nature': 3, 'Architecture': 5, 'Culture': 5, 'Nightlife': 5, 'Beaches': 4, 'History': 4, 'Conferences': 3},
    review: 'Gaudí\'s work is even more striking in person. Also ate extremely well the whole trip.',
    tags: '#architecture #food #nightlife',
    photoCount: 8,
    has3DScan: false,
  ),
  _FriendActivity(
    friendName: 'Sophie Chen',
    username: '@sophie.chen',
    timeAgo: '1 week ago',
    city: 'Banff',
    country: 'Canada',
    overallRating: 4.9,
    subRatings: {'Food': 3, 'Nature': 5, 'Architecture': 2, 'Culture': 3, 'Nightlife': 1, 'Beaches': 2, 'History': 2, 'Conferences': 1},
    review: 'The lake water color still doesn\'t look real to me. Hiked every day, would happily go back.',
    tags: '#nature #hiking #views',
    photoCount: 12,
    has3DScan: true,
  ),
  _FriendActivity(
    friendName: 'Daniel Kim',
    username: '@danielkim',
    timeAgo: '2 weeks ago',
    city: 'Istanbul',
    country: 'Türkiye',
    overallRating: 4.7,
    subRatings: {'Food': 5, 'Nature': 3, 'Architecture': 5, 'Culture': 5, 'Nightlife': 3, 'Beaches': 2, 'History': 5, 'Conferences': 2},
    review: 'History around every corner and the food scene is unreal. Highly underrated city.',
    tags: '#history #food #culture',
    photoCount: 5,
    has3DScan: false,
  ),
];

/// Friends' activity feed — recent memories from everyone on your friends
/// list, with full rating breakdowns, photos, and 3D scan indicators.
/// Reached from the bottom nav's Friends tab.
class FriendsScreen extends StatelessWidget {
  const FriendsScreen({super.key});

  void _handleNavSelect(BuildContext context, int index) async {
    if (index == 0) {
      Navigator.of(context).pop();
      return;
    }
    if (index == 2) {
      final result = await Navigator.of(context).push<bool>(
        MaterialPageRoute(builder: (context) => const LogSearchScreen()),
      );
      if (result == true && context.mounted) {
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
    if (index == 4) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
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
                padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('Friends', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w600, color: AppColors.navy)),
                              SizedBox(height: 4),
                              Text(
                                'Recent memories from the people you follow',
                                style: TextStyle(fontSize: 13.5, color: AppColors.navyMuted),
                              ),
                            ],
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const FindFriendsScreen()),
                          ),
                          child: Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(color: AppColors.creamDark, borderRadius: BorderRadius.circular(20)),
                            child: const Icon(Icons.person_add_alt_1_outlined, size: 20, color: AppColors.navy),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(builder: (context) => const FriendRequestsScreen()),
                          ),
                          child: Container(
                            width: 40,
                            height: 40,
                            margin: const EdgeInsets.only(left: 8),
                            decoration: BoxDecoration(color: AppColors.creamDark, borderRadius: BorderRadius.circular(20)),
                            child: Stack(
                              clipBehavior: Clip.none,
                              children: [
                                const Center(child: Icon(Icons.notifications_outlined, size: 20, color: AppColors.navy)),
                                Positioned(
                                  top: -2,
                                  right: -2,
                                  child: Container(
                                    padding: const EdgeInsets.all(3),
                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.gold),
                                    child: const Text('3', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.white)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    for (final activity in _activities) ...[
                      _FriendActivityCard(activity: activity),
                      const SizedBox(height: 16),
                    ],
                  ],
                ),
              ),
            ),
            BottomNavBar(selectedIndex: 3, onSelect: (index) => _handleNavSelect(context, index)),
          ],
        ),
      ),
    );
  }
}

class _FriendActivityCard extends StatelessWidget {
  const _FriendActivityCard({required this.activity});
  final _FriendActivity activity;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.creamDark, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Friend attribution.
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.cream),
                child: Icon(Icons.person, size: 18, color: AppColors.navyMuted.withOpacity(0.6)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(activity.friendName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy)),
                    Text('${activity.username} · ${activity.timeAgo}', style: const TextStyle(fontSize: 11, color: AppColors.navyMuted)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // City + overall rating.
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: AppColors.gold),
              const SizedBox(width: 4),
              Expanded(
                child: Text('${activity.city}, ${activity.country}', style: const TextStyle(fontSize: 15.5, fontWeight: FontWeight.w600, color: AppColors.navy)),
              ),
              const Icon(Icons.star, size: 15, color: AppColors.gold),
              const SizedBox(width: 3),
              Text(activity.overallRating.toStringAsFixed(1), style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy)),
            ],
          ),
          const SizedBox(height: 10),

          // All sub-category ratings.
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final entry in activity.subRatings.entries)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(10)),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(_categoryIcons[entry.key], size: 13, color: AppColors.navyMuted),
                      const SizedBox(width: 4),
                      Text('${entry.value}', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.navy)),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),

          // Photos, with a 3D scan badge alongside if included.
          SizedBox(
            height: 56,
            child: Row(
              children: [
                for (var i = 0; i < 3; i++) ...[
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: AppColors.navy.withOpacity(0.15 + (i * 0.08)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(color: AppColors.cream, borderRadius: BorderRadius.circular(8)),
                    child: Text(
                      '+${(activity.photoCount - 3).clamp(0, 99)}',
                      style: const TextStyle(fontSize: 12, color: AppColors.navyMuted, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (activity.has3DScan) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: AppColors.gold.withOpacity(0.15), borderRadius: BorderRadius.circular(10)),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: const [
                  Icon(Icons.view_in_ar_outlined, size: 15, color: AppColors.gold),
                  SizedBox(width: 6),
                  Text('3D scan available', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: AppColors.gold)),
                ],
              ),
            ),
          ],
          const SizedBox(height: 10),

          Text(activity.review, style: const TextStyle(fontSize: 12.5, color: AppColors.navyMuted, height: 1.4)),
          const SizedBox(height: 6),
          Text(activity.tags, style: const TextStyle(fontSize: 11.5, color: AppColors.gold, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}