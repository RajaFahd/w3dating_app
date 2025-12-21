import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';
import 'dart:async';

class LookingForPage extends StatefulWidget {
  const LookingForPage({Key? key}) : super(key: key);

  @override
  State<LookingForPage> createState() => _LookingForPageState();
}

class _LookingForPageState extends State<LookingForPage> {
  final List<String> options = [
    'Long-term partner',
    'Long-term, open to short',
    'Short-term, open to long',
    'Short-term fun',
    'New friends',
    'Still figuring it out',
  ];
  String? selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                        'What are you looking for right\nnow ?',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: MediaQuery.of(context).size.width < 400 ? 22 : 26,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: MediaQuery.of(context).size.height < 800 ? 20 : 32),

                      // Options
                      ...options.map((option) => Padding(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).size.height < 800 ? 12.0 : 16.0
                        ),
                        child: InkWell(
                          onTap: () {
                            setState(() {
                              selectedOption = option;
                            });
                          },
                          child: Container(
                            height: MediaQuery.of(context).size.height < 800 ? 50 : 56,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: selectedOption == option 
                                  ? const Color(0xFFFF3F80)
                                  : Colors.white.withOpacity(0.2),
                                width: 1.5,
                              ),
                            ),
                            child: Row(
                              children: [
                                SizedBox(width: MediaQuery.of(context).size.width < 400 ? 12 : 16),
                                Container(
                                  width: 24,
                                  height: 24,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: selectedOption == option
                                          ? const Color(0xFFFF3F80)
                                          : Colors.white.withOpacity(0.6),
                                      width: 2,
                                    ),
                                  ),
                                  child: selectedOption == option
                                      ? const Center(
                                          child: Icon(
                                            Icons.circle,
                                            size: 12,
                                            color: Color(0xFFFF3F80),
                                          ),
                                        )
                                      : null,
                                ),
                                SizedBox(width: MediaQuery.of(context).size.width < 400 ? 10 : 12),
                                Expanded(
                                  child: Text(
                                    option,
                                    style: TextStyle(
                                      color: selectedOption == option
                                          ? Colors.white
                                          : Colors.white.withOpacity(0.8),
                                      fontSize: 16,
                                    ),
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
                    if (selectedOption != null) {
                      Provider.of<ProfileProvider>(context, listen: false)
                          .setLookingFor(selectedOption!);
                      Navigator.pushNamed(context, '/recent_pics');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Please select what you are looking for')),
                      );
                    }
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
        duration: const Duration(milliseconds: 400),
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
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 120,
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
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    slides[i]['subtitle']!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 15,
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(slides.length, (i) => Container(
            margin: const EdgeInsets.symmetric(horizontal: 4),
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: i == _currentPage ? const Color(0xFFFF3F80) : Colors.white24,
            ),
          )),
        ),
      ],
    );
  }
}

// Cara pakai di halaman utama onboarding Anda:
// ...

