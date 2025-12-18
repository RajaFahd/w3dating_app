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
	final double _completion = 0.4; // 40%
	int _currentPage = 0;
	final PageController _pageController = PageController();

	@override
	Widget build(BuildContext context) {
		final theme = Theme.of(context);
		return Scaffold(
			backgroundColor: Theme.of(context).scaffoldBackgroundColor,
			appBar: AppBar(
				backgroundColor: Colors.transparent,
				elevation: 0,
				leading: Padding(
					padding: const EdgeInsets.only(left: 24),
					child: IconButton(
						icon: const Icon(Icons.arrow_back_ios, size: 22),
						onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
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
						padding: EdgeInsets.symmetric(
							vertical: MediaQuery.of(context).size.height < 800 ? 16 : 26, 
							horizontal: MediaQuery.of(context).size.width < 400 ? 16 : 34
						),
						color: Theme.of(context).scaffoldBackgroundColor,
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
												radius: MediaQuery.of(context).size.width < 400 ? 22 : 28,
												backgroundColor: Colors.purple.shade800.withOpacity(0.3),
												child: Icon(Icons.settings, color: Colors.white, size: MediaQuery.of(context).size.width < 400 ? 18 : 24),
											),
										),

										// Avatar dengan efek pink dan progress
                    Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Efek pink transparan memudar ke luar
                        Container(
                          width: MediaQuery.of(context).size.width < 400 ? 150 : 190,
                          height: MediaQuery.of(context).size.width < 400 ? 150 : 190,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                        ),

                        // Cincin progress di luar avatar
                        SizedBox(
                          width: MediaQuery.of(context).size.width < 400 ? 135 : 170,
                          height: MediaQuery.of(context).size.width < 400 ? 135 : 170,
                          child: CustomPaint(
                            painter: _ProgressRingPainter(progress: _completion),
                          ),
                        ),

                        // Avatar utama
                        CircleAvatar(
                          radius: MediaQuery.of(context).size.width < 400 ? 60 : 75,
                          backgroundImage: NetworkImage('https://i.pravatar.cc/200?img=47'),
                        ),

                        // Persentase "40%" di bawah avatar menempel
                        Positioned(
                          bottom: -12, // agar menempel ke bawah lingkaran
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.pink.shade400,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: const Color.fromARGB(255, 74, 74, 74),
                                width: 4, // border tipis
                              ),
                            ),
                            child: Text(
                              '40%',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
										// Edit button
										IconButton(
											onPressed: () => Navigator.pushNamed(context, '/profile/edit'),
											icon: CircleAvatar(
												radius: MediaQuery.of(context).size.width < 400 ? 22 : 28,
												backgroundColor: Colors.purple.shade800.withOpacity(0.3),
												child: Icon(Icons.edit, color: Colors.white, size: MediaQuery.of(context).size.width < 400 ? 18 : 24),
											),
										),
									],
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
						padding: EdgeInsets.symmetric(
							horizontal: MediaQuery.of(context).size.width < 400 ? 8 : 12, 
							vertical: 14
						),
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

					// Get Dating Plus section with PageView
					Expanded(
						child: Container(
							width: double.infinity,
							color: const Color(0xFF1B1C23),
							padding: const EdgeInsets.symmetric(vertical: 24),
							child: Column(
								crossAxisAlignment: CrossAxisAlignment.center,
								children: [
									Expanded(
										child: PageView(
											controller: _pageController,
											onPageChanged: (index) {
												setState(() {
													_currentPage = index;
												});
											},
											children: [
												_buildSubscriptionPage(
													title: 'Get Dating Plus',
													buttonText: 'Get Dating Plus',
													buttonColor: theme.primaryColor,
													context: context,
												),
												_buildSubscriptionPage(
													title: 'Get Dating Gold',
													buttonText: 'Get Dating Gold',
													buttonColor: theme.primaryColor,
													context: context,
												),
												_buildSubscriptionPage(
													title: 'Get Dating Platinum',
													buttonText: 'Get Dating Platinum',
													buttonColor: theme.primaryColor,
													context: context,
												),
											],
										),
									),
									const SizedBox(height: 18),
									// dots indicator
									Row(
										mainAxisAlignment: MainAxisAlignment.center,
										children: List.generate(3, (index) {
											return Container(
												margin: const EdgeInsets.symmetric(horizontal: 4),
												width: 8,
												height: 8,
												decoration: BoxDecoration(
													color: _currentPage == index ? Colors.pink.shade300 : Colors.white24,
													shape: BoxShape.circle,
												),
											);
										}),
									),
								],
							),
						),
					)
				],
			),
			bottomNavigationBar: AppBottomNavigation(currentIndex: 4),
		);
	}

	Widget _buildSubscriptionPage({
		required String title,
		required String buttonText,
		required Color buttonColor,
		required BuildContext context,
	}) {
		return Padding(
			padding: const EdgeInsets.symmetric(horizontal: 24),
			child: Column(
				mainAxisAlignment: MainAxisAlignment.center,
				children: [
					Text(
						title,
						style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
					),
					const SizedBox(height: 12),
					const Text(
						'Get Unlimited Likes, Passport and more!',
						textAlign: TextAlign.center,
						style: TextStyle(color: Colors.white70),
					),
					const SizedBox(height: 20),
					ElevatedButton(
						style: ElevatedButton.styleFrom(
							backgroundColor: buttonColor,
							padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
							shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
						),
						onPressed: () => Navigator.pushNamed(context, '/profile/subscription'),
						child: Text(buttonText),
					),
				],
			),
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
		final bgPaint = Paint()..color = const Color.fromARGB(65, 255, 0, 153)..style = PaintingStyle.stroke..strokeWidth = 8;
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

