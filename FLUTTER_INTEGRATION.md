# 📱 Flutter Integration Guide

## Setup HTTP Client

### 1. Install Dependencies
Tambahkan di `pubspec.yaml`:
```yaml
dependencies:
  http: ^1.1.0
  shared_preferences: ^2.2.2
  provider: ^6.1.1
```

### 2. Create API Service

**`lib/services/api_service.dart`:**
```dart
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:8000/api';
  
  // Get saved token
  Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }
  
  // Save token
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }
  
  // Clear token (logout)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
  
  // GET request
  Future<Map<String, dynamic>> get(String endpoint) async {
    final token = await getToken();
    final response = await http.get(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    
    return _handleResponse(response);
  }
  
  // POST request
  Future<Map<String, dynamic>> post(String endpoint, Map<String, dynamic> body) async {
    final token = await getToken();
    final response = await http.post(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    
    return _handleResponse(response);
  }
  
  // PUT request
  Future<Map<String, dynamic>> put(String endpoint, Map<String, dynamic> body) async {
    final token = await getToken();
    final response = await http.put(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    
    return _handleResponse(response);
  }
  
  // DELETE request
  Future<Map<String, dynamic>> delete(String endpoint) async {
    final token = await getToken();
    final response = await http.delete(
      Uri.parse('$baseUrl$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
    
    return _handleResponse(response);
  }
  
  Map<String, dynamic> _handleResponse(http.Response response) {
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return jsonDecode(response.body);
    } else {
      throw Exception('API Error: ${response.statusCode} - ${response.body}');
    }
  }
}
```

---

## Authentication Flow

### Login Page Integration

**`lib/welcome/login_page.dart`:**
```dart
import 'package:w3dating_app/services/api_service.dart';

class _LoginPageState extends State<LoginPage> {
  final ApiService _apiService = ApiService();
  final TextEditingController _phoneController = TextEditingController();
  String _selectedCountryCode = '+61';
  bool _isLoading = false;

  Future<void> _sendOTP() async {
    setState(() => _isLoading = true);
    
    try {
      final response = await _apiService.post('/auth/send-otp', {
        'phone_number': _phoneController.text,
        'country_code': _selectedCountryCode,
      });
      
      if (response['success']) {
        Navigator.pushNamed(context, '/otp', arguments: {
          'phone_number': _phoneController.text,
          'country_code': _selectedCountryCode,
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }
  
  // ... rest of widget
}
```

### OTP Verification

**`lib/welcome/otp_page.dart`:**
```dart
Future<void> _verifyOTP() async {
  setState(() => _isLoading = true);
  
  try {
    final args = ModalRoute.of(context)!.settings.arguments as Map;
    final response = await _apiService.post('/auth/verify-otp', {
      'phone_number': args['phone_number'],
      'otp_code': _otpController.text,
    });
    
    if (response['success']) {
      // Save token
      await _apiService.saveToken(response['token']);
      
      // Check if has profile
      if (response['has_profile']) {
        Navigator.pushReplacementNamed(context, '/home');
      } else {
        Navigator.pushReplacementNamed(context, '/first_name');
      }
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Invalid OTP')),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}
```

---

## Profile Creation

**`lib/welcome/recent_pics.dart`:**
```dart
Future<void> _uploadPhotos() async {
  setState(() => _isLoading = true);
  
  try {
    final token = await _apiService.getToken();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiService.baseUrl}/profile/photos'),
    );
    
    request.headers['Authorization'] = 'Bearer $token';
    
    for (var i = 0; i < _images.length; i++) {
      if (_images[i] != null) {
        request.files.add(
          await http.MultipartFile.fromPath(
            'photos[]',
            _images[i]!.path,
          ),
        );
      }
    }
    
    var response = await request.send();
    
    if (response.statusCode == 200) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Upload failed: $e')),
    );
  } finally {
    setState(() => _isLoading = false);
  }
}
```

---

## Get Swipe Profiles

**`lib/home/home_screen.dart`:**
```dart
class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> _profiles = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfiles();
  }

  Future<void> _loadProfiles() async {
    try {
      final response = await _apiService.get('/swipe/profiles');
      
      if (response['success']) {
        setState(() {
          _profiles = List<Map<String, dynamic>>.from(response['data']);
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading profiles')),
      );
    }
  }

  Future<void> _swipe(int targetUserId, String type) async {
    try {
      final response = await _apiService.post('/swipe', {
        'target_user_id': targetUserId,
        'type': type, // 'like', 'dislike', 'super_like'
      });
      
      if (response['success'] && response['is_match']) {
        // Show match screen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MatchScreenPage(
              matchName: response['match_data']['profile']['first_name'],
              matchImageUrl: response['match_data']['photos'][0]['photo_url'],
            ),
          ),
        );
      }
    } catch (e) {
      print('Swipe error: $e');
    }
  }
  
  // ... rest of widget
}
```

