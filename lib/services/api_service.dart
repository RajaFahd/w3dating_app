import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../config/api_config.dart';

class ApiService {
  // Base URL dari config
  static String get baseUrl => ApiConfig.baseUrl;
  
  // Singleton pattern
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  String? _token;
  
  // Get token dari SharedPreferences
  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  // Save token ke SharedPreferences
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    _token = token;
  }

  // Clear token (logout)
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    _token = null;
  }

  // Get headers with authorization
  Map<String, String> _getHeaders({bool requiresAuth = true}) {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth && _token != null) {
      headers['Authorization'] = 'Bearer $_token';
    }

    return headers;
  }

  // GET request
  Future<Map<String, dynamic>> get(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      print('DEBUG ApiService.get: Calling $url with token: ${_token != null ? _token!.substring(0, 20) + '...' : 'NO TOKEN'}');
      final response = await http.get(
        url,
        headers: _getHeaders(requiresAuth: requiresAuth),
      ).timeout(ApiConfig.timeout);

      print('DEBUG ApiService.get: Response status ${response.statusCode}');
      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Service unavailable');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST request
  Future<Map<String, dynamic>> post(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = true,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.post(
        url,
        headers: _getHeaders(requiresAuth: requiresAuth),
        body: jsonEncode(body),
      ).timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Service unavailable');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // PUT request
  Future<Map<String, dynamic>> put(
    String endpoint, {
    required Map<String, dynamic> body,
    bool requiresAuth = true,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.put(
        url,
        headers: _getHeaders(requiresAuth: requiresAuth),
        body: jsonEncode(body),
      ).timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Service unavailable');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // DELETE request
  Future<Map<String, dynamic>> delete(
    String endpoint, {
    bool requiresAuth = true,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final response = await http.delete(
        url,
        headers: _getHeaders(requiresAuth: requiresAuth),
      ).timeout(ApiConfig.timeout);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Service unavailable');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // POST dengan multipart (untuk upload foto)
  Future<Map<String, dynamic>> postMultipart(
    String endpoint, {
    required Map<String, String> fields,
    required List<File> files,
    required String fileFieldName,
    bool requiresAuth = true,
  }) async {
    try {
      final url = Uri.parse('$baseUrl$endpoint');
      final request = http.MultipartRequest('POST', url);

      // Add headers
      if (requiresAuth && _token != null) {
        request.headers['Authorization'] = 'Bearer $_token';
      }
      request.headers['Accept'] = 'application/json';

      // Add fields
      request.fields.addAll(fields);

      // Add files
      for (var file in files) {
        request.files.add(
          await http.MultipartFile.fromPath(
            '$fileFieldName[]',
            file.path,
          ),
        );
      }

      final streamedResponse = await request.send().timeout(
        ApiConfig.timeout,
      );
      final response = await http.Response.fromStream(streamedResponse);

      return _handleResponse(response);
    } on SocketException {
      throw Exception('No internet connection');
    } on HttpException {
      throw Exception('Service unavailable');
    } catch (e) {
      throw Exception('Error: $e');
    }
  }

  // Handle response
  Map<String, dynamic> _handleResponse(http.Response response) {
    Map<String, dynamic> data = {};
    try {
      final decoded = jsonDecode(response.body);
      if (decoded is Map<String, dynamic>) {
        data = decoded;
      } else {
        data = {'data': decoded};
      }
    } catch (_) {
      // Non-JSON response; keep empty data but continue handling by status code
      data = {};
    }

    if (response.statusCode >= 200 && response.statusCode < 300) {
      return data;
    } else if (response.statusCode == 401) {
      // Unauthorized - clear token
      clearToken();
      throw Exception('Session expired. Please login again.');
    } else if (response.statusCode == 422) {
      // Validation error
      final errors = data['errors'] as Map<String, dynamic>?;
      if (errors != null && errors.isNotEmpty) {
        final firstError = errors.values.first;
        final errorMessage = firstError is List ? firstError.first : firstError;
        throw Exception(errorMessage);
      }
      throw Exception(data['message'] ?? 'Validation error');
    } else {
      throw Exception(data['message'] ?? 'Something went wrong (HTTP ${response.statusCode})');
    }
  }

  // ==================== AUTH ENDPOINTS ====================

  Future<Map<String, dynamic>> sendOTP({
    required String phoneNumber,
    required String countryCode,
  }) async {
    return await post(
      '/auth/send-otp',
      body: {
        'phone_number': phoneNumber,
        'country_code': countryCode,
      },
      requiresAuth: false,
    );
  }

  Future<Map<String, dynamic>> verifyOTP({
    required String phoneNumber,
    required String otpCode,
  }) async {
    final response = await post(
      '/auth/verify-otp',
      body: {
        'phone_number': phoneNumber,
        'otp_code': otpCode,
      },
      requiresAuth: false,
    );

    // Save token
    if (response['token'] != null) {
      await saveToken(response['token']);
    }

    return response;
  }

  Future<Map<String, dynamic>> logout() async {
    final response = await post('/auth/logout', body: {});
    await clearToken();
    return response;
  }

  Future<Map<String, dynamic>> getMe() async {
    return await get('/auth/me');
  }

  // ==================== PROFILE ENDPOINTS ====================

  Future<Map<String, dynamic>> createProfile({
    required Map<String, dynamic> profileData,
  }) async {
    return await post('/profile/create', body: profileData);
  }

  Future<Map<String, dynamic>> updateProfile({
    required Map<String, dynamic> profileData,
  }) async {
    return await put('/profile/update', body: profileData);
  }

  Future<Map<String, dynamic>> uploadPhotos({
    required List<File> photos,
  }) async {
    return await postMultipart(
      '/profile/photos',
      fields: {},
      files: photos,
      fileFieldName: 'photos',
    );
  }

  Future<Map<String, dynamic>> deletePhoto(int photoId) async {
    return await delete('/profile/photos/$photoId');
  }

  Future<Map<String, dynamic>> getInterests() async {
    return await get('/profile/interests');
  }

  Future<Map<String, dynamic>> updateInterests({
    required List<int> interestIds,
  }) async {
    return await post(
      '/profile/interests',
      body: {'interest_ids': interestIds},
    );
  }

  // ==================== SWIPE ENDPOINTS ====================

  Future<Map<String, dynamic>> getProfiles() async {
    return await get('/swipe/profiles');
  }

  Future<Map<String, dynamic>> swipe({
    required int targetUserId,
    required String type, // 'like', 'dislike', 'super_like'
  }) async {
    return await post(
      '/swipe',
      body: {
        'target_user_id': targetUserId,
        'type': type,
      },
    );
  }

  Future<Map<String, dynamic>> unlikeUser(int targetUserId) async {
    return await delete(
      '/swipes/unlike?target_user_id=$targetUserId',
    );
  }

  // ==================== MATCH ENDPOINTS ====================

  Future<Map<String, dynamic>> getMatches() async {
    return await get('/matches');
  }

  Future<Map<String, dynamic>> getLikedUsers() async {
    return await get('/matches/liked-me');
  }

  Future<Map<String, dynamic>> getMatchDetail(int userId) async {
    return await get('/matches/$userId');
  }

  // ==================== CHAT ENDPOINTS ====================

  Future<Map<String, dynamic>> getChatList() async {
    return await get('/chat/list');
  }

  Future<Map<String, dynamic>> getMessages(int userId) async {
    return await get('/chat/$userId/messages');
  }

  Future<Map<String, dynamic>> sendMessage({
    required int userId,
    required String message,
  }) async {
    return await post(
      '/chat/$userId/send',
      body: {'message': message},
    );
  }

  // ==================== FILTER ENDPOINTS ====================

  Future<Map<String, dynamic>> getFilter() async {
    return await get('/filter');
  }

  Future<Map<String, dynamic>> updateFilter({
    required Map<String, dynamic> filterData,
  }) async {
    return await put('/filter', body: filterData);
  }

  // ==================== SUBSCRIPTION ENDPOINTS ====================

  Future<Map<String, dynamic>> getPlans() async {
    return await get('/subscriptions/plans');
  }

  Future<Map<String, dynamic>> subscribe({
    required String planType,
  }) async {
    return await post(
      '/subscriptions/subscribe',
      body: {'plan_type': planType},
    );
  }

  Future<Map<String, dynamic>> getMySubscription() async {
    return await get('/subscriptions/my-subscription');
  }

  Future<Map<String, dynamic>> cancelSubscription() async {
    return await post('/subscriptions/cancel', body: {});
  }
}
