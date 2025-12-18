import 'package:flutter/material.dart';
import 'package:w3dating_app/main.dart';

class SideBar extends StatelessWidget {
  const SideBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Drawer(
      backgroundColor: scheme.surface,
      child: SafeArea(
        child: Column(
          children: [
            // Profile header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: GestureDetector(
                onTap: () => Navigator.pushNamed(context, '/profile'),
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
                      border: Border.all(color: scheme.primary, width: 2),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Name and email
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'John Doe',
                          style: TextStyle(
                            color: scheme.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'example@gmail.com',
                          style: TextStyle(
                            color: scheme.primary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Menu button
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(Icons.menu, color: scheme.onSurface),
                  ),
                ],
                ),
              ),
            ),
            Divider(color: scheme.onSurface.withOpacity(0.08)),
            // Menu items
            _MenuItem(
              icon: Icons.home_outlined,
              label: 'Home',
              onTap: () => Navigator.pushNamed(context, '/home'),
            ),
            _MenuItem(
              icon: Icons.favorite_border,
              label: 'W3Dating Package',
              onTap: () => Navigator.pushNamed(context, '/profile/subscription'),
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
              onTap: () => Navigator.pushNamed(context, '/profile/setting'),
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
                  Icon(Icons.dark_mode, color: scheme.onSurface.withOpacity(0.6)),
                  const SizedBox(width: 12),
                  Text(
                    'Dark Mode',
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontSize: 16,
                    ),
                  ),
                  const Spacer(),
                  Switch(
                    value: Theme.of(context).brightness == Brightness.dark,
                    onChanged: (v) {
                      try {
                        final app = W3DatingApp.of(context);
                        app.setThemeMode(v ? ThemeMode.dark : ThemeMode.light);
                      } catch (_) {}
                    },
                    activeColor: scheme.primary,
                  ),
                ],
              ),
            ),
            // App version
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Text(
                    'W3Dating - Dating App',
                    style: TextStyle(
                      color: scheme.onSurface,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'App Version 1.1',
                    style: TextStyle(
                      color: scheme.onSurface.withOpacity(0.6),
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
    final scheme = Theme.of(context).colorScheme;
    return ListTile(
      leading: Icon(icon, color: scheme.onSurface),
      title: Text(
        label,
        style: TextStyle(
          color: scheme.onSurface,
          fontSize: 16,
        ),
      ),
      trailing: Icon(Icons.chevron_right, color: scheme.onSurface.withOpacity(0.6)),
      onTap: onTap,
    );
  }
}