// lib/services/api_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'api_client.dart';
import '../models/sports_field.dart';
import '../models/team.dart';
import '../models/user.dart';
import '../models/message.dart';
import '../models/match.dart';
import '../models/booking.dart';

class ApiService {
  static final ApiClient _client = ApiClient();

  // Make the base URL easily accessible
  static String get baseUrl => ApiClient.baseUrl;

  // Authentication Methods

  // Login method
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      print("Attempting login to: $baseUrl/auth/login/");
      print("With email: $email");

      // Make sure we're sending the data in the EXACT format the backend expects
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      // Improved error handling
      final statusCode = response.statusCode;
      print("Login response status: $statusCode");

      if (response.body.isNotEmpty) {
        try {
          final responseData = jsonDecode(response.body);
          print("Login response body: $responseData");

          // Success case
          if (statusCode >= 200 && statusCode < 300) {
            // Save auth token if present
            if (responseData != null && responseData.containsKey('token')) {
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('authToken', responseData['token']);
            }
            return responseData;
          } else {
            // Error case
            final errorMessage = responseData.containsKey('detail')
                ? responseData['detail']
                : 'Request failed with status: $statusCode';
            throw Exception(errorMessage);
          }
        } catch (e) {
          // JSON decode error
          print("JSON decode error: $e");
          print("Raw response: ${response.body}");
          throw Exception('Failed to parse login response: $e');
        }
      } else {
        throw Exception('Empty response with status: $statusCode');
      }
    } catch (e) {
      print('Login error: $e');
      throw Exception('Failed to login: $e');
    }
  }

  // Register method
  static Future<Map<String, dynamic>> register(
      String username, String email, String password, String role,
      {Map<String, dynamic>? additionalData}) async {
    try {
      print("Attempting registration to: $baseUrl/auth/register/");
      print("With email: $email, username: $username, role: $role");

      final Map<String, dynamic> registrationData = {
        'username': username,
        'email': email,
        'password': password,
        'role': role,
      };

      // If additionalData is provided, merge it with registrationData
      if (additionalData != null) {
        registrationData.addAll(additionalData);
      }

      // Use the client to register with full data
      return await _client.post('auth/register/',
          data: registrationData, requiresAuth: false);
    } catch (e) {
      print('Registration error: $e');
      throw Exception('Failed to register: $e');
    }
  }

  // Logout method
  static Future<void> logout() async {
    try {
      await _client.logout();
    } catch (e) {
      print('Logout error: $e');
      // Still clear local auth data even if the server request fails
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('authToken');
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('userRole');
      await prefs.remove('loggedInEmail');
    }
  }

  // User Profile Methods

  // Get current user profile
  static Future<Map<String, dynamic>> getUserProfile() async {
    try {
      return await _client.getUserProfile();
    } catch (e) {
      print('Get profile error: $e');
      throw Exception('Failed to load profile: $e');
    }
  }

  // Update user profile
  static Future<Map<String, dynamic>> updateUserProfile(
      Map<String, dynamic> profileData) async {
    try {
      return await _client.updateUserProfile(profileData);
    } catch (e) {
      print('Update profile error: $e');
      throw Exception('Failed to update profile: $e');
    }
  }

  // Sports Field Methods

  // Get all sports fields
  static Future<List<SportsField>> getSportsFields() async {
    try {
      print("Calling API to get sports fields...");
      final fieldsJson = await _client.getAllFields(showAll: true);
      print("Received fields JSON: $fieldsJson");

      return fieldsJson
          .map((fieldJson) {
            try {
              return SportsField.fromJson(fieldJson);
            } catch (e) {
              print("Error parsing field: $e for data: $fieldJson");
              return null;
            }
          })
          .where((field) => field != null)
          .cast<SportsField>()
          .toList();
    } catch (e) {
      print('Get fields error: $e');
      throw Exception('Failed to load sports fields: $e');
    }
  }

  // Get field details
  static Future<SportsField> getFieldDetails(int fieldId) async {
    try {
      final fieldJson = await _client.getFieldDetails(fieldId);
      return SportsField.fromJson(fieldJson);
    } catch (e) {
      print('Get field details error: $e');
      throw Exception('Failed to load field details: $e');
    }
  }

  // Register a new field (for renters)
  static Future<SportsField> registerField(
      Map<String, dynamic> fieldData) async {
    try {
      // Ensure we have a valid token before proceeding
      final isAuthenticated = await _client.ensureValidToken();
      if (!isAuthenticated) {
        throw Exception('You must be logged in to register a field');
      }

      print("Registering field with data: $fieldData");

      // Explicitly set requiresAuth to true
      final registeredFieldJson =
          await _client.post('fields/', data: fieldData, requiresAuth: true);

      // Safe parsing to handle potential null values
      if (registeredFieldJson != null) {
        return SportsField.fromJson(registeredFieldJson);
      } else {
        // Handle null response
        throw Exception('Received null response from server');
      }
    } catch (e) {
      print('Register field error: $e');
      throw Exception('Failed to register field: $e');
    }
  }

  static Future<SportsField> updateField(
      int fieldId, Map<String, dynamic> updateData) async {
    try {
      final updatedFieldJson =
          await _client.patch('fields/$fieldId/', data: updateData);
      return SportsField.fromJson(updatedFieldJson);
    } catch (e) {
      print('Update field error: $e');
      throw Exception('Failed to update field: $e');
    }
  }

  // Delete a field
  static Future<void> deleteField(int fieldId) async {
    try {
      await _client.delete('fields/$fieldId/');
    } catch (e) {
      print('Delete field error: $e');
      throw Exception('Failed to delete field: $e');
    }
  }

  // Team Methods

  // Get user's teams
  static Future<List<Team>> getUserTeams() async {
    try {
      final teamsJson = await _client.getUserTeams();
      return teamsJson.map((teamJson) => Team.fromJson(teamJson)).toList();
    } catch (e) {
      print('Get teams error: $e');
      throw Exception('Failed to load teams: $e');
    }
  }

  // Get team details
  static Future<Team> getTeamDetails(int teamId) async {
    try {
      final teamJson = await _client.get('teams/$teamId/');
      return Team.fromJson(teamJson);
    } catch (e) {
      print('Get team details error: $e');
      throw Exception('Failed to load team details: $e');
    }
  }

  // Create a new team
  static Future<Team> createTeam(Map<String, dynamic> teamData) async {
    try {
      final createdTeamJson = await _client.createTeam(teamData);
      return Team.fromJson(createdTeamJson);
    } catch (e) {
      print('Create team error: $e');
      throw Exception('Failed to create team: $e');
    }
  }

  // Join a team
  static Future<Map<String, dynamic>> joinTeam(int teamId) async {
    try {
      return await _client.joinTeam(teamId);
    } catch (e) {
      print('Join team error: $e');
      throw Exception('Failed to join team: $e');
    }
  }

  // Match Methods

  // Get user's matches
  static Future<List<Match>> getUserMatches() async {
    try {
      final matchesJson = await _client.getUserMatches();
      return matchesJson.map((matchJson) => Match.fromJson(matchJson)).toList();
    } catch (e) {
      print('Get matches error: $e');
      throw Exception('Failed to load matches: $e');
    }
  }

  // Create a match
  static Future<Match> createMatch(Map<String, dynamic> matchData) async {
    try {
      final createdMatchJson = await _client.createMatch(matchData);
      return Match.fromJson(createdMatchJson);
    } catch (e) {
      print('Create match error: $e');
      throw Exception('Failed to create match: $e');
    }
  }

  // Training Sessions Methods

  // Get training sessions (for players or coaches)
  static Future<List<TrainingSession>> getTrainingSessions() async {
    try {
      final sessionsJson = await _client.getTrainingSessions();
      return sessionsJson
          .map((sessionJson) => TrainingSession.fromJson(sessionJson))
          .toList();
    } catch (e) {
      print('Get training sessions error: $e');
      throw Exception('Failed to load training sessions: $e');
    }
  }

  // Create a training session (for coaches)
  static Future<TrainingSession> createTrainingSession(
      Map<String, dynamic> sessionData) async {
    try {
      final createdSessionJson =
          await _client.createTrainingSession(sessionData);
      return TrainingSession.fromJson(createdSessionJson);
    } catch (e) {
      print('Create training session error: $e');
      throw Exception('Failed to create training session: $e');
    }
  }

  // Booking Methods

  // Get user's bookings
  static Future<List<FieldBooking>> getUserBookings() async {
    try {
      final bookingsJson = await _client.getUserBookings();
      return bookingsJson
          .map((bookingJson) => FieldBooking.fromJson(bookingJson))
          .toList();
    } catch (e) {
      print('Get bookings error: $e');
      throw Exception('Failed to load bookings: $e');
    }
  }

  // Create a booking
  static Future<FieldBooking> createBooking(
      Map<String, dynamic> bookingData) async {
    try {
      final createdBookingJson = await _client.createBooking(bookingData);
      return FieldBooking.fromJson(createdBookingJson);
    } catch (e) {
      print('Create booking error: $e');
      throw Exception('Failed to create booking: $e');
    }
  }

  // Direct Message Methods

  // Get user's conversations
  static Future<List<Conversation>> getConversations() async {
    try {
      final conversationsJson = await _client.getConversations();
      return conversationsJson
          .map((convJson) => Conversation.fromJson(convJson))
          .toList();
    } catch (e) {
      print('Get conversations error: $e');
      throw Exception('Failed to load conversations: $e');
    }
  }

  // Get conversation with a specific user
  static Future<List<DirectMessage>> getConversation(int userId) async {
    try {
      final messagesJson = await _client.getConversation(userId);
      return messagesJson
          .map((msgJson) => DirectMessage.fromJson(msgJson))
          .toList();
    } catch (e) {
      print('Get conversation error: $e');
      throw Exception('Failed to load conversation: $e');
    }
  }

  // Send a message
  static Future<DirectMessage> sendMessage(
      int receiverId, String message) async {
    try {
      final sentMessageJson = await _client.sendMessage(receiverId, message);
      return DirectMessage.fromJson(sentMessageJson);
    } catch (e) {
      print('Send message error: $e');
      throw Exception('Failed to send message: $e');
    }
  }

  // Recommendation Methods

  // Get recommended fields
  static Future<List<SportsField>> getRecommendedFields() async {
    try {
      final fieldsJson = await _client.getRecommendedFields();
      return fieldsJson
          .map((fieldJson) => SportsField.fromJson(fieldJson))
          .toList();
    } catch (e) {
      print('Get recommended fields error: $e');
      throw Exception('Failed to load recommended fields: $e');
    }
  }

  // Get recommended coaches
  static Future<List<Coach>> getRecommendedCoaches() async {
    try {
      final coachesJson = await _client.get('recommendations/coaches/');
      return coachesJson.map((coachJson) => Coach.fromJson(coachJson)).toList();
    } catch (e) {
      print('Get recommended coaches error: $e');
      throw Exception('Failed to load recommended coaches: $e');
    }
  }

  // Find match for player
  static Future<List<Player>> findMatchingPlayers() async {
    try {
      final playersJson = await _client.get('recommendations/players/');
      return playersJson
          .map((playerJson) => Player.fromJson(playerJson))
          .toList();
    } catch (e) {
      print('Find matching players error: $e');
      throw Exception('Failed to find matching players: $e');
    }
  }

  static Future<List<dynamic>> getTeamMatches(
      {String? sport,
      String? region,
      String? experienceLevel,
      int? teamId, // Add this parameter
      int numResults = 5}) async {
    try {
      // Build query parameters
      final queryParams = {
        if (sport != null) 'sport': sport,
        if (region != null) 'region': region,
        if (experienceLevel != null) 'experience_level': experienceLevel,
        if (teamId != null)
          'team_id': teamId.toString(), // Add team_id to query
        'num_results': numResults.toString(),
      };

      // Convert query parameters to URL format
      final queryString = queryParams.entries
          .map((e) =>
              '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
          .join('&');

      // Make API call
      final result = await _client.get('teams/matchmaking/?$queryString');
      return result;
    } catch (e) {
      print('Get team matches error: $e');
      throw Exception('Failed to load team matches: $e');
    }
  }

  // Get all available fields (for player and coach view)
  static Future<List<SportsField>> getAvailableFields() async {
    try {
      final fieldsJson = await _client.get('fields/?available_for_female=true');
      return fieldsJson
          .map((fieldJson) => SportsField.fromJson(fieldJson))
          .toList();
    } catch (e) {
      print('Get available fields error: $e');
      throw Exception('Failed to load available fields: $e');
    }
  }
}
