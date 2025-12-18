import 'package:flutter/material.dart';
import 'package:w3dating_app/template/bottom_navigation.dart';
import 'package:w3dating_app/template/sidebar.dart';
import 'package:w3dating_app/home/match_screen_page.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  // ========================================
  // DATA PROFIL - Ganti dengan data Anda
  // ========================================
  final List<Map<String, dynamic>> _profiles = [
    {
      'name': 'Davina Karamoy',
      'age': '21',
      'location': 'Jakarta',
      'distance': '5 km',
      'image': 'assets/images/profiles/davina.jpg', // Path gambar lokal
      'bio': 'Artist',
      'interests': ['Acting', 'Work', 'cooking'],
      'occupation': 'Artist',
      'isNew': true,
    },
    {
      'name': 'Ariel Tatum',
      'age': '32',
      'location': 'Jakarta',
      'distance': '5 km',
      'image': 'assets/images/profiles/ariel.jpg', // Path gambar lokal
      'bio': 'Artist',
      'interests': ['Acting', 'Work', 'cooking'],
      'occupation': 'Artist',
      'isNew': false,
    },
    {
      'name': 'Anya Geraldine',
      'age': '25',
      'location': 'Jakarta',
      'distance': '5 km',
      'image': 'assets/images/profiles/anya.jpg', // Path gambar lokal
      'bio': 'Artist',
      'interests': ['Acting', 'Work', 'cooking'],
      'occupation': 'Artist',
      'isNew': false,
    },
    {
      'name': 'Seno',
      'age': '20',
      'location': 'Yogyakarta',
      'distance': '2 km',
      'image': 'assets/images/profiles/seno.jpg', // Path gambar lokal
      'bio': 'Love code and basketball',
      'interests': ['Basketball', 'Code', 'Sleep'],
      'occupation': 'Hengkerrrrrr',
      'isNew': false,
    },
    {
      'name': 'Raja',
      'age': '20',
      'location': 'Yogyakarta',
      'distance': '5 km',
      'image': 'assets/images/profiles/raja.jpg', // Path gambar lokal
      'bio': 'IT Enthusiast',
      'interests': ['Code', 'IT', 'Hike'],
      'occupation': 'Pentesttttttttttttttttttttt',
      'isNew': false,
    },
    {
      'name': 'Bima',
      'age': '24',
      'location': 'Sleman',
      'distance': '5 km',
      'image': 'assets/images/profiles/bima.jpg', // Path gambar lokal
      'bio': 'IT Enthusiast',
      'interests': ['Code', 'IT', 'Hike'],
      'occupation': 'Pentesttttttttttttttttttttt',
      'isNew': false,
    },
  ];
  // ========================================

  void _onLike() {
    // Feedback sudah ditampilkan di card dengan icon
    // Simulasi random match (30% chance to show match screen)
    if (math.Random().nextDouble() < 0.3) {
      // Ambil profil yang sedang di-like (profil terakhir)
      final likedProfile = _profiles.isNotEmpty ? _profiles.last : null;
      
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted && likedProfile != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => MatchScreenPage(
                matchName: likedProfile['name'] as String,
                userImageUrl: 'https://images.pexels.com/photos/2379004/pexels-photo-2379004.jpeg?auto=compress&cs=tinysrgb&w=400',
                // Home uses local asset path under key 'image'; pass that safely
                matchImageUrl: likedProfile['image'] as String,
              ),
            ),
          );
        }
      });
    }
  }

  void _onDislike() {
    // Feedback sudah ditampilkan di card dengan icon
    // Bisa tambahkan logic lain seperti save to database
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      drawer: const SideBar(),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            tooltip: 'Open menu',
            icon: const Icon(Icons.menu_rounded, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        centerTitle: true,
        title: Row(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(colors: [theme.primaryColor, theme.primaryColor.withOpacity(0.85)]),
            ),
            child: const Icon(Icons.favorite, color: Colors.white, size: 20),
          ),
        ]),
        actions: [
          IconButton(
            tooltip: 'Filter',
            icon: const Icon(Icons.filter_list_outlined),
            onPressed: () => Navigator.pushNamed(context, '/profile/filter'),
          ),
        ],
      ),
      body: SafeArea(
		child: Column(
			children: [
			Expanded( // ✅ Ganti SizedBox yang fix height jadi Expand flex
				child: Center(
				child: SwipeCardStack(
					profiles: _profiles,
					onLike: _onLike,
					onDislike: _onDislike,
				),
				),
			),
			],
		),
	  ),

      bottomNavigationBar: AppBottomNavigation(currentIndex: 0),
    );
  }
}

