import 'package:flutter/material.dart';
import 'package:w3dating_app/template/bottom_navigation.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/api_service.dart';
import '../config/api_config.dart';

class ChatListPage extends StatefulWidget {
  const ChatListPage({super.key});

  @override
  State<ChatListPage> createState() => _ChatListPageState();
}

class _ChatListPageState extends State<ChatListPage> with AutomaticKeepAliveClientMixin {
  final ApiService _apiService = ApiService();
  bool _isLoading = true;
  List<Map<String, dynamic>> _chatList = [];
  List<Map<String, dynamic>> _matches = [];

  @override
  bool get wantKeepAlive => false; // Don't keep state, reload when visible

  @override
  void initState() {
    super.initState();
    _loadChatList();
    _loadMatches();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload chat list when this page becomes visible
    if (ModalRoute.of(context)?.isCurrent == true) {
      _loadChatList();
      _loadMatches();
    }
  }

  Future<void> _loadChatList() async {
    setState(() => _isLoading = true);
    
    try {
      
      final response = await _apiService.get('/chat/list');
      
      if (response['success'] == true) {
        setState(() {
          _chatList = List<Map<String, dynamic>>.from(response['data']);
          _isLoading = false;
        });
      } else {
        setState(() => _isLoading = false);
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _loadMatches() async {
    try {
      final response = await _apiService.get('/matches');
      if (response['success'] == true) {
        setState(() {
          _matches = List<Map<String, dynamic>>.from(response['data']);
        });
      }
    } catch (e) {
      // Silently fail - matches are optional
    }
  }

  String _getPhotoUrl(String? photoUrl) {
    if (photoUrl == null || photoUrl.isEmpty) return '';
    if (photoUrl.startsWith('http')) return photoUrl;
    final baseUrl = ApiConfig.baseUrl.replaceAll('/api', '');
    return '$baseUrl$photoUrl';
  }

  @override
  @override
  Widget build(BuildContext context) {
    super.build(context); // Required for AutomaticKeepAliveClientMixin
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
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
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await _loadChatList();
                await _loadMatches();
              },
              child: Column(
              children: [
                // Horizontal scrolling matches at top
                if (_matches.isNotEmpty)
                  Container(
                    height: 110,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      itemCount: _matches.length,
                      itemBuilder: (context, index) {
                        final match = _matches[index];
                        final photoUrl = _getPhotoUrl(match['avatar']);
                        final isOnline = match['is_online'] ?? false;

                        return GestureDetector(
                          onTap: () async {
                            final result = await Navigator.pushNamed(
                              context,
                              '/chat_screen',
                              arguments: {
                                'user_id': match['user_id'],
                                'name': match['name'],
                                'avatar': photoUrl,
                                'is_online': isOnline,
                              },
                            );
                            if (result == true) _loadChatList();
                          },
                          child: Container(
                            margin: const EdgeInsets.symmetric(horizontal: 6),
                            child: Column(
                              children: [
                                Stack(
                                  children: [
                                    CircleAvatar(
                                      radius: 30,
                                      backgroundColor: Colors.grey.shade800,
                                      child: photoUrl.isNotEmpty
                                          ? ClipOval(
                                              child: CachedNetworkImage(
                                                imageUrl: photoUrl,
                                                width: 60,
                                                height: 60,
                                                fit: BoxFit.cover,
                                                placeholder: (context, url) =>
                                                    const CircularProgressIndicator(strokeWidth: 2),
                                                errorWidget: (context, url, error) =>
                                                    const Icon(Icons.person),
                                              ),
                                            )
                                          : const Icon(Icons.person),
                                    ),
                                    if (isOnline)
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
                                    match['name'] ?? '',
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
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: EdgeInsets.only(left: 16, bottom: 12, top: 10),
                    child: Text(
                      'Messages',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                // Message list
                Expanded(
                  child: _chatList.isEmpty
                      ? const Center(
                          child: Text(
                            'No messages yet',
                            style: TextStyle(color: Colors.white54, fontSize: 16),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _chatList.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1, indent: 76, color: Color(0xFF2E2E34)),
                          itemBuilder: (context, index) {
                            final chat = _chatList[index];
                            final photoUrl = _getPhotoUrl(chat['avatar']);
                            final isOnline = chat['is_online'] ?? false;
                            final unreadCount = chat['unread_count'] ?? 0;

                            return ListTile(
                              onTap: () async {
                                final result = await Navigator.pushNamed(
                                  context,
                                  '/chat_screen',
                                  arguments: {
                                    'user_id': chat['user_id'],
                                    'name': chat['name'],
                                    'avatar': photoUrl,
                                    'is_online': isOnline,
                                  },
                                );
                                if (result == true) _loadChatList();
                              },
                              leading: Stack(
                                children: [
                                  CircleAvatar(
                                    radius: 28,
                                    backgroundColor: Colors.grey.shade800,
                                    child: photoUrl.isNotEmpty
                                        ? ClipOval(
                                            child: CachedNetworkImage(
                                              imageUrl: photoUrl,
                                              width: 56,
                                              height: 56,
                                              fit: BoxFit.cover,
                                              placeholder: (context, url) =>
                                                  const CircularProgressIndicator(strokeWidth: 2),
                                              errorWidget: (context, url, error) =>
                                                  const Icon(Icons.person),
                                            ),
                                          )
                                        : const Icon(Icons.person),
                                  ),
                                  if (isOnline)
                                    Positioned(
                                      left: 0,
                                      bottom: 0,
                                      child: Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: Colors.green,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: theme.scaffoldBackgroundColor, width: 4),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              title: Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Text(
                                  chat['name'] ?? '',
                                  style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                                ),
                              ),
                              subtitle: Text(
                                chat['last_message'] ?? '',
                                style: TextStyle(
                                  color: unreadCount > 0 ? Colors.white : Colors.grey,
                                  fontSize: 14,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              trailing: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Text(
                                    chat['last_message_time'] ?? '',
                                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                                  ),
                                  const SizedBox(height: 5),
                                  if (unreadCount > 0)
                                    Container(
                                      padding: const EdgeInsets.all(6),
                                      decoration: const BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Color(0xFFFF4081),
                                      ),
                                      child: Text(
                                        unreadCount > 9 ? '9+' : unreadCount.toString(),
                                        style: const TextStyle(
                                          fontSize: 10,
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
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
          ),
      bottomNavigationBar: AppBottomNavigation(currentIndex: 3),
    );
  }
}
