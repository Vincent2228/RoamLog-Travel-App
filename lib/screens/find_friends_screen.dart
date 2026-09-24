import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class _SuggestedUser {
  const _SuggestedUser(this.name, this.username, this.mutualFriends);
  final String name;
  final String username;
  final int mutualFriends;
}

// Placeholder user directory — swap for a real user search API once you
// have a backend.
const _suggestedUsers = [
  _SuggestedUser('Olivia Bennett', '@oliviabennett', 32),
  _SuggestedUser('James Wilson', '@james.wilson', 28),
  _SuggestedUser('Ava Martinez', '@avamartinez', 21),
  _SuggestedUser('William Clark', '@willclark', 18),
  _SuggestedUser('Mia Thompson', '@miathompson', 14),
];

/// Search for users and send friend requests. There's no backend, so
/// "Add Friend" just flips the button to "Requested" locally — nothing is
/// actually sent anywhere yet.
class FindFriendsScreen extends StatefulWidget {
  const FindFriendsScreen({super.key});

  @override
  State<FindFriendsScreen> createState() => _FindFriendsScreenState();
}

class _FindFriendsScreenState extends State<FindFriendsScreen> {
  final _searchController = TextEditingController();
  String _query = '';
  final Set<String> _requested = {};

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _query.isEmpty
        ? _suggestedUsers
        : _suggestedUsers.where((u) {
            final q = _query.toLowerCase();
            return u.name.toLowerCase().contains(q) || u.username.toLowerCase().contains(q);
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
                  const Text('Find friends', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.navy)),
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
                          hintText: 'Search usernames...',
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
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: filtered.length,
                  separatorBuilder: (context, index) => Divider(height: 1, color: AppColors.creamDark),
                  itemBuilder: (context, index) {
                    final user = filtered[index];
                    final requested = _requested.contains(user.username);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        children: [
                          Container(
                            width: 42,
                            height: 42,
                            decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.creamDark),
                            child: Icon(Icons.person, size: 20, color: AppColors.navyMuted.withOpacity(0.6)),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(user.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy)),
                                Text('${user.username} · ${user.mutualFriends} mutual friends', style: const TextStyle(fontSize: 11.5, color: AppColors.navyMuted)),
                              ],
                            ),
                          ),
                          GestureDetector(
                            // TODO: send a real friend request once there's a backend.
                            onTap: requested ? null : () => setState(() => _requested.add(user.username)),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              decoration: BoxDecoration(
                                color: requested ? AppColors.creamDark : AppColors.navy,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                requested ? 'Requested' : 'Add Friend',
                                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: requested ? AppColors.navyMuted : Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
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