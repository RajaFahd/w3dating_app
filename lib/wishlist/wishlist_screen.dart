import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:w3dating_app/template/bottom_navigation.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class WishlistScreen extends StatefulWidget {
	const WishlistScreen({Key? key}) : super(key: key);

	@override
	State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
	final ApiService _apiService = ApiService();
	List<Map<String, dynamic>> _likedProfiles = [];
	bool _isLoading = true;
	String? _error;

	@override
	void initState() {
		super.initState();
		_loadLikedProfiles();
	}

	Future<void> _loadLikedProfiles() async {
		setState(() {
			_isLoading = true;
			_error = null;
		});

		try {
			// Get profiles that current user has liked
			final response = await _apiService.get('/swipes/my-likes');
			
			if (response['success'] == true) {
				final List<dynamic> data = response['data'] ?? [];
				
				setState(() {
					_likedProfiles = data.map((item) {
						final profile = item['profile'] ?? {};
						final photos = (item['photos'] as List?) ?? [];
						
						// Calculate age
						int age = 0;
						if (profile['birth_date'] != null) {
							try {
								final birthDate = DateTime.parse(profile['birth_date']);
								age = DateTime.now().year - birthDate.year;
							} catch (_) {}
						}
						
						// Get photo URL
						String? photoUrl;
						if (photos.isNotEmpty) {
							photoUrl = photos[0]['photo_url'];
							if (photoUrl != null && !photoUrl.startsWith('http')) {
								final baseUrl = ApiConfig.baseUrl.replaceAll('/api', '');
								photoUrl = '$baseUrl$photoUrl';
							}
						}
						
												return {
							'user_id': item['id'],
							'name': profile['first_name'] ?? 'Unknown',
							'age': age,
																	'interest': (profile['interest'] as List?)?.map((e) => e.toString()).toList() ?? [],
													'bio': profile['bio'] ?? '',
													'language': profile['language'] ?? '',
							'city': profile['city'] ?? 'Unknown',
							'image': photoUrl ?? '',
						};
					}).toList();
					_isLoading = false;
				});
			}
		} catch (e) {
			setState(() {
				_error = e.toString().replaceAll('Exception: ', '');
				_isLoading = false;
			});
		}
	}

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Theme.of(context).scaffoldBackgroundColor,
			appBar: AppBar(
				backgroundColor: Colors.transparent,
				elevation: 0,
				leading: IconButton(icon: const Icon(Icons.arrow_back_ios), onPressed: () => Navigator.pushReplacementNamed(context, '/home')),
				centerTitle: false,
				title: const Text('People You Liked', style: TextStyle(fontWeight: FontWeight.bold)),
				actions: [IconButton(onPressed: _loadLikedProfiles, icon: const Icon(Icons.refresh))],
			),
			body: _isLoading
				? const Center(child: CircularProgressIndicator(color: Color(0xFFFF3F80)))
				: _error != null
					? Center(
							child: Column(
								mainAxisAlignment: MainAxisAlignment.center,
								children: [
									const Icon(Icons.error_outline, color: Colors.white54, size: 64),
									const SizedBox(height: 16),
									Text(_error!, style: const TextStyle(color: Colors.white70)),
									const SizedBox(height: 16),
									ElevatedButton(
										onPressed: _loadLikedProfiles,
										style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFFF3F80)),
										child: const Text('Retry'),
									),
								],
							),
						)
					: _likedProfiles.isEmpty
						? const Center(
								child: Column(
									mainAxisAlignment: MainAxisAlignment.center,
									children: [
										Icon(Icons.favorite_border, color: Colors.white54, size: 64),
										SizedBox(height: 16),
										Text('No liked profiles yet', style: TextStyle(color: Colors.white70, fontSize: 18)),
										SizedBox(height: 8),
										Text('Start swiping to find your matches!', style: TextStyle(color: Colors.white54)),
									],
								),
							)
						: GridView.builder(
								padding: const EdgeInsets.all(12),
								gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
									crossAxisCount: 2,
									childAspectRatio: 0.78,
									crossAxisSpacing: 12,
									mainAxisSpacing: 12,
								),
								itemCount: _likedProfiles.length,
								itemBuilder: (ctx, idx) {
									final p = _likedProfiles[idx];
									return Material(
										elevation: 3,
										color: Colors.transparent,
										shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
										clipBehavior: Clip.antiAlias,
										child: InkWell(
														onTap: () async {
														  final removed = await Navigator.pushNamed(context, '/wishlist_profile', arguments: p);
														  if (removed == true) {
														    // Reload list from backend to reflect removal
														    _loadLikedProfiles();
														  }
														},
											child: Stack(
												fit: StackFit.expand,
												children: [
													p['image'].toString().isEmpty
														? Container(
															color: const Color(0xFF0E1222),
															child: const Center(
																child: Icon(Icons.person_outline, color: Colors.white54, size: 48),
															),
														)
														: CachedNetworkImage(
															imageUrl: p['image'].toString(),
															fit: BoxFit.cover,
															placeholder: (c, url) => Container(
																color: const Color(0xFF0E1222),
																child: const Center(
																	child: CircularProgressIndicator(color: Color(0xFFFF3F80)),
																),
															),
															errorWidget: (c, url, e) => Container(
																color: const Color(0xFF0E1222),
																child: const Center(
																	child: Icon(Icons.broken_image, color: Colors.white54),
																),
															),
														),
													Container(
														decoration: BoxDecoration(
															gradient: LinearGradient(
																colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
																begin: Alignment.topCenter,
																end: Alignment.bottomCenter,
															),
														),
													),
													Padding(
														padding: const EdgeInsets.all(12.0),
														child: Column(
															mainAxisAlignment: MainAxisAlignment.end,
															crossAxisAlignment: CrossAxisAlignment.start,
															children: [
																Text(
																	'${p['name']}, ${p['age']}',
																	style: const TextStyle(
																		color: Colors.white,
																		fontWeight: FontWeight.bold,
																		fontSize: 18,
																	),
																),
																const SizedBox(height: 4),
																																// Show interest(s) if available
																																Builder(builder: (context) {
																																	final interests = (p['interest'] as List?)?.map((e) => e.toString()).toList() ?? [];
																																	if (interests.isEmpty) return const SizedBox.shrink();
																																	return Text(
																																		interests.join(', '),
																																		style: const TextStyle(
																																			color: Colors.white70,
																																			fontSize: 13,
																																		),
																																		maxLines: 1,
																																		overflow: TextOverflow.ellipsis,
																																	);
																																}),
																if (p['city'].toString().isNotEmpty)
																	Row(
																		children: [
																			const Icon(Icons.location_on, color: Colors.white54, size: 14),
																			const SizedBox(width: 4),
																			Text(
																				p['city'].toString(),
																				style: const TextStyle(color: Colors.white54, fontSize: 12),
																			),
																		],
																	),
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