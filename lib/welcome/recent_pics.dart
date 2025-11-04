import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class RecentPicsPage extends StatefulWidget {
  const RecentPicsPage({Key? key}) : super(key: key);

  @override
  State<RecentPicsPage> createState() => _RecentPicsPageState();
}

class _RecentPicsPageState extends State<RecentPicsPage> {
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
            : Center(
                child: Icon(
                  Icons.add, 
                  color: Colors.white70, 
                  size: isLarge ? 40 : 32,
                ),
              ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 400;

    return Scaffold(
      backgroundColor: const Color(0xFF2B2C33),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Back button
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0),
              child: IconButton(
                icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: isSmall ? 16.0 : 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: isSmall ? 16 : 32),
                    // Title
                    Text(
                      'Add your recent pics',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: isSmall ? 22 : 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: isSmall ? 20 : 32),

                    // Photo grid layout
                    SizedBox(
                      height: isSmall ? 260 : 255,
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
                  ],
                ),
              ),
            ),

            // Next button
            Padding(
              padding: EdgeInsets.all(isSmall ? 16.0 : 24.0),
              child: SizedBox(
                width: double.infinity,
                height: isSmall ? 50 : 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(28),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/home');
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFF6DA0), Color(0xFFFF3F80)]),
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
                    ),
                    child: const Center(
                      child: Text(
                        'Next',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

