// lib/models/training_session.dart

class TrainingSession {
  final int sessionId;
  final int coachId;
  final int fieldId;
  final String sessionDate;
  final String startTime;
  final String endTime;
  final String sportType;
  final String? description;
  final double price;
  final int maxParticipants;
  final int currentParticipants;
  final bool isActive;

  TrainingSession({
    required this.sessionId,
    required this.coachId,
    required this.fieldId,
    required this.sessionDate,
    required this.startTime,
    required this.endTime,
    required this.sportType,
    this.description,
    required this.price,
    required this.maxParticipants,
    required this.currentParticipants,
    required this.isActive,
  });

  factory TrainingSession.fromJson(Map<String, dynamic> json) {
    return TrainingSession(
      sessionId: json['session_id'],
      coachId: json['coach_id'],
      fieldId: json['field_id'],
      sessionDate: json['session_date'],
      startTime: json['start_time'],
      endTime: json['end_time'],
      sportType: json['sport_type'],
      description: json['description'],
      price: json['price'].toDouble(),
      maxParticipants: json['max_participants'],
      currentParticipants: json['current_participants'],
      isActive: json['is_active'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'coach_id': coachId,
      'field_id': fieldId,
      'session_date': sessionDate,
      'start_time': startTime,
      'end_time': endTime,
      'sport_type': sportType,
      'description': description,
      'price': price,
      'max_participants': maxParticipants,
      'current_participants': currentParticipants,
      'is_active': isActive,
    };
  }
}
