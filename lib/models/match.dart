// lib/models/match.dart

class Match {
  final int matchId;
  final int fieldId;
  final int team1Id;
  final int team2Id;
  final DateTime matchDate;
  final String matchTime;
  String? fieldName; // Not from DB, but useful for UI
  String? team1Name; // Not from DB, but useful for UI
  String? team2Name; // Not from DB, but useful for UI

  Match({
    required this.matchId,
    required this.fieldId,
    required this.team1Id,
    required this.team2Id,
    required this.matchDate,
    required this.matchTime,
    this.fieldName,
    this.team1Name,
    this.team2Name,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      matchId: json['match_id'],
      fieldId: json['field_id'],
      team1Id: json['team1_id'],
      team2Id: json['team2_id'],
      matchDate: DateTime.parse(json['match_date']),
      matchTime: json['match_time'],
      fieldName: json['field_name'],
      team1Name: json['team1_name'],
      team2Name: json['team2_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'match_id': matchId,
      'field_id': fieldId,
      'team1_id': team1Id,
      'team2_id': team2Id,
      'match_date':
          matchDate.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
      'match_time': matchTime,
    };
  }
}

// lib/models/training_session.dart

class TrainingSession {
  final int sessionId;
  final int coachId;
  final int teamId;
  final DateTime trainingDate;
  final String trainingTime;
  final int fieldId;
  String? coachName; // Not from DB, but useful for UI
  String? teamName; // Not from DB, but useful for UI
  String? fieldName; // Not from DB, but useful for UI

  TrainingSession({
    required this.sessionId,
    required this.coachId,
    required this.teamId,
    required this.trainingDate,
    required this.trainingTime,
    required this.fieldId,
    this.coachName,
    this.teamName,
    this.fieldName,
  });

  factory TrainingSession.fromJson(Map<String, dynamic> json) {
    return TrainingSession(
      sessionId: json['session_id'],
      coachId: json['coach_id'],
      teamId: json['team_id'],
      trainingDate: DateTime.parse(json['training_date']),
      trainingTime: json['training_time'],
      fieldId: json['field_id'],
      coachName: json['coach_name'],
      teamName: json['team_name'],
      fieldName: json['field_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'session_id': sessionId,
      'coach_id': coachId,
      'team_id': teamId,
      'training_date':
          trainingDate.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
      'training_time': trainingTime,
      'field_id': fieldId,
    };
  }
}
