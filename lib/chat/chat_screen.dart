import 'package:flutter/material.dart';
import 'package:w3dating_app/chat/chat_list.dart';

class ChatScreen extends StatefulWidget {
	const ChatScreen({Key? key}) : super(key: key);

	@override
	State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
	final TextEditingController _ctl = TextEditingController();
	final List<Map<String, dynamic>> _messages = [
		{'fromMe': false, 'text': 'Hi Richard , thanks for adding me', 'time': '08:35'},
		{'fromMe': true, 'text': 'Hi Miselia , your welcome , nice to meet you too', 'time': '08:40'},
		{'fromMe': false, 'text': "I look you're singer, can you sing for me", 'time': '09:44'},
		{'fromMe': true, 'text': 'Sure', 'time': '09:30'},
		{'fromMe': false, 'text': 'Really!', 'time': '10:44'},
		{'fromMe': true, 'text': 'Why not', 'time': '10:44'},
	];

	@override
	Widget build(BuildContext context) {
		final arg = ModalRoute.of(context)?.settings.arguments;
		MessageItem? msg;
		if (arg is MessageItem) msg = arg;

		return Scaffold(
			backgroundColor: const Color(0xFF1B1C23),
			appBar: AppBar(
				backgroundColor: Colors.transparent,
				elevation: 0,
				leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
				title: Row(children: [
					CircleAvatar(radius: 20, backgroundImage: msg != null ? NetworkImage(msg.avatarUrl) : null, backgroundColor: Colors.grey[700]),
					const SizedBox(width: 12),
					Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
						Text(msg?.name ?? 'Name', style: const TextStyle(fontWeight: FontWeight.bold)),
						Text(msg != null ? 'Online 24m ago' : '', style: const TextStyle(fontSize: 12, color: Colors.white70)),
					])
				]),
				actions: [
					IconButton(onPressed: () {}, icon: const Icon(Icons.call)),
					IconButton(onPressed: () {}, icon: const Icon(Icons.videocam)),
				],
			),
			body: Column(children: [
				Expanded(
					child: ListView.builder(
						padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
						itemCount: _messages.length,
						itemBuilder: (context, i) {
							final m = _messages[i];
							final fromMe = m['fromMe'] as bool;
							return Align(
								alignment: fromMe ? Alignment.centerRight : Alignment.centerLeft,
								child: Padding(
									padding: const EdgeInsets.symmetric(vertical: 8),
									child: Column(
										crossAxisAlignment: fromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
										children: [
											Container(
												constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.72),
												padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
												decoration: BoxDecoration(
													color: fromMe ? Colors.pink.shade300 : const Color(0xFF2A2B30),
													borderRadius: BorderRadius.only(
														topLeft: const Radius.circular(14),
														topRight: const Radius.circular(14),
														bottomLeft: Radius.circular(fromMe ? 14 : 4),
														bottomRight: Radius.circular(fromMe ? 4 : 14),
													),
												),
												child: Text(m['text'], style: TextStyle(color: fromMe ? Colors.white : Colors.white70)),
											),
											const SizedBox(height: 6),
											Text(m['time'], style: const TextStyle(color: Colors.white60, fontSize: 12)),
										],
									),
								),
							);
						},
					),
				),
				SafeArea(
					child: Container(
						padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
						color: const Color(0xFF17171A),
						child: Row(children: [
							Expanded(
								child: Container(
									height: 48,
									padding: const EdgeInsets.symmetric(horizontal: 12),

									child: Row(children: [
										const Icon(Icons.insert_emoticon, color: Colors.white54),
										const SizedBox(width: 8),
										Expanded(child: TextField(controller: _ctl, style: const TextStyle(color: Colors.white), decoration: const InputDecoration.collapsed(hintText: 'Send message...', hintStyle: TextStyle(color: Colors.white54)))),
									]),
								),
							),
							const SizedBox(width: 8),
							Container(
								width: 44,
								height: 44,
								decoration: BoxDecoration(shape: BoxShape.circle, gradient: const LinearGradient(colors: [Color(0xFFFF80B0), Color(0xFFFF4DA8)])),
								child: IconButton(
									onPressed: () {
										if (_ctl.text.trim().isEmpty) return;
										setState(() {
											_messages.add({'fromMe': true, 'text': _ctl.text.trim(), 'time': 'Now'});
											_ctl.clear();
										});
									},
									icon: const Icon(Icons.send, color: Colors.white),
								),
							)
						]),
					),
				)
			]),
		);
	}
}

