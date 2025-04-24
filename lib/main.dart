// lib/main.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

// These imports assume your pubspec.yaml has name: sportcon_1st_gui
// and that you have the listed folders & files under lib/screens/.
import 'package:sportcon_1st_gui/screens/coach/coach_home_screen.dart';
import 'package:sportcon_1st_gui/screens/login/login_screen.dart';
import 'package:sportcon_1st_gui/screens/player/player_home_screen.dart';
import 'package:sportcon_1st_gui/screens/renter/renter_home_screen.dart';

// Provider for app-wide state management
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';

void main() async {
  // Ensure Flutter is initialized
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: const SportConnectApp(),
    ),
  );
}

class SportConnectApp extends StatefulWidget {
  const SportConnectApp({super.key});

  @override
  State<SportConnectApp> createState() => _SportConnectAppState();
}

class _SportConnectAppState extends State<SportConnectApp> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Get auth provider
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    // Load saved login state
    await authProvider.loadLoginState();
  }

  @override
  Widget build(BuildContext context) {
    // Get providers
    final authProvider = Provider.of<AuthProvider>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);

    return MaterialApp(
      title: 'SportConnect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        primaryColor: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1B5E20),
          selectedItemColor: Colors.yellowAccent,
          unselectedItemColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: themeProvider.themeMode,

      // Show the appropriate home screen based on auth state
      home: authProvider.isLoggedIn
          ? _buildHomeScreen(authProvider.userRole, authProvider.loggedInEmail)
          : LoginScreen(onLogin: _handleLogin),
    );
  }

  // Build the appropriate home screen based on user role
  Widget _buildHomeScreen(String userRole, String email) {
    switch (userRole) {
      case 'Player':
        return PlayerHomeScreen(
          onThemeChanged: _changeThemeMode,
          onLogout: _handleLogout,
          loggedInEmail: email,
        );
      case 'Coach':
        return CoachScreen(
          onThemeChanged: _changeThemeMode,
          onLogout: _handleLogout,
          loggedInEmail: email,
        );
      case 'Renter':
        return RenterScreen(
          onThemeChanged: _changeThemeMode,
          onLogout: _handleLogout,
          loggedInEmail: email,
        );
      default:
        return const Center(child: Text('Unknown Role'));
    }
  }

  // Handle theme changes
  void _changeThemeMode(ThemeMode mode) {
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);
    themeProvider.setThemeMode(mode);
  }

  // Handle user login
  Future<void> _handleLogin(String email, String role) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.setLoggedIn(true, email, role);
  }

  // Handle user logout
  Future<void> _handleLogout() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    await authProvider.logout();
  }
}
