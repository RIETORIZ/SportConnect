// lib/services/auth_service.dart

import 'api_service.dart';

class AuthService {
  // Login with email and password
  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    return await ApiService.login(email, password);
  }

  // Register a new user
  static Future<Map<String, dynamic>> register(
      String username, String email, String password, String role) async {
    return await ApiService.register(username, email, password, role);
  }

  // Logout the current user
  static Future<void> logout() async {
    await ApiService.logout();
  }
}
