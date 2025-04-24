// lib/models/user.dart

class User {
  final int userId;
  final String username;
  final String email;
  final String? phoneNumber;
  final String? region;
  final int? age;
  final String? gender;

  User({
    required this.userId,
    required this.username,
    required this.email,
    this.phoneNumber,
    this.region,
    this.age,
    this.gender,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_id'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      region: json['region'],
      age: json['age'],
      gender: json['gender'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'username': username,
      'email': email,
      'phone_number': phoneNumber,
      'region': region,
      'age': age,
      'gender': gender,
    };
  }
}

class Player extends User {
  final String? preferredSports;
  final String? experienceLevel;

  Player({
    required int userId,
    required String username,
    required String email,
    String? phoneNumber,
    String? region,
    int? age,
    String? gender,
    this.preferredSports,
    this.experienceLevel,
  }) : super(
          userId: userId,
          username: username,
          email: email,
          phoneNumber: phoneNumber,
          region: region,
          age: age,
          gender: gender,
        );

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      userId: json['user_id'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      region: json['region'],
      age: json['age'],
      gender: json['gender'],
      preferredSports: json['preferred_sports'],
      experienceLevel: json['experience_level'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({
      'preferred_sports': preferredSports,
      'experience_level': experienceLevel,
    });
    return data;
  }
}

class Coach extends User {
  final String? specialization;
  final int? yearsOfExperience;
  final String? certifications;
  final double review;
  final double rating;

  Coach({
    required int userId,
    required String username,
    required String email,
    String? phoneNumber,
    String? region,
    int? age,
    String? gender,
    this.specialization,
    this.yearsOfExperience,
    this.certifications,
    this.review = 0.0,
    this.rating = 0.0,
  }) : super(
          userId: userId,
          username: username,
          email: email,
          phoneNumber: phoneNumber,
          region: region,
          age: age,
          gender: gender,
        );

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      userId: json['user_id'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      region: json['region'],
      age: json['age'],
      gender: json['gender'],
      specialization: json['specialization'],
      yearsOfExperience: json['years_of_experience'],
      certifications: json['certifications'],
      review: json['review']?.toDouble() ?? 0.0,
      rating: json['rating']?.toDouble() ?? 0.0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({
      'specialization': specialization,
      'years_of_experience': yearsOfExperience,
      'certifications': certifications,
      'review': review,
      'rating': rating,
    });
    return data;
  }
}

class Renter extends User {
  final String? businessName;
  final String? contactInfo;
  final int fieldsOwned;
  final double rating;

  Renter({
    required int userId,
    required String username,
    required String email,
    String? phoneNumber,
    String? region,
    int? age,
    String? gender,
    this.businessName,
    this.contactInfo,
    this.fieldsOwned = 0,
    this.rating = 0.0,
  }) : super(
          userId: userId,
          username: username,
          email: email,
          phoneNumber: phoneNumber,
          region: region,
          age: age,
          gender: gender,
        );

  factory Renter.fromJson(Map<String, dynamic> json) {
    return Renter(
      userId: json['user_id'],
      username: json['username'],
      email: json['email'],
      phoneNumber: json['phone_number'],
      region: json['region'],
      age: json['age'],
      gender: json['gender'],
      businessName: json['business_name'],
      contactInfo: json['contact_info'],
      fieldsOwned: json['fields_owned'] ?? 0,
      rating: json['rating']?.toDouble() ?? 0.0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data.addAll({
      'business_name': businessName,
      'contact_info': contactInfo,
      'fields_owned': fieldsOwned,
      'rating': rating,
    });
    return data;
  }
}
