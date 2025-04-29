// lib/screens/login/login_screen.dart

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final Function(String, String) onLogin;
  const LoginScreen({Key? key, required this.onLogin}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = "";
  bool _isLoading = false;

  late AnimationController _controller;
  late Animation<double> _animation;

  // Example sports emojis
  final List<String> sportEmojis = [
    "⚽",
    "🏀",
    "🏈",
    "🎾",
    "🏉",
    "🥇",
    "🏆",
    "🎳"
  ];
  String currentEmoji = "⚽";

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _animation = Tween<double>(begin: 0, end: 20).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Check if the user is already logged in
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final userRole = prefs.getString('userRole') ?? '';
    final email = prefs.getString('loggedInEmail') ?? '';

    if (isLoggedIn && userRole.isNotEmpty && email.isNotEmpty) {
      // If already logged in, call the onLogin callback
      widget.onLogin(email, userRole);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void startBallAnimation() {
    _controller.forward(from: 0);
    setState(() {
      currentEmoji = sportEmojis[Random().nextInt(sportEmojis.length)];
      errorMessage = "";
    });
  }

  Future<void> handleLogin() async {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        errorMessage = "Please enter email and password";
      });
      return;
    }

    setState(() {
      _isLoading = true;
      errorMessage = "";
    });

    try {
      /* Comment out the development shortcuts for now
      // For development/testing, allow use of the existing shortcuts
      if (password == "rose") {
        if (email == "adminP") {
          widget.onLogin("player@sportconnect.com", "Player");
          return;
        } else if (email == "adminC") {
          widget.onLogin("coach@sportconnect.com", "Coach");
          return;
        } else if (email == "adminR") {
          widget.onLogin("renter@sportconnect.com", "Renter");
          return;
        }
      }
      */

      // Call the authentication service
      final response = await AuthService.login(email, password);

      // Call the callback function with the authenticated user information
      widget.onLogin(email, response['user_type']);
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _goToRegisterScreen() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const RegisterScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Full-screen gradient
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black, // top
              Colors.green.shade900, // bottom
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            // For smaller screens, ensure scrollable
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Title
                Text(
                  "Sport $currentEmoji Connect",
                  style: const TextStyle(
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.greenAccent,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Login to your account",
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),

                // Login Card
                Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 10,
                  shadowColor: Colors.greenAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Email TextField
                        TextField(
                          controller: emailController,
                          onTap: startBallAnimation,
                          onChanged: (_) => startBallAnimation(),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Email",
                            labelStyle:
                                const TextStyle(color: Colors.greenAccent),
                            filled: true,
                            fillColor: Colors.black,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.email,
                                color: Colors.greenAccent),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Password TextField
                        TextField(
                          controller: passwordController,
                          obscureText: true,
                          onTap: startBallAnimation,
                          onChanged: (_) => startBallAnimation(),
                          style: const TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: "Password",
                            labelStyle:
                                const TextStyle(color: Colors.greenAccent),
                            filled: true,
                            fillColor: Colors.black,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            prefixIcon: const Icon(Icons.lock,
                                color: Colors.greenAccent),
                          ),
                        ),
                        const SizedBox(height: 10),

                        // Error message
                        if (errorMessage.isNotEmpty)
                          Text(
                            errorMessage,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 14,
                            ),
                          ),

                        const SizedBox(height: 20),

                        // Login Button
                        _isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.greenAccent)
                            : ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 70,
                                    vertical: 14,
                                  ),
                                ),
                                onPressed: handleLogin,
                                child: const Text(
                                  "Login",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                        const SizedBox(height: 10),

                        // Register button
                        TextButton(
                          onPressed: _goToRegisterScreen,
                          child: const Text(
                            "Don't have an account? Register now",
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // Debug Login Shortcuts (only for development)
                Card(
                  color: Colors.grey[900],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 5,
                  shadowColor: Colors.redAccent,
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          "Quick Login (Dev Only)",
                          style: TextStyle(
                            color: Colors.redAccent,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildDevLoginButton("Player", "adminP", "rose"),
                            _buildDevLoginButton("Coach", "adminC", "rose"),
                            _buildDevLoginButton("Renter", "adminR", "rose"),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDevLoginButton(String role, String email, String password) {
    return ElevatedButton(
      onPressed: () {
        emailController.text = email;
        passwordController.text = password;
        handleLogin();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.redAccent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        role,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