---

## Chat Integration

**`lib/chat/chat_list.dart`:**
```dart
Future<void> _loadChatList() async {
  try {
    final response = await _apiService.get('/chat/list');
    
    if (response['success']) {
      setState(() {
        _chatList = List<Map<String, dynamic>>.from(response['data']);
      });
    }
  } catch (e) {
    print('Error loading chats: $e');
  }
}
```

**`lib/chat/chat_screen.dart`:**
```dart
Future<void> _loadMessages(int userId) async {
  try {
    final response = await _apiService.get('/chat/$userId/messages');
    
    if (response['success']) {
      setState(() {
        _messages = List<Map<String, dynamic>>.from(response['data']);
      });
    }
  } catch (e) {
    print('Error loading messages: $e');
  }
}

Future<void> _sendMessage(int userId, String message) async {
  try {
    final response = await _apiService.post('/chat/$userId/send', {
      'message': message,
    });
    
    if (response['success']) {
      setState(() {
        _messages.add(response['data']);
      });
      _messageController.clear();
    }
  } catch (e) {
    print('Error sending message: $e');
  }
}
```

---

## Filter Integration

**`lib/profile/filter.dart`:**
```dart
Future<void> _loadFilter() async {
  try {
    final response = await _apiService.get('/filter');
    
    if (response['success']) {
      setState(() {
        men = response['data']['show_men'];
        women = response['data']['show_women'];
        nonbinary = response['data']['show_nonbinary'];
        ageRange = RangeValues(
          response['data']['age_min'].toDouble(),
          response['data']['age_max'].toDouble(),
        );
        distance = response['data']['distance_max'].toDouble();
      });
    }
  } catch (e) {
    print('Error loading filter: $e');
  }
}

Future<void> _saveFilter() async {
  try {
    final response = await _apiService.put('/filter', {
      'show_men': men,
      'show_women': women,
      'show_nonbinary': nonbinary,
      'age_min': ageRange.start.toInt(),
      'age_max': ageRange.end.toInt(),
      'distance_max': distance.toInt(),
    });
    
    if (response['success']) {
      Navigator.pop(context);
    }
  } catch (e) {
    print('Error saving filter: $e');
  }
}
```

---

## Error Handling

Create a global error handler:

**`lib/services/error_handler.dart`:**
```dart
class ErrorHandler {
  static void handle(BuildContext context, dynamic error) {
    String message = 'An error occurred';
    
    if (error.toString().contains('401')) {
      message = 'Session expired. Please login again.';
      // Clear token and redirect to login
      ApiService().clearToken();
      Navigator.pushReplacementNamed(context, '/login');
    } else if (error.toString().contains('404')) {
      message = 'Resource not found';
    } else if (error.toString().contains('500')) {
      message = 'Server error. Please try again later.';
    }
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }
}
```

---

## Loading State Management

Use Provider for global loading state:

**`lib/providers/loading_provider.dart`:**
```dart
import 'package:flutter/material.dart';

class LoadingProvider extends ChangeNotifier {
  bool _isLoading = false;
  
  bool get isLoading => _isLoading;
  
  void setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
```

Wrap app with provider in `main.dart`:
```dart
runApp(
  MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => LoadingProvider()),
    ],
    child: const W3DatingApp(),
  ),
);
```

---

## Testing API

Before integrating, test endpoints with Postman or curl:

```bash
# Login
curl -X POST http://localhost:8000/api/auth/send-otp \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"812345678","country_code":"+61"}'

# Verify
curl -X POST http://localhost:8000/api/auth/verify-otp \
  -H "Content-Type: application/json" \
  -d '{"phone_number":"812345678","otp_code":"123456"}'
```

---

## Change API URL for Production

When deploying, update `baseUrl`:

```dart
class ApiService {
  static const String baseUrl = 'https://your-domain.com/api';
}
```

---

## 🎯 Checklist Integration

- [ ] Install http & shared_preferences packages
- [ ] Create ApiService class
- [ ] Integrate login flow
- [ ] Integrate OTP verification
- [ ] Integrate profile creation
- [ ] Integrate photo upload
- [ ] Integrate swipe functionality
- [ ] Integrate chat
- [ ] Integrate filter
- [ ] Test all endpoints
- [ ] Handle errors properly
- [ ] Add loading states
- [ ] Update baseUrl for production
