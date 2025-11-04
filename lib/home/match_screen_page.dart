import 'package:flutter/material.dart';

class MatchScreenPage extends StatelessWidget {
	const MatchScreenPage({Key? key}) : super(key: key);

	@override
	Widget build(BuildContext context) {
		return Dialog(
			backgroundColor: Colors.transparent,
			child: Container(
				padding: const EdgeInsets.all(20),
				decoration: BoxDecoration(color: const Color(0xFF2E2E34), borderRadius: BorderRadius.circular(16)),
				child: Column(mainAxisSize: MainAxisSize.min, children: [
					const Text('It\'s a Match!', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
					const SizedBox(height: 12),
					const Text('You and Alex liked each other.'),
					const SizedBox(height: 14),
					ElevatedButton(onPressed: () => Navigator.pop(context), child: const Text('Continue'))
				]),
			),
		);
	}
}

