import 'package:flutter/material.dart';

class AppBottomNavigation extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int>? onTap;

  const AppBottomNavigation({Key? key, this.currentIndex = 0, this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1F1F23),
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(18), topRight: Radius.circular(18)),
        boxShadow: [BoxShadow(color: Colors.black54, blurRadius: 8, offset: Offset(0, -2))],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
  children: [
          _navItem(context, Icons.home_outlined, 0),
          _navItem(context, Icons.search, 1),
          _centerAction(context),
          _navItem(context, Icons.chat_bubble_outline, 3),
          _navItem(context, Icons.person_outline, 4),
        ],
      ),
    );
  }

  Widget _navItem(BuildContext context, IconData icon, int index) {
    final isActive = index == currentIndex;
    final color = isActive ? const Color(0xFFFE5F9F) : Colors.white54;
    return IconButton(
      onPressed: () => onTap?.call(index),
      icon: Icon(icon, color: color),
    );
  }

  Widget _centerAction(BuildContext context) {
    final isActive = currentIndex == 2;
    return GestureDetector(
      onTap: () => onTap?.call(2),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 240),
        width: 64,
        height: 64,
        decoration: BoxDecoration(
          gradient: isActive ? const LinearGradient(colors: [Color(0xFFFF80B0), Color(0xFFFF4DA8)]) : null,
          color: isActive ? null : const Color(0xFF2E2E34),
          borderRadius: BorderRadius.circular(32),
          boxShadow: isActive ? [BoxShadow(color: Colors.pink.withOpacity(0.3), blurRadius: 8, offset: Offset(0,4))] : [],
          border: isActive ? null : Border.all(color: Colors.white12, width: 1.2),
        ),
        child: Center(
          child: Icon(
            isActive ? Icons.favorite : Icons.favorite_border,
            color: isActive ? Colors.white : Colors.white54,
            size: 28,
          ),
        ),
      ),
    );
  }
}
