import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../config/constants.dart';
import 'api_service.dart';

class AuthService {
  final ApiService _apiService = ApiService();
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();
  
  User? _currentUser;
  
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;

  // Login
  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _apiService.post(
        ApiConstants.login,
        data: {
          'email': email,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['success']) {
        final token = response.data['data']['token'];
        final userData = response.data['data']['user'];

        // Save token
        await _secureStorage.write(key: StorageKeys.accessToken, value: token);
        _apiService.setToken(token);

        // Save user data
        _currentUser = User.fromJson(userData);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(StorageKeys.userData, json.encode(userData));

        return {'success': true, 'user': _currentUser};
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Login failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Register
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String phone,
    required String password,
  }) async {
    try {
      final response = await _apiService.post(
        ApiConstants.register,
        data: {
          'name': name,
          'email': email,
          'phone': phone,
          'password': password,
          'role': 'customer',
        },
      );

      if (response.statusCode == 201 && response.data['success']) {
        final token = response.data['data']['token'];
        final userData = response.data['data']['user'];

        // Save token
        await _secureStorage.write(key: StorageKeys.accessToken, value: token);
        _apiService.setToken(token);

        // Save user data
        _currentUser = User.fromJson(userData);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(StorageKeys.userData, json.encode(userData));

        return {'success': true, 'user': _currentUser};
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Registration failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Load saved auth state
  Future<bool> loadAuthState() async {
    try {
      final token = await _secureStorage.read(key: StorageKeys.accessToken);
      if (token == null) return false;

      _apiService.setToken(token);

      // Load user data
      final prefs = await SharedPreferences.getInstance();
      final userDataString = prefs.getString(StorageKeys.userData);
      if (userDataString != null) {
        _currentUser = User.fromJson(json.decode(userDataString));
        return true;
      }

      // Fetch fresh user data
      final response = await _apiService.get(ApiConstants.me);
      if (response.statusCode == 200 && response.data['success']) {
        _currentUser = User.fromJson(response.data['data']);
        await prefs.setString(StorageKeys.userData, json.encode(response.data['data']));
        return true;
      }

      return false;
    } catch (e) {
      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    try {
      await _apiService.post(ApiConstants.logout);
    } catch (e) {
      // Ignore errors during logout
    }

    // Clear local data
    await _secureStorage.delete(key: StorageKeys.accessToken);
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(StorageKeys.userData);
    _apiService.clearToken();
    _currentUser = null;
  }

  // Update profile
  Future<Map<String, dynamic>> updateProfile({
    String? name,
    String? phone,
    String? avatar,
  }) async {
    try {
      final response = await _apiService.put(
        ApiConstants.updateProfile,
        data: {
          if (name != null) 'name': name,
          if (phone != null) 'phone': phone,
          if (avatar != null) 'avatar': avatar,
        },
      );

      if (response.statusCode == 200 && response.data['success']) {
        _currentUser = User.fromJson(response.data['data']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(StorageKeys.userData, json.encode(response.data['data']));
        return {'success': true, 'user': _currentUser};
      } else {
        return {
          'success': false,
          'message': response.data['message'] ?? 'Update failed'
        };
      }
    } catch (e) {
      return {'success': false, 'message': 'Network error: $e'};
    }
  }

  // Update FCM token
  Future<void> updateFCMToken(String fcmToken) async {
    try {
      await _apiService.put(
        ApiConstants.updateFcmToken,
        data: {'fcmToken': fcmToken},
      );
    } catch (e) {
      print('Failed to update FCM token: $e');
    }
  }
}