class SwipeCardStack extends StatefulWidget {
  final List<Map<String, dynamic>> profiles;
  final VoidCallback? onLike;
  final VoidCallback? onDislike;

  const SwipeCardStack({Key? key, required this.profiles, this.onLike, this.onDislike}) : super(key: key);

  @override
  State<SwipeCardStack> createState() => _SwipeCardStackState();
}

class _SwipeCardStackState extends State<SwipeCardStack> with SingleTickerProviderStateMixin {
  int _topIndex = 0;
  Offset _drag = Offset.zero;
  double _rotation = 0.0;
  late final AnimationController _animController;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    // controller kept for potential future animations
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  void _onPanUpdate(DragUpdateDetails d) {
    setState(() {
      // Batasi pergerakan dengan dampening/resistance
      final newDragX = _drag.dx + d.delta.dx;
      final newDragY = _drag.dy + d.delta.dy;
      
      // Deteksi arah dominan swipe
      final isVerticalSwipe = newDragY.abs() > newDragX.abs() * 1.5;
      
      // Jika swipe vertikal, set X ke 0 agar lurus ke atas
      final clampedX = isVerticalSwipe ? 0.0 : newDragX.clamp(-500.0, 500.0);
      
      // Batasi vertical movement (hanya bisa ke atas, tidak bisa ke bawah)
      final clampedY = newDragY.clamp(-500.0, 0.0);
      
      _drag = Offset(clampedX, clampedY);
      
      // Rotation hanya untuk swipe horizontal, tidak ada rotation untuk swipe vertikal
      _rotation = isVerticalSwipe ? 0.0 : (clampedX / 400).clamp(-0.15, 0.15);
    });
  }

  Future<void> _onPanEnd(DragEndDetails d) async {
    // Deteksi arah swipe berdasarkan drag akhir
    final isVerticalSwipe = _drag.dy.abs() > _drag.dx.abs();
    final isHorizontalSwipe = _drag.dx.abs() > 80;
    final isUpSwipe = _drag.dy < -50;
    
    if (isHorizontalSwipe || isUpSwipe) {
      if (isVerticalSwipe && isUpSwipe) {
        // Swipe ke atas - LURUS tanpa goyah
        setState(() {
          _drag = Offset(0, -500); // X = 0 untuk movement lurus ke atas
          _rotation = 0; // Tidak ada rotasi
        });
        // Super Like - tanpa SnackBar
        // widget.onSuperLike?.call(); // Bisa tambahkan callback jika perlu
      } else if (isHorizontalSwipe) {
        // Swipe kiri/kanan
        final liked = _drag.dx > 0;
        setState(() {
          _drag = Offset(liked ? 500 : -500, _drag.dy);
          _rotation = (liked ? 0.2 : -0.2);
        });
        // Trigger callbacks
        if (liked) {
          widget.onLike?.call();
        } else {
          widget.onDislike?.call();
        }
      }
      
      // Delay minimal untuk visual feedback - dipercepat jadi 150ms
      await Future.delayed(const Duration(milliseconds: 150));
      // Reset for next card
      if (mounted) {
        setState(() {
          _topIndex = (_topIndex + 1) % widget.profiles.length;
          _drag = Offset.zero;
          _rotation = 0.0;
        });
      }
    } else {
      // Spring back animation dengan smooth return ke center
      setState(() {
        _drag = Offset.zero;
        _rotation = 0.0;
      });
    }
  }

