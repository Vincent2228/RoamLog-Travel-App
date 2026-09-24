import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

/// The 5-button bottom bar shared by DashboardScreen and ProfileScreen
/// (Home, Explore, Add Memory, Friends, Profile). Only [selectedIndex]
/// controls which icon is highlighted — actual navigation, where it
/// exists, is handled by the screen that owns [onSelect].
class BottomNavBar extends StatelessWidget {
  const BottomNavBar({super.key, required this.selectedIndex, required this.onSelect});

  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 10, 20, 20),
      decoration: BoxDecoration(
        color: AppColors.cream,
        border: Border(top: BorderSide(color: AppColors.creamDark, width: 1)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _NavItem(icon: Icons.home_filled, label: 'Home', index: 0, selectedIndex: selectedIndex, onSelect: onSelect),
          _NavItem(icon: Icons.explore_outlined, label: 'Explore', index: 1, selectedIndex: selectedIndex, onSelect: onSelect),
          _AddMemoryButton(onTap: () => onSelect(2)),
          _NavItem(icon: Icons.people_outline, label: 'Friends', index: 3, selectedIndex: selectedIndex, onSelect: onSelect),
          _NavItem(icon: Icons.person_outline, label: 'Profile', index: 4, selectedIndex: selectedIndex, onSelect: onSelect),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.index,
    required this.selectedIndex,
    required this.onSelect,
  });

  final IconData icon;
  final String label;
  final int index;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final selected = index == selectedIndex;
    final color = selected ? AppColors.navy : AppColors.navyMuted.withOpacity(0.55);
    return GestureDetector(
      onTap: () => onSelect(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: color)),
        ],
      ),
    );
  }
}

class _AddMemoryButton extends StatelessWidget {
  const _AddMemoryButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // TODO: navigate to a real "create memory" flow once it exists.
      onTap: onTap,
      child: Transform.translate(
        offset: const Offset(0, -14),
        child: Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.navy,
            boxShadow: [
              BoxShadow(color: AppColors.navy.withOpacity(0.3), blurRadius: 12, offset: const Offset(0, 4)),
            ],
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}