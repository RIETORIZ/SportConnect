// lib/models/player.dart

class Player {
  final int playerId;
  final int userId;
  final String username;
  final String email;
  final String? experienceLevel;
  final int? age;
  final String? gender;
  final String? location;
  final List<String>? preferredSports;
  final String? profileImage;
  final bool isLookingForTeam;

  Player({
    required this.playerId,
    required this.userId,
    required this.username,
    required this.email,
    this.experienceLevel,
    this.age,
    this.gender,
    this.location,
    this.preferredSports,
    this.profileImage,
    required this.isLookingForTeam,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    List<String>? sportsList;
    if (json['preferred_sports'] != null) {
      sportsList = List<String>.from(json['preferred_sports']);
    }

    return Player(
      playerId: json['player_id'],
      userId: json['user_id'],
      username: json['username'],
      email: json['email'],
      experienceLevel: json['experience_level'],
      age: json['age'],
      gender: json['gender'],
      location: json['location'],
      preferredSports: sportsList,
      profileImage: json['profile_image'],
      isLookingForTeam: json['is_looking_for_team'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'player_id': playerId,
      'user_id': userId,
      'username': username,
      'email': email,
      'experience_level': experienceLevel,
      'age': age,
      'gender': gender,
      'location': location,
      'preferred_sports': preferredSports,
      'profile_image': profileImage,
      'is_looking_for_team': isLookingForTeam,
    };
  }
}
