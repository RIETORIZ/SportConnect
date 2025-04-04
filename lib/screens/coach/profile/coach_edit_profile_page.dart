import 'package:flutter/material.dart';

class PlayerEditProfilePage extends StatefulWidget {
  const PlayerEditProfilePage({Key? key}) : super(key: key);

  @override
  State<PlayerEditProfilePage> createState() => _PlayerEditProfilePageState();
}

class _PlayerEditProfilePageState extends State<PlayerEditProfilePage> {
  final TextEditingController _nameController = TextEditingController(text: 'Player Name');
  final TextEditingController _emailController = TextEditingController(text: 'player@sportconnect.com');

  void _saveProfile() {
    // In real code, you'd save to DB or an API
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Profile saved: ${_nameController.text} / ${_emailController.text}')),
    );
    Navigator.pop(context); // Return to player_profile_page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Edit Player Profile', style: TextStyle(color: Colors.greenAccent)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _nameController,
              style: const TextStyle(color: Colors.greenAccent),
              decoration: InputDecoration(
                labelText: 'Name',
                labelStyle: const TextStyle(color: Colors.greenAccent),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _emailController,
              style: const TextStyle(color: Colors.greenAccent),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: const TextStyle(color: Colors.greenAccent),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveProfile,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('Save', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
