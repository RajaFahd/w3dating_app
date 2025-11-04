import 'package:flutter/material.dart';

class RecentPicsPage extends StatelessWidget {
  const RecentPicsPage({Key? key}) : super(key: key);

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
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    // Title
                    const Text(
                      'Add your recent pics',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 26,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 32),

                    // Photo layout: large box on left, two small stacked on right, three small boxes below
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final gap = 12.0;
                          final totalWidth = constraints.maxWidth;
                          final largeWidth = (totalWidth - gap) * 0.66; // left large box ~66%
                          final smallColumnWidth = totalWidth - largeWidth - gap;
                          // smallBoxSize intentionally unused — we calculate sizes directly below

                          Widget slot({double? width, double? height, double iconSize = 24}) => SizedBox(
                                width: width,
                                height: height,
                                child: CustomPaint(
                                  painter: _DashedBorder(color: Colors.white24, strokeWidth: 1.6, radius: 12),
                                  child: Center(child: Icon(Icons.add, color: Colors.white54, size: iconSize)),
                                ),
                              );

                          return Column(
                            children: [
                              // Top row with large left and two stacked small on right
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Large box
                                  SizedBox(width: largeWidth, height: largeWidth, child: slot(width: largeWidth, height: largeWidth, iconSize: 36)),
                                  SizedBox(width: gap),
                                  // Right column with two small boxes
                                  Column(
                                    children: [
                                      slot(width: smallColumnWidth, height: (largeWidth - gap) / 2, iconSize: 20),
                                      SizedBox(height: gap),
                                      slot(width: smallColumnWidth, height: (largeWidth - gap) / 2, iconSize: 20),
                                    ],
                                  )
                                ],
                              ),

                              const SizedBox(height: 16),

                              // Bottom row of three small boxes
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  slot(width: (totalWidth - gap * 2) / 3, height: (totalWidth - gap * 2) / 3, iconSize: 20),
                                  SizedBox(width: gap),
                                  slot(width: (totalWidth - gap * 2) / 3, height: (totalWidth - gap * 2) / 3, iconSize: 20),
                                  SizedBox(width: gap),
                                  slot(width: (totalWidth - gap * 2) / 3, height: (totalWidth - gap * 2) / 3, iconSize: 20),
                                ],
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Next button
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: SizedBox(
                width: double.infinity,
                height: 56,
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
                      boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 8, offset: Offset(0, 4))],
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


class _DashedBorder extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double radius;

  _DashedBorder({required this.color, this.strokeWidth = 1.0, this.radius = 8.0});

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final rrect = RRect.fromRectAndRadius(rect, Radius.circular(radius));
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;

    const dashWidth = 6.0;
    const dashSpace = 6.0;

    final path = Path()..addRRect(rrect);
    final metrics = path.computeMetrics();
    for (final metric in metrics) {
      double distance = 0.0;
      while (distance < metric.length) {
        final len = dashWidth;
        final extract = metric.extractPath(distance, distance + len);
        canvas.drawPath(extract, paint);
        distance += dashWidth + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

