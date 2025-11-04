import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final ImagePicker _picker = ImagePicker();
  final List<File?> _images = List.filled(6, null);

  Future<void> _pickImage(int index) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1800,
        maxHeight: 1800,
        imageQuality: 85,
      );
      
      if (pickedFile != null) {
        setState(() {
          _images[index] = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to pick image: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Widget _buildImageBox(int index, {bool isLarge = false}) {
    final isSmall = MediaQuery.of(context).size.width < 400;
    final double largeSize = isSmall ? 220 : 240;
    final double smallSize = isSmall ? 100 : 110;
    final double size = isLarge ? largeSize : smallSize;
    
    return GestureDetector(
      onTap: () => _pickImage(index),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: const Color(0xFF2A2F45),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white24, style: BorderStyle.solid, width: 2),
        ),
        child: _images[index] != null
            ? ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.file(
                  _images[index]!,
                  fit: BoxFit.cover,
                ),
              )
            : const Center(
                child: Icon(Icons.add, color: Colors.white70, size: 40),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 400;

    return Scaffold(
      backgroundColor: const Color(0xFF1B1C23),
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
        padding: EdgeInsets.all(isSmall ? 12 : 16),
        child: Column(
          children: [
            // Photo grid layout
            SizedBox(
              height: isSmall ? 260 : 250,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Large photo box (left)
                  _buildImageBox(0, isLarge: true),
                  
                  SizedBox(width: isSmall ? 8 : 12),
                  
                  // Small photo boxes (right column)
                  Expanded(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(child: _buildImageBox(1)),
                          ],
                        ),
                        SizedBox(height: isSmall ? 8 : 12),
                        Row(
                          children: [
                            Expanded(child: _buildImageBox(2)),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),


            // Bottom 3 small boxes
            Row(
              children: [
                Expanded(child: _buildImageBox(3)),
                SizedBox(width: isSmall ? 8 : 12),
                Expanded(child: _buildImageBox(4)),
                SizedBox(width: isSmall ? 8 : 12),
                Expanded(child: _buildImageBox(5)),
              ],
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
              title: 'language I know',
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
