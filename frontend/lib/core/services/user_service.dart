import 'api_service.dart';
import '../models/user_models.dart';
import '../../shared/models/user_profile.dart';

class UserService {
  // API Endpoints
  static const String _profileEndpoint = '/user/profile';
  static const String _updateProfileEndpoint = '/user/profile';
  static const String _uploadPhotoEndpoint = '/user/upload-photo';
  static const String _superLoverEndpoint = '/user/super-lover';
  static const String _superLoverStatusEndpoint = '/user/super-lover/status';
  static const String _superLoverBioEndpoint = '/user/super-lover/bio';
  static const String _availableSuperLoversEndpoint = '/user/super-lovers';
  static const String _blockUserEndpoint = '/user/block';
  static const String _unblockUserEndpoint = '/user/unblock';
  static const String _blockedUsersEndpoint = '/user/blocked';

  /// Get user profile
  static Future<UserProfile> getProfile() async {
    try {
      final response = await ApiService.get(_profileEndpoint);
      return UserProfile.fromMap(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Update user profile
  static Future<UserProfile> updateProfile(Map<String, dynamic> profileData) async {
    try {
      final response = await ApiService.put(
        _updateProfileEndpoint,
        body: profileData,
      );
      return UserProfile.fromMap(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Upload profile photo
  static Future<String> uploadPhoto(String filePath) async {
    try {
      // TODO: Implement file upload logic
      final response = await ApiService.post(
        _uploadPhotoEndpoint,
        body: {
          'photoPath': filePath,
        },
      );
      return response['photoUrl'] ?? '';
    } catch (e) {
      rethrow;
    }
  }

  /// Become Super Lover
  static Future<SuperLoverData> becomeSuperLover() async {
    try {
      final response = await ApiService.post(_superLoverEndpoint);
      return SuperLoverData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Update Super Lover status
  static Future<SuperLoverData> updateSuperLoverStatus(String status) async {
    try {
      final response = await ApiService.put(
        _superLoverStatusEndpoint,
        body: {
          'status': status,
        },
      );
      return SuperLoverData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Update Super Lover bio
  static Future<SuperLoverData> updateSuperLoverBio(String bio) async {
    try {
      final response = await ApiService.put(
        _superLoverBioEndpoint,
        body: {
          'bio': bio,
        },
      );
      return SuperLoverData.fromJson(response);
    } catch (e) {
      rethrow;
    }
  }

  /// Get available Super Lovers
  static Future<List<UserProfile>> getAvailableSuperLovers({
    int page = 1,
    int limit = 20,
    String? status,
  }) async {
    try {
      final response = await ApiService.get(
        _availableSuperLoversEndpoint,
        queryParameters: {
          'page': page,
          'limit': limit,
          if (status != null) 'status': status,
        },
      );
      
      final List<dynamic> usersData = response['users'] ?? [];
      return usersData.map((user) => UserProfile.fromMap(user)).toList();
    } catch (e) {
      rethrow;
    }
  }

  /// Block a user
  static Future<void> blockUser(String userId) async {
    try {
      await ApiService.post(
        _blockUserEndpoint,
        body: {
          'userId': userId,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Unblock a user
  static Future<void> unblockUser(String userId) async {
    try {
      await ApiService.post(
        _unblockUserEndpoint,
        body: {
          'userId': userId,
        },
      );
    } catch (e) {
      rethrow;
    }
  }

  /// Get blocked users list
  static Future<List<UserProfile>> getBlockedUsers() async {
    try {
      final response = await ApiService.get(_blockedUsersEndpoint);
      final List<dynamic> usersData = response['blockedUsers'] ?? [];
      return usersData.map((user) => UserProfile.fromMap(user)).toList();
    } catch (e) {
      rethrow;
    }
  }
}
