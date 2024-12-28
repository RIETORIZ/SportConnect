import 'package:flutter/material.dart';

import 'dm/direct_messages.dart';
import 'fields/sports_feed.dart';
// Subfolders relative to player_home_screen.dart
import 'matches/matches_page.dart';
import 'teams/team_search_page.dart';
import 'training/training_page.dart';

class PlayerHomeScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final VoidCallback onLogout;
  final String loggedInEmail;

  const PlayerHomeScreen({
    super.key,
    required this.onThemeChanged,
    required this.onLogout,
    required this.loggedInEmail,
  });

  @override
  State<PlayerHomeScreen> createState() => _PlayerHomeScreenState();
}

class _PlayerHomeScreenState extends State<PlayerHomeScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const SportsFeed(),
    const MatchesPage(),
    const TeamSearchPage(),
    const TrainingPage(),
    const DirectMessages(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.green,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/player_profile.png'),
                ),
                SizedBox(height: 10),
                Text(
                  'Player Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '@playerusername',
                  style: TextStyle(
                    color: Colors.white54,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.light_mode),
            title: const Text('Light Mode'),
            onTap: () {
              widget.onThemeChanged(ThemeMode.light);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.dark_mode),
            title: const Text('Dark Mode'),
            onTap: () {
              widget.onThemeChanged(ThemeMode.dark);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('System Default'),
            onTap: () {
              widget.onThemeChanged(ThemeMode.system);
              Navigator.pop(context);
            },
          ),
          const Spacer(),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context);
              widget.onLogout();
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SportConnect'),
      ),
      drawer: _buildDrawer(),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
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
            label: 'Team Search',
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
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}
