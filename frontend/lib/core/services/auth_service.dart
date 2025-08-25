import 'api_service.dart';
import '../models/auth_models.dart';

class AuthService {
  // API Endpoints
  static const String _sendOtpEndpoint = '/auth/send-otp';
  static const String _verifyOtpEndpoint = '/auth/verify-otp';
  static const String _loginEndpoint = '/auth/login';
  static const String _logoutEndpoint = '/auth/logout';
  static const String _refreshTokenEndpoint = '/auth/refresh-token';
  static const String _forgotPasswordEndpoint = '/auth/forgot-password';
  static const String _resetPasswordEndpoint = '/auth/reset-password';

  /// Send OTP to phone number
  static Future<OtpResponse> sendOtp(String phoneNumber) async {
    try {
      final response = await ApiService.post(
        _sendOtpEndpoint,
        body: {
          'phoneNumber': phoneNumber,
        },
      );

      return OtpResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Verify OTP code
  static Future<AuthResponse> verifyOtp(String phoneNumber, String otpCode) async {
    try {
      final response = await ApiService.post(
        _verifyOtpEndpoint,
        body: {
          'phoneNumber': phoneNumber,
          'otp': otpCode, // Changed from 'otpCode' to 'otp' to match backend expectation
        },
      );

      return AuthResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Login with credentials
  static Future<AuthResponse> login(String phoneNumber, String password) async {
    try {
      final response = await ApiService.post(
        _loginEndpoint,
        body: {
          'phoneNumber': phoneNumber,
          'password': password,
        },
      );

      return AuthResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Logout user
  static Future<void> logout() async {
    try {
      await ApiService.post(_logoutEndpoint);
    } catch (e) {
      rethrow;
    }
  }

  /// Refresh access token
  static Future<AuthResponse> refreshToken(String refreshToken) async {
    try {
      final response = await ApiService.post(
        _refreshTokenEndpoint,
        body: {
          'refreshToken': refreshToken,
        },
      );

      return AuthResponse.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Request password reset
  static Future<void> forgotPassword(String phoneNumber) async {
    try {
      await ApiService.post(
        _forgotPasswordEndpoint,
        body: {
          'phoneNumber': phoneNumber,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Reset password with OTP
  static Future<void> resetPassword(
    String phoneNumber,
    String otpCode,
    String newPassword,
  ) async {
    try {
      await ApiService.post(
        _resetPasswordEndpoint,
        body: {
          'phoneNumber': phoneNumber,
          'otpCode': otpCode,
          'newPassword': newPassword,
        },
      );
    } catch (e) {
      rethrow;
    }
  }
}
