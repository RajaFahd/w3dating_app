import 'package:flutter/material.dart';

class SwipeProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _profiles = [];
  int _currentIndex = 0;
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get profiles => _profiles;
  int get currentIndex => _currentIndex;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasProfiles => _profiles.isNotEmpty && _currentIndex < _profiles.length;
  Map<String, dynamic>? get currentProfile => hasProfiles ? _profiles[_currentIndex] : null;

  void setProfiles(List<Map<String, dynamic>> newProfiles) {
    _profiles = newProfiles;
    _currentIndex = 0;
    _error = null;
    notifyListeners();
  }

  void setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void setError(String? errorMessage) {
    _error = errorMessage;
    _isLoading = false;
    notifyListeners();
  }

  void nextProfile() {
    if (_currentIndex < _profiles.length - 1) {
      _currentIndex++;
      notifyListeners();
    }
  }

  void removeCurrentProfile() {
    if (hasProfiles) {
      _profiles.removeAt(_currentIndex);
      notifyListeners();
    }
  }

  void clear() {
    _profiles = [];
    _currentIndex = 0;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
