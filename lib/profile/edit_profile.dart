import 'package:flutter/material.dart';

class EditProfile extends StatelessWidget {
  const EditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF000A33),
      appBar: AppBar(
        backgroundColor: const Color(0xFF212635),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            
            GridView.builder(
              shrinkWrap: true,
              itemCount: 6,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 12,
                crossAxisSpacing: 12,
              ),
              itemBuilder: (context, i) {
                return GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2F45),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.white24),
                    ),
                    child: const Center(
                      child: Icon(Icons.add, color: Colors.white70, size: 30),
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 20),

            const _SettingTile(
              title: 'Interests',
              value: 'Photography, Tea, Travel',
            ),

            const _SettingTile(
              title: 'Relationship goals',
              value: 'Long-term partner',
              showArrow: true,
            ),

            const _SettingTile(
              title: 'Language I know',
              value: 'English',
            ),

            const _SettingTile(
              title: 'Sexual Orientation',
              value: 'Straight',
              showArrow: true,
            ),

            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

class _SettingTile extends StatelessWidget {
  final String title;
  final String value;
  final bool showArrow;

  const _SettingTile({
    required this.title,
    required this.value,
    this.showArrow = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: const Color(0xFF2A2F45),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15)),
                const SizedBox(height: 4),
                Text(value,
                    style: TextStyle(color: Colors.white.withOpacity(0.55))),
              ],
            ),
          ),
          if (showArrow)
            const Icon(Icons.chevron_right, color: Colors.white54),
        ],
      ),
    );
  }
}
