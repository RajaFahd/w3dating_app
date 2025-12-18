import 'package:flutter/material.dart';

class SuperLikesSheet extends StatefulWidget {
  const SuperLikesSheet({Key? key}) : super(key: key);

  @override
  State<SuperLikesSheet> createState() => _SuperLikesSheetState();
}

class _SuperLikesSheetState extends State<SuperLikesSheet> {
  int _selected = 1; // 0 -> left, 1 -> center, 2 -> right

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () => Navigator.of(context).pop(),
      child: DraggableScrollableSheet(
        initialChildSize: 0.56,
        minChildSize: 0.32,
        maxChildSize: 0.92,
        builder: (context, controller) => Container(
          padding: const EdgeInsets.only(top: 12, left: 16, right: 16, bottom: 20),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // handle
              Container(width: 56, height: 6, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(4))),
              const SizedBox(height: 18),

              // icon
              CircleAvatar(radius: 28, backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.15), child: Icon(Icons.star, color: Theme.of(context).colorScheme.primary, size: 32)),
              const SizedBox(height: 12),

              Text('Stant out with Super Like', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 6),
              Text("You're 3x more likely to get a match!", style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
              const SizedBox(height: 18),

              // options
              SizedBox(
                height: 120,
                child: Row(
                  children: List.generate(3, (i) {
                    final labels = ['3', '15', '20'];
                    final price = '296.60/ea';
                    final isSelected = _selected == i;
                    return Expanded(
                      child: Padding(
                        padding: EdgeInsets.only(left: i == 0 ? 0 : 10, right: i == 2 ? 0 : 0),
                        child: GestureDetector(
                          onTap: () => setState(() => _selected = i),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.surface,
                              borderRadius: BorderRadius.circular(8),
                              border: isSelected ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : Border.all(color: Theme.of(context).dividerColor.withOpacity(0.2)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(labels[i], style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 28, fontWeight: FontWeight.bold)),
                                const SizedBox(height: 6),
                                Text('Super Likes', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7))),
                                const SizedBox(height: 6),
                                Text(price, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6), fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 18),
              // CTA
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 6,
                    backgroundColor: Colors.transparent,
                  ),
                  onPressed: () {
                    // For UI-only app just close
                    Navigator.of(context).pop();
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Purchased Super Likes (UI-only)')));
                  },
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFF3F80), Color(0xFFFF8AB8)]),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: const Center(child: Text('GET SUPER LINKS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
