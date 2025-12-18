import 'dart:math';
import 'dart:async';

import 'package:flutter/material.dart';

class WelcomeCarousel extends StatefulWidget {
  const WelcomeCarousel({super.key});

  @override
  State<WelcomeCarousel> createState() => _WelcomeCarouselState();
}

class _WelcomeCarouselState extends State<WelcomeCarousel> {
  final List<Map<String, String>> slides = [
    {
      'title': 'Begin Your\nChapter of Love',
      'subtitle': 'Embrace the dating world\narmed with tools and support',
    },
    {
      'title': 'Your Journey\nof Connection',
      'subtitle': 'Explore essentials and delights\nthat boost confidence',
    },
    {
      'title': 'Start Your\nDating Story',
      'subtitle': 'Your companion for meaningful\nconnections',
    },
  ];
  late final PageController _pageController;
  int _currentPage = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _startAutoScroll();
  }

  void _startAutoScroll() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (!mounted) return;
      int nextPage = (_currentPage + 1) % slides.length;
      _pageController.animateToPage(
        nextPage,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isSmall = width < 350 || height < 650;
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: isSmall ? 60 : 200,
          child: PageView.builder(
            controller: _pageController,
            itemCount: slides.length,
            onPageChanged: (i) {
              setState(() => _currentPage = i);
            },
            itemBuilder: (context, i) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    slides[i]['title']!,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isSmall ? 15 : 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: isSmall ? 3 : 0),
                  Text(
                    slides[i]['subtitle']!,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: isSmall ? 10 : 16,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        SizedBox(height: isSmall ? 16 : 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            slides.length,
            (i) => Container(
              margin: EdgeInsets.symmetric(horizontal: isSmall ? 1.5 : 4),
              width: isSmall ? 5 : 8,
              height: isSmall ? 5 : 8,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: i == _currentPage
                    ? const Color(0xFFFF3F80)
                    : Colors.white24,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class OnboardingPage extends StatelessWidget {
  const OnboardingPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final bg = Theme.of(context).scaffoldBackgroundColor;
    final pink = const Color(0xFFFE6E9F);
    final lightPink = const Color(0xFFFFC0D6);
    final width = MediaQuery.of(context).size.width;
    final height = MediaQuery.of(context).size.height;
    final isSmallW = width < 400;
    final isSmallH = height < 800;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Gambar utama (lock + avatar + dotted circle)
                    SizedBox(
                      width: isSmallW ? 220 : 300,
                      height: isSmallH ? 240 : 360,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          // Dotted circle
                          CustomPaint(
                            size: Size(
                              isSmallW ? 180 : 260,
                              isSmallW ? 180 : 260,
                            ),
                            painter: DottedCirclePainter(
                              color: Colors.white30,
                              gap: 10,
                              strokeWidth: 3,
                            ),
                          ),
                          // Avatar-1 (atas)
                          Positioned(
                            top: isSmallW ? 10 : 18,
                            child: glowAvatar(
                              'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=200',
                              isSmallW ? 36 : 48,
                            ),
                          ),
                          // Avatar-2 (kiri bawah)
                          Positioned(
                            left: isSmallW ? 8 : 24,
                            bottom: isSmallW ? 32 : 52,
                            child: glowAvatar(
                              'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?auto=compress&cs=tinysrgb&w=200',
                              isSmallW ? 38 : 52,
                            ),
                          ),
                          // Avatar-3 (kanan bawah)
                          Positioned(
                            right: isSmallW ? 8 : 24,
                            bottom: isSmallW ? 32 : 52,
                            child: glowAvatar(
                              'https://images.pexels.com/photos/2379005/pexels-photo-2379005.jpeg?auto=compress&cs=tinysrgb&w=200',
                              isSmallW ? 38 : 52,
                            ),
                          ),
                          // Lingkaran tengah + icon
                          Container(
                            width: isSmallW ? 110 : 170,
                            height: isSmallW ? 110 : 170,
                            decoration: BoxDecoration(
                              color: Colors.white24,
                              shape: BoxShape.circle,
                            ),
                            alignment: Alignment.center,
                            child: Container(
                              width: isSmallW ? 60 : 120,
                              height: isSmallW ? 60 : 120,
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
                                    blurRadius: isSmallW ? 8 : 18,
                                    offset: Offset(0, isSmallW ? 3 : 8),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Icon(
                                      Icons.favorite,
                                      size: isSmallW ? 28 : 60,
                                      color: Colors.white,
                                    ),
                                    Positioned(
                                      bottom: isSmallW ? 8 : 24,
                                      child: Icon(
                                        Icons.lock_outline,
                                        size: isSmallW ? 14 : 28,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: isSmallH ? 24 : 30),
                    // Carousel teks (auto-scroll, responsif, tidak overflow)
                    Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: isSmallW ? 30 : 0,
                      ),
                      child: WelcomeCarousel(),
                    ),
                  ],
                ),
              ),
            ),
            // Tombol bawah
            Padding(
              padding: EdgeInsets.only(
                left: isSmallW ? 8 : 20,
                right: isSmallW ? 8 : 20,
                bottom: isSmallH ? 14 : 28,
              ),
              child: SizedBox(
                height: isSmallH ? 46 : 62,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    elevation: 6,
                  ),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/login');
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [pink, const Color(0xFFFF8AB8)],
                      ),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: Container(
                      alignment: Alignment.center,
                      child: Text(
                        'Find Someone',
                        style: TextStyle(
                          fontSize: isSmallW ? 14 : 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
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

class DottedCirclePainter extends CustomPainter {
  final Color color;
  final double gap;
  final double strokeWidth;

  DottedCirclePainter({
    this.color = Colors.white24,
    this.gap = 6,
    this.strokeWidth = 4,
  });

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
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        start,
        sweep,
        false,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

Widget glowAvatar(String url, double size) {
  return Container(
    width: size,
    height: size,
    decoration: BoxDecoration(
      shape: BoxShape.circle,
      boxShadow: [
        BoxShadow(
          color: Colors.pink.withOpacity(0.25),
          blurRadius: 8,
          spreadRadius: 1,
        ),
      ],
    ),
    child: CircleAvatar(backgroundImage: NetworkImage(url)),
  );
}
