import 'package:flutter/material.dart';
import 'package:w3dating_app/template/bottom_navigation.dart';

class ExploreScreen extends StatefulWidget {
	const ExploreScreen({Key? key}) : super(key: key);

	@override
	State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
	final List<Map<String, String>> _cards = [
		{
			'image': 'https://images.pexels.com/photos/1190295/pexels-photo-1190295.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
			'title': 'Free Tonight',
			'subtitle': 'Down for something spontaneous',
			'cta': 'JOIN NOW'
		},
		{
			'image': 'https://images.pexels.com/photos/326875/pexels-photo-326875.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=750&w=1260',
			'title': 'City Vibes',
			'subtitle': 'Explore local crowds and meetups',
			'cta': 'EXPLORE'
		},
	];

	@override
	Widget build(BuildContext context) {
		final bg = const Color(0xFF1B1C23);

		return Scaffold(
			backgroundColor: bg,
			appBar: AppBar(
				backgroundColor: Colors.transparent,
				elevation: 0,
				leading: IconButton(
					icon: const Icon(Icons.arrow_back_ios),
					onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
				),
				centerTitle: true,
				title: const Text('Explore', style: TextStyle(fontWeight: FontWeight.w600)),
			),
			body: SafeArea(
				child: ListView.builder(
					padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
					itemCount: _cards.length,
					itemBuilder: (context, index) {
						final item = _cards[index];
						return Padding(
							padding: const EdgeInsets.only(bottom: 20.0),
							child: _ExploreCard(
								imageUrl: item['image']!,
								title: item['title']!,
								subtitle: item['subtitle']!,
								cta: item['cta']!,
							),
						);
				},
			),
		),
		bottomNavigationBar: AppBottomNavigation(currentIndex: 1),
		);
	}
}class _ExploreCard extends StatelessWidget {
	final String imageUrl;
	final String title;
	final String subtitle;
	final String cta;

	const _ExploreCard({Key? key, required this.imageUrl, required this.title, required this.subtitle, required this.cta}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return AspectRatio(
			aspectRatio: 16 / 11,
			child: ClipRRect(
				borderRadius: BorderRadius.circular(16),
				child: Stack(
					fit: StackFit.expand,
					children: [
						Image.network(
							imageUrl,
							fit: BoxFit.cover,
							loadingBuilder: (context, child, progress) {
								if (progress == null) return child;
								return Container(color: Colors.grey[900], child: const Center(child: CircularProgressIndicator()));
							},
							errorBuilder: (context, err, st) => Container(color: Colors.grey[900], child: const Center(child: Icon(Icons.broken_image, color: Colors.white54))),
						),
						Container(
							decoration: BoxDecoration(
								gradient: LinearGradient(
									begin: Alignment.topCenter,
									end: Alignment.bottomCenter,
									colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
								),
							),
						),
						Padding(
							padding: const EdgeInsets.all(20.0),
							child: Column(
								mainAxisAlignment: MainAxisAlignment.end,
								crossAxisAlignment: CrossAxisAlignment.start,
								children: [
									Text(title, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w700)),
									const SizedBox(height: 6),
									Text(subtitle, style: const TextStyle(color: Colors.white70, fontSize: 14)),
									const SizedBox(height: 12),
														SizedBox(
															width: 140,
															height: 44,
															child: ElevatedButton(
																style: ElevatedButton.styleFrom(
																	backgroundColor: Colors.white,
																	foregroundColor: Colors.black,
																	shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
																	elevation: 6,
																	padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
																),
																onPressed: () {},
																child: Text(cta, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, letterSpacing: 0.6)),
															),
														)
								],
							),
						),
					],
				),
			),
		);
	}
}

