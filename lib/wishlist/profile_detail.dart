import 'package:flutter/material.dart';

class ProfileDetail extends StatelessWidget {
  const ProfileDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final image = 'https://picsum.photos/600/900?random=42';
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
                        Image.network(
                          image,
                          width: double.infinity,
                          height: 420,
                          fit: BoxFit.cover,
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
                            children: const [
                              Text('Chelsea, 21', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                              SizedBox(height: 6),
                              Text('5 miles away', style: TextStyle(color: Colors.white70)),
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
                      const Text(
                        'Just moved back to jakarata after living at India for 10+ years. Di luar terliat cenger - center di dalam.',
                        style: TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 16),

                      const Text('Interests', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          _chipLabel(Icons.camera_alt, 'Photography'),
                          _chipLabel(Icons.music_note, 'Music'),
                          _chipLabel(Icons.school, 'Study'),
                          _chipLabel(Icons.movie, 'Movies'),
                          _chipLabel(Icons.camera, 'Instagram'),
                          _chipLabel(Icons.travel_explore, 'Travelling'),
                        ],
                      ),

                      const SizedBox(height: 18),
                      const Text('Languages', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Wrap(spacing: 8, children: const [
                        _LangChip('English'),
                        _LangChip('Spanish'),
                      ]),
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
                  _actionCircle(icon: Icons.close, bg: Colors.grey.shade800, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 20),
                  _actionCircle(icon: Icons.star, bg: Colors.blue.shade700, onTap: () => Navigator.pop(context)),
                  const SizedBox(width: 20),
                  _actionCircle(icon: Icons.favorite, bg: Colors.pink.shade400, onTap: () => Navigator.pop(context)),
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
  const _LangChip(this.label, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: const Color(0xFF222433), borderRadius: BorderRadius.circular(18)),
      child: Text(label, style: const TextStyle(color: Colors.white70)),
    );
  }
}


