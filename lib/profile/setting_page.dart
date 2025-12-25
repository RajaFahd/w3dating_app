import 'package:flutter/material.dart';
import 'package:w3dating_app/main.dart';
import '../services/api_service.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({super.key});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  final ApiService _apiService = ApiService();
  double maxDistance = 40;
  RangeValues ageRange = const RangeValues(18, 30);
  String? _phoneNumber;
  String? _location;
  String? _email;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      final response = await _apiService.getMe();
      
      if (response['success'] == true) {
        final user = response['data'] as Map<String, dynamic>?;
        
        if (user != null) {
          final profile = user['profile'] as Map<String, dynamic>?;
          
          setState(() {
            _phoneNumber = '${user['country_code'] ?? '+62'}${user['phone_number'] ?? ''}';
            _email = user['email'] ?? 'Not set';
            _location = profile?['city'] ?? 'Not set';
            _isLoading = false;
          });
        } else {
          setState(() => _isLoading = false);
        }
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      width: 44,
                      height: 44,
                      decoration: const BoxDecoration(
                        color: Color(0xFF4A254A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Settings',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 16),
                    // Account Setting
                    const Text(
                      'Account Setting',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _buildSettingItem(
                            icon: Icons.phone,
                            title: 'Phone Number',
                            value: _phoneNumber ?? 'Not set',
                          ),
                    _isLoading
                        ? const SizedBox()
                        : _buildSettingItem(
                            icon: Icons.email_outlined,
                            title: 'Email Address',
                            value: _email ?? 'Not set',
                          ),
                    
                    const SizedBox(height: 24),
                    // Discovery Setting
                    const Text(
                      'Discovery Setting',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _isLoading
                        ? const SizedBox()
                        : _buildSettingItem(
                            icon: Icons.location_on_outlined,
                            title: 'Location',
                            value: _location ?? 'Not set',
                          ),
                    
                    const SizedBox(height: 24),
                    // Other
                    const Text(
                      'Other',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    // Maximum Distance
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                             Text(
                               'Maximum Distance',
                               style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                             ),
                              Text(
                              '${maxDistance.toInt()}km',
                              style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: const Color(0xFFFF3F80),
                              inactiveTrackColor: Colors.white24,
                              thumbColor: const Color(0xFFFF3F80),
                              overlayColor: const Color(0x33FF3F80),
                              trackHeight: 4,
                            ),
                            child: Slider(
                              value: maxDistance,
                              min: 1,
                              max: 100,
                              onChanged: (value) {
                                setState(() {
                                  maxDistance = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    // Show Me
                    _buildSettingItem(
                      title: 'Show Me',
                      value: 'Women',
                      showArrow: true,
                    ),
                    
                    // Age Range
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Age Range',
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7)),
                              ),
                              Text(
                                '${ageRange.start.toInt()} - ${ageRange.end.toInt()}',
                                style: TextStyle(color: Theme.of(context).colorScheme.onSurface),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SliderTheme(
                            data: SliderTheme.of(context).copyWith(
                              activeTrackColor: const Color(0xFFFF3F80),
                              inactiveTrackColor: Colors.white24,
                              thumbColor: const Color(0xFFFF3F80),
                              overlayColor: const Color(0x33FF3F80),
                              trackHeight: 4,
                              rangeThumbShape: const RoundRangeSliderThumbShape(
                                enabledThumbRadius: 10,
                              ),
                            ),
                            child: RangeSlider(
                              values: ageRange,
                              min: 18,
                              max: 70,
                              onChanged: (values) {
                                setState(() {
                                  ageRange = values;
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Theme mode toggle
                    Container(
                      margin: const EdgeInsets.only(bottom: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.brightness_6, color: Colors.amber),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Light Mode',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Switch between light and dark appearance',
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          StatefulBuilder(
                            builder: (context, setSB) {
                              // Try to read app's current theme mode (fallback to system)
                              bool value = Theme.of(context).brightness == Brightness.light;
                              return Switch(
                                value: value,
                                onChanged: (v) {
                                  // Access app state to set theme mode
                                  try {
                                    // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
                                    final app = W3DatingApp.of(context);
                                    app?.setThemeMode(v ? ThemeMode.light : ThemeMode.dark);
                                    setSB(() {});
                                    setState(() {});
                                  } catch (_) {
                                    // If accessor not available, do nothing
                                  }
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem({
    IconData? icon,
    required String title,
    required String value,
    bool showArrow = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1C2932),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white70),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
          if (showArrow)
            const Icon(
              Icons.arrow_forward_ios,
              color: Colors.white70,
              size: 16,
            ),
        ],
      ),
    );
  }
}
