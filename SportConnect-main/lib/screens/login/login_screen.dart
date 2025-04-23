import 'dart:math';

import 'package:flutter/material.dart';

import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  final Function(String, String) onLogin;
  const LoginScreen({super.key, required this.onLogin});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String errorMessage = "";

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
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void startBallAnimation() {
    _controller.forward(from: 0);
    setState(() {
      currentEmoji = sportEmojis[Random().nextInt(sportEmojis.length)];
      errorMessage = "";
    });
  }

  void handleLogin() {
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (password == "rose") {
      if (email == "adminP") {
        widget.onLogin("player@sportconnect.com", "Player");
      } else if (email == "adminC") {
        widget.onLogin("coach@sportconnect.com", "Coach");
      } else if (email == "adminR") {
        widget.onLogin("renter@sportconnect.com", "Renter");
      } else {
        setState(() {
          errorMessage = "Invalid credentials (use adminP, adminC, or adminR)";
        });
      }
    } else {
      setState(() {
        errorMessage = "Incorrect password (use 'rose')";
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
                            labelText: "Email (adminP/adminC/adminR)",
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
                            labelText: "Password (try 'rose')",
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
                        ElevatedButton(
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

                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
