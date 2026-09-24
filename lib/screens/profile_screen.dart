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

class _Badge {
  const _Badge(this.icon, this.label);
  final IconData icon;
  final String label;
}

class _FavoriteCity {
  const _FavoriteCity(this.name, this.country, this.rating, this.color);
  final String name;
  final String country;
  final double rating;
  final Color color;
}

class _Experience {
  const _Experience({
    required this.city,
    required this.country,
    required this.rating,
    required this.dateRange,
    required this.review,
    required this.tags,
    required this.photoCount,
  });
  final String city;
  final String country;
  final double rating;
  final String dateRange;
  final String review;
  final String tags;
  final int photoCount;
}

class _CustomList {
  const _CustomList(this.title, this.placeCount, this.color);
  final String title;
  final int placeCount;
  final Color color;
}

class _Friend {
  const _Friend(this.name, this.username, this.trips, this.reviews);
  final String name;
  final String username;
  final int trips;
  final int reviews;
}

// All placeholder data — wire this screen up to real profile/trip data
// once you have a backend.
const _badges = [
  _Badge(Icons.explore_outlined, 'Dedicated Traveler'),
  _Badge(Icons.public, 'World Explorer'),
  _Badge(Icons.camera_alt_outlined, 'Photo Collector'),
  _Badge(Icons.account_balance_outlined, 'Culture Seeker'),
  _Badge(Icons.edit_note_outlined, 'Early Reviewer'),
];

const _favoriteCities = [
  _FavoriteCity('Kyoto', 'Japan', 4.9, Color(0xFFB0673F)),
  _FavoriteCity('Rome', 'Italy', 4.8, Color(0xFFB07C4A)),
  _FavoriteCity('Barcelona', 'Spain', 4.7, Color(0xFF7A5C9E)),
  _FavoriteCity('Queenstown', 'New Zealand', 4.7, Color(0xFF4C7A54)),
];

const _experiences = [
  _Experience(
    city: 'Kyoto',
    country: 'Japan',
    rating: 4.9,
    dateRange: '12 - 18 Apr 2024',
    review: 'Absolutely magical. The culture, the people, the food — everything was unforgettable.',
    tags: '#culture #temples #food',
    photoCount: 6,
  ),
  _Experience(
    city: 'Rome',
    country: 'Italy',
    rating: 4.8,
    dateRange: '05 - 12 Oct 2023',
    review: 'Ancient history around every corner. The food was unreal and the city was so alive.',
    tags: '#history #architecture #food',
    photoCount: 4,
  ),
  _Experience(
    city: 'Queenstown',
    country: 'New Zealand',
    rating: 4.7,
    dateRange: '20 - 27 Jan 2024',
    review: 'Adventure paradise! From hiking to bungee jumping, every day was epic.',
    tags: '#nature #adventure #views',
    photoCount: 5,
  ),
];

const _customLists = [
  _CustomList('Best Summer Spots for 2026', 12, Color(0xFF3E8E86)),
  _CustomList('Bucket List: Europe', 18, Color(0xFFB0673F)),
  _CustomList('Coffee and Cafés Around the World', 9, Color(0xFFB07C4A)),
  _CustomList('Nature Escapes', 14, Color(0xFF4C7A54)),
];

const _friends = [
  _Friend('Isabella Rossi', '@isabellarossi', 37, 56),
  _Friend('Lucas Martin', '@lucasmartin', 24, 31),
  _Friend('Sophie Chen', '@sophie.chen', 41, 72),
  _Friend('Daniel Kim', '@danielkim', 19, 27),
];

