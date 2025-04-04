import 'package:flutter/material.dart';

import 'coach_edit_profile_page.dart';

class PlayerProfilePage extends StatelessWidget {
  const PlayerProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Hardcoded example data
    final playerName = 'Player Name';
    final playerEmail = 'player@sportconnect.com';

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Player Profile', style: TextStyle(color: Colors.greenAccent)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('assets/player_profile.png'),
            ),
            const SizedBox(height: 20),
            Text(
              'Name: $playerName',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 8),
            Text(
              'Email: $playerEmail',
              style: const TextStyle(color: Colors.white, fontSize: 18),
            ),
            const SizedBox(height: 30),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onPressed: () {
                // Navigate to edit profile
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const PlayerEditProfilePage()),
                );
              },
              child: const Text('Edit Profile', style: TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}
