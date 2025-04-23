import 'package:flutter/material.dart';

import 'dm/direct_messages_page.dart';
import 'fields/register_sport_field_page.dart';
import 'fields/sport_fields_page.dart';
import 'search/search_page.dart';

class RenterScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final VoidCallback onLogout;
  final String loggedInEmail;

  const RenterScreen({
    super.key,
    required this.onThemeChanged,
    required this.onLogout,
    required this.loggedInEmail,
  });

  @override
  State<RenterScreen> createState() => _RenterScreenState();
}

class _RenterScreenState extends State<RenterScreen> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    SportFieldsPage(),
    SearchPage(),
    DMOverviewPage(),
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
              color: Colors.yellow,
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
                  'Renter Name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                Text(
                  '@renterusername',
                  style: TextStyle(
                    color: Colors.black54,
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

  // Only show the FAB if on tab 0 (Sport Fields)
  Widget? _buildFloatingActionButton() {
    if (_selectedIndex == 0) {
      return FloatingActionButton.extended(
        onPressed: _navigateToRegisterField,
        backgroundColor: Colors.yellow,
        icon: const Icon(Icons.add, color: Colors.black),
        label: const Text(
          'Add Field',
          style: TextStyle(color: Colors.black),
        ),
      );
    }
    // Otherwise, no FAB
    return null;
  }

  void _navigateToRegisterField() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterSportFieldPage(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Renter Menu'),
      ),
      drawer: _buildDrawer(),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.sports_soccer),
            label: 'Sport Fields',
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
        selectedItemColor: Colors.yellow,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),

      // If the buildFloatingActionButton returns null, no FAB is displayed
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
