import 'package:flutter/material.dart';
import 'package:w3dating_app/main.dart';
import '../services/api_service.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final ApiService _apiService = ApiService();
  Map<String, dynamic>? _user;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final response = await _apiService.getMe();
      if (response['success'] == true && response['data'] != null) {
        setState(() {
          _user = response['data'];
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    
    if (_isLoading) {
      return Drawer(
        backgroundColor: scheme.surface,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    final profile = _user?['profile'] as Map<String, dynamic>?;
    final photos = _user?['photos'] as List<dynamic>?;
    final firstName = profile?['first_name'] ?? 'User';
    final phoneNumber = _user?['phone_number'] ?? '';
    final countryCode = _user?['country_code'] ?? '';
    final displayPhone = '$countryCode $phoneNumber';
    
    // Get primary photo (is_primary = 1) or first photo
    String? profileImageUrl;
    if (photos != null && photos.isNotEmpty) {
      try {
        final primaryPhoto = photos.firstWhere(
          (p) => (p as Map<String, dynamic>)['is_primary'] == 1,
          orElse: () => photos.first,
        );
        final photoPath = (primaryPhoto as Map<String, dynamic>)['photo_url'];
        if (photoPath != null) {
          // Build full URL - remove /api from base URL for storage files
          final baseUrlWithoutApi = ApiService.baseUrl.replaceAll('/api', '');
          profileImageUrl = '$baseUrlWithoutApi$photoPath';
        }
      } catch (e) {
        profileImageUrl = null;
      }
    }
    
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
                        border: Border.all(color: scheme.primary, width: 2),
                      ),
                      child: ClipOval(
                        child: profileImageUrl != null 
                          ? Image.network(
                              profileImageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return Icon(Icons.person, color: scheme.onSurface, size: 32);
                              },
                            )
                          : Icon(Icons.person, color: scheme.onSurface, size: 32),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Name and phone
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            firstName,
                            style: TextStyle(
                              color: scheme.onSurface,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            displayPhone,
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
                        app?.setThemeMode(v ? ThemeMode.dark : ThemeMode.light);
                      } catch (_) {}
                    },
                    activeThumbColor: scheme.primary,
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