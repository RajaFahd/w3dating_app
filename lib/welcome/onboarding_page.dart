import 'dart:math';

import 'package:flutter/material.dart';

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bg = const Color(0xFF2B2C33);
    final pink = const Color(0xFFFE6E9F);
    final lightPink = const Color(0xFFFFC0D6);

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 28.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 300,
                        height: 360,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // dotted circle
                            CustomPaint(
                              size: const Size(300, 300),
                              painter: DottedCirclePainter(color: Colors.white30, gap: 10, strokeWidth: 3),
                            ),

                            // three small avatar dots around
                            Positioned(
                              top: 18,
                              left: 180,
                              child: glowAvatar('https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=200', 48),
                            ),
                            Positioned(
                              top: 110,
                              left: 12,
                              child: glowAvatar('https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=200', 52),
                            ),
                            Positioned(
                              bottom: 30,
                              right: 20,
                              child: glowAvatar('https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?auto=compress&cs=tinysrgb&w=200', 52),
                            ),

                            // central large circle with lock/heart icon
                            Container(
                              width: 190,
                              height: 190,
                              decoration: BoxDecoration(
                                color: Colors.white24,
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: LinearGradient(
                                    colors: [lightPink, pink],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: pink.withOpacity(0.4),
                                      blurRadius: 18,
                                      offset: const Offset(0, 8),
                                    )
                                  ],
                                ),
                                child: Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        Icons.favorite,
                                        size: 60,
                                        color: Colors.white,
                                      ),
                                      // small lock icon overlay
                                      Positioned(
                                        bottom: 24,
                                        child: Icon(
                                          Icons.lock_outline,
                                          size: 28,
                                          color: Colors.white70,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Title
                      Text(
                        'Begin Your\\nChapter of Love',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 26,
                          fontWeight: FontWeight.w700,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Subtitle
                      Text(
                        'Embrace the dating world\\narmed with tools and support',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                        ),
                      ),

                      const SizedBox(height: 22),

                      // pager dots
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          dot(Colors.white38),
                          const SizedBox(width: 8),
                          dot(pink),
                          const SizedBox(width: 8),
                          dot(Colors.white38),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // CTA button
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 28),
              child: SizedBox(
                height: 62,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(40)),
                    elevation: 6,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [pink, const Color(0xFFFF8AB8)]),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: const Text(
                        'Find Someone',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white),
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

  Widget dot(Color c) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(color: c, shape: BoxShape.circle),
    );
  }

  Widget glowAvatar(String url, double size) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(color: Colors.pink.withOpacity(0.25), blurRadius: 8, spreadRadius: 1),
        ],
      ),
      child: CircleAvatar(
        backgroundImage: NetworkImage(url),
      ),
    );
  }
}

class DottedCirclePainter extends CustomPainter {
  final Color color;
  final double gap;
  final double strokeWidth;

  DottedCirclePainter({this.color = Colors.white24, this.gap = 6, this.strokeWidth = 4});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final double radius = min(size.width, size.height) / 2 - strokeWidth;
    final Offset center = Offset(size.width / 2, size.height / 2);

    final double circumference = 2 * pi * radius;
    final double dash = 6.0;
    final double gapWithDash = dash + gap;
    final int count = (circumference / gapWithDash).floor();

    for (int i = 0; i < count; i++) {
      final double start = (i * gapWithDash) / circumference * 2 * pi;
      final double sweep = dash / circumference * 2 * pi;
      canvas.drawArc(Rect.fromCircle(center: center, radius: radius), start, sweep, false, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