/// Personal profile screen. Reached from DashboardScreen's bottom nav
/// (Profile tab). Tapping Home in this screen's own bottom nav just pops
/// back to the dashboard rather than rebuilding it.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _coverImage;
  File? _avatarImage;

  Future<void> _pickCoverImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) setState(() => _coverImage = File(picked.path));
  }

  Future<void> _pickAvatarImage() async {
    final picked = await ImagePicker().pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked != null) setState(() => _avatarImage = File(picked.path));
  }

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
    // No other tabs have a real destination from here.
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ProfileHeader(
                      coverImage: _coverImage,
                      avatarImage: _avatarImage,
                      onTapCover: _pickCoverImage,
                      onTapAvatar: _pickAvatarImage,
                    ),
                    const SizedBox(height: 20),
                    _SectionLabel('BADGES'),
                    const SizedBox(height: 10),
                    _BadgesRow(),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _StatsRow(),
                    ),
                    const SizedBox(height: 24),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: _SectionLabel('TOP 4 FAVORITE CITIES'),
                    ),
                    const SizedBox(height: 12),
                    _FavoriteCitiesRow(),
                    const SizedBox(height: 28),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _SectionLabel('YOUR EXPERIENCES'),
                          const SizedBox(height: 12),
                          for (final experience in _experiences) ...[
                            _ExperienceCard(experience: experience),
                            const SizedBox(height: 12),
                          ],
                          const SizedBox(height: 8),
                          _SectionLabel('MY LISTS'),
                          const SizedBox(height: 4),
                          for (final list in _customLists) _CustomListRow(list: list),
                          const SizedBox(height: 20),
                          _SectionLabel('MY FRIENDS · ${_friends.length}'),
                          const SizedBox(height: 4),
                          for (final friend in _friends) _FriendRow(friend: friend),
                          const SizedBox(height: 16),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            BottomNavBar(selectedIndex: 4, onSelect: _handleNavSelect),
          ],
        ),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Text(
            text,
            style: TextStyle(fontSize: 11.5, letterSpacing: 0.6, fontWeight: FontWeight.w700, color: AppColors.navyMuted.withOpacity(0.8)),
          ),
        ),
        GestureDetector(
          // TODO: navigate to a full list/grid for this section.
          onTap: () {},
          child: Row(
            children: [
              Text('View All', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.navy.withOpacity(0.7))),
              Icon(Icons.chevron_right, size: 16, color: AppColors.navy.withOpacity(0.7)),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.coverImage,
    required this.avatarImage,
    required this.onTapCover,
    required this.onTapAvatar,
  });

  final File? coverImage;
  final File? avatarImage;
  final VoidCallback onTapCover;
  final VoidCallback onTapAvatar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 250,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              // Background photo of the city the user currently lives in.
              // Tap it to pick a placeholder photo from your device.
              GestureDetector(
                onTap: onTapCover,
                child: Container(
                  height: 190,
                  width: double.infinity,
                  color: AppColors.creamDark,
                  child: coverImage != null
                      ? Image.file(coverImage!, fit: BoxFit.cover)
                      : Icon(Icons.landscape_outlined, size: 48, color: AppColors.navyMuted.withOpacity(0.4)),
                ),
              ),
              // Birthplace / residing labels, flanking the avatar. Sits
              // just below the cover photo so it doesn't overlap it.
              Positioned(
                left: 24,
                right: 24,
                top: 198,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('RESIDING', style: TextStyle(fontSize: 10.5, letterSpacing: 0.5, color: AppColors.navyMuted, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.location_on, size: 14, color: AppColors.gold),
                              SizedBox(width: 4),
                              Text('Edmonton', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy)),
                            ],
                          ),
                          const Text('Canada', style: TextStyle(fontSize: 12, color: AppColors.navyMuted)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 100),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('BIRTHPLACE', style: TextStyle(fontSize: 10.5, letterSpacing: 0.5, color: AppColors.navyMuted, fontWeight: FontWeight.w600)),
                          const SizedBox(height: 2),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.home, size: 14, color: AppColors.gold),
                              SizedBox(width: 4),
                              Text('Budapest', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy)),
                            ],
                          ),
                          const Text('Hungary', style: TextStyle(fontSize: 12, color: AppColors.navyMuted)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Avatar, overlapping the bottom edge of the cover photo.
              Positioned(
                top: 138,
                left: 0,
                right: 0,
                child: Center(
                  child: GestureDetector(
                    onTap: onTapAvatar,
                    child: Stack(
                      children: [
                        Container(
                          width: 104,
                          height: 104,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.creamDark,
                            border: Border.all(color: AppColors.cream, width: 4),
                          ),
                          child: ClipOval(
                            child: avatarImage != null
                                ? Image.file(avatarImage!, fit: BoxFit.cover)
                                : Icon(Icons.person, size: 44, color: AppColors.navyMuted.withOpacity(0.5)),
                          ),
                        ),
                        Positioned(
                          right: 0,
                          bottom: 4,
                          child: Container(
                            width: 26,
                            height: 26,
                            decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.gold),
                            child: const Icon(Icons.edit, size: 13, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const Text('Vincent B.', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.navy)),
        const SizedBox(height: 2),
        const Text('@vincentbercze', style: TextStyle(fontSize: 13, color: AppColors.navyMuted)),
      ],
    );
  }
}

class _BadgesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 88,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _badges.length,
        separatorBuilder: (context, index) => const SizedBox(width: 16),
        itemBuilder: (context, index) {
          final badge = _badges[index];
          return SizedBox(
            width: 68,
            child: Column(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.gold.withOpacity(0.5), width: 1.5),
                  ),
                  child: Icon(badge.icon, color: AppColors.gold, size: 22),
                ),
                const SizedBox(height: 6),
                Text(
                  badge.label,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 10.5, color: AppColors.navyMuted, height: 1.2),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatCard(icon: Icons.flight_outlined, value: '125,430 km', label: "Total world distance · that's 3.1x around the Earth"),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(icon: Icons.public, value: '42%', label: 'World visited · 84 of 197 countries'),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.icon, required this.value, required this.label});

  final IconData icon;
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.creamDark, borderRadius: BorderRadius.circular(14)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.gold, size: 20),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: AppColors.navy)),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11, color: AppColors.navyMuted, height: 1.3)),
        ],
      ),
    );
  }
}

