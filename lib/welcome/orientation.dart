import 'package:flutter/material.dart';

class OrientationPage extends StatefulWidget {
  const OrientationPage({Key? key}) : super(key: key);

  @override
  State<OrientationPage> createState() => _OrientationPageState();
}

class _OrientationPageState extends State<OrientationPage> {
  final List<String> orientations = [
    'Straight',
    'Gay',
    'Lesbian',
    'Bisexual',
    'Asexual',
    'Queer',
    'Demisexual',
  ];
  String? selectedOrientation;

  @override
  Widget build(BuildContext context) {
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
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width < 400 ? 16.0 : 24.0
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: MediaQuery.of(context).size.height < 800 ? 16 : 32),
                      // Title
                      Text(
                        'Your sexual orientation ?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width < 400 ? 22 : 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height < 800 ? 20 : 32),

                      // Orientation options
                      ...orientations.map((orientation) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height < 800 ? 12.0 : 16.0
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedOrientation = orientation;
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height < 800 ? 50 : 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedOrientation == orientation 
                                  ? const Color(0xFFFF3F80)
                                  : Colors.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width < 400 ? 12 : 16),
                                Icon(
                                  selectedOrientation == orientation
                                      ? Icons.check_box_rounded
                                      : Icons.check_box_outline_blank_rounded,
                                  color: selectedOrientation == orientation
                                      ? const Color(0xFFFF3F80)
                                      : Colors.white.withOpacity(0.6),
                                  size: 24,
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width < 400 ? 10 : 12),
                                Text(
                                  orientation,
                                  style: TextStyle(
                                    color: selectedOrientation == orientation
                                        ? Colors.white
                                        : Colors.white.withOpacity(0.8),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )).toList(),
                      const SizedBox(height: 16), // Extra space for scroll
                    ],
                  ),
                ),
              ),
            ),

            // Next button
            Padding(
              padding: EdgeInsets.all(
                MediaQuery.of(context).size.width < 400 ? 16.0 : 24.0
              ),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height < 800 ? 50 : 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF3F80),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/interested');
                  },
                  child: const Text(
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
          ],
        ),
      ),
    );
  }
}

