// lib/services/api_client.dart

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiClient {
  // Base URL for the API - adjust this to match your Django server
  static String get baseUrl {
    // Determine the base URL based on the platform
    if (kIsWeb) {
      return 'http://localhost:8000/api'; // For web
    } else if (Platform.isAndroid) {
      return 'http://10.0.2.2:8000/api'; // For Android emulator
    } else {
      return 'http://localhost:8000/api'; // For iOS and others
    }
  }

  // HTTP client
  final http.Client _client = http.Client();

  // Singleton pattern
  static final ApiClient _instance = ApiClient._internal();

  factory ApiClient() {
    return _instance;
  }

  ApiClient._internal();

  // Get auth token from SharedPreferences
  Future<String?> _getAuthToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('authToken');
  }

  // Get headers with auth token if available
  Future<Map<String, String>> _getHeaders({bool requiresAuth = true}) async {
    final headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };

    if (requiresAuth) {
      final token = await _getAuthToken();
      if (token != null) {
        // This format exactly matches what your Django backend expects
        headers['Authorization'] = 'Token $token';
        print("Using token for authentication: $token");
      } else {
        print("No auth token found in SharedPreferences");
      }
    }

    return headers;
  }

  // Generic HTTP GET method
  Future<dynamic> get(String endpoint, {bool requiresAuth = true}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = await _getHeaders(requiresAuth: requiresAuth);

    print("Making GET request to: $url");
    print("Headers: $headers");

    try {
      final response = await _client.get(url, headers: headers);
      print("Response status: ${response.statusCode}");
      print(
          "Response body (first 100 chars): ${response.body.substring(0, min(100, response.body.length))}...");
      return _handleResponse(response);
    } catch (e) {
      print("Network error during GET: $e");
      throw Exception('Network error: $e');
    }
  }

  // Generic HTTP POST method
  Future<dynamic> post(String endpoint,
      {dynamic data, bool requiresAuth = true}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = await _getHeaders(requiresAuth: requiresAuth);

    print("Making POST request to: $url");
    print("Headers: $headers");
    if (data != null) {
      print("Request body: ${jsonEncode(data)}");
    }

    try {
      final response = await _client.post(
        url,
        headers: headers,
        body: data != null ? jsonEncode(data) : null,
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      return _handleResponse(response);
    } catch (e) {
      print("Network error during POST: $e");
      throw Exception('Network error: $e');
    }
  }

  // Generic HTTP PUT method
  Future<dynamic> put(String endpoint,
      {dynamic data, bool requiresAuth = true}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = await _getHeaders(requiresAuth: requiresAuth);

    try {
      final response = await _client.put(
        url,
        headers: headers,
        body: data != null ? jsonEncode(data) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Generic HTTP PATCH method
  Future<dynamic> patch(String endpoint,
      {dynamic data, bool requiresAuth = true}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = await _getHeaders(requiresAuth: requiresAuth);

    try {
      final response = await _client.patch(
        url,
        headers: headers,
        body: data != null ? jsonEncode(data) : null,
      );
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Generic HTTP DELETE method
  Future<dynamic> delete(String endpoint, {bool requiresAuth = true}) async {
    final url = Uri.parse('$baseUrl/$endpoint');
    final headers = await _getHeaders(requiresAuth: requiresAuth);

    try {
      final response = await _client.delete(url, headers: headers);
      return _handleResponse(response);
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  // Handle HTTP response
  dynamic _handleResponse(http.Response response) {
    final statusCode = response.statusCode;
    final responseBody =
        response.body.isNotEmpty ? jsonDecode(response.body) : null;

    if (statusCode >= 200 && statusCode < 300) {
      return responseBody;
    } else {
      // Extract error message from response if available
      final errorMessage =
          responseBody != null && responseBody.containsKey('detail')
              ? responseBody['detail']
              : 'Request failed with status: $statusCode';

      throw Exception(errorMessage);
    }
  }

  // Authentication methods

  Future<Map<String, dynamic>> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/auth/login/');
    final headers = await _getHeaders(requiresAuth: false);

    try {
      // Ensure the body structure matches exactly what Django expects
      final response = await _client.post(
        url,
        headers: headers,
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      print("Login response status: ${response.statusCode}");
      print("Login response body length: ${response.body.length}");
      print("Login response body: ${response.body}");

      final responseData = _handleResponse(response);

      // Save auth token if present
      if (responseData != null && responseData.containsKey('token')) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('authToken', responseData['token']);
        print("Saved auth token: ${responseData['token']}");

        // Also save logged-in status for convenience
        await prefs.setBool('isLoggedIn', true);

        // Save email for future reference
        await prefs.setString('loggedInEmail', email);

        // Save user role if available
        if (responseData.containsKey('user_type')) {
          await prefs.setString(
              'userRole', responseData['user_type'].toString().toLowerCase());
          print("Saved user role: ${responseData['user_type']}");
        }
      }

      return responseData;
    } catch (e) {
      print("Login error in api_client: $e");
      throw Exception('Network error: $e');
    }
  }

  // Register
  Future<Map<String, dynamic>> register(
      String username, String email, String password, String role,
      {Map<String, dynamic>? additionalData}) async {
    // Create the registration data with required fields
    final Map<String, dynamic> registrationData = {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    };

    // If additional data is provided, merge it with registrationData
    if (additionalData != null) {
      registrationData.addAll(additionalData);
    }

    return await post(
      'auth/register/',
      data: registrationData,
      requiresAuth: false,
    );
  }

  // Logout
  Future<void> logout() async {
    try {
      await post('auth/logout/');
    } finally {
      // Clear auth token regardless of API call success
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('authToken');
      await prefs.setBool('isLoggedIn', false);
      await prefs.remove('userRole');
      await prefs.remove('loggedInEmail');
    }
  }

  // User profile
  Future<Map<String, dynamic>> getUserProfile() async {
    return await get('users/profile/');
  }

  // Update user profile
  Future<Map<String, dynamic>> updateUserProfile(
      Map<String, dynamic> profileData) async {
    return await patch('users/profile/', data: profileData);
  }

  // Get recommended fields
  Future<List<dynamic>> getRecommendedFields() async {
    return await get('recommendations/fields/');
  }

  // Get all fields
  Future<List<dynamic>> getAllFields() async {
    print("Getting all fields from API endpoint: $baseUrl/fields/");
    final response = await get('fields/');
    print("Fields API response: $response");

    if (response is List) {
      return response;
    } else if (response is Map) {
      // Some APIs return objects like {"results": [...]} instead of direct arrays
      if (response.containsKey('results') && response['results'] is List) {
        return response['results'];
      }
    }

    print("Unexpected response format: $response");
    return [];
  }

  // Get field details
  Future<Map<String, dynamic>> getFieldDetails(int fieldId) async {
    return await get('fields/$fieldId/');
  }

  // Create a booking
  Future<Map<String, dynamic>> createBooking(
      Map<String, dynamic> bookingData) async {
    return await post('bookings/', data: bookingData);
  }

  // Get user's bookings
  Future<List<dynamic>> getUserBookings() async {
    return await get('bookings/');
  }

  // Get user's teams
  Future<List<dynamic>> getUserTeams() async {
    return await get('teams/');
  }

  // Join a team
  Future<Map<String, dynamic>> joinTeam(int teamId) async {
    return await post('teams/$teamId/join/');
  }

  // Create a team
  Future<Map<String, dynamic>> createTeam(Map<String, dynamic> teamData) async {
    return await post('teams/', data: teamData);
  }

  // Get user's matches
  Future<List<dynamic>> getUserMatches() async {
    return await get('matches/');
  }

  // Create a match
  Future<Map<String, dynamic>> createMatch(
      Map<String, dynamic> matchData) async {
    return await post('matches/', data: matchData);
  }

  // Get training sessions
  Future<List<dynamic>> getTrainingSessions() async {
    return await get('training/');
  }

  // Create a training session (for coaches)
  Future<Map<String, dynamic>> createTrainingSession(
      Map<String, dynamic> sessionData) async {
    return await post('training/', data: sessionData);
  }

  // Invite player to training (for coaches)
  Future<Map<String, dynamic>> inviteToTraining(
      int sessionId, int playerId) async {
    return await post('training/$sessionId/invite/',
        data: {'player_id': playerId});
  }

  // Get conversations
  Future<List<dynamic>> getConversations() async {
    return await get('messages/');
  }

  // Get conversation with a specific user
  Future<List<dynamic>> getConversation(int userId) async {
    return await get('messages/$userId/');
  }

  // Send a message
  Future<Map<String, dynamic>> sendMessage(
      int receiverId, String message) async {
    return await post(
      'messages/',
      data: {
        'receiver_id': receiverId,
        'message_text': message,
      },
    );
  }

  // Helper function to get the minimum of two numbers
  int min(int a, int b) {
    return a < b ? a : b;
  }
}
