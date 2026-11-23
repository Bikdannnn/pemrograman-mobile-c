import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

/// Bottom Navigation Bar untuk Role USER (`Home`, `Profile`) — tanpa Chat.
class FoodViewUserBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FoodViewUserBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE0E0E0), width: 0.8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavIconItem(
            icon: Icons.home_rounded,
            selected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavIconItem(
            icon: Icons.person_rounded,
            selected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
        ],
      ),
    );
  }
}

/// Bottom Navigation Bar untuk Role PEMILIK RESTORAN (`Notifikasi`, `Profil Restoran`) — tanpa Chat.
class FoodViewOwnerBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const FoodViewOwnerBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 54,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: Color(0xFFE0E0E0), width: 0.8),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavIconItem(
            icon: Icons.notifications_rounded,
            selected: currentIndex == 0,
            onTap: () => onTap(0),
          ),
          _NavIconItem(
            icon: Icons.person_rounded,
            selected: currentIndex == 1,
            onTap: () => onTap(1),
          ),
        ],
      ),
    );
  }
}

class _NavIconItem extends StatelessWidget {
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _NavIconItem({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Icon(
          icon,
          size: 25,
          color: selected ? AppColors.darkOrange : AppColors.primaryOrange,
        ),
      ),
    );
  }
}
