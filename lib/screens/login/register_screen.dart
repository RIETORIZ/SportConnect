import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _selectedRole = 'Player';
  final TextEditingController _emailController = TextEditingController();

  Future<void> _registerUser() async {
    final email = _emailController.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid email')),
      );
      return;
    }

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('registeredEmail', email);
    await prefs.setString('registeredRole', _selectedRole);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Registered as $_selectedRole successfully!')),
    );

    // Navigate back to the login screen
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Register a new account',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            // Email Input
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            // Role Selection
            const Text(
              'Select Role:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            DropdownButton<String>(
              value: _selectedRole,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedRole = newValue!;
                });
              },
              items: <String>['Player', 'Coach', 'Renter']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 30),
            // Register Button
            Center(
              child: ElevatedButton(
                onPressed: _registerUser,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(150, 50),
                ),
                child: const Text('Register'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
