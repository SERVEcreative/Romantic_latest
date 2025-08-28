class UserProfile {
  // Basic Profile Information
  final String id;
  final String name;
  final String fullName;
  final int age;
  final String gender;
  final String location;
  final String bio;
  final String image;
  final String? photoUrl;
  
  // Contact Information
  final String email;
  final String phoneNumber;
  
  // Status Information
  final bool online;
  final String lastSeen;
  final bool isVerified;
  
  // Timestamps
  final DateTime createdAt;
  final DateTime updatedAt;
  
  // Super Lover Information
  final bool isSuperLover;
  final String? superLoverStatus; // 'online', 'ready', 'offline'
  final String? superLoverBio;
  final double? superLoverRating;
  final int? superLoverCallCount;
  final int? superLoverTotalEarnings;
  final DateTime? superLoverJoinedAt;

  const UserProfile({
    required this.id,
    required this.name,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.location,
    required this.bio,
    required this.image,
    this.photoUrl,
    required this.email,
    required this.phoneNumber,
    required this.online,
    required this.lastSeen,
    this.isVerified = false,
    required this.createdAt,
    required this.updatedAt,
    this.isSuperLover = false,
    this.superLoverStatus,
    this.superLoverBio,
    this.superLoverRating,
    this.superLoverCallCount,
    this.superLoverTotalEarnings,
    this.superLoverJoinedAt,
  });

  // Factory constructor from API response
  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      fullName: map['fullName'] ?? map['name'] ?? '',
      age: map['age'] ?? 0,
      gender: map['gender'] ?? '',
      location: map['location'] ?? '',
      bio: map['bio'] ?? '',
      image: map['image'] ?? '',
      photoUrl: map['photoUrl'],
      email: map['email'] ?? '',
      phoneNumber: map['phoneNumber'] ?? '',
      online: map['online'] ?? false,
      lastSeen: map['lastSeen'] ?? '',
      isVerified: map['isVerified'] ?? false,
      createdAt: DateTime.tryParse(map['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt'] ?? '') ?? DateTime.now(),
      isSuperLover: map['isSuperLover'] ?? false,
      superLoverStatus: map['superLoverStatus'],
      superLoverBio: map['superLoverBio'],
      superLoverRating: map['superLoverRating']?.toDouble(),
      superLoverCallCount: map['superLoverCallCount'],
      superLoverTotalEarnings: map['superLoverTotalEarnings'],
      superLoverJoinedAt: map['superLoverJoinedAt'] != null 
          ? DateTime.tryParse(map['superLoverJoinedAt']) 
          : null,
    );
  }

  // Convert to API request format
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'fullName': fullName,
      'age': age,
      'gender': gender,
      'location': location,
      'bio': bio,
      'image': image,
      'photoUrl': photoUrl,
      'email': email,
      'phoneNumber': phoneNumber,
      'online': online,
      'lastSeen': lastSeen,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isSuperLover': isSuperLover,
      'superLoverStatus': superLoverStatus,
      'superLoverBio': superLoverBio,
      'superLoverRating': superLoverRating,
      'superLoverCallCount': superLoverCallCount,
      'superLoverTotalEarnings': superLoverTotalEarnings,
      'superLoverJoinedAt': superLoverJoinedAt?.toIso8601String(),
    };
  }

  // Partial update support
  UserProfile copyWith({
    String? id,
    String? name,
    String? fullName,
    int? age,
    String? gender,
    String? location,
    String? bio,
    String? image,
    String? photoUrl,
    String? email,
    String? phoneNumber,
    bool? online,
    String? lastSeen,
    bool? isVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    bool? isSuperLover,
    String? superLoverStatus,
    String? superLoverBio,
    double? superLoverRating,
    int? superLoverCallCount,
    int? superLoverTotalEarnings,
    DateTime? superLoverJoinedAt,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      fullName: fullName ?? this.fullName,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      location: location ?? this.location,
      bio: bio ?? this.bio,
      image: image ?? this.image,
      photoUrl: photoUrl ?? this.photoUrl,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      online: online ?? this.online,
      lastSeen: lastSeen ?? this.lastSeen,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isSuperLover: isSuperLover ?? this.isSuperLover,
      superLoverStatus: superLoverStatus ?? this.superLoverStatus,
      superLoverBio: superLoverBio ?? this.superLoverBio,
      superLoverRating: superLoverRating ?? this.superLoverRating,
      superLoverCallCount: superLoverCallCount ?? this.superLoverCallCount,
      superLoverTotalEarnings: superLoverTotalEarnings ?? this.superLoverTotalEarnings,
      superLoverJoinedAt: superLoverJoinedAt ?? this.superLoverJoinedAt,
    );
  }

  // Convenience methods
  bool get hasSuperLoverData => isSuperLover && superLoverStatus != null;
  bool get isSuperLoverOnline => isSuperLover && superLoverStatus == 'online';
  bool get isSuperLoverReady => isSuperLover && superLoverStatus == 'ready';
  
  // Profile completion percentage
  double get profileCompletionPercentage {
    int completedFields = 0;
    int totalFields = 8; // Basic profile fields
    
    if (name.isNotEmpty) completedFields++;
    if (fullName.isNotEmpty) completedFields++;
    if (age > 0) completedFields++;
    if (gender.isNotEmpty) completedFields++;
    if (location.isNotEmpty) completedFields++;
    if (bio.isNotEmpty) completedFields++;
    if (image.isNotEmpty || photoUrl != null) completedFields++;
    if (email.isNotEmpty) completedFields++;
    
    return completedFields / totalFields;
  }

  // Static factory for current user (mock)
  static UserProfile getCurrentUser() {
    return UserProfile(
      id: 'current_user',
      name: 'Me',
      fullName: 'Current User',
      age: 25,
      gender: 'male',
      bio: 'Love life and adventures!',
      location: 'New York',
      image: '',
      photoUrl: null,
      email: 'user@example.com',
      phoneNumber: '+1234567890',
      online: true,
      lastSeen: 'now',
      createdAt: DateTime.now().subtract(const Duration(days: 60)),
      updatedAt: DateTime.now(),
    );
  }

  // Create from SuperLoverData
  factory UserProfile.fromSuperLoverData(UserProfile base, SuperLoverData superLoverData) {
    return base.copyWith(
      isSuperLover: superLoverData.isSuperLover,
      superLoverStatus: superLoverData.status,
      superLoverBio: superLoverData.bio,
      superLoverRating: superLoverData.rating,
      superLoverCallCount: superLoverData.callCount,
      superLoverTotalEarnings: superLoverData.totalEarnings,
      superLoverJoinedAt: superLoverData.joinedAt,
    );
  }

  @override
  String toString() {
    return 'UserProfile(id: $id, name: $name, fullName: $fullName, age: $age, gender: $gender, location: $location, bio: $bio, image: $image, photoUrl: $photoUrl, online: $online, lastSeen: $lastSeen, email: $email, phoneNumber: $phoneNumber, createdAt: $createdAt, updatedAt: $updatedAt, isSuperLover: $isSuperLover)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.id == id &&
        other.name == name &&
        other.fullName == fullName &&
        other.age == age &&
        other.gender == gender &&
        other.location == location &&
        other.bio == bio &&
        other.image == image &&
        other.photoUrl == photoUrl &&
        other.email == email &&
        other.phoneNumber == phoneNumber &&
        other.online == online &&
        other.lastSeen == lastSeen &&
        other.isVerified == isVerified &&
        other.createdAt == createdAt &&
        other.updatedAt == updatedAt &&
        other.isSuperLover == isSuperLover &&
        other.superLoverStatus == superLoverStatus &&
        other.superLoverBio == superLoverBio &&
        other.superLoverRating == superLoverRating &&
        other.superLoverCallCount == superLoverCallCount &&
        other.superLoverTotalEarnings == superLoverTotalEarnings &&
        other.superLoverJoinedAt == superLoverJoinedAt;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        fullName.hashCode ^
        age.hashCode ^
        gender.hashCode ^
        location.hashCode ^
        bio.hashCode ^
        image.hashCode ^
        photoUrl.hashCode ^
        email.hashCode ^
        phoneNumber.hashCode ^
        online.hashCode ^
        lastSeen.hashCode ^
        isVerified.hashCode ^
        createdAt.hashCode ^
        updatedAt.hashCode ^
        isSuperLover.hashCode ^
        superLoverStatus.hashCode ^
        superLoverBio.hashCode ^
        superLoverRating.hashCode ^
        superLoverCallCount.hashCode ^
        superLoverTotalEarnings.hashCode ^
        superLoverJoinedAt.hashCode;
  }
}

// Keep SuperLoverData for specialized operations
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
