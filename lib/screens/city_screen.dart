import 'package:flutter/material.dart';

import '../models/city_summary.dart';
import '../theme/app_colors.dart';

class _SubRating {
  const _SubRating(this.label, this.icon, this.offset);
  final String label;
  final IconData icon;
  final double offset;
}

// Fixed offsets from the city's overall rating, just so each category
// looks a little different instead of repeating the same number 7 times.
// Swap this whole approach for real per-category data once you have it.
const _subRatingTemplate = [
  _SubRating('Food', Icons.restaurant_outlined, 0.1),
  _SubRating('Safety', Icons.shield_outlined, -0.2),
  _SubRating('Affordability', Icons.attach_money, -0.4),
  _SubRating('People', Icons.groups_outlined, 0.0),
  _SubRating('Nature', Icons.terrain_outlined, 0.2),
  _SubRating('Transit', Icons.directions_bus_outlined, -0.3),
  _SubRating('Activities & Culture', Icons.theater_comedy_outlined, 0.1),
];

class _Attraction {
  const _Attraction(this.name, this.tag, this.icon);
  final String name;
  final String tag;
  final IconData icon;
}

const _attractions = [
  _Attraction('Old Town Square', 'Landmark', Icons.account_balance_outlined),
  _Attraction('Central Market', 'Food & Shopping', Icons.storefront_outlined),
  _Attraction('Riverside Park', 'Nature', Icons.park_outlined),
  _Attraction('Historic Cathedral', 'Landmark', Icons.church_outlined),
];

class _Event {
  const _Event(this.title, this.date, this.icon);
  final String title;
  final String date;
  final IconData icon;
}

const _events = [
  _Event('Summer Music Festival', 'Jun 14 - 16', Icons.music_note_outlined),
  _Event('Food & Wine Expo', 'Jul 2 - 4', Icons.local_bar_outlined),
  _Event('Tech Founders Summit', 'Sep 22', Icons.business_center_outlined),
];

class _FriendMemory {
  const _FriendMemory({required this.friendName, required this.rating, required this.dateRange, required this.review, required this.tags});
  final String friendName;
  final double rating;
  final String dateRange;
  final String review;
  final String tags;
}

const _friendMemories = [
  _FriendMemory(
    friendName: 'Isabella Rossi',
    rating: 4.8,
    dateRange: 'Visited Mar 2024',
    review: 'One of my favorite trips ever. Would go back in a heartbeat.',
    tags: '#mustsee #foodie',
  ),
  _FriendMemory(
    friendName: 'Lucas Martin',
    rating: 4.5,
    dateRange: 'Visited Nov 2023',
    review: 'Great for a long weekend — packed a lot in without feeling rushed.',
    tags: '#weekendtrip',
  ),
];

class _StrangerReview {
  const _StrangerReview({required this.username, required this.rating, required this.likes, required this.review});
  final String username;
  final double rating;
  final int likes;
  final String review;
}

const _strangerReviews = [
  _StrangerReview(username: '@travelwithmae', rating: 5.0, likes: 214, review: 'Exceeded every expectation. The kind of place that stays with you.'),
  _StrangerReview(username: '@jhwanders', rating: 4.5, likes: 132, review: 'Beautiful city, though it gets busy — go early to beat the crowds.'),
  _StrangerReview(username: '@backpack_beau', rating: 4.0, likes: 87, review: 'Solid stop on any itinerary. A couple days is plenty.'),
];

/// City page. Reached by tapping a city card on the dashboard or profile
/// screen. Everything below the header is placeholder content generated
/// from [summary] — swap in real per-city data once you have a backend.
class CityScreen extends StatefulWidget {
  const CityScreen({super.key, required this.summary});

  final CitySummary summary;

  @override
  State<CityScreen> createState() => _CityScreenState();
}

class _CityScreenState extends State<CityScreen> {
  bool _wishlisted = false;

