import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  double maxDistance = 40;
  RangeValues ageRange = const RangeValues(18, 30);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF061233),
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
                  const Text(
                    'Settings',
                    style: TextStyle(
                      color: Colors.white,
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
                    _buildSettingItem(
                      icon: Icons.phone,
                      title: 'Phone Number',
                      value: '+123 4567 890',
                    ),
                    _buildSettingItem(
                      icon: Icons.email_outlined,
                      title: 'Email Address',
                      value: 'yourname@gmail.com',
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
                    _buildSettingItem(
                      icon: Icons.location_on_outlined,
                      title: 'Location',
                      value: '2300 Traverwood Dr. Ann Arbor, MI',
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
                        color: const Color(0xFF1C2932),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Maximum Distance',
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(
                                '${maxDistance.toInt()}km',
                                style: const TextStyle(color: Colors.white),
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
                        color: const Color(0xFF1C2932),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Age Range',
                                style: TextStyle(color: Colors.white70),
                              ),
                              Text(
                                '${ageRange.start.toInt()} - ${ageRange.end.toInt()}',
                                style: const TextStyle(color: Colors.white),
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
