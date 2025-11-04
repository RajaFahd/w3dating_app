import 'package:flutter/material.dart';
import 'package:w3dating_app/template/bottom_navigation.dart';
import 'package:w3dating_app/template/super_likes.dart';
import 'package:w3dating_app/profile/setting_page.dart';

class ProfileScreen extends StatefulWidget {
	const ProfileScreen({Key? key}) : super(key: key);

	@override
	State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
	int _tab = 4;
	final double _completion = 0.4; // 40%

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		return Scaffold(
			backgroundColor: const Color(0xFF2B2C33),
			appBar: AppBar(
				backgroundColor: Colors.transparent,
				elevation: 0,
				leading: Padding(
					padding: const EdgeInsets.only(left: 24),
					child: IconButton(
						icon: const Icon(Icons.arrow_back_ios, size: 22),
						onPressed: () => Navigator.pop(context),
					),
				),
				title: const Text(
					'Profile',
					style: TextStyle(
						fontSize: 24,
						fontWeight: FontWeight.bold,
					),
				),
				actions: [
					Padding(
						padding: const EdgeInsets.only(right: 20),
						child: InkWell(
							borderRadius: BorderRadius.circular(12),
							onTap: () => Navigator.pushNamed(context, '/profile/filter'),
							child: Container(
								width: 44,
								height: 44,
								decoration: BoxDecoration(
									border: Border.all(
										color: Colors.white24,
										width: 1,
									),
									borderRadius: BorderRadius.circular(8),
								),
								child: const Icon(
									Icons.filter_list,
									size: 24,
									color: Colors.white,
								),
							),
						),
					),
				],
			),
			body: Column(
				children: [
					// 🔥 Header area: Settings - Avatar - Edit sejajar horizontal + avatar diperbesar
					Container(
						width: double.infinity,
						padding: const EdgeInsets.symmetric(vertical: 26, horizontal: 20),
						color: const Color(0xFF2B2C33),
						child: Column(
							children: [
								Row(
									mainAxisAlignment: MainAxisAlignment.spaceBetween,
									crossAxisAlignment: CrossAxisAlignment.center,
									children: [
										// Settings button
										IconButton(
											onPressed: () => Navigator.push(
												context,
												MaterialPageRoute(builder: (context) => const SettingPage()),
											),
											icon: CircleAvatar(
												radius: 28,
												backgroundColor: Colors.purple.shade800.withOpacity(0.3),
												child: const Icon(Icons.settings, color: Colors.white),
											),
										),

										// Avatar with circular progress
										Stack(
											alignment: Alignment.center,
											children: [
												SizedBox(
													width: 170,
													height: 170,
													child: CustomPaint(
														painter: _ProgressRingPainter(progress: _completion),
														child: Container(),
													),
												),
												CircleAvatar(
													radius: 75,
													backgroundImage: NetworkImage('https://i.pravatar.cc/200?img=47'),
												),
											],
										),

										// Edit button
										IconButton(
											onPressed: () => Navigator.pushNamed(context, '/profile/edit'),
											icon: CircleAvatar(
												radius: 28,
												backgroundColor: Colors.purple.shade800.withOpacity(0.3),
												child: const Icon(Icons.edit, color: Colors.white),
											),
										),
									],
								),
								Container(
									padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
									decoration: BoxDecoration(
										color: Colors.pink.shade400,
										borderRadius: BorderRadius.circular(20),
									),
									child: const Text(
										'40%',
										style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
									),
								),

								const SizedBox(height: 14),
								const Text('Richard, 20', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
								const SizedBox(height: 6),
								Row(
									mainAxisSize: MainAxisSize.min,
									children: const [
										Icon(Icons.location_on, size: 16),
										SizedBox(width: 6),
										Text('Mentreal, Canada'),
									],
								),
							],
						),
					),



					// Cards row
					Padding(
						padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
						child: Row(
							mainAxisAlignment: MainAxisAlignment.spaceBetween,
							children: [
																_FeatureCard(
																	title: '0 Super Likes',
																	icon: Icons.star_border,
																	onTap: () {
																		showModalBottomSheet(
																			context: context,
																			backgroundColor: Colors.transparent,
																			isScrollControlled: true,
																			builder: (_) => const SuperLikesSheet(),
																		);
																	},
																),
								_FeatureCard(title: 'My Boosts', icon: Icons.rocket_launch, onTap: () {}),
								_FeatureCard(title: 'Subscriptions', icon: Icons.notifications_none, onTap: () => Navigator.pushNamed(context, '/profile/subscription')),
							],
						),
					),

					// Get Dating Plus section
					Expanded(
						child: Container(
							width: double.infinity,
							color: const Color(0xFF071236),
							padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.center,
								children: [
									const SizedBox(height: 8),
									const Text('Get Dating Plus', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
									const SizedBox(height: 8),
									const Text('Get Unlimited Likes, Passport and more!', textAlign: TextAlign.center, style: TextStyle(color: Colors.white70)),
									const SizedBox(height: 16),
									ElevatedButton(
										style: ElevatedButton.styleFrom(backgroundColor: theme.primaryColor, padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28))),
										onPressed: () => Navigator.pushNamed(context, '/profile/subscription'),
										child: const Text('Get Dating Plus'),
									),
									const SizedBox(height: 18),
									// dots indicator
									Row(mainAxisAlignment: MainAxisAlignment.center, children: [
										Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.pink.shade300, shape: BoxShape.circle)),
										const SizedBox(width: 8),
										Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle)),
										const SizedBox(width: 8),
										Container(width: 8, height: 8, decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle)),
									])
								],
							),
						),
					)
				],
			),
			bottomNavigationBar: AppBottomNavigation(currentIndex: _tab, onTap: (i) {
				if (i == 0) Navigator.pushReplacementNamed(context, '/home');
				if (i == 1) Navigator.pushReplacementNamed(context, '/explore');
				if (i == 2) Navigator.pushReplacementNamed(context, '/wishlist');
				if (i == 3) Navigator.pushReplacementNamed(context, '/chat_list');
			}),
		);
	}
}

