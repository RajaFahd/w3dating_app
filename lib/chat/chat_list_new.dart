import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:w3dating_app/template/bottom_navigation.dart';
import '../services/api_service.dart';
import '../providers/chat_provider.dart';

class ChatListPageNew extends StatefulWidget {
  const ChatListPageNew({super.key});

  @override
  State<ChatListPageNew> createState() => _ChatListPageNewState();
}

class _ChatListPageNewState extends State<ChatListPageNew> {
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _loadMatches();
  }

  Future<void> _loadMatches() async {
    final chatProvider = Provider.of<ChatProvider>(context, listen: false);
    chatProvider.setLoading(true);

    try {
      final response = await _apiService.getChatList();
      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        final matches = data.map((m) => m as Map<String, dynamic>).toList();
        chatProvider.setMatches(matches);
      }
    } catch (e) {
      _showError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Messages',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.white, size: 28),
          onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
        ),
      ),
      body: Consumer<ChatProvider>(
        builder: (context, chatProvider, child) {
          if (chatProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: Color(0xFFFF3F80)),
            );
          }

          if (chatProvider.matches.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.chat_bubble_outline, color: Colors.white54, size: 64),
                  const SizedBox(height: 16),
                  const Text(
                    'No matches yet',
                    style: TextStyle(color: Colors.white70, fontSize: 18),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Start swiping to find matches!',
                    style: TextStyle(color: Colors.white54),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              // Horizontal match list
              Container(
                height: 120,
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: chatProvider.matches.length,
                  itemBuilder: (context, index) {
                    final match = chatProvider.matches[index];
                    return _buildMatchCard(match);
                  },
                ),
              ),

              const Divider(color: Colors.white24),

              // Message list
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  itemCount: chatProvider.matches.length,
                  itemBuilder: (context, index) {
                    final match = chatProvider.matches[index];
                    return _buildMessageTile(match);
                  },
                ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: const AppBottomNavigation(currentIndex: 3),
    );
  }

  Widget _buildMatchCard(Map<String, dynamic> match) {
    final name = match['name'] ?? 'Unknown';
    final photo = match['photo'] ?? '';

    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: GestureDetector(
        onTap: () => _openChat(match),
        child: Column(
          children: [
            Stack(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: photo.isNotEmpty
                      ? CachedNetworkImageProvider(photo)
                      : const AssetImage('assets/images/profiles/default.jpg') as ImageProvider,
                ),
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
              width: 65,
              child: Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 13, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageTile(Map<String, dynamic> match) {
    final name = match['name'] ?? 'Unknown';
    final photo = match['photo'] ?? '';
    final lastMessage = match['last_message'] ?? 'Start chatting!';
    final time = match['last_message_time'] ?? '';
    final unreadCount = match['unread_count'] ?? 0;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundImage: photo.isNotEmpty
                ? CachedNetworkImageProvider(photo)
                : const AssetImage('assets/images/profiles/default.jpg') as ImageProvider,
          ),
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),
      title: Text(
        name,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w600,
          fontSize: 16,
        ),
      ),
      subtitle: Text(
        lastMessage,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(
          color: unreadCount > 0 ? Colors.white : Colors.white60,
          fontWeight: unreadCount > 0 ? FontWeight.w500 : FontWeight.normal,
        ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            time,
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
          if (unreadCount > 0) ...[
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFFFF3F80),
                shape: BoxShape.circle,
              ),
              constraints: const BoxConstraints(
                minWidth: 20,
                minHeight: 20,
              ),
              child: Text(
                unreadCount > 9 ? '9+' : unreadCount.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ],
      ),
      onTap: () => _openChat(match),
    );
  }

  void _openChat(Map<String, dynamic> match) {
    Navigator.pushNamed(
      context,
      '/chat_screen',
      arguments: {
        'user_id': match['user_id'],
        'name': match['name'],
        'photo': match['photo'],
      },
    );
  }
}
