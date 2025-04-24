// lib/models/team.dart

class Team {
  final int teamId;
  final String teamName;
  final int? coachId;
  final String? location;
  final List<int> playerIds;
  final String? region;
  String? coachName; // Not from DB, but useful for UI
  List<String>? playerNames; // Not from DB, but useful for UI

  Team({
    required this.teamId,
    required this.teamName,
    this.coachId,
    this.location,
    required this.playerIds,
    this.region,
    this.coachName,
    this.playerNames,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      teamId: json['team_id'],
      teamName: json['team_name'],
      coachId: json['coach_id'],
      location: json['location'],
      playerIds: List<int>.from(json['player_id'] ?? []),
      region: json['region'],
      coachName: json['coach_name'],
      playerNames: json['player_names'] != null
          ? List<String>.from(json['player_names'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team_id': teamId,
      'team_name': teamName,
      'coach_id': coachId,
      'location': location,
      'player_id': playerIds,
      'region': region,
    };
  }
}

class TeamMember {
  final int teamMemberId;
  final int teamId;
  final int userId;
  final DateTime joinedAt;

  TeamMember({
    required this.teamMemberId,
    required this.teamId,
    required this.userId,
    required this.joinedAt,
  });

  factory TeamMember.fromJson(Map<String, dynamic> json) {
    return TeamMember(
      teamMemberId: json['team_member_id'],
      teamId: json['team_id'],
      userId: json['user_id'],
      joinedAt: DateTime.parse(json['joined_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team_member_id': teamMemberId,
      'team_id': teamId,
      'user_id': userId,
      'joined_at':
          joinedAt.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
    };
  }
}
