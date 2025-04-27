// lib/models/coach.dart

class Coach {
  final int coachId;
  final int userId;
  final String username;
  final String email;
  final String? specialization;
  final String? experienceLevel;
  final double? rating;
  final String? bio;
  final String? profileImage;
  final String? location;
  final List<String>? sportTypes;
  final bool isAvailable;

  Coach({
    required this.coachId,
    required this.userId,
    required this.username,
    required this.email,
    this.specialization,
    this.experienceLevel,
    this.rating,
    this.bio,
    this.profileImage,
    this.location,
    this.sportTypes,
    required this.isAvailable,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    List<String>? sportTypesList;
    if (json['sport_types'] != null) {
      sportTypesList = List<String>.from(json['sport_types']);
    }

    return Coach(
      coachId: json['coach_id'],
      userId: json['user_id'],
      username: json['username'],
      email: json['email'],
      specialization: json['specialization'],
      experienceLevel: json['experience_level'],
      rating: json['rating'] != null ? json['rating'].toDouble() : null,
      bio: json['bio'],
      profileImage: json['profile_image'],
      location: json['location'],
      sportTypes: sportTypesList,
      isAvailable: json['is_available'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'coach_id': coachId,
      'user_id': userId,
      'username': username,
      'email': email,
      'specialization': specialization,
      'experience_level': experienceLevel,
      'rating': rating,
      'bio': bio,
      'profile_image': profileImage,
      'location': location,
      'sport_types': sportTypes,
      'is_available': isAvailable,
    };
  }
}
