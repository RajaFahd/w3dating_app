import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/profile_provider.dart';

class YourGenderPage extends StatefulWidget {
	const YourGenderPage({super.key});

	@override
	State<YourGenderPage> createState() => _YourGenderPageState();
}

class _YourGenderPageState extends State<YourGenderPage> {
	final List<String> options = ['Women', 'Men', 'Other'];
	String? selected;

	@override
	Widget build(BuildContext context) {
		return Scaffold(
			backgroundColor: Theme.of(context).scaffoldBackgroundColor,
			body: SafeArea(
				child: Column(
					crossAxisAlignment: CrossAxisAlignment.start,
					children: [
						// Back button
						Padding(
							padding: const EdgeInsets.only(left: 8.0, top: 8.0),
							child: IconButton(
								icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
								onPressed: () => Navigator.pop(context),
							),
						),

						Expanded(
							child: Padding(
								padding: const EdgeInsets.symmetric(horizontal: 24.0),
								child: Column(
									crossAxisAlignment: CrossAxisAlignment.start,
									children: [
										const SizedBox(height: 32),
										const Text(
											"What's your gender ?",
											style: TextStyle(
												color: Colors.white,
												fontSize: 26,
												fontWeight: FontWeight.w600,
											),
										),
										const SizedBox(height: 32),

										// options
										...options.map((opt) => Padding(
													padding: const EdgeInsets.only(bottom: 16.0),
													child: InkWell(
														onTap: () => setState(() => selected = opt),
														child: Container(
															height: 56,
															decoration: BoxDecoration(
																borderRadius: BorderRadius.circular(12),
																border: Border.all(
																	color: selected == opt ? const Color(0xFFFF3F80) : Colors.white.withOpacity(0.18),
																	width: 1.6,
																),
															),
															child: Row(
																children: [
																	const SizedBox(width: 16),
																	Padding(
																		padding: const EdgeInsets.only(right: 12.0),
																		child: Container(
																			width: 24,
																			height: 24,
																			decoration: BoxDecoration(
																				shape: BoxShape.circle,
																				border: Border.all(
																					color: selected == opt ? const Color(0xFFFF3F80) : Colors.white.withOpacity(0.5),
																					width: 2,
																				),
																			),
																			child: selected == opt
																					? const Center(
																							child: Icon(
																								Icons.circle,
																								size: 12,
																								color: Color(0xFFFF3F80),
																							),
																						)
																					: null,
																		),
																	),
																	Expanded(
																		child: Text(
																			opt,
																			style: TextStyle(
																				color: selected == opt ? Colors.white : Colors.white.withOpacity(0.85),
																				fontSize: 16,
																			),
																		),
																	),
																],
															),
														),
													),
												)).toList(),
									],
								),
							),
						),

						// Next button
						Padding(
							padding: const EdgeInsets.all(24.0),
							child: SizedBox(
								width: double.infinity,
								height: 56,
								child: ElevatedButton(
									style: ElevatedButton.styleFrom(
										backgroundColor: const Color(0xFFFF3F80),
										shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
									),
									onPressed: () {
							if (selected != null) {
								Provider.of<ProfileProvider>(context, listen: false).setGender(selected!);
								Navigator.pushNamed(context, '/orientation');
							} else {
								ScaffoldMessenger.of(context).showSnackBar(
									const SnackBar(content: Text('Please select your gender')),
								);
							}
						},
									child: const Text(
										'Next',
										style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
									),
								),
							),
						),
					],
				),
			),
		);
	}
}

