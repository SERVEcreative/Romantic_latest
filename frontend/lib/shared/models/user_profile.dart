class UserProfile {
  final String id;
  final String name;
  final String fullName;
  final int age;
  final String gender;
  final String location;
  final String bio;
  final String image;
  final String? photoUrl;
  final bool online;
  final String lastSeen;

  UserProfile({
    required this.id,
    required this.name,
    required this.fullName,
    required this.age,
    required this.gender,
    required this.location,
    required this.bio,
    required this.image,
    this.photoUrl,
    required this.online,
    required this.lastSeen,
  });

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
      online: map['online'] ?? false,
      lastSeen: map['lastSeen'] ?? '',
    );
  }

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
      'online': online,
      'lastSeen': lastSeen,
    };
  }
}
