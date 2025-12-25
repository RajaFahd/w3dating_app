import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/api_service.dart';
import 'dart:async';

class ChatScreenApi extends StatefulWidget {
  const ChatScreenApi({super.key});

  @override
  State<ChatScreenApi> createState() => _ChatScreenApiState();
}

class _ChatScreenApiState extends State<ChatScreenApi> {
  final ApiService _apiService = ApiService();
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  bool _isLoading = true;
  bool _isSending = false;
  List<Map<String, dynamic>> _messages = [];
  
  int? _userId;
  String? _name;
  String? _avatarUrl;
  bool? _isOnline;
  
  Timer? _pollTimer;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
    
    if (args != null && _userId == null) {
      _userId = args['user_id'];
      _name = args['name'];
      _avatarUrl = args['avatar'];
      _isOnline = args['is_online'];
      _loadMessages();
      _startPolling();
    }
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _startPolling() {
    // Poll for new messages every 3 seconds
    _pollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) _loadMessages(silent: true);
    });
  }

  Future<void> _loadMessages({bool silent = false}) async {
    if (!silent) setState(() => _isLoading = true);
    
    try {
      final response = await _apiService.get('/chat/$_userId/messages');
      if (response['success'] == true) {
        setState(() {
          _messages = List<Map<String, dynamic>>.from(response['data']);
          _isLoading = false;
        });
        
        // Scroll to bottom after loading
        if (_messages.isNotEmpty) {
          Future.delayed(const Duration(milliseconds: 100), () {
            if (_scrollController.hasClients) {
              _scrollController.animateTo(
                _scrollController.position.maxScrollExtent,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeOut,
              );
            }
          });
        }
      }
    } catch (e) {
      if (!silent) {
        setState(() => _isLoading = false);
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: $e')),
          );
        }
      }
    }
  }

  Future<void> _sendMessage() async {
    final message = _controller.text.trim();
    if (message.isEmpty || _isSending) return;
    
    setState(() => _isSending = true);
    
    try {
      final response = await _apiService.post(
        '/chat/$_userId/send',
        body: {'message': message},
      );
      
      if (response['success'] == true) {
        _controller.clear();
        // Reload messages to show the new one
        await _loadMessages(silent: true);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send: $e')),
        );
      }
    } finally {
      setState(() => _isSending = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) {
          Navigator.pushReplacementNamed(context, '/chat_list');
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context, true); // Return true to indicate chat was viewed
            },
          ),
          title: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade800,
                child: _avatarUrl != null && _avatarUrl!.isNotEmpty
                    ? ClipOval(
                        child: CachedNetworkImage(
                          imageUrl: _avatarUrl!,
                          width: 40,
                          height: 40,
                          fit: BoxFit.cover,
                          placeholder: (context, url) =>
                              const CircularProgressIndicator(strokeWidth: 2),
                          errorWidget: (context, url, error) =>
                              const Icon(Icons.person, size: 20),
                        ),
                      )
                    : const Icon(Icons.person, size: 20),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _name ?? 'User',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      _isOnline == true ? 'Online' : 'Offline',
                      style: const TextStyle(fontSize: 12, color: Colors.white70),
                    ),
                  ],
                ),
              )
            ],
          ),
          actions: [
            IconButton(onPressed: () {}, icon: const Icon(Icons.call, size: 22)),
            IconButton(onPressed: () {}, icon: const Icon(Icons.videocam, size: 22)),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _messages.isEmpty
                      ? const Center(
                          child: Text(
                            'No messages yet\nSay hi! 👋',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white54),
                          ),
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          itemCount: _messages.length,
                          itemBuilder: (context, i) {
                            final m = _messages[i];
                            final isMine = m['is_mine'] as bool;
                            
                            return Align(
                              alignment: isMine ? Alignment.centerRight : Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(vertical: 8),
                                child: Column(
                                  crossAxisAlignment:
                                      isMine ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context).size.width * 0.72),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 14, vertical: 10),
                                      decoration: BoxDecoration(
                                        color: isMine
                                            ? Colors.pink.shade300
                                            : const Color(0xFF2A2B30),
                                        borderRadius: BorderRadius.only(
                                          topLeft: const Radius.circular(14),
                                          topRight: const Radius.circular(14),
                                          bottomLeft: Radius.circular(isMine ? 14 : 4),
                                          bottomRight: Radius.circular(isMine ? 4 : 14),
                                        ),
                                      ),
                                      child: Text(
                                        m['message'],
                                        style: TextStyle(
                                            color: isMine ? Colors.white : Colors.white70),
                                      ),
                                    ),
                                    const SizedBox(height: 6),
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          m['time'],
                                          style: const TextStyle(
                                              color: Colors.white60, fontSize: 12),
                                        ),
                                        if (isMine && m['is_read'] == true) ...[
                                          const SizedBox(width: 4),
                                          const Icon(Icons.done_all,
                                              size: 14, color: Colors.blue),
                                        ],
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
            SafeArea(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: MediaQuery.of(context).size.width < 400 ? 8 : 12,
                  vertical: 10,
                ),
                color: const Color(0xFF17171A),
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 48,
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width < 400 ? 8 : 12),
                        child: Row(
                          children: [
                            const Icon(Icons.insert_emoticon, color: Colors.white54, size: 22),
                            SizedBox(
                                width: MediaQuery.of(context).size.width < 400 ? 6 : 8),
                            Expanded(
                              child: TextField(
                                controller: _controller,
                                style: const TextStyle(color: Colors.white),
                                decoration: const InputDecoration.collapsed(
                                  hintText: 'Send message...',
                                  hintStyle: TextStyle(color: Colors.white54),
                                ),
                                onSubmitted: (_) => _sendMessage(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(width: MediaQuery.of(context).size.width < 400 ? 6 : 8),
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF80B0), Color(0xFFFF4DA8)],
                        ),
                      ),
                      child: _isSending
                          ? const Padding(
                              padding: EdgeInsets.all(12),
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : IconButton(
                              onPressed: _sendMessage,
                              icon: const Icon(Icons.send, color: Colors.white, size: 20),
                            ),
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
