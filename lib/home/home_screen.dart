import 'package:flutter/material.dart';
import 'package:w3dating_app/template/bottom_navigation.dart';
import 'package:w3dating_app/template/sidebar.dart';
import 'package:w3dating_app/home/match_screen_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _tab = 0;

  final List<Map<String, dynamic>> _profiles = List.generate(
    6,
    (i) => {
      'name': i == 0 ? 'Richard' : 'Person ${i + 1}',
      'age': '${22 + i}',
      'location': '${2 + i} km',
      'image': 'https://picsum.photos/800/1000?random=${i + 100}',  // Stable high quality images
      'interests': i == 0 ? ['Photography', 'Travel', 'Coffee'] :
                  ['Climbing', 'Skincare', 'Dancing']
    },
  );

  void _onLike() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Liked')));
  }

  void _onDislike() {
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Disliked')));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final swipeAreaHeight = MediaQuery.of(context).size.height * 0.78;

    return Scaffold(
      backgroundColor: const Color(0xFF0F1224),
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

      bottomNavigationBar: AppBottomNavigation(currentIndex: _tab, onTap: (i) {
        setState(() => _tab = i);
        switch (i) {
          case 0:
            return;
          case 1:
            Navigator.pushReplacementNamed(context, '/explore');
            break;
              case 2:
                Navigator.pushReplacementNamed(context, '/wishlist');
                break;
          case 3:
            Navigator.pushReplacementNamed(context, '/chat_list');
            break;
          case 4:
            Navigator.pushReplacementNamed(context, '/profile');
            break;
        }
      }),
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
      _drag += d.delta;
      _rotation = (_drag.dx / 300).clamp(-0.3, 0.3);
    });
  }

  Future<void> _onPanEnd(DragEndDetails d) async {
    if (_drag.dx.abs() > 120) {
      final liked = _drag.dx > 0;
      // Set final position for animation
      setState(() {
        _drag = Offset(liked ? 500 : -500, 0);
        _rotation = (liked ? 0.3 : -0.3);
      });
      // Trigger callbacks
      if (liked) {
        widget.onLike?.call();
      } else {
        widget.onDislike?.call();
      }
      // Wait for visual feedback
      await Future.delayed(const Duration(milliseconds: 100));
      // Reset for next card
      if (mounted) setState(() {
        _topIndex = (_topIndex + 1) % widget.profiles.length;
        _drag = Offset.zero;
        _rotation = 0.0;
      });
    } else {
      // Spring back animation
      setState(() {
        _drag = Offset.zero;
        _rotation = 0.0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final visible = List.generate(3, (i) => (_topIndex + i) % widget.profiles.length).reversed.toList();
    final children = <Widget>[];
    for (final idx in visible) {
      final profile = widget.profiles[idx];
      final isTop = idx == _topIndex;
      final pos = visible.indexOf(idx);
      final scale = 1 - (pos * 0.03);
      final translateY = pos * 12.0;

      final card = Positioned.fill(
        child: Transform.translate(
          offset: isTop ? _drag : Offset(0, translateY),
          child: Transform.rotate(
            angle: isTop ? _rotation : 0.0,
            child: Align(
              alignment: Alignment.center,
              child: FractionallySizedBox(
                widthFactor: 1.0 * scale,
                heightFactor: 1.0,
                child: Card(
                  color: const Color(0xFF0D1220),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  clipBehavior: Clip.antiAlias,
                  child: Stack(
                    children: [
                      Positioned.fill(
                        child: Image.network(
                          profile['image'] as String,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              color: Colors.grey[900],
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            );
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey[900],
                              child: const Center(
                                child: Icon(Icons.error_outline, color: Colors.white54, size: 48),
                              ),
                            );
                          },
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
                            const SizedBox(height: 8),
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


