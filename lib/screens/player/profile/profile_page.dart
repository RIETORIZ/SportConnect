import 'package:flutter/material.dart';

class ProfilePage extends StatelessWidget {
  ProfilePage({super.key});

  // Example user data
  final String userName = 'Mr. Mohammed Rahmani';
  final String userRole = 'Patient'; // or "Coach", "Player", "Renter"
  final String userImage = 'assets/player_profile.png';

  // Example list items
  final List<Map<String, dynamic>> generalItems = [
    {'title': 'Family Members', 'icon': Icons.people},
    {'title': 'Prescriptions & Reports', 'icon': Icons.description},
    {'title': 'Payment Methods', 'icon': Icons.account_balance_wallet},
    {'title': 'Your Reviews', 'icon': Icons.rate_review},
    {'title': 'Settings & Activities', 'icon': Icons.settings},
  ];

  final List<Map<String, dynamic>> preferenceItems = [
    {'title': 'Help & Support', 'icon': Icons.help_outline},
    {'title': 'Privacy & Policy', 'icon': Icons.privacy_tip_outlined},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        // The "back arrow" to pop back
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.greenAccent),
          onPressed: () {
            Navigator.pop(context); // go back to PlayerHomeScreen
          },
        ),
        elevation: 0,
        backgroundColor: Colors.black,
        centerTitle: false,
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.greenAccent,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.greenAccent),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.redAccent),
            onPressed: () {
              // Implement logout logic or show a confirm
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logout pressed')),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // User info row
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(userImage),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        userName,
                        style: const TextStyle(
                          color: Colors.greenAccent,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        userRole,
                        style: const TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                // “Edit” button
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.greenAccent),
                  onPressed: () {
                    // Navigate to EditProfilePage or show a modal, etc.
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit Profile tapped')),
                    );
                  },
                ),
              ],
            ),

            const SizedBox(height: 20),

            // GENERAL Section
            const Text(
              'General',
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: generalItems.map((item) {
                  return ListTile(
                    leading: Icon(item['icon'], color: Colors.greenAccent),
                    title: Text(
                      item['title'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing:
                        const Icon(Icons.chevron_right, color: Colors.white24),
                    onTap: () {
                      // Navigate or handle item logic
                    },
                  );
                }).toList(),
              ),
            ),

            const SizedBox(height: 20),

            // PREFERENCES Section
            const Text(
              'Preferences',
              style: TextStyle(
                color: Colors.greenAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: preferenceItems.map((item) {
                  return ListTile(
                    leading: Icon(item['icon'], color: Colors.greenAccent),
                    title: Text(
                      item['title'],
                      style: const TextStyle(color: Colors.white),
                    ),
                    trailing:
                        const Icon(Icons.chevron_right, color: Colors.white24),
                    onTap: () {
                      // Implement item logic
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
