import 'package:flutter/material.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1E1E1E),
      child: SafeArea(
        child: Column(
          children: [
            // Profile header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  // Profile image
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        image: NetworkImage('https://i.pravatar.cc/150?img=1'),
                        fit: BoxFit.cover,
                      ),
                      border: Border.all(color: Colors.pink.shade400, width: 2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Name and email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'John Doe',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'example@gmail.com',
                          style: TextStyle(
                            color: Color(0xFFFF3F80),
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Menu button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.menu, color: Colors.white),
                  ),
                ],
              ),
            ),
            const Divider(color: Colors.white10),
            // Menu items
            _MenuItem(
              icon: Icons.home_outlined,
              label: 'Home',
              onTap: () => Navigator.pushNamed(context, '/home'),
            ),
            _MenuItem(
              icon: Icons.favorite_border,
              label: 'W3Dating Package',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.list_alt,
              label: 'Package List',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.waving_hand_outlined,
              label: 'Welcome',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.grid_view,
              label: 'Components',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              onTap: () {},
            ),
            _MenuItem(
              icon: Icons.person_outline,
              label: 'Profile',
              onTap: () => Navigator.pushNamed(context, '/profile'),
            ),
            _MenuItem(
              icon: Icons.logout,
              label: 'Logout',
              onTap: () => Navigator.pushReplacementNamed(context, '/onboarding'),
            ),
            const Spacer(),
            // Dark mode toggle
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  const Icon(Icons.dark_mode, color: Colors.white54),
                  const SizedBox(width: 12),
                  const Text(
                    'Dark Mode',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: true,
                    onChanged: (_) {},
                    activeColor: const Color(0xFFFF3F80),
                  ),
                ],
              ),
            ),
            // App version
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: const [
                  Text(
                    'W3Dating - Dating App',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'App Version 1.1',
                    style: TextStyle(
                      color: Colors.white54,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(
        label,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      trailing: const Icon(Icons.chevron_right, color: Colors.white54),
      onTap: onTap,
    );
  }
}