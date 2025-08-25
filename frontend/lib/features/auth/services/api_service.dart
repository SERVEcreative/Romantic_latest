import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/models/auth_models.dart';

class ApiService {
  // Mock data for offline development
  static const bool _useMockData = false; // Set to false to use real API
  
  static const String baseUrl = 'http://192.168.1.4:5000/api'; // Using actual IP address
  // static const String baseUrl = 'http://10.0.2.2:5000/api'; // For Android emulator
  // static const String baseUrl = 'http://your-server-ip:5000/api'; // For real device

  // Headers
  static Map<String, String> get _headers => {
    'Content-Type': 'application/json',
  };

  static Map<String, String> _authHeaders(String token) => {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };

  // Send OTP - Real API Implementation
  static Future<Map<String, dynamic>> sendOTP(String phoneNumber) async {
    try {
      final response = await AuthService.sendOtp(phoneNumber);
      return {
        'success': response.success,
        'data': {
          'phoneNumber': response.phoneNumber,
          'otpId': response.otpId,
          'expiresIn': response.expiresIn,
        },
        'message': response.message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to send OTP: $e',
      };
    }
  }

  // Verify OTP - Real API Implementation
  static Future<Map<String, dynamic>> verifyOTP(String phoneNumber, String otpCode) async {
    try {
      final response = await AuthService.verifyOtp(phoneNumber, otpCode);
      
      if (response.success && response.accessToken != null) {
        await _saveToken(response.accessToken!);
      }
      
      return {
        'success': response.success,
        'data': {
          'phoneNumber': phoneNumber,
          'accessToken': response.accessToken,
          'user': response.user?.toJson(),
        },
        'message': response.message,
      };
    } catch (e) {
      return {
        'success': false,
        'message': 'Failed to verify OTP: $e',
      };
    }
  }

  // Register User - Mock Implementation
  static Future<Map<String, dynamic>> registerUser({
    required String phoneNumber,
    required String fullName,
    required int age,
    required String gender,
    String? bio,
  }) async {
    if (_useMockData) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 2));
      
      final mockToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      await _saveToken(mockToken);
      
      return {
        'success': true,
        'data': {
          'user': {
            'id': 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
            'phoneNumber': phoneNumber,
            'fullName': fullName,
            'age': age,
            'gender': gender,
            'bio': bio ?? '',
            'coins': 100, // Starting coins
            'createdAt': DateTime.now().toIso8601String(),
          },
          'accessToken': mockToken,
        },
        'message': 'User registered successfully (MOCK MODE)',
      };
    }

    // Real API call (when backend is ready)
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/register'),
        headers: _headers,
        body: jsonEncode({
          'phoneNumber': phoneNumber,
          'fullName': fullName,
          'age': age,
          'gender': gender,
          'bio': bio ?? '',
        }),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 201 || response.statusCode == 200) {
        // Save token
        if (data['data']?['accessToken'] != null) {
          await _saveToken(data['data']['accessToken']);
        }
        
        return {
          'success': true,
          'data': data['data'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Registration failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Login User - Mock Implementation
  static Future<Map<String, dynamic>> loginUser(String phoneNumber) async {
    if (_useMockData) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      final mockToken = 'mock_token_${DateTime.now().millisecondsSinceEpoch}';
      await _saveToken(mockToken);
      
      return {
        'success': true,
        'data': {
          'user': {
            'id': 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
            'phoneNumber': phoneNumber,
            'fullName': 'Mock User',
            'age': 25,
            'gender': 'male',
            'bio': 'This is a mock user for testing',
            'coins': 150,
            'createdAt': DateTime.now().toIso8601String(),
          },
          'accessToken': mockToken,
        },
        'message': 'Login successful (MOCK MODE)',
      };
    }

    // Real API call (when backend is ready)
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: _headers,
        body: jsonEncode({
          'phoneNumber': phoneNumber,
        }),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        // Save token
        if (data['data']?['accessToken'] != null) {
          await _saveToken(data['data']['accessToken']);
        }
        
        return {
          'success': true,
          'data': data['data'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Login failed',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Get User Profile - Mock Implementation
  static Future<Map<String, dynamic>> getUserProfile() async {
    if (_useMockData) {
      // Simulate network delay
      await Future.delayed(const Duration(seconds: 1));
      
      return {
        'success': true,
        'data': {
          'id': 'mock_user_${DateTime.now().millisecondsSinceEpoch}',
          'phoneNumber': '+919876543210',
          'fullName': 'Mock User',
          'age': 25,
          'gender': 'male',
          'bio': 'This is a mock user profile for testing',
          'coins': 150,
          'createdAt': DateTime.now().toIso8601String(),
        },
        'message': 'Profile retrieved successfully (MOCK MODE)',
      };
    }

    // Real API call (when backend is ready)
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'No authentication token',
        };
      }

      final response = await http.get(
        Uri.parse('$baseUrl/auth/profile'),
        headers: _authHeaders(token),
      );

      final data = jsonDecode(response.body);
      
      if (response.statusCode == 200) {
        return {
          'success': true,
          'data': data['data'],
          'message': data['message'],
        };
      } else {
        return {
          'success': false,
          'message': data['message'] ?? 'Failed to get profile',
        };
      }
    } catch (e) {
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Logout User
  static Future<Map<String, dynamic>> logoutUser() async {
    // Clear token regardless of mock mode
    await _clearToken();

    if (_useMockData) {
      return {
        'success': true,
        'message': 'Logged out successfully (MOCK MODE)',
      };
    }

    // Real API call (when backend is ready)
    try {
      final token = await _getToken();
      if (token == null) {
        return {
          'success': false,
          'message': 'No authentication token',
        };
      }

      final response = await http.post(
        Uri.parse('$baseUrl/auth/logout'),
        headers: _authHeaders(token),
      );

      // Clear token regardless of response
      await _clearToken();

      if (response.statusCode == 200) {
        return {
          'success': true,
          'message': 'Logged out successfully',
        };
      } else {
        return {
          'success': false,
          'message': 'Logout failed',
        };
      }
    } catch (e) {
      // Clear token even if network error
      await _clearToken();
      return {
        'success': false,
        'message': 'Network error: $e',
      };
    }
  }

  // Token Management
  static Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Check if user is logged in
  static Future<bool> isLoggedIn() async {
    final token = await _getToken();
    return token != null;
  }
}
