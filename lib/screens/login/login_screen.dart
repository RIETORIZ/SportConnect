import 'package:flutter/material.dart';

import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  final Function(String, String) onLogin; // Accepts email and role

  const LoginScreen({super.key, required this.onLogin});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Login as Player
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.black,
                minimumSize: const Size(200, 50),
              ),
              onPressed: () => onLogin('player@sportconnect.com', 'Player'),
              child: const Text('Login as Player'),
            ),
            const SizedBox(height: 10),
            // Login as Coach
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.black,
                minimumSize: const Size(200, 50),
              ),
              onPressed: () => onLogin('coach@sportconnect.com', 'Coach'),
              child: const Text('Login as Coach'),
            ),
            const SizedBox(height: 10),
            // Login as Renter
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.yellow,
                foregroundColor: Colors.black,
                minimumSize: const Size(200, 50),
              ),
              onPressed: () => onLogin('renter@sportconnect.com', 'Renter'),
              child: const Text('Login as Renter'),
            ),
            const SizedBox(height: 20),
            // Navigate to Register Screen
            TextButton(
              onPressed: () {
                // Navigate to the Register screen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const RegisterScreen()),
                );
              },
              child: const Text(
                'Don\'t have an account? Register here',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
