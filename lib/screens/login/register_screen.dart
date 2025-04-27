// lib/screens/login/register_screen.dart

import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  /* ───────────────────────────────────────── COMMON CONTROLLERS ───────── */
  final _formKey = GlobalKey<FormState>();

  final _usernameC = TextEditingController();
  final _passwordC = TextEditingController();
  final _confirmPasswordC = TextEditingController();
  final _emailC = TextEditingController();
  final _phoneC = TextEditingController();
  final _regionC = TextEditingController();
  final _ageC = TextEditingController();
  final _genderC = TextEditingController();

  /* ───────────────────────────────────────── ROLE CHOICE ──────────────── */
  String _role = 'Player';

  /* ────────────────────────────── ROLE-SPECIFIC CONTROLLERS ───────────── */
  // Player
  final _sportC = TextEditingController();
  final _expLevelC = TextEditingController();
  // Coach
  final _specC = TextEditingController();
  final _certC = TextEditingController();
  final _yearsExpC = TextEditingController();
  // Renter
  final _bizNameC = TextEditingController();
  final _contactInfoC = TextEditingController();
  final _fieldsOwnedC = TextEditingController();
  final _ratingC = TextEditingController();

  bool _isLoading = false;
  String _errorMessage = '';

  /* ───────────────────────────────────────── HELPERS ──────────────────── */
  InputDecoration _dec(String lbl) => InputDecoration(
        labelText: lbl,
        labelStyle: const TextStyle(
            color: Colors.greenAccent, fontWeight: FontWeight.bold),
        fillColor: Colors.black,
        filled: true,
        hintStyle: const TextStyle(color: Colors.greenAccent),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.greenAccent),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Colors.greenAccent),
        ),
      );

  List<Widget> _roleFields() {
    switch (_role) {
      case 'Coach':
        return [
          TextFormField(
            controller: _specC,
            decoration: _dec('Specialization'),
            style: const TextStyle(color: Colors.greenAccent),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _certC,
            decoration: _dec('Certifications'),
            style: const TextStyle(color: Colors.greenAccent),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _yearsExpC,
            decoration: _dec('Years of Experience'),
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.greenAccent),
          ),
        ];
      case 'Renter':
        return [
          TextFormField(
            controller: _bizNameC,
            decoration: _dec('Business Name'),
            style: const TextStyle(color: Colors.greenAccent),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _contactInfoC,
            decoration: _dec('Contact Info'),
            style: const TextStyle(color: Colors.greenAccent),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _fieldsOwnedC,
            decoration: _dec('Fields Owned'),
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.greenAccent),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _ratingC,
            decoration: _dec('Rating (1-10)'),
            keyboardType: TextInputType.number,
            style: const TextStyle(color: Colors.greenAccent),
          ),
        ];
      default: // Player
        return [
          TextFormField(
            controller: _sportC,
            decoration: _dec('Preferred Sports'),
            style: const TextStyle(color: Colors.greenAccent),
          ),
          const SizedBox(height: 12),
          TextFormField(
            controller: _expLevelC,
            decoration: _dec('Experience Level'),
            style: const TextStyle(color: Colors.greenAccent),
          ),
        ];
    }
  }

  /* ───────────────────────────────────────── REGISTER ─────────────────── */
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    // Common data that will be sent to both Django backend and stored locally
    final data = <String, dynamic>{
      'role': _role.toLowerCase(), // Make sure role is lowercase for backend
      // common
      'username': _usernameC.text.trim(),
      'password': _passwordC.text.trim(),
      'email': _emailC.text.trim(),
      'phone_number': _phoneC.text.trim(),
      'region': _regionC.text.trim(),
      'age': int.tryParse(_ageC.text.trim()) ?? 0,
      'gender': _genderC.text.trim(),
      // role-specific
      if (_role == 'Player') ...{
        'preferred_sports': _sportC.text.trim(),
        'experience_level': _expLevelC.text.trim(),
      },
      if (_role == 'Coach') ...{
        'specialization': _specC.text.trim(),
        'certifications': _certC.text.trim(),
        'years_of_experience': int.tryParse(_yearsExpC.text.trim()) ?? 0,
      },
      if (_role == 'Renter') ...{
        'business_name': _bizNameC.text.trim(),
        'contact_info': _contactInfoC.text.trim(),
        'fields_owned': int.tryParse(_fieldsOwnedC.text.trim()) ?? 0,
        'rating':
            double.tryParse(_ratingC.text.trim()) ?? 0.0, // Changed to double
      }
    };

    try {
      // Store locally for reference
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('last_registered', jsonEncode(data));

      // Call the Django backend registration service
      final response = await AuthService.register(
        _usernameC.text.trim(),
        _emailC.text.trim(),
        _passwordC.text.trim(),
        _role.toLowerCase(),
        additionalData: data,
      );

      if (!mounted) return;

      // Log the response for debugging
      print('Registration response: $response');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registered as $_role successfully!'),
          backgroundColor: Colors.green,
        ),
      );

      // Optional: Auto-login after registration
      /*
      try {
        await AuthService.login(
          _emailC.text.trim(),
          _passwordC.text.trim(),
        );
        // Navigate to home page if auto-login successful
      } catch (loginError) {
        // Just navigate back if auto-login fails
        Navigator.pop(context);
      }
      */

      Navigator.pop(context);
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Registration failed: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  /* ───────────────────────────────────────── BUILD ────────────────────── */
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
              colors: [Colors.black, Color(0xFF004D00)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  const Text('Register',
                      style: TextStyle(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: Colors.greenAccent)),
                  const SizedBox(height: 8),
                  const Text('Create a New Account',
                      style: TextStyle(fontSize: 18, color: Colors.white70)),
                  const SizedBox(height: 32),

                  /* ───────────── CARD ───────────── */
                  Card(
                    color: Colors.grey[900],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16)),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /* -------- COMMON INPUTS -------- */
                            TextFormField(
                              controller: _usernameC,
                              decoration: _dec('Username'),
                              style: const TextStyle(color: Colors.greenAccent),
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _passwordC,
                              decoration: _dec('Password'),
                              style: const TextStyle(color: Colors.greenAccent),
                              obscureText: true,
                              validator: (v) => (v == null || v.trim().isEmpty)
                                  ? 'Required'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _confirmPasswordC,
                              decoration: _dec('Confirm Password'),
                              style: const TextStyle(color: Colors.greenAccent),
                              obscureText: true,
                              validator: (v) {
                                if (v == null || v.trim().isEmpty) {
                                  return 'Required';
                                }
                                if (v != _passwordC.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _emailC,
                              decoration: _dec('Email'),
                              keyboardType: TextInputType.emailAddress,
                              style: const TextStyle(color: Colors.greenAccent),
                              validator: (v) => (v == null || !v.contains('@'))
                                  ? 'Invalid email'
                                  : null,
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _phoneC,
                              decoration: _dec('Phone Number'),
                              keyboardType: TextInputType.phone,
                              style: const TextStyle(color: Colors.greenAccent),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _regionC,
                              decoration: _dec('Region'),
                              style: const TextStyle(color: Colors.greenAccent),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _ageC,
                              decoration: _dec('Age'),
                              keyboardType: TextInputType.number,
                              style: const TextStyle(color: Colors.greenAccent),
                            ),
                            const SizedBox(height: 12),
                            TextFormField(
                              controller: _genderC,
                              decoration: _dec('Gender'),
                              style: const TextStyle(color: Colors.greenAccent),
                            ),
                            const SizedBox(height: 24),

                            /* -------- ROLE PICKER -------- */
                            const Text('Select Role:',
                                style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontWeight: FontWeight.bold)),
                            const SizedBox(height: 6),
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(color: Colors.greenAccent),
                              ),
                              child: DropdownButton<String>(
                                value: _role,
                                dropdownColor: Colors.grey[900],
                                iconEnabledColor: Colors.greenAccent,
                                underline: const SizedBox(),
                                style:
                                    const TextStyle(color: Colors.greenAccent),
                                onChanged: (v) => setState(() => _role = v!),
                                items: const ['Player', 'Coach', 'Renter']
                                    .map((e) => DropdownMenuItem(
                                        value: e, child: Text(e)))
                                    .toList(),
                              ),
                            ),
                            const SizedBox(height: 24),

                            /* -------- DYNAMIC ROLE FIELDS -------- */
                            ..._roleFields(),
                            const SizedBox(height: 24),

                            /* -------- ERROR MESSAGE -------- */
                            if (_errorMessage.isNotEmpty)
                              Center(
                                child: Text(
                                  _errorMessage,
                                  style: const TextStyle(
                                    color: Colors.red,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            if (_errorMessage.isNotEmpty)
                              const SizedBox(height: 16),
                            Center(
                              child: _isLoading
                                  ? const CircularProgressIndicator(
                                      color: Colors.greenAccent)
                                  : ElevatedButton(
                                      onPressed: _register,
                                      style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.green,
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 14, horizontal: 48),
                                          shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30))),
                                      child: const Text('Register',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.bold)),
                                    ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
