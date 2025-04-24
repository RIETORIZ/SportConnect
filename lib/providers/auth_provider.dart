// lib/providers/auth_provider.dart

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  bool _isLoggedIn = false;
  String _userRole = '';
  String _loggedInEmail = '';

  bool get isLoggedIn => _isLoggedIn;
  String get userRole => _userRole;
  String get loggedInEmail => _loggedInEmail;

  // Load the user's login state from SharedPreferences
  Future<void> loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    _userRole = prefs.getString('userRole') ?? '';
    _loggedInEmail = prefs.getString('loggedInEmail') ?? '';
    notifyListeners();
  }

  // Set the user's login state
  Future<void> setLoggedIn(bool isLoggedIn, String email, String role) async {
    _isLoggedIn = isLoggedIn;
    _loggedInEmail = email;
    _userRole = role;

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', isLoggedIn);
    await prefs.setString('loggedInEmail', email);
    await prefs.setString('userRole', role);

    notifyListeners();
  }

  // Login the user
  Future<void> login(String email, String password) async {
    try {
      final response = await AuthService.login(email, password);
      await setLoggedIn(true, email, response['user_type']);
    } catch (e) {
      rethrow;
    }
  }

  // Register a new user
  Future<void> register(
      String username, String email, String password, String role) async {
    try {
      await AuthService.register(username, email, password, role);
      // Note: In a real app, you might want to auto-login after registration
      // For now, we'll just return to the login screen
    } catch (e) {
      rethrow;
    }
  }

  // Logout the user
  Future<void> logout() async {
    try {
      await AuthService.logout();
      await setLoggedIn(false, '', '');
    } catch (e) {
      print('Error during logout: $e');
      // Even if the backend logout fails, we'll clear local state
      await setLoggedIn(false, '', '');
    }
  }
}
