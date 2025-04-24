// lib/services/match_service.dart

import 'api_service.dart';
import '../models/match.dart';
import '../models/user.dart';

class MatchService {
  // Get all matches for the current user
  static Future<List<Match>> getUserMatches() async {
    return await ApiService.getUserMatches();
  }

  // Create a new match
  static Future<Match> createMatch({
    required int fieldId,
    required int team1Id,
    int? team2Id,
    required String matchDate,
    required String matchTime,
  }) async {
    final matchData = {
      'field_id': fieldId,
      'team1_id': team1Id,
      if (team2Id != null) 'team2_id': team2Id,
      'match_date': matchDate,
      'match_time': matchTime,
    };

    return await ApiService.createMatch(matchData);
  }

  // Find matching opponents
  static Future<List<Player>> findMatchingPlayers() async {
    return await ApiService.findMatchingPlayers();
  }
}
