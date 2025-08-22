class UserProfile {
  final String name;
  final int age;
  final String location;
  final String bio;
  final String image;
  final bool online;
  final String lastSeen;

  UserProfile({
    required this.name,
    required this.age,
    required this.location,
    required this.bio,
    required this.image,
    required this.online,
    required this.lastSeen,
  });

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      location: map['location'] ?? '',
      bio: map['bio'] ?? '',
      image: map['image'] ?? '',
      online: map['online'] ?? false,
      lastSeen: map['lastSeen'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'location': location,
      'bio': bio,
      'image': image,
      'online': online,
      'lastSeen': lastSeen,
    };
  }
}
