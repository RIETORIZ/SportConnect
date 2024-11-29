// lib/coach.dart

import 'package:flutter/material.dart';

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

  static const List<Widget> _widgetOptions = <Widget>[
    TrainingPage(),
    MatchesPlayedPage(),
    TeamPage(),
    SearchPage(),
    DirectMessagesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  // Drawer with Theme and Logout functionality
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
                  'Coach Name',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '@coachusername',
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
          const Spacer(), // Pushes the Logout button to the bottom
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Logout',
              style: TextStyle(color: Colors.red),
            ),
            onTap: () {
              Navigator.pop(context); // Close the drawer
              widget.onLogout(); // Call the logout callback
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
        title: const Text('Coach Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              // Navigate to Create Training Session
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const CreateTrainingSessionPage(),
                ),
              );
            },
            tooltip: 'Create Training Session',
          ),
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              // Navigate to Invite Player
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
  currentIndex: _selectedIndex,
  selectedItemColor: Colors.orange, // Coach selected color
  unselectedItemColor: Colors.grey, // Unselected color remains grey
  onTap: _onItemTapped,
  type: BottomNavigationBarType.fixed, // To show all labels
),
    );
  }
}

class CreateTrainingSessionPage extends StatelessWidget {
  const CreateTrainingSessionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Training Session'),
      ),
      body: const Center(
        child: Text(
          'Here you can create a training session.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class InvitePlayerPage extends StatelessWidget {
  const InvitePlayerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Player'),
      ),
      body: const Center(
        child: Text(
          'Here you can invite players to join your team.',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('List of Training Sessions'),
    );
  }
}

class MatchesPlayedPage extends StatelessWidget {
  const MatchesPlayedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Matches Played'),
    );
  }
}

class TeamPage extends StatelessWidget {
  const TeamPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Your Team'),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Search for Teams'),
    );
  }
}

class DirectMessagesPage extends StatelessWidget {
  const DirectMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Direct Messages'),
    );
  }
}
