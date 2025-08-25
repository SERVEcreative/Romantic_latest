class OtpResponse {
  final bool success;
  final String message;
  final String? otpId;
  final int? expiresIn;
  final String? phoneNumber;

  OtpResponse({
    required this.success,
    required this.message,
    this.otpId,
    this.expiresIn,
    this.phoneNumber,
  });

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      otpId: json['otpId'],
      expiresIn: json['expiresIn'],
      phoneNumber: json['phoneNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'otpId': otpId,
      'expiresIn': expiresIn,
      'phoneNumber': phoneNumber,
    };
  }
}

class AuthResponse {
  final bool success;
  final String message;
  final String? accessToken;
  final String? refreshToken;
  final UserData? user;
  final int? expiresIn;

  AuthResponse({
    required this.success,
    required this.message,
    this.accessToken,
    this.refreshToken,
    this.user,
    this.expiresIn,
  });

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
      user: json['user'] != null ? UserData.fromJson(json['user']) : null,
      expiresIn: json['expiresIn'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
      'user': user?.toJson(),
      'expiresIn': expiresIn,
    };
  }
}

class UserData {
  final String id;
  final String phoneNumber;
  final String? name;
  final String? email;
  final bool isVerified;
  final bool isSuperLover;
  final String? profileImage;
  final DateTime? createdAt;
  final DateTime? lastLoginAt;

  UserData({
    required this.id,
    required this.phoneNumber,
    this.name,
    this.email,
    required this.isVerified,
    required this.isSuperLover,
    this.profileImage,
    this.createdAt,
    this.lastLoginAt,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      id: json['id'] ?? '',
      phoneNumber: json['phoneNumber'] ?? '',
      name: json['name'],
      email: json['email'],
      isVerified: json['isVerified'] ?? false,
      isSuperLover: json['isSuperLover'] ?? false,
      profileImage: json['profileImage'],
      createdAt: json['createdAt'] != null 
          ? DateTime.parse(json['createdAt']) 
          : null,
      lastLoginAt: json['lastLoginAt'] != null 
          ? DateTime.parse(json['lastLoginAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phoneNumber': phoneNumber,
      'name': name,
      'email': email,
      'isVerified': isVerified,
      'isSuperLover': isSuperLover,
      'profileImage': profileImage,
      'createdAt': createdAt?.toIso8601String(),
      'lastLoginAt': lastLoginAt?.toIso8601String(),
    };
  }
}
