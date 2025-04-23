import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
// These imports assume your pubspec.yaml has name: sportcon_1st_gui
// and that you have the listed folders & files under lib/screens/.
import 'package:sportcon_1st_gui/screens/coach/coach_home_screen.dart';
import 'package:sportcon_1st_gui/screens/login/login_screen.dart';
import 'package:sportcon_1st_gui/screens/player/player_home_screen.dart';
import 'package:sportcon_1st_gui/screens/renter/renter_home_screen.dart';

void main() {
  runApp(const SportConnectApp());
}

class SportConnectApp extends StatefulWidget {
  const SportConnectApp({super.key});

  @override
  State<SportConnectApp> createState() => _SportConnectAppState();
}

class _SportConnectAppState extends State<SportConnectApp> {
  ThemeMode _themeMode = ThemeMode.system;

  bool _isLoggedIn = false;
  String _userRole = ''; // 'Player', 'Coach', 'Renter'
  String _loggedInEmail = '';

  @override
  void initState() {
    super.initState();
    _loadLoginState();
  }

  /// Load login state from SharedPreferences so the user stays logged in
  /// across app restarts.
  Future<void> _loadLoginState() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _userRole = prefs.getString('userRole') ?? '';
      _loggedInEmail = prefs.getString('loggedInEmail') ?? '';
    });
  }

  /// Allow changing between light, dark, or system theme.
  void _changeThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  /// Handle user login, storing email and role in SharedPreferences.
  Future<void> _handleLogin(String email, String role) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('loggedInEmail', email);
    await prefs.setString('userRole', role);

    setState(() {
      _isLoggedIn = true;
      _loggedInEmail = email;
      _userRole = role;
    });
  }

  /// Handle user logout, clearing from SharedPreferences.
  Future<void> _handleLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('loggedInEmail');
    await prefs.remove('userRole');

    setState(() {
      _isLoggedIn = false;
      _loggedInEmail = '';
      _userRole = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    // Decide which screen to show: Login or the role-specific home screen.
    Widget homeWidget;
    if (_isLoggedIn) {
      switch (_userRole) {
        case 'Player':
          // Player's main screen
          homeWidget = PlayerHomeScreen(
            onThemeChanged: _changeThemeMode,
            onLogout: _handleLogout,
            loggedInEmail: _loggedInEmail,
          );
          break;

        case 'Coach':
          // Coach's main screen
          homeWidget = CoachScreen(
            onThemeChanged: _changeThemeMode,
            onLogout: _handleLogout,
            loggedInEmail: _loggedInEmail,
          );
          break;

        case 'Renter':
          // Renter's main screen
          homeWidget = RenterScreen(
            onThemeChanged: _changeThemeMode,
            onLogout: _handleLogout,
            loggedInEmail: _loggedInEmail,
          );
          break;

        default:
          // If somehow role isn't recognized
          homeWidget = const Center(child: Text('Unknown Role'));
      }
    } else {
      // Show the login screen if not logged in
      homeWidget = LoginScreen(onLogin: _handleLogin);
    }

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
      themeMode: _themeMode,
      home: homeWidget,
    );
  }
}
