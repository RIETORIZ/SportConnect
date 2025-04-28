// lib/services/auth_service.dart

import 'api_service.dart';

class AuthService {
  // Login with email and password
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    return await ApiService.login(email, password);
  }

  // Register a new user with role-specific data
  static Future<Map<String, dynamic>> register(
      String username, String email, String password, String role,
      {Map<String, dynamic>? additionalData}) async {
    // Create registration data with required fields
    final Map<String, dynamic> registrationData = {
      'username': username,
      'email': email,
      'password': password,
      'role': role,
    };

    // If additionalData is provided, merge it with registrationData
    if (additionalData != null) {
      // Remove password from additionalData to avoid conflicts
      additionalData.remove('password');

      // Add the rest of the data
      registrationData.addAll(additionalData);
    }

    // FIX: Pass the complete registrationData to the API
    return await ApiService.register(username, email, password, role,
        additionalData: registrationData);
  }

  // Logout the current user
  static Future<void> logout() async {
    await ApiService.logout();
  }
}