class _FavoriteCitiesRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _favoriteCities.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final city = _favoriteCities[index];
          return GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CityScreen(
                    summary: CitySummary(
                      name: city.name,
                      country: city.country,
                      rating: city.rating,
                      color: city.color,
                      icon: Icons.location_city,
                    ),
                  ),
                ),
              );
            },
            child: Container(
            width: 100,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [city.color.withOpacity(0.85), city.color.withOpacity(0.5)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(city.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white)),
                Text(city.country, style: TextStyle(fontSize: 10.5, color: Colors.white.withOpacity(0.85))),
                const Spacer(),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, size: 12, color: AppColors.goldLight),
                    const SizedBox(width: 3),
                    Text(city.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: Colors.white)),
                  ],
                ),
              ],
            ),
            ),
          );
        },
      ),
    );
  }
}

class _ExperienceCard extends StatelessWidget {
  const _ExperienceCard({required this.experience});
  final _Experience experience;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.creamDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '${experience.city}, ${experience.country}',
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: AppColors.navy),
                ),
              ),
              const Icon(Icons.star, size: 14, color: AppColors.gold),
              const SizedBox(width: 3),
              Text(experience.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy)),
            ],
          ),
          const SizedBox(height: 2),
          Text(experience.dateRange, style: const TextStyle(fontSize: 11.5, color: AppColors.navyMuted)),
          const SizedBox(height: 10),
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
                      '+${(experience.photoCount - 3).clamp(0, 99)}',
                      style: const TextStyle(fontSize: 12, color: AppColors.navyMuted, fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(experience.review, style: const TextStyle(fontSize: 12.5, color: AppColors.navyMuted, height: 1.4)),
          const SizedBox(height: 6),
          Text(experience.tags, style: const TextStyle(fontSize: 11.5, color: AppColors.gold, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _CustomListRow extends StatelessWidget {
  const _CustomListRow({required this.list});
  final _CustomList list;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(width: 44, height: 44, decoration: BoxDecoration(color: list.color, borderRadius: BorderRadius.circular(10))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(list.title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy)),
                Text('${list.placeCount} places', style: const TextStyle(fontSize: 11.5, color: AppColors.navyMuted)),
              ],
            ),
          ),
          Icon(Icons.chevron_right, size: 18, color: AppColors.navyMuted.withOpacity(0.7)),
        ],
      ),
    );
  }
}

class _FriendRow extends StatelessWidget {
  const _FriendRow({required this.friend});
  final _Friend friend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.creamDark),
            child: Icon(Icons.person, size: 18, color: AppColors.navyMuted.withOpacity(0.6)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(friend.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy)),
                Text('${friend.username} · ${friend.trips} trips · ${friend.reviews} reviews', style: const TextStyle(fontSize: 11, color: AppColors.navyMuted)),
              ],
            ),
          ),
          // TODO: wire these up to real actions (message, more options) later.
          Icon(Icons.mail_outline, size: 18, color: AppColors.navyMuted.withOpacity(0.6)),
          const SizedBox(width: 12),
          Icon(Icons.more_vert, size: 18, color: AppColors.navyMuted.withOpacity(0.6)),
        ],
      ),
    );
  }
}