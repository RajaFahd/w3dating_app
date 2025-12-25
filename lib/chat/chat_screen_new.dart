import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../services/api_service.dart';
import '../providers/chat_provider.dart';

class ChatScreenNew extends StatefulWidget {
  const ChatScreenNew({super.key});

  @override
  State<ChatScreenNew> createState() => _ChatScreenNewState();
}

class _ChatScreenNewState extends State<ChatScreenNew> {
  final ApiService _apiService = ApiService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  
  int? _userId;
  String? _userName;
  String? _userPhoto;
  bool _isLoading = false;
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final args = ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?;
      if (args != null) {
        setState(() {
          _userId = args['user_id'];
          _userName = args['name'];
          _userPhoto = args['photo'];
        });
        _loadMessages();
      }
    });
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadMessages() async {
    if (_userId == null) return;

    setState(() => _isLoading = true);

    try {
      final response = await _apiService.getMessages(_userId!);
      if (!mounted) return;
      
      if (response['success'] == true) {
        final List<dynamic> data = response['data'] ?? [];
        final messages = data.map((m) => m as Map<String, dynamic>).toList();
        
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        chatProvider.setMessages(_userId!, messages);
        
        setState(() => _isLoading = false);
        _scrollToBottom();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  Future<void> _sendMessage() async {
    if (_messageController.text.trim().isEmpty || _userId == null || _isSending) {
      return;
    }

    final messageText = _messageController.text.trim();
    _messageController.clear();
    setState(() => _isSending = true);

    try {
      final response = await _apiService.sendMessage(
        userId: _userId!,
        message: messageText,
      );
      if (!mounted) return;

      if (response['success'] == true) {
        final messageData = response['data'];
        
        final chatProvider = Provider.of<ChatProvider>(context, listen: false);
        chatProvider.addMessage(_userId!, messageData);
        
        setState(() => _isSending = false);
        _scrollToBottom();
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSending = false);
      _showError(e.toString().replaceAll('Exception: ', ''));
    }
  }

  void _scrollToBottom() {
    if (_scrollController.hasClients) {
      Future.delayed(const Duration(milliseconds: 100), () {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      });
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
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, size: 28),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: _userPhoto != null && _userPhoto!.isNotEmpty
                  ? CachedNetworkImageProvider(_userPhoto!)
                  : const AssetImage('assets/images/profiles/default.jpg') as ImageProvider,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _userName ?? 'Unknown',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  const Text(
                    'Online',
                    style: TextStyle(fontSize: 12, color: Colors.green),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.videocam_outlined, size: 28),
            onPressed: () {
              // TODO: Implement video call
            },
          ),
          IconButton(
            icon: const Icon(Icons.phone_outlined, size: 24),
            onPressed: () {
              // TODO: Implement voice call
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Messages list
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Color(0xFFFF3F80)),
                  )
                : Consumer<ChatProvider>(
                    builder: (context, chatProvider, child) {
                      final messages = chatProvider.getMessages(_userId ?? 0);
                      
                      if (messages.isEmpty) {
                        return const Center(
                          child: Text(
                            'No messages yet\nSay hi! 👋',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.white54, fontSize: 16),
                          ),
                        );
                      }

                      return ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.all(16),
                        itemCount: messages.length,
                        itemBuilder: (context, index) {
                          final message = messages[index];
                          final isMe = message['is_sender'] == true;
                          return _buildMessageBubble(message, isMe);
                        },
                      );
                    },
                  ),
          ),

          // Message input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              border: Border(
                top: BorderSide(color: Colors.white.withOpacity(0.1)),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF383840),
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(width: 16),
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            style: const TextStyle(color: Colors.white),
                            decoration: const InputDecoration(
                              hintText: 'Type a message...',
                              hintStyle: TextStyle(color: Colors.white54),
                              border: InputBorder.none,
                            ),
                            maxLines: null,
                            textCapitalization: TextCapitalization.sentences,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.emoji_emotions_outlined, color: Colors.white54),
                          onPressed: () {
                            // TODO: Show emoji picker
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFFFF6DA0), Color(0xFFFF3F80)],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: _isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(Map<String, dynamic> message, bool isMe) {
    final text = message['message'] ?? '';
    final time = message['created_at'] ?? '';

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.7,
        ),
        decoration: BoxDecoration(
          gradient: isMe
              ? const LinearGradient(
                  colors: [Color(0xFFFF6DA0), Color(0xFFFF3F80)],
                )
              : null,
          color: isMe ? null : const Color(0xFF383840),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(18),
            topRight: const Radius.circular(18),
            bottomLeft: Radius.circular(isMe ? 18 : 4),
            bottomRight: Radius.circular(isMe ? 4 : 18),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              text,
              style: const TextStyle(color: Colors.white, fontSize: 15),
            ),
            const SizedBox(height: 4),
            Text(
              time,
              style: TextStyle(
                color: Colors.white.withOpacity(0.7),
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