  @override
  Widget build(BuildContext context) {
    final summary = widget.summary;

    return Scaffold(
      backgroundColor: AppColors.cream,
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _CityHeader(
                summary: summary,
                wishlisted: _wishlisted,
                onToggleWishlist: () => setState(() => _wishlisted = !_wishlisted),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const _SectionLabel('BACKGROUND'),
                    const SizedBox(height: 8),
                    Text(
                      '${summary.name} is known for its blend of local culture, striking scenery, '
                      'and a food scene worth traveling for. Whether you have a couple of days or a couple '
                      'of weeks, there\'s plenty here to fill an itinerary.',
                      style: const TextStyle(fontSize: 13.5, color: AppColors.navyMuted, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                    const _SectionLabel('RATINGS'),
                    const SizedBox(height: 10),
                    _OverallRating(rating: summary.rating),
                    const SizedBox(height: 14),
                    _SubRatingsList(baseRating: summary.rating),
                    const SizedBox(height: 24),
                    const _SectionLabel('TOP ATTRACTIONS'),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _AttractionsRow(color: summary.color),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 24),
                    const _SectionLabel('UPCOMING EVENTS'),
                    const SizedBox(height: 10),
                    for (final event in _events) _EventRow(event: event),
                    const SizedBox(height: 24),
                    const _SectionLabel("FRIENDS' MEMORIES"),
                    const SizedBox(height: 10),
                    for (final memory in _friendMemories) ...[
                      _FriendMemoryCard(memory: memory),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 12),
                    const _SectionLabel('TOP REVIEWS'),
                    const SizedBox(height: 10),
                    for (final review in _strangerReviews) ...[
                      _StrangerReviewCard(review: review),
                      const SizedBox(height: 10),
                    ],
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
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
    return Text(
      text,
      style: TextStyle(fontSize: 11.5, letterSpacing: 0.6, fontWeight: FontWeight.w700, color: AppColors.navyMuted.withOpacity(0.8)),
    );
  }
}

class _CityHeader extends StatelessWidget {
  const _CityHeader({required this.summary, required this.wishlisted, required this.onToggleWishlist});

  final CitySummary summary;
  final bool wishlisted;
  final VoidCallback onToggleWishlist;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          IconButton(
            onPressed: () => Navigator.of(context).pop(),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          // Backdrop photo of the city.
          Container(
            height: 190,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [summary.color.withOpacity(0.85), summary.color.withOpacity(0.5)],
              ),
            ),
            child: Align(
              alignment: Alignment.center,
              child: Icon(summary.icon, size: 64, color: Colors.white.withOpacity(0.25)),
            ),
          ),
          // Smaller poster, overlapping the backdrop's bottom-left.
          Positioned(
            left: 24,
            top: 140,
            child: Container(
              width: 96,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.cream, width: 4),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [summary.color.withOpacity(0.9), summary.color.withOpacity(0.6)],
                ),
              ),
              alignment: Alignment.center,
              child: Icon(summary.icon, size: 32, color: Colors.white.withOpacity(0.5)),
            ),
          ),
          // Title, country, and wishlist button, beside the poster.
          Positioned(
            left: 134,
            right: 24,
            top: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(summary.name, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w600, color: AppColors.navy)),
                const SizedBox(height: 2),
                Text(summary.country, style: const TextStyle(fontSize: 14, color: AppColors.navyMuted)),
                const SizedBox(height: 12),
                _WishlistButton(wishlisted: wishlisted, onTap: onToggleWishlist),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WishlistButton extends StatelessWidget {
  const _WishlistButton({required this.wishlisted, required this.onTap});

  final bool wishlisted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // TODO: persist wishlist state once you have somewhere to store it.
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: wishlisted ? AppColors.gold : Colors.transparent,
          border: Border.all(color: AppColors.gold, width: 1.5),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              wishlisted ? Icons.bookmark : Icons.bookmark_border,
              size: 16,
              color: wishlisted ? Colors.white : AppColors.gold,
            ),
            const SizedBox(width: 6),
            Text(
              wishlisted ? 'Wishlisted' : 'Wishlist',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: wishlisted ? Colors.white : AppColors.gold),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverallRating extends StatelessWidget {
  const _OverallRating({required this.rating});
  final double rating;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.star, color: AppColors.gold, size: 26),
        const SizedBox(width: 8),
        Text(rating.toStringAsFixed(1), style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: AppColors.navy)),
        const SizedBox(width: 6),
        const Text('/ 5', style: TextStyle(fontSize: 14, color: AppColors.navyMuted)),
      ],
    );
  }
}

