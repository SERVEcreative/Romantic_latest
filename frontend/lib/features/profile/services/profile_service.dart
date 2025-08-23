import '../models/user_profile_model.dart';

class ProfileService {

  // Singleton pattern
  static final ProfileService _instance = ProfileService._internal();
  factory ProfileService() => _instance;
  ProfileService._internal();

  // Mock current user profile
  static UserProfileModel get currentUser => UserProfileModel(
        id: 'current_user_1',
        name: 'John Doe',
        fullName: 'John Michael Doe',
        age: 28,
        gender: 'male',
        location: 'New York, NY',
        bio: 'Love traveling, coffee, and meeting new people! ☕✈️',
        image: 'assets/images/profile2.jpeg',
        photoUrl: null,
        online: true,
        lastSeen: '2 min ago',
        email: 'john.doe@example.com',
        phoneNumber: '+1234567890',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
        updatedAt: DateTime.now(),
      );

  /// Get current user profile
  Future<UserProfileModel> getCurrentUserProfile() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    return currentUser;
  }

  /// Update user profile
  Future<UserProfileModel> updateProfile({
    required String name,
    required String fullName,
    required int age,
    required String gender,
    required String location,
    required String bio,
    String? image,
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    return currentUser.copyWith(
      name: name,
      fullName: fullName,
      age: age,
      gender: gender,
      location: location,
      bio: bio,
      image: image ?? currentUser.image,
      updatedAt: DateTime.now(),
    );
  }

  /// Update profile image
  Future<UserProfileModel> updateProfileImage(String imagePath) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 1000));
    
    return currentUser.copyWith(
      image: imagePath,
      updatedAt: DateTime.now(),
    );
  }

  /// Delete account
  Future<bool> deleteAccount() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 1200));
    
    // In real app, this would call the API to delete the account
    return true;
  }

  /// Logout user
  Future<bool> logout() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // In real app, this would clear tokens and call logout API
    return true;
  }

  /// Get user preferences
  Future<Map<String, dynamic>> getUserPreferences() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    return {
      'notifications': {
        'push': true,
        'email': false,
        'sms': true,
      },
      'privacy': {
        'profileVisibility': 'public',
        'showOnlineStatus': true,
        'showLastSeen': true,
      },
      'app': {
        'theme': 'light',
        'language': 'en',
        'autoPlayVideos': true,
      },
    };
  }

  /// Update user preferences
  Future<Map<String, dynamic>> updateUserPreferences(
    Map<String, dynamic> preferences,
  ) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    // In real app, this would call the API to update preferences
    return preferences;
  }

  /// Get account statistics
  Future<Map<String, dynamic>> getAccountStatistics() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    return {
      'totalMatches': 45,
      'totalLikes': 128,
      'totalViews': 567,
      'accountAge': '30 days',
      'lastActive': '2 min ago',
      'profileCompleteness': 85,
    };
  }

  /// Report a user
  Future<bool> reportUser({
    required String userId,
    required String reason,
    String? description,
  }) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // In real app, this would call the API to report the user
    return true;
  }

  /// Block a user
  Future<bool> blockUser(String userId) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // In real app, this would call the API to block the user
    return true;
  }

  /// Unblock a user
  Future<bool> unblockUser(String userId) async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // In real app, this would call the API to unblock the user
    return true;
  }

  /// Get blocked users list
  Future<List<UserProfileModel>> getBlockedUsers() async {
    // Simulate API call delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Return empty list for now
    return [];
  }
}