  // Helper method untuk feedback opacity
  double _getFeedbackOpacity() {
    final dragDistance = (_drag.dx.abs() > _drag.dy.abs()) 
        ? _drag.dx.abs() 
        : _drag.dy.abs();
    // Opacity 0.0 - 1.0 based on drag distance (max at 100px)
    return (dragDistance / 100).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final visible = List.generate(3, (i) => (_topIndex + i) % widget.profiles.length).reversed.toList();
    final children = <Widget>[];
    for (final idx in visible) {
      final profile = widget.profiles[idx];
      final isTop = idx == _topIndex;
      final pos = visible.indexOf(idx);
      final scale = 1 - (pos * 0.00); // Lebih besar scale difference
      final translateY = pos * 0.0; // Lebih kecil translateY agar lebih rapat

      final card = Positioned.fill(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16), // Padding kiri kanan
          child: AnimatedContainer(
            duration: isTop && _drag == Offset.zero 
              ? const Duration(milliseconds: 200) 
              : Duration.zero,
            curve: Curves.easeOut,
            child: Transform.translate(
              offset: isTop ? _drag : Offset(0, translateY),
              child: Transform.rotate(
                angle: isTop ? _rotation : 0.0,
                child: Align(
                alignment: Alignment.center,
                child: FractionallySizedBox(
                  widthFactor: scale, // Menggunakan scale langsung
                  heightFactor: scale, // Tambahkan heightFactor juga
                  child: Card(
                    elevation: isTop ? 8 : 0, // Shadow hanya untuk card teratas
                    color: const Color(0xFF0D1220),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.asset(
                          profile['image'] as String,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            // Fallback jika gambar tidak ditemukan
                            return Container(
                              color: Colors.grey[900],
                              child: const Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.person_outline, color: Colors.white54, size: 80),
                                    SizedBox(height: 8),
                                    Text(
                                      'Image not found',
                                      style: TextStyle(color: Colors.white54),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      
                      // Feedback overlay - Like di kiri atas
                      if (isTop && _drag.dx > 20)
                        Positioned(
                          top: 20,
                          left: 20,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 100),
                            opacity: _getFeedbackOpacity(),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.15),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.5),
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.favorite,
                                size: 60,
                                color: Colors.green,
                              ),
                            ),
                          ),
                        ),
                      
                      // Feedback overlay - Dislike di kanan atas
                      if (isTop && _drag.dx < -20)
                        Positioned(
                          top: 20,
                          right: 20,
                          child: AnimatedOpacity(
                            duration: const Duration(milliseconds: 100),
                            opacity: _getFeedbackOpacity(),
                            child: Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                color: Colors.red.withOpacity(0.15),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.red.withOpacity(0.5),
                                  width: 3,
                                ),
                              ),
                              child: const Icon(
                                Icons.close,
                                size: 60,
                                color: Colors.red,
                              ),
                            ),
                          ),
                        ),
                      
                      // Feedback overlay - Super Like di center agak bawah
                      if (isTop && _drag.dy < -20 && _drag.dy.abs() > _drag.dx.abs())
                        Positioned(
                          top: MediaQuery.of(context).size.height * 0.55,
                          left: 0,
                          right: 0,
                          child: Center(
                            child: AnimatedOpacity(
                              duration: const Duration(milliseconds: 100),
                              opacity: _getFeedbackOpacity(),
                              child: Container(
                                width: 120,
                                height: 120,
                                decoration: BoxDecoration(
                                  color: Colors.blue.withOpacity(0.15),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Colors.blue.withOpacity(0.5),
                                    width: 3,
                                  ),
                                ),
                                child: const Icon(
                                  Icons.star,
                                  size: 70,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ),
                        ),
                      
                      // Gradient overlay at bottom
                      Positioned(
                        left: 0,
                        right: 0,
                        bottom: 0,
                        height: 200, // Made taller to cover more
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                Colors.black.withOpacity(0.9),
                                Colors.black.withOpacity(1.0), // Added solid black at bottom
                              ],
                              stops: const [0.0, 0.7, 1.0], // Adjusted gradient stops
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 16,
                        right: 16,
                        bottom: 16,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (profile['isNew'] == true)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.pink.shade400.withOpacity(0.95),
                                  borderRadius: BorderRadius.circular(16)
                                ),
                                child: const Text(
                                  'New here',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600
                                  )
                                ),
                              ),
                            SizedBox(height: profile['isNew'] == true ? 8 : 0),
                            Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    '${profile['name']}, ${profile['age']}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 26,
                                      fontWeight: FontWeight.bold,
                                      shadows: [Shadow(color: Colors.black54, offset: Offset(0, 2), blurRadius: 4)],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 40,
                                  height: 40,
                                  decoration: const BoxDecoration(
                                    color: Colors.pink,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.star,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final interest in profile['interests'] as List)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.pink.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: Colors.pink.withOpacity(0.5),
                                        width: 1,
                                      ),
                                    ),
                                    child: Text(
                                      interest,
                                      style: TextStyle(
                                        color: Colors.pink.shade200,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ),
          ),
        ),
      );

      if (isTop) {
        children.add(GestureDetector(onPanUpdate: _onPanUpdate, onPanEnd: _onPanEnd, child: card));
      } else {
        children.add(card);
      }
    }

    return Stack(alignment: Alignment.center, children: children);
  }
}


