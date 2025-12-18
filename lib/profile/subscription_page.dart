import 'package:flutter/material.dart';

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  int _currentPage = 0;
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
                  Text('My Subscription', style: TextStyle(color: Theme.of(context).colorScheme.onBackground, fontSize: 18, fontWeight: FontWeight.w600)),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // Gradient card with PageView
            SizedBox(
              height: 80,
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildSubscriptionCard('PLUS', const LinearGradient(colors: [Color(0xFFFF5A9A), Color(0xFFFF8A50)])),
                  _buildSubscriptionCard('GOLD', const LinearGradient(colors: [Color(0xFFFFB347), Color(0xFFFFCC33)])),
                  _buildSubscriptionCard('PLATINUM', const LinearGradient(colors: [Color(0xFF1A1A1A), Color(0xFF4A4A4A)])),
                ],
              ),
            ),

            const SizedBox(height: 14),
            // dots
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor.withOpacity(0.3),
                    shape: BoxShape.circle,
                  ),
                );
              }),
            ),

            const SizedBox(height: 18),

            // Features list - berubah sesuai paket
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: ListView(
                  children: _getFeaturesForCurrentPage(context),
                ),
              ),
            ),

            // Bottom CTA - harga berubah sesuai paket
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
                      gradient: _getGradientForCurrentPage(),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('Starting at  ', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w500)),
                          Text(_getPriceForCurrentPage(), style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.w700)),
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

  Widget _buildSubscriptionCard(String planName, LinearGradient gradient) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: gradient,
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.25), blurRadius: 12, offset: const Offset(0, 8))],
        ),
        child: Row(
          children: [
            const Expanded(
              child: Text('W3Dating App', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(12)),
              child: Text(planName, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _getFeaturesForCurrentPage(BuildContext context) {
    if (_currentPage == 0) {
      // PLUS
      return [
        _featureRow(context, 'Unlimited Likes', true),
        _featureRow(context, 'See Who Likes You', false, locked: true),
        _featureRow(context, 'Priority Likes', false, locked: true),
        _featureRow(context, 'Unlimited Rewinds', true),
        _featureRow(context, '1 Free Boost per month', false, locked: true),
        _featureRow(context, '5 Free Super Likes per week', false, locked: true),
        _featureRow(context, 'Message Before Matching', false, locked: true),
        _featureRow(context, 'Passport', true),
        _featureRow(context, 'Top Picks', false, locked: true),
        _featureRow(context, 'Control Your Profile', true),
        _featureRow(context, 'Control Who Sees You', true),
        _featureRow(context, 'Control Who You See', true),
        _featureRow(context, 'Hide Ads', true),
        const SizedBox(height: 24),
      ];
    } else if (_currentPage == 1) {
      // GOLD
      return [
        _featureRow(context, 'Unlimited Likes', true),
        _featureRow(context, 'See Who Likes You', true),
        _featureRow(context, 'Priority Likes', false, locked: true),
        _featureRow(context, 'Unlimited Rewinds', true),
        _featureRow(context, '1 Free Boost per month', true),
        _featureRow(context, '5 Free Super Likes per week', true),
        _featureRow(context, 'Message Before Matching', false, locked: true),
        _featureRow(context, 'Passport', true),
        _featureRow(context, 'Top Picks', true),
        _featureRow(context, 'Control Your Profile', true),
        _featureRow(context, 'Control Who Sees You', true),
        _featureRow(context, 'Control Who You See', true),
        _featureRow(context, 'Hide Ads', true),
        const SizedBox(height: 24),
      ];
    } else {
      // PLATINUM
      return [
        _featureRow(context, 'Unlimited Likes', true),
        _featureRow(context, 'See Who Likes You', true),
        _featureRow(context, 'Priority Likes', true),
        _featureRow(context, 'Unlimited Rewinds', true),
        _featureRow(context, '1 Free Boost per month', true),
        _featureRow(context, '5 Free Super Likes per week', true),
        _featureRow(context, 'Message Before Matching', true),
        _featureRow(context, 'Passport', true),
        _featureRow(context, 'Top Picks', true),
        _featureRow(context, 'Control Your Profile', true),
        _featureRow(context, 'Control Who Sees You', true),
        _featureRow(context, 'Control Who You See', true),
        _featureRow(context, 'Hide Ads', true),
        const SizedBox(height: 24),
      ];
    }
  }

  LinearGradient _getGradientForCurrentPage() {
    if (_currentPage == 0) {
      return const LinearGradient(colors: [Color(0xFFFF3F80), Color(0xFFFF8AB8)]);
    } else if (_currentPage == 1) {
      return const LinearGradient(colors: [Color(0xFFFFB347), Color(0xFFFFCC33)]);
    } else {
      return const LinearGradient(colors: [Color(0xFF1A1A1A), Color(0xFF4A4A4A)]);
    }
  }

  String _getPriceForCurrentPage() {
    if (_currentPage == 0) {
      return '₹450';
    } else if (_currentPage == 1) {
      return '₹650';
    } else {
      return '₹999';
    }
  }

  Widget _featureRow(BuildContext context, String title, bool enabled, {bool locked = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(locked ? Icons.lock_outline : Icons.check, color: locked ? Theme.of(context).colorScheme.onSurface.withOpacity(0.3) : Theme.of(context).colorScheme.primary, size: 20),
          const SizedBox(width: 12),
          Text(title, style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(locked ? 0.5 : 1.0), fontSize: 16)),
        ],
      ),
    );
  }
}
