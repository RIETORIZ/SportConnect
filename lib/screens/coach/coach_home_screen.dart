import 'package:flutter/material.dart';

// Import your new pages here:
import 'dm/direct_messages_page.dart';
import 'matches/matches_page.dart';
import 'search/search_page.dart';
import 'team/team_page.dart';
import 'training/coach_training_page.dart';
import 'training/invite_player_page.dart';

class CoachScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final VoidCallback onLogout;
  final String loggedInEmail;

  const CoachScreen({
    super.key,
    required this.onThemeChanged,
    required this.onLogout,
    required this.loggedInEmail,
  });

  @override
  State<CoachScreen> createState() => _CoachScreenState();
}

class _CoachScreenState extends State<CoachScreen> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    const CoachTrainingPage(),
    const MatchesPage(),
    const TeamsPage(),
    const SearchPage(),
    const DMOverviewPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Drawer _buildDrawer() {
    return Drawer(
      child: Container(
        color: Colors.black, // Dark background for the drawer
        child: Column(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.black, // Keep it dark
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
                    'Coach Name',
                    style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    '@coachusername',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.light_mode, color: Colors.greenAccent),
              title: const Text(
                'Light Mode',
                style: TextStyle(color: Colors.greenAccent),
              ),
              onTap: () {
                widget.onThemeChanged(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode, color: Colors.greenAccent),
              title: const Text(
                'Dark Mode',
                style: TextStyle(color: Colors.greenAccent),
              ),
              onTap: () {
                widget.onThemeChanged(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.greenAccent),
              title: const Text(
                'System Default',
                style: TextStyle(color: Colors.greenAccent),
              ),
              onTap: () {
                widget.onThemeChanged(ThemeMode.system);
                Navigator.pop(context);
              },
            ),
            const Spacer(),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.redAccent),
              title: const Text(
                'Logout',
                style: TextStyle(color: Colors.redAccent),
              ),
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
      // Black app bar for consistency
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Coach Menu',
          style: TextStyle(color: Colors.greenAccent),
        ),
        iconTheme: const IconThemeData(color: Colors.greenAccent),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            color: Colors.greenAccent,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const InvitePlayerPage(),
                ),
              );
            },
            tooltip: 'Invite Player',
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        // Black background to match Player theme
        backgroundColor: Colors.black,
        // Green for selected item
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        currentIndex: _selectedIndex,
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.fitness_center),
            label: 'Training',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Matches',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Team',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: 'Search',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: 'DM',
          ),
        ],
      ),
    );
  }
}
