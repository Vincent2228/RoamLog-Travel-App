import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class _FriendRequest {
  const _FriendRequest(this.name, this.username, this.mutualFriends);
  final String name;
  final String username;
  final int mutualFriends;
}

/// Incoming friend requests. Accept/decline just removes the request from
/// this local list — there's no backend yet to actually confirm a
/// friendship or notify the other person.
class FriendRequestsScreen extends StatefulWidget {
  const FriendRequestsScreen({super.key});

  @override
  State<FriendRequestsScreen> createState() => _FriendRequestsScreenState();
}

class _FriendRequestsScreenState extends State<FriendRequestsScreen> {
  final List<_FriendRequest> _requests = const [
    _FriendRequest('Priya Nair', '@priyanair', 12),
    _FriendRequest('Marco Rossi', '@marco.rossi', 7),
    _FriendRequest('Grace Lin', '@gracelin', 4),
  ].toList();

  void _respond(_FriendRequest request) {
    // TODO: send accept/decline to a real backend once there is one.
    setState(() => _requests.remove(request));
  }

  @override
  Widget build(BuildContext context) {
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
                  const Text('Friend requests', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: AppColors.navy)),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: _requests.isEmpty
                    ? const Center(
                        child: Text('No pending requests', style: TextStyle(fontSize: 14, color: AppColors.navyMuted)),
                      )
                    : ListView.separated(
                        itemCount: _requests.length,
                        separatorBuilder: (context, index) => Divider(height: 1, color: AppColors.creamDark),
                        itemBuilder: (context, index) {
                          final request = _requests[index];
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
                                      Text(request.name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.navy)),
                                      Text('${request.username} · ${request.mutualFriends} mutual friends', style: const TextStyle(fontSize: 11.5, color: AppColors.navyMuted)),
                                    ],
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () => _respond(request),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(shape: BoxShape.circle, color: AppColors.creamDark),
                                    child: const Icon(Icons.close, size: 16, color: AppColors.navyMuted),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                GestureDetector(
                                  onTap: () => _respond(request),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: const BoxDecoration(shape: BoxShape.circle, color: AppColors.navy),
                                    child: const Icon(Icons.check, size: 16, color: Colors.white),
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