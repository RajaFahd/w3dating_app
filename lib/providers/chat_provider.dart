import 'package:flutter/material.dart';

class ChatProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _matches = [];
  Map<int, List<Map<String, dynamic>>> _messages = {};
  bool _isLoading = false;

  List<Map<String, dynamic>> get matches => _matches;
  bool get isLoading => _isLoading;

  void setMatches(List<Map<String, dynamic>> newMatches) {
    _matches = newMatches;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setMessages(int userId, List<Map<String, dynamic>> messages) {
    _messages[userId] = messages;
    notifyListeners();
  }

  List<Map<String, dynamic>> getMessages(int userId) {
    return _messages[userId] ?? [];
  }

  void addMessage(int userId, Map<String, dynamic> message) {
    if (_messages[userId] == null) {
      _messages[userId] = [];
    }
    _messages[userId]!.add(message);
    notifyListeners();
  }

  void clear() {
    _matches = [];
    _messages = {};
    _isLoading = false;
    notifyListeners();
  }
}