class _SubRatingsList extends StatelessWidget {
  const _SubRatingsList({required this.baseRating});
  final double baseRating;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final sub in _subRatingTemplate)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              children: [
                Icon(sub.icon, size: 17, color: AppColors.navyMuted),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(sub.label, style: const TextStyle(fontSize: 13.5, color: AppColors.navy)),
                ),
                const Icon(Icons.star, size: 14, color: AppColors.gold),
                const SizedBox(width: 4),
                Text(
                  (baseRating + sub.offset).clamp(1.0, 5.0).toStringAsFixed(1),
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _AttractionsRow extends StatelessWidget {
  const _AttractionsRow({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 108,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: _attractions.length,
        separatorBuilder: (context, index) => const SizedBox(width: 10),
        itemBuilder: (context, index) {
          final attraction = _attractions[index];
          return Container(
            width: 140,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: AppColors.creamDark, borderRadius: BorderRadius.circular(14)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(attraction.icon, size: 20, color: color),
                const Spacer(),
                Text(attraction.name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy)),
                Text(attraction.tag, style: const TextStyle(fontSize: 11, color: AppColors.navyMuted)),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _EventRow extends StatelessWidget {
  const _EventRow({required this.event});
  final _Event event;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(color: AppColors.creamDark, borderRadius: BorderRadius.circular(10)),
            child: Icon(event.icon, size: 18, color: AppColors.gold),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(event.title, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.navy)),
                Text(event.date, style: const TextStyle(fontSize: 11.5, color: AppColors.navyMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FriendMemoryCard extends StatelessWidget {
  const _FriendMemoryCard({required this.memory});
  final _FriendMemory memory;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.creamDark, borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.cream),
                child: Icon(Icons.person, size: 16, color: AppColors.navyMuted.withOpacity(0.6)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(memory.friendName, style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w600, color: AppColors.navy)),
              ),
              const Icon(Icons.star, size: 13, color: AppColors.gold),
              const SizedBox(width: 3),
              Text(memory.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.navy)),
            ],
          ),
          const SizedBox(height: 4),
          Text(memory.dateRange, style: const TextStyle(fontSize: 11, color: AppColors.navyMuted)),
          const SizedBox(height: 8),
          Text(memory.review, style: const TextStyle(fontSize: 12.5, color: AppColors.navyMuted, height: 1.4)),
          const SizedBox(height: 6),
          Text(memory.tags, style: const TextStyle(fontSize: 11.5, color: AppColors.gold, fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}

class _StrangerReviewCard extends StatelessWidget {
  const _StrangerReviewCard({required this.review});
  final _StrangerReview review;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(border: Border.all(color: AppColors.creamDark, width: 1.5), borderRadius: BorderRadius.circular(16)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(review.username, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.navy)),
              ),
              const Icon(Icons.star, size: 13, color: AppColors.gold),
              const SizedBox(width: 3),
              Text(review.rating.toStringAsFixed(1), style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: AppColors.navy)),
            ],
          ),
          const SizedBox(height: 6),
          Text(review.review, style: const TextStyle(fontSize: 12.5, color: AppColors.navyMuted, height: 1.4)),
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.favorite_border, size: 15, color: AppColors.navyMuted.withOpacity(0.6)),
              const SizedBox(width: 4),
              Text('${review.likes}', style: TextStyle(fontSize: 11.5, color: AppColors.navyMuted.withOpacity(0.8))),
            ],
          ),
        ],
      ),
    );
  }
}