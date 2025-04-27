import 'package:flutter/material.dart';

import 'dm/direct_messages_page.dart';
import 'fields/register_sport_field_page.dart';
import 'fields/sport_fields_page.dart';
import 'profile/renter_edit_profile_page.dart';
import 'search/search_page.dart';

class RenterScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final VoidCallback onLogout;
  final String loggedInEmail;

  const RenterScreen({
    Key? key,
    required this.onThemeChanged,
    required this.onLogout,
    required this.loggedInEmail,
  }) : super(key: key);

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

  final List<Map<String, dynamic>> generalItems = [
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
                          'Renter Name',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '@renterusername',
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
                      Navigator.pop(context);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const RenterEditProfilePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),

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
                  trailing:
                      const Icon(Icons.chevron_right, color: Colors.white30),
                  onTap: () {
                    // Connect to your Django backend with API requests for these menu items
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item['title']} tapped')),
                    );
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
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('${item['title']} tapped')),
                    );
                  },
                );
              }).toList(),
            ),
            const SizedBox(height: 10),

            // Theme toggles
            ListTile(
              leading: const Icon(Icons.light_mode, color: Colors.greenAccent),
              title: const Text('Light Mode',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                widget.onThemeChanged(ThemeMode.light);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.dark_mode, color: Colors.greenAccent),
              title: const Text('Dark Mode',
                  style: TextStyle(color: Colors.white)),
              onTap: () {
                widget.onThemeChanged(ThemeMode.dark);
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.greenAccent),
              title: const Text('System Default',
                  style: TextStyle(color: Colors.white)),
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

  Widget? _buildFloatingActionButton() {
    if (_selectedIndex == 0) {
      return FloatingActionButton.extended(
        onPressed: _navigateToRegisterField,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Field',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
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
        title: const Text('SportConnect'),
        backgroundColor: Colors.green,
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
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.green,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButton: _buildFloatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
