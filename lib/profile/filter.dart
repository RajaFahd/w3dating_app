import 'package:flutter/material.dart';

class ProfileFilterPage extends StatefulWidget {
	const ProfileFilterPage({super.key});

	@override
	State<ProfileFilterPage> createState() => _ProfileFilterPageState();
}

class _ProfileFilterPageState extends State<ProfileFilterPage> {
	bool men = false;
	bool women = true;
	bool nonbinary = false;

	RangeValues ageRange = const RangeValues(18, 50);
	double distance = 18;

		@override
		Widget build(BuildContext context) {
			return Scaffold(
				backgroundColor: Theme.of(context).scaffoldBackgroundColor,
				body: SafeArea(
					child: Column(
						children: [
						// AppBar like header
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
									Text('Date Filter', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontSize: 18, fontWeight: FontWeight.w600)),
								],
							),
						),

									Expanded(
										child: SingleChildScrollView(
											padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
											child: Column(
												crossAxisAlignment: CrossAxisAlignment.stretch,
												children: [
										// Who you want to date
															_sectionContainer(
																child: Column(
																	crossAxisAlignment: CrossAxisAlignment.start,
																	children: [
																		Text('Who you want to date', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), fontSize: 13)),
																		const SizedBox(height: 12),
																		_checkboxRow('Men', men, (v) => setState(() => men = v)),
																		const SizedBox(height: 12),
																		_checkboxRow('Women', women, (v) => setState(() => women = v)),
																		const SizedBox(height: 12),
																		_checkboxRow('Nonbinary people', nonbinary, (v) => setState(() => nonbinary = v)),
																	],
																),
															),

										Padding(
											padding: const EdgeInsets.symmetric(horizontal: 16),
											child: Divider(color: Theme.of(context).dividerColor.withOpacity(0.2), height: 1),
										),
										const SizedBox(height: 16),

										// Age
															_sectionContainer(
																child: Column(
																	crossAxisAlignment: CrossAxisAlignment.start,
																	children: [
																		Text('Age', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), fontSize: 13)),
																		const SizedBox(height: 12),
																		Text('Between ${ageRange.start.toInt()} and ${ageRange.end.toInt()}', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w600)),
																		const SizedBox(height: 8),
																		SliderTheme(
																			data: SliderTheme.of(context).copyWith(
																				activeTrackColor: const Color(0xFFFF3F80),
																				inactiveTrackColor: Colors.white24,
																				trackHeight: 4,
																				thumbColor: const Color(0xFFFF3F80),
																				overlayColor: const Color(0x33FF3F80),
																				rangeThumbShape: const RoundRangeSliderThumbShape(enabledThumbRadius: 10),
																			),
																			child: RangeSlider(
																				values: ageRange,
																				min: 18,
																				max: 70,
																				divisions: 52,
																				labels: RangeLabels('${ageRange.start.toInt()}', '${ageRange.end.toInt()}'),
																				onChanged: (r) => setState(() => ageRange = r),
																			),
																		),
																	],
																),
															),

										Padding(
											padding: const EdgeInsets.symmetric(horizontal: 16),
											child: Divider(color: Theme.of(context).dividerColor.withOpacity(0.2), height: 1),
										),
										const SizedBox(height: 16),

										// Distance
															_sectionContainer(
																child: Column(
																	crossAxisAlignment: CrossAxisAlignment.start,
																	children: [
																		Text('Distance', style: TextStyle(color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7), fontSize: 13)),
																		const SizedBox(height: 12),
																		Text('Up to ${distance.toInt()} kilometers only', style: TextStyle(color: Theme.of(context).colorScheme.onSurface, fontWeight: FontWeight.w600)),
																		const SizedBox(height: 8),
																		SliderTheme(
																			data: SliderTheme.of(context).copyWith(
																				activeTrackColor: const Color(0xFFFF3F80),
																				inactiveTrackColor: Colors.white24,
																				trackHeight: 4,
																				thumbColor: const Color(0xFFFF3F80),
																				overlayColor: const Color(0x33FF3F80),
																			),
																			child: Slider(
																				value: distance,
																				min: 1,
																				max: 200,
																				divisions: 199,
																				onChanged: (v) => setState(() => distance = v),
																			),
																		),
																	],
																),
															),
										const SizedBox(height: 24),
									],
								),
							),
						),

						// Apply button
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
									onPressed: () {
										Navigator.pop(context);
									},
									child: Ink(
										decoration: BoxDecoration(
											gradient: const LinearGradient(colors: [Color(0xFFFF3F80), Color(0xFFFF8AB8)]),
											borderRadius: BorderRadius.circular(28),
										),
										child: const Center(
											child: Text('Apply', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600)),
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

	Widget _sectionContainer({required Widget child}) {
			return Container(
				padding: const EdgeInsets.all(14),
				decoration: BoxDecoration(
					color: Theme.of(context).colorScheme.surface,
					borderRadius: BorderRadius.circular(12),
				),
				child: child,
			);
	}

		Widget _checkboxRow(String title, bool value, ValueChanged<bool> onChanged) {
			return InkWell(
				onTap: () => onChanged(!value),
							child: Row(
					children: [
						Expanded(
										child: Text(title, style: TextStyle(color: value ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface.withOpacity(0.7), fontSize: 16)),
						),
						Container(
							width: 36,
							height: 36,
							decoration: BoxDecoration(
											color: value ? Theme.of(context).colorScheme.primary.withOpacity(0.15) : Colors.transparent,
								borderRadius: BorderRadius.circular(6),
											border: Border.all(color: value ? Theme.of(context).colorScheme.primary : Theme.of(context).dividerColor.withOpacity(0.2), width: 1.6),
							),
										child: value
												? Center(child: Icon(Icons.check, size: 18, color: Theme.of(context).colorScheme.primary))
												: null,
						),
					],
				),
			);
		}
}

