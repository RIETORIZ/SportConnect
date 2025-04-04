import 'package:flutter/material.dart';

// Existing imports
import 'coach/coach_page.dart';
import 'dm/direct_messages.dart';
import 'family/family_members_page.dart';
import 'fields/sports_feed.dart';
import 'friends/friends_page.dart';
import 'matches/matches_page.dart';
import 'profile/edit_profile_page.dart';
import 'reports/reports_page.dart';
import 'teams/teams_page.dart';
import 'training/training_page.dart';

class PlayerHomeScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final VoidCallback onLogout;
  final String loggedInEmail;

  const PlayerHomeScreen({
    Key? key,
    required this.onThemeChanged,
    required this.onLogout,
    required this.loggedInEmail,
  }) : super(key: key);

  @override
  State<PlayerHomeScreen> createState() => _PlayerHomeScreenState();
}

class _PlayerHomeScreenState extends State<PlayerHomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const SportsFeed(),
    const MatchesPage(),
    const TeamsPage(),
    const TrainingPage(),
    const DMOverviewPage(),
  ];

  final List<Map<String, dynamic>> generalItems = [
    {'title': 'Family Members', 'icon': Icons.people},
    {'title': 'Reports', 'icon': Icons.description},
    {'title': 'Payment Methods', 'icon': Icons.account_balance_wallet},
    {'title': 'Your Reviews', 'icon': Icons.rate_review},
    {'title': 'Settings', 'icon': Icons.settings},
  ];

  final List<Map<String, dynamic>> preferenceItems = [
    {'title': 'Help & Support', 'icon': Icons.help_outline},
    {'title': 'Privacy & Policy', 'icon': Icons.privacy_tip_outlined},
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Drawer _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.black,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top user info
            Container(
              width: double.infinity,
              color: Colors.green,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/player_profile.png'),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'adminP',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@adminPUser',
                          style: TextStyle(
                            color: Colors.white70,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.white),
                    onPressed: () {
                      Navigator.pop(context); // close Drawer
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ProfileEditPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

            // "Friends"
            ListTile(
              leading: const Icon(Icons.person, color: Colors.greenAccent),
              title: const Text(
                'Friends',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const FriendsPage()),
                );
              },
            ),

            // "Coach"
            ListTile(
              leading: const Icon(Icons.person_pin, color: Colors.greenAccent),
              title: const Text(
                'Coach',
                style: TextStyle(color: Colors.white),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>  CoachPage()),
                );
              },
            ),
            const SizedBox(height: 8),

            // "General" expansion
            ExpansionTile(
              title: const Text(
                'General',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              collapsedIconColor: Colors.greenAccent,
              iconColor: Colors.greenAccent,
              childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
              backgroundColor: Colors.grey[900],
              collapsedBackgroundColor: Colors.grey[900],
              children: generalItems.map((item) {
                return ListTile(
                  leading: Icon(item['icon'], color: Colors.greenAccent),
                  title: Text(
                    item['title'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing: const Icon(Icons.chevron_right, color: Colors.white30),
                  onTap: () {
                    final title = item['title'] as String;
                    Navigator.pop(context); // close Drawer

                    if (title == 'Family Members') {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>  FamilyMembersPage(),
                        ),
                      );
                    } else if (title == 'Reports') {
                      // Navigate to ReportsPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>  ReportsPage()),
                      );
                    } else {
                      // e.g., Payment Methods, Your Reviews, etc.
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('$title tapped')),
                      );
                    }
                  },
                );
              }).toList(),
            ),

            // "Preferences" expansion
            ExpansionTile(
              title: const Text(
                'Preferences',
                style: TextStyle(
                  color: Colors.greenAccent,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              collapsedIconColor: Colors.greenAccent,
              iconColor: Colors.greenAccent,
              childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
              backgroundColor: Colors.grey[900],
              collapsedBackgroundColor: Colors.grey[900],
              children: preferenceItems.map((item) {
                return ListTile(
                  leading: Icon(item['icon'], color: Colors.greenAccent),
                  title: Text(
                    item['title'],
                    style: const TextStyle(color: Colors.white),
                  ),
                  trailing:
                      const Icon(Icons.chevron_right, color: Colors.white30),
                  onTap: () {
                    // e.g. 'Help & Support', 'Privacy & Policy'
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item['title']} tapped')),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),

            // Light / Dark / System toggles
            ListTile(
              leading: const Icon(Icons.light_mode, color: Colors.greenAccent),
              title: const Text('Light Mode', style: TextStyle(color: Colors.white)),
              onTap: () {
                widget.onThemeChanged(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode, color: Colors.greenAccent),
              title: const Text('Dark Mode', style: TextStyle(color: Colors.white)),
              onTap: () {
                widget.onThemeChanged(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.greenAccent),
              title: const Text('System Default', style: TextStyle(color: Colors.white)),
              onTap: () {
                widget.onThemeChanged(ThemeMode.system);
                Navigator.pop(context);
              },
            ),

            const SizedBox(height: 10),

            // Logout
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Logout', style: TextStyle(color: Colors.red)),
              onTap: () {
                Navigator.pop(context);
                widget.onLogout();
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Make the AppBar green
      appBar: AppBar(
        title: const Text('SportConnect'),
        backgroundColor: Colors.green,
      ),
      drawer: _buildDrawer(),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Sportfields',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_score),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Teams',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Training',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'DM',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.green,
        onTap: _onItemTapped,
      ),
    );
  }
}
