// lib/services/team_service.dart

import 'dart:convert';
import 'api_service.dart';
import 'api_client.dart';
import '../models/team.dart';

class TeamService {
  static final ApiClient _client = ApiClient();

  // Get all teams for the current user
  static Future<List<Team>> getUserTeams() async {
    return await ApiService.getUserTeams();
  }

  // Get details of a specific team
  static Future<Team> getTeamDetails(int teamId) async {
    return await ApiService.getTeamDetails(teamId);
  }

  // Create a new team
  static Future<Team> createTeam({
    required String teamName,
    required String location,
    String? region,
    int? coachId,
    List<int>? playerIds,
  }) async {
    final teamData = {
      'team_name': teamName,
      'location': location,
      if (region != null) 'region': region,
      if (coachId != null) 'coach_id': coachId,
      if (playerIds != null) 'player_id': playerIds,
    };

    return await ApiService.createTeam(teamData);
  }

  // Join an existing team
  static Future<Map<String, dynamic>> joinTeam(int teamId) async {
    return await ApiService.joinTeam(teamId);
  }

  // Add a player to team (for coaches)
  static Future<Map<String, dynamic>> addPlayerToTeam(
      int teamId, int playerId) async {
    try {
      // Get team details
      final team = await ApiService.getTeamDetails(teamId);

      // Extract player IDs
      final currentPlayers = List<int>.from(team.playerIds);

      // Add player if not already included
      if (!currentPlayers.contains(playerId)) {
        currentPlayers.add(playerId);
      }

      // Update the team with the new player list
      return await _client.patch(
        'teams/$teamId/',
        data: {
          'player_id': currentPlayers,
        },
      );
    } catch (e) {
      print('Add player to team error: $e');
      throw Exception('Failed to add player to team: $e');
    }
  }
}
