import 'package:flutter/material.dart';
import 'package:w3dating_app/chat/chat_list.dart';
import 'dart:math' as math;

class MatchScreenPage extends StatefulWidget {
  final String matchName;
  final String userImageUrl;
  final String matchImageUrl;

  const MatchScreenPage({
    Key? key,
    this.matchName = 'Marianne',
    this.userImageUrl = 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400',
    this.matchImageUrl = 'https://images.pexels.com/photos/415829/pexels-photo-415829.jpeg?auto=compress&cs=tinysrgb&w=400',
  }) : super(key: key);

  @override
  State<MatchScreenPage> createState() => _MatchScreenPageState();
}

class _MatchScreenPageState extends State<MatchScreenPage> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final isSmall = width < 400;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF2B2C33),
              Color(0xFF3D2B47),
              Color(0xFF2B2C33),
            ],
          ),
        ),
        child: SafeArea(
          child: Stack(
            children: [
              // Floating hearts background
              ...List.generate(8, (index) => _buildFloatingHeart(index)),
              
              // Main content
              FadeTransition(
                opacity: _fadeAnimation,
                child: Column(
                  children: [
                    const Spacer(),
                    
                    // Photos with tilt effect
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: SizedBox(
                        height: isSmall ? 380 : 450,
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            // Left photo (user) - tilted left
                            Positioned(
                              left: isSmall ? 20 : 40,
                              child: Transform.rotate(
                                angle: -0.15,
                                child: _buildPhotoCard(
                                  widget.userImageUrl,
                                  isSmall ? 180 : 220,
                                  isSmall ? 260 : 320,
                                  Alignment.bottomLeft,
                                ),
                              ),
                            ),
                            
                            // Right photo (match) - tilted right
                            Positioned(
                              right: isSmall ? 20 : 40,
                              top: isSmall ? 20 : 40,
                              child: Transform.rotate(
                                angle: 0.15,
                                child: _buildPhotoCard(
                                  widget.matchImageUrl,
                                  isSmall ? 180 : 220,
                                  isSmall ? 260 : 320,
                                  Alignment.topRight,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Congratulations text
                    const Text(
                      'CONGRATULATIONS',
                      style: TextStyle(
                        color: Color(0xFFFF3F80),
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // It's a MATCH! text
                    RichText(
                      textAlign: TextAlign.center,
                      text: const TextSpan(
                        style: TextStyle(
                          fontSize: 32,
                          color: Colors.white,
                          fontWeight: FontWeight.w300,
                          fontStyle: FontStyle.italic,
                        ),
                        children: [
                          TextSpan(text: "it's a "),
                          TextSpan(
                            text: "MATCH!",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 12),
                    
                    // Subtitle
                    Text(
                      '"Say hello to ${widget.matchName} and start your\nconversation now!"',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Buttons
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: isSmall ? 20 : 40),
                      child: Column(
                        children: [
                          // Say Hello button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                padding: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                elevation: 0,
                              ),
                              onPressed: () {
                                // Navigate to chat screen
                                Navigator.pushReplacementNamed(
                                  context,
                                  '/chat_screen',
                                  arguments: MessageItem(
                                    name: widget.matchName,
                                    message: '',
                                    time: 'Now',
                                    avatarUrl: widget.matchImageUrl,
                                    isRead: false,
                                    isOnline: true,
                                  ),
                                );
                              },
                              child: Ink(
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFFF80B0), Color(0xFFFF4DA8)],
                                  ),
                                  borderRadius: BorderRadius.circular(40),
                                ),
                                child: Container(
                                  alignment: Alignment.center,
                                  child: const Text(
                                    'Say Hello',
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          
                          const SizedBox(height: 16),
                          
                          // Keep Swiping button
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                side: const BorderSide(color: Colors.white24),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(40),
                                ),
                              ),
                              onPressed: () {
                                // Navigate back to home
                                Navigator.pushReplacementNamed(context, '/home');
                              },
                              child: const Text(
                                'Keep Swiping',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const Spacer(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPhotoCard(String imageUrl, double width, double height, Alignment heartPosition) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3), width: 3),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(17),
            child: imageUrl.startsWith('http')
                ? Image.network(
                    imageUrl,
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.person, size: 80, color: Colors.white38),
                      );
                    },
                  )
                : Image.asset(
                    imageUrl,
                    width: width,
                    height: height,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[800],
                        child: const Icon(Icons.person, size: 80, color: Colors.white38),
                      );
                    },
                  ),
          ),
          // Heart icon with pink background
          Align(
            alignment: heartPosition,
            child: Transform.translate(
              offset: heartPosition == Alignment.bottomLeft 
                  ? const Offset(15, -15) 
                  : const Offset(-15, 15),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF80B0), Color(0xFFFF4DA8)],
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF4DA8).withOpacity(0.5),
                      blurRadius: 15,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite,
                  color: Colors.white,
                  size: 24,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingHeart(int index) {
    final random = math.Random(index);
    final left = random.nextDouble() * MediaQuery.of(context).size.width;
    final delay = random.nextInt(3);
    final size = 15.0 + random.nextDouble() * 20;
    final isPink = random.nextBool();
    
    return Positioned(
      left: left,
      top: -50,
      child: TweenAnimationBuilder(
        duration: Duration(seconds: 8 + delay),
        tween: Tween<double>(begin: -50, end: MediaQuery.of(context).size.height + 50),
        builder: (context, double value, child) {
          return Transform.translate(
            offset: Offset(math.sin(value / 100) * 30, value),
            child: Opacity(
              opacity: (1 - (value / MediaQuery.of(context).size.height)).clamp(0.0, 0.6),
              child: Icon(
                Icons.favorite,
                color: isPink ? const Color(0xFFFF80B0) : Colors.white38,
                size: size,
              ),
            ),
          );
        },
        onEnd: () {
          if (mounted) {
            setState(() {}); // Restart animation
          }
        },
      ),
    );
  }
}