class _FeatureCard extends StatelessWidget {
	final String title;
	final IconData icon;
	final VoidCallback onTap;

	const _FeatureCard({Key? key, required this.title, required this.icon, required this.onTap}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Expanded(
			child: Padding(
				padding: const EdgeInsets.symmetric(horizontal: 6),
				child: GestureDetector(
					onTap: onTap,
					child: Container(
						height: 92,
						decoration: BoxDecoration(color: const Color(0xFF222433), borderRadius: BorderRadius.circular(12)),
						child: Stack(
							children: [
								Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(icon, color: Colors.white70, size: 28), const SizedBox(height: 8), Text(title, style: const TextStyle(color: Colors.white70))],)),
								Positioned(
									bottom: 6,
									right: 6,
									child: CircleAvatar(radius: 12, backgroundColor: Colors.grey.shade800, child: const Icon(Icons.add, size: 16, color: Colors.white70)),
								)
							],
						),
					),
				),
			),
		);
	}
}

class _ProgressRingPainter extends CustomPainter {
	final double progress;
	_ProgressRingPainter({required this.progress});

	@override
	void paint(Canvas canvas, Size size) {
		final center = Offset(size.width / 2, size.height / 2);
		final radius = (size.width / 2) - 6;
		final bgPaint = Paint()..color = Colors.white12..style = PaintingStyle.stroke..strokeWidth = 8;
		final progPaint = Paint()
			..shader = const LinearGradient(colors: [Color(0xFFFF80B0), Color(0xFFFF4DA8)]).createShader(Rect.fromCircle(center: center, radius: radius))
			..style = PaintingStyle.stroke
			..strokeWidth = 8
			..strokeCap = StrokeCap.round;

		canvas.drawCircle(center, radius, bgPaint);
		final sweep = 2 * 3.1415926535 * progress;
		canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -3.1415926535 / 2, sweep, false, progPaint);
	}

	@override
	bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

