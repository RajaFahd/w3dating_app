import 'package:flutter/material.dart';
import 'package:w3dating_app/template/bottom_navigation.dart';

class MessageItem {
  final String name;
  final String message;
  final String time;
  final String avatarUrl;
  final bool isRead;
  final bool isOnline;

  const MessageItem({
    required this.name,
    required this.message,
    required this.time,
    required this.avatarUrl,
    this.isRead = false,
    this.isOnline = false,
  });
}

final List<MessageItem> messages = [
  MessageItem(
    name: 'Davina Karamoy',
    message: 'Halo, boleh kenalan ga?',
    time: '2m ago',
    avatarUrl: 'assets/images/profiles/davina_kotak.jpg',
    isRead: true,
    isOnline: true,
  ),
  MessageItem(
    name: 'Matt',
    message: 'Is that because we like the...',
    time: '4m ago',
    avatarUrl: 'https://i.pravatar.cc/150?img=12',
  ),
  MessageItem(
    name: 'Karthik',
    message: 'How do you know john?',
    time: '8h ago',
    avatarUrl: 'https://i.pravatar.cc/150?img=6',
    isRead: true,
    isOnline: true,
  ),
  MessageItem(
    name: 'Elisha',
    message: 'Have you even been...',
    time: '1d ago',
    avatarUrl: 'https://i.pravatar.cc/150?img=15',
    isOnline: true,
  ),
  MessageItem(
    name: 'Wyatt',
    message: "that so awesome!",
    time: '3h ago',
    avatarUrl: 'https://i.pravatar.cc/150?img=20',
  ),
  MessageItem(
    name: 'Grayson',
    message: 'Would love to!',
    time: '5d ago',
    avatarUrl: 'https://i.pravatar.cc/150?img=8',
  )
];

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  // Helper method untuk mendapatkan image provider yang tepat
  ImageProvider _getAvatarImage(String avatarUrl) {
    if (avatarUrl.startsWith('assets/')) {
      return AssetImage(avatarUrl);
    } else {
      return NetworkImage(avatarUrl);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF1A1A1F),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'New Matches',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
      ),
      body: Column(
        children: [
          // Horizontal scrolling matches at top
          // Horizontal scrolling matches at top
          Container(
            height: 120, // diperbesar agar muat nama
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];

                return Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: GestureDetector(
                    onTap: () => Navigator.pushNamed(context, '/chat_screen', arguments: msg),
                    child: Column(
                      children: [
                        Stack(
                        children: [
                          CircleAvatar(
                            radius: 30,
                            backgroundImage: _getAvatarImage(msg.avatarUrl),
                          ),
                          if (msg.isOnline)
                            Positioned(
                              left: 0,
                              bottom: 0,
                              child: Container(
                                width: 18,
                                height: 18,
                                decoration: BoxDecoration(
                                  color: Colors.green,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: Theme.of(context).scaffoldBackgroundColor,
                                    width: 3,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      SizedBox(
                        width: 65, // biar nama tidak melebar
                        child: Text(
                          msg.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                  ),
                );
              },
            ),
          ),
          Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding: const EdgeInsets.only(left: 16, bottom: 12),
              child: Text(
                'Message',
                style: const TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          // Message list
          Expanded(
            child: ListView.separated(
              itemCount: messages.length,
              separatorBuilder: (_, __) => const Divider(height: 1, indent: 76, color: Color(0xFF2E2E34)),
              itemBuilder: (context, index) {
                final msg = messages[index];
                return ListTile(
                  onTap: () => Navigator.pushNamed(context, '/chat_screen', arguments: msg),
                  leading: Stack(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundImage: _getAvatarImage(msg.avatarUrl),
                      ),
                      if (msg.isOnline)
                        Positioned(
                          left: 0,
                          bottom: 0,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: Colors.green,
                              shape: BoxShape.circle,
                              border: Border.all(color: theme.scaffoldBackgroundColor, width: 4),
                            ),
                          ),
                        ),
                    ],
                  ),
                  title: Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      msg.name,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                  ),
                  subtitle: Text(
                    msg.message,
                    style: TextStyle(
                      color: msg.isRead ? Colors.grey : Colors.white,
                      fontSize: 14,
                    ),
                  ),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        msg.time,
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 5),
                      Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: msg.isRead 
                              ? const Color(0xFFFF4081).withOpacity(0.15)
                              : Colors.white.withOpacity(0.15),
                          border: Border.all(
                            color: msg.isRead 
                                ? const Color(0xFFFF4081).withOpacity(0.5)
                                : Colors.white.withOpacity(0.5),
                            width: 1,
                          ),
                        ),
                        child: Center(
                          child: Icon(
                            Icons.check,
                            size: 14,
                            color: const Color(0xFFFF4081),
                          ),
                        ),
                      ),
                    ],
                  ),

                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(currentIndex: 3),
    );
  }
}