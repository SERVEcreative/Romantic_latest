import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

class TokenService {
  static const String _tokenKey = 'auth_token';
  static const String _refreshTokenKey = 'refresh_token';
  static const String _userIdKey = 'user_id';

  /// Save authentication token
  static Future<void> saveToken(String token) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
      Logger.success('Token saved successfully');
    } catch (e) {
      Logger.error('Failed to save token', e);
      rethrow;
    }
  }

  /// Get stored authentication token
  static Future<String?> getToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      Logger.info('Token retrieved: ${token != null ? 'Found' : 'Not found'}');
      return token;
    } catch (e) {
      Logger.error('Failed to get token', e);
      return null;
    }
  }

  /// Save refresh token
  static Future<void> saveRefreshToken(String refreshToken) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_refreshTokenKey, refreshToken);
      Logger.success('Refresh token saved successfully');
    } catch (e) {
      Logger.error('Failed to save refresh token', e);
      rethrow;
    }
  }

  /// Get stored refresh token
  static Future<String?> getRefreshToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_refreshTokenKey);
    } catch (e) {
      Logger.error('Failed to get refresh token', e);
      return null;
    }
  }

  /// Save user ID
  static Future<void> saveUserId(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userIdKey, userId);
      Logger.success('User ID saved successfully');
    } catch (e) {
      Logger.error('Failed to save user ID', e);
      rethrow;
    }
  }

  /// Get stored user ID
  static Future<String?> getUserId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_userIdKey);
    } catch (e) {
      Logger.error('Failed to get user ID', e);
      return null;
    }
  }

  /// Clear all stored tokens and user data
  static Future<void> clearAllTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_refreshTokenKey);
      await prefs.remove(_userIdKey);
      Logger.success('All tokens cleared successfully');
    } catch (e) {
      Logger.error('Failed to clear tokens', e);
      rethrow;
    }
  }

  /// Check if user is logged in (has valid token)
  static Future<bool> isLoggedIn() async {
    try {
      final token = await getToken();
      return token != null && token.isNotEmpty;
    } catch (e) {
      Logger.error('Failed to check login status', e);
      return false;
    }
  }

  /// Save complete authentication data
  static Future<void> saveAuthData({
    required String token,
    String? refreshToken,
    String? userId,
  }) async {
    try {
      await saveToken(token);
      if (refreshToken != null) {
        await saveRefreshToken(refreshToken);
      }
      if (userId != null) {
        await saveUserId(userId);
      }
      Logger.success('Authentication data saved successfully');
    } catch (e) {
      Logger.error('Failed to save authentication data', e);
      rethrow;
    }
  }
}
