import '../../shared/models/user_profile.dart';

class SuperLoverData {
  final bool isSuperLover;
  final String? status; // 'online', 'ready', 'offline'
  final String? bio;
  final double? rating;
  final int? callCount;
  final int? totalEarnings;
  final DateTime? joinedAt;

  SuperLoverData({
    required this.isSuperLover,
    this.status,
    this.bio,
    this.rating,
    this.callCount,
    this.totalEarnings,
    this.joinedAt,
  });

  factory SuperLoverData.fromJson(Map<String, dynamic> json) {
    return SuperLoverData(
      isSuperLover: json['isSuperLover'] ?? false,
      status: json['status'],
      bio: json['bio'],
      rating: json['rating']?.toDouble(),
      callCount: json['callCount'],
      totalEarnings: json['totalEarnings'],
      joinedAt: json['joinedAt'] != null 
          ? DateTime.parse(json['joinedAt']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuperLover': isSuperLover,
      'status': status,
      'bio': bio,
      'rating': rating,
      'callCount': callCount,
      'totalEarnings': totalEarnings,
      'joinedAt': joinedAt?.toIso8601String(),
    };
  }
}

class ProfileUpdateRequest {
  final String? name;
  final String? email;
  final int? age;
  final String? gender;
  final String? location;
  final String? bio;
  final String? profileImage;

  ProfileUpdateRequest({
    this.name,
    this.email,
    this.age,
    this.gender,
    this.location,
    this.bio,
    this.profileImage,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    if (name != null) data['name'] = name;
    if (email != null) data['email'] = email;
    if (age != null) data['age'] = age;
    if (gender != null) data['gender'] = gender;
    if (location != null) data['location'] = location;
    if (bio != null) data['bio'] = bio;
    if (profileImage != null) data['profileImage'] = profileImage;
    return data;
  }
}

class BlockUserRequest {
  final String userId;
  final String? reason;

  BlockUserRequest({
    required this.userId,
    this.reason,
  });

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      if (reason != null) 'reason': reason,
    };
  }
}
