import 'package:flutter/material.dart';

class SubscriptionPage extends StatelessWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2B2C33),
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(color: const Color(0xFF4A254A), shape: BoxShape.circle),
                      child: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text('My Subscription', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Gradient card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  gradient: const LinearGradient(colors: [Color(0xFFFF5A9A), Color(0xFFFF8A50)]),
                  boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 12, offset: Offset(0, 8))],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text('W3Dating App', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                          SizedBox(height: 6),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                      decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
                      child: const Text('PLUS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 14),
            // dots
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.pink.shade300, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle)),
              const SizedBox(width: 8),
              Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle)),
            ]),

            const SizedBox(height: 18),

            // Features list
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView(
                  children: [
                    _featureRow('Unlimited Likes', true),
                    _featureRow('See Who Likes You', false, locked: true),
                    _featureRow('Priority Likes', false, locked: true),
                    _featureRow('Unlimited Rewinds', true),
                    _featureRow('1 Free Boost per month', false, locked: true),
                    _featureRow('5 Free Super Likes per week', false, locked: true),
                    _featureRow('Message Before Matching', false, locked: true),
                    _featureRow('Passport', true),
                    _featureRow('Top Picks', false, locked: true),
                    _featureRow('Control Your Profile', true),
                    _featureRow('Control Who Sees You', true),
                    _featureRow('Control Who You See', true),
                    _featureRow('Hide Ads', true),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Bottom CTA
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: SizedBox(
                height: 56,
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    padding: EdgeInsets.zero,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                    elevation: 6,
                  ),
                  onPressed: () {},
                  child: Ink(
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(colors: [Color(0xFFFF3F80), Color(0xFFFF8AB8)]),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          Text('Starting at', style: TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w500)),
                          SizedBox(height: 6),
                          Text('\u20B9 450', style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w700)),
                        ],
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

  Widget _featureRow(String title, bool enabled, {bool locked = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(locked ? Icons.lock_outline : Icons.check, color: locked ? Colors.white24 : Colors.white, size: 20),
          const SizedBox(width: 12),
          Text(title, style: TextStyle(color: locked ? Colors.white24 : Colors.white, fontSize: 16)),
        ],
      ),
    );
  }
}
