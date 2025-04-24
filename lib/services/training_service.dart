// lib/services/training_service.dart

import 'api_service.dart';
import 'api_client.dart';
import '../models/match.dart';

class TrainingService {
  static final ApiClient _client = ApiClient();

  // Get all training sessions for the current user
  static Future<List<TrainingSession>> getTrainingSessions() async {
    return await ApiService.getTrainingSessions();
  }

  // Create a new training session (for coaches)
  static Future<TrainingSession> createTrainingSession({
    required int coachId,
    required int teamId,
    required String trainingDate,
    required String trainingTime,
    required int fieldId,
  }) async {
    final sessionData = {
      'coach_id': coachId,
      'team_id': teamId,
      'training_date': trainingDate,
      'training_time': trainingTime,
      'field_id': fieldId,
    };

    return await ApiService.createTrainingSession(sessionData);
  }

  // Invite player to training session
  static Future<Map<String, dynamic>> invitePlayerToTraining(
      int sessionId, int playerId) async {
    try {
      // This would be a custom endpoint in your Django backend
      return await _client.post(
        'training/$sessionId/invite/',
        data: {
          'player_id': playerId,
        },
      );
    } catch (e) {
      print('Invite player to training error: $e');
      throw Exception('Failed to invite player to training: $e');
    }
  }
}
