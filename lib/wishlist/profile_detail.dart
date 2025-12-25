import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../config/api_config.dart';
import '../services/api_service.dart';

class ProfileDetail extends StatelessWidget {
  const ProfileDetail({super.key});

  @override
  Widget build(BuildContext context) {
    final args = (ModalRoute.of(context)?.settings.arguments as Map?) ?? {};
    final image = (args['image'] as String?) ?? '';
    final name = (args['name'] ?? 'Unknown').toString();
    final age = (args['age'] ?? '').toString();
    final city = (args['city'] ?? '').toString();
    final bio = (args['bio'] ?? '').toString();
    final language = (args['language'] ?? '').toString();
    final interests = (args['interest'] as List?)?.map((e) => e.toString()).toList() ?? <String>[];

    String absolutePhotoUrl(String? photoUrl) {
      if (photoUrl == null || photoUrl.isEmpty) return '';
      if (photoUrl.startsWith('http')) return photoUrl;
      final baseUrl = ApiConfig.baseUrl.replaceAll('/api', '');
      return '$baseUrl$photoUrl';
    }
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pop(context)),
        title: const Text('Recommendation'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 92),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Image card
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Stack(
                      children: [
                        if (absolutePhotoUrl(image).isEmpty)
                          Container(
                            width: double.infinity,
                            height: 420,
                            color: const Color(0xFF0E1222),
                            child: const Center(
                              child: Icon(Icons.person_outline, color: Colors.white54, size: 64),
                            ),
                          )
                        else
                          CachedNetworkImage(
                            imageUrl: absolutePhotoUrl(image),
                            width: double.infinity,
                            height: 420,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: const Color(0xFF0E1222),
                              child: const Center(
                                child: CircularProgressIndicator(color: Color(0xFFFF3F80)),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: const Color(0xFF0E1222),
                              child: const Center(
                                child: Icon(Icons.broken_image, color: Colors.white54, size: 48),
                              ),
                            ),
                          ),
                        Container(
                          height: 420,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(colors: [Colors.transparent, Colors.black.withOpacity(0.6)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                          ),
                        ),
                        Positioned(
                          left: 18,
                          bottom: 18,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('$name, $age', style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                              const SizedBox(height: 6),
                              if (city.isNotEmpty)
                                Row(
                                  children: [
                                    const Icon(Icons.location_on, color: Colors.white70, size: 14),
                                    const SizedBox(width: 4),
                                    Text(city, style: const TextStyle(color: Colors.white70)),
                                  ],
                                ),
                            ],
                          ),
                        ),
                        // pink floating action on image
                        Positioned(
                          right: 18,
                          bottom: 18,
                          child: CircleAvatar(
                            radius: 22,
                            backgroundColor: const Color(0xFF4A2A4A),
                            child: Icon(Icons.star, color: Colors.pink.shade200),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Basic information', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      if (bio.isNotEmpty)
                        Text(bio, style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 16),

                      const Text('Interests', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          for (final interest in interests)
                            _chipLabel(Icons.local_fire_department, interest),
                          if (interests.isEmpty)
                            const Text('No interests listed', style: TextStyle(color: Colors.white54)),
                        ],
                      ),

                      const SizedBox(height: 18),
                      const Text('Languages', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      if (language.isNotEmpty)
                        Wrap(spacing: 8, children: [
                          _LangChip(language),
                        ])
                      else
                        const Text('No languages listed', style: TextStyle(color: Colors.white54)),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // bottom action row
          Positioned(
            left: 0,
            right: 0,
            bottom: 12,
            child: SizedBox(
              height: 72,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Dislike button
                  _actionCircle(
                    icon: Icons.close,
                    bg: Colors.grey.shade800,
                    onTap: () async {
                      final userId = args['user_id'] as int?;
                      if (userId != null) {
                        try {
                          // Call backend to remove like from wishlist
                          final api = ApiService();
                          await api.unlikeUser(userId);
                        } catch (_) {
                          // ignore error, still pop
                        }
                      }
                      Navigator.pop(context, true); // signal removal
                    },
                  ),
                  const SizedBox(width: 20),
                  // Message button -> navigate to chat screen
                  _actionCircle(
                    icon: Icons.message,
                    bg: Colors.pink.shade400,
                    onTap: () {
                      Navigator.pushNamed(
                        context,
                        '/chat_screen',
                        arguments: {
                          'user_id': args['user_id'],
                          'name': name,
                          'avatar': absolutePhotoUrl(image),
                          // is_online optional; omit if not available
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _chipLabel(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: const Color(0xFF222433), borderRadius: BorderRadius.circular(20)),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 14, color: Colors.white70), const SizedBox(width: 6), Text(label, style: const TextStyle(color: Colors.white70))],
      ),
    );
  }

  Widget _actionCircle({required IconData icon, required Color bg, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: CircleAvatar(radius: 28, backgroundColor: bg, child: Icon(icon, color: Colors.white, size: 28)),
    );
  }
}

class _LangChip extends StatelessWidget {
  final String label;
  const _LangChip(this.label);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFF222433), borderRadius: BorderRadius.circular(18)),
      child: Text(label, style: const TextStyle(color: Colors.white70)),
    );
  }
}


