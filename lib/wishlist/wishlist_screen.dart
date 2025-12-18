import 'package:flutter/material.dart';
import 'package:w3dating_app/template/bottom_navigation.dart';

class WishlistScreen extends StatefulWidget {
	const WishlistScreen({Key? key}) : super(key: key);

	@override
	State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
	final List<Map<String, String>> _people = List.generate(
		8,
		(i) => {
			'name': i % 2 == 0 ? 'Chelsea' : 'Javelle',
			'sub': i % 3 == 0 ? 'Harward University' : 'Law student at stanford',
			'image': 'https://picsum.photos/400/600?random=${100 + i}',
		},
	);

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Theme.of(context).scaffoldBackgroundColor,
			appBar: AppBar(
				backgroundColor: Colors.transparent,
				elevation: 0,
				leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pushReplacementNamed(context, '/home')),
				centerTitle: false,
				title: const Text('Liked you', style: TextStyle(fontWeight: FontWeight.bold)),
				actions: [IconButton(onPressed: () => Navigator.pushNamed(context, '/profile/filter'), icon: const Icon(Icons.filter_list))],
			),
			body: GridView.builder(
				padding: const EdgeInsets.all(12),
				gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, childAspectRatio: 0.78, crossAxisSpacing: 12, mainAxisSpacing: 12),
				itemCount: _people.length,
				itemBuilder: (ctx, idx) {
					final p = _people[idx];
										return Material(
											elevation: 3,
											color: Colors.transparent,
											shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
											clipBehavior: Clip.antiAlias,
											child: InkWell(
												onTap: () => Navigator.pushNamed(context, '/wishlist_profile'),
												child: Stack(
													fit: StackFit.expand,
													children: [
														Image.network(
															p['image']!,
															fit: BoxFit.cover,
															loadingBuilder: (c, child, progress) {
																if (progress == null) return child;
																return Container(color: const Color(0xFF0E1222), child: const Center(child: CircularProgressIndicator()));
															},
															errorBuilder: (c, e, st) => Container(color: const Color(0xFF0E1222), child: const Center(child: Icon(Icons.broken_image, color: Colors.white54))),
														),
														Container(
															decoration: BoxDecoration(
																gradient: LinearGradient(colors: [Colors.transparent, Colors.black.withOpacity(0.6)], begin: Alignment.topCenter, end: Alignment.bottomCenter),
															),
														),
														Padding(
															padding: const EdgeInsets.all(12.0),
															child: Column(
																mainAxisAlignment: MainAxisAlignment.end,
																crossAxisAlignment: CrossAxisAlignment.start,
																children: [
																	Text(p['name']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
																	const SizedBox(height: 6),
																	Text(p['sub']!, style: const TextStyle(color: Colors.white70, fontSize: 13)),
																],
															),
														),
													],
												),
											),
										);
			},
		),
		bottomNavigationBar: AppBottomNavigation(currentIndex: 2),
		);
	}
}