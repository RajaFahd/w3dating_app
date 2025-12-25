import 'package:flutter/material.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;

  const AppBottomNavigation({super.key, this.currentIndex = 0});

  void _handleNavigation(BuildContext context, int index) {
    // Jangan navigate jika sudah di halaman yang sama
    if (index == currentIndex) return;

    // Route ke halaman yang sesuai
    switch (index) {
      case 0:
        Navigator.pushReplacementNamed(context, '/home');
        break;
      case 1:
        Navigator.pushReplacementNamed(context, '/explore');
        break;
      case 2:
        Navigator.pushReplacementNamed(context, '/wishlist');
        break;
      case 3:
        Navigator.pushReplacementNamed(context, '/chat_list');
        break;
      case 4:
        Navigator.pushReplacementNamed(context, '/profile');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
  final scheme = Theme.of(context).colorScheme;
  return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: scheme.surface,
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).brightness == Brightness.dark ? Colors.black54 : Colors.black12,
            blurRadius: 8,
            offset: const Offset(0, -2),
          )
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
          _navItem(context, Icons.home_outlined, 0),
          _navItem(context, Icons.search, 1),
          _navItem(context, Icons.favorite_outline, 2),
          _navItem(context, Icons.chat_bubble_outline, 3),
          _navItem(context, Icons.person_outline, 4),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, int index) {
    final isActive = index == currentIndex;
    final scheme = Theme.of(context).colorScheme;
    
    return GestureDetector(
      onTap: () => _handleNavigation(context, index),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isActive ? scheme.primary : Colors.transparent,
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: isActive
              ? Colors.white
              : Theme.of(context).brightness == Brightness.dark
                  ? Colors.white70
                  : Colors.black87,
          size: 32,
        ),
      ),
    );
  }
}
