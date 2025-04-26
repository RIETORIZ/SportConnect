import 'package:flutter/material.dart';

// ── feature screens ─────────────────────────────────────────
import 'coach/coach_page.dart';
import 'dm/direct_messages.dart';
import 'family/family_members_page.dart';
import 'fields/sports_feed.dart';
import 'friends/friends_page.dart';
import 'matches/matches_page.dart';
import 'profile/edit_profile_page.dart';
import 'reports/reports_page.dart';
import 'settings/player_settings_page.dart';
import 'teams/teams_page.dart';
import 'training/training_page.dart';
// ────────────────────────────────────────────────────────────

class PlayerHomeScreen extends StatefulWidget {
  const PlayerHomeScreen({
    Key? key,
    required this.onThemeChanged,
    required this.onLogout,
    required this.loggedInEmail,
  }) : super(key: key);

  final Function(ThemeMode) onThemeChanged;
  final VoidCallback onLogout;
  final String loggedInEmail;

  @override
  State<PlayerHomeScreen> createState() => _PlayerHomeScreenState();
}

class _PlayerHomeScreenState extends State<PlayerHomeScreen> {
  int _selectedIndex = 0;

  static final _pages = <Widget>[
    const SportsFeed(),
    const MatchesPage(),
    const TeamsPage(),
    const TrainingPage(),
    const DMOverviewPage(),
  ];

  final _general = [
    {'title': 'Family Members', 'icon': Icons.people},
    {'title': 'Reports',        'icon': Icons.description},
    {'title': 'Payment Methods','icon': Icons.account_balance_wallet},
    {'title': 'Your Reviews',   'icon': Icons.rate_review},
    {'title': 'Settings',       'icon': Icons.settings},
  ];

  final _prefs = [
    {'title': 'Help & Support', 'icon': Icons.help_outline},
    {'title': 'Privacy & Policy','icon': Icons.privacy_tip_outlined},
  ];

  void _onItemTapped(int idx) => setState(() => _selectedIndex = idx);

  // ───────────────────────── Drawer ─────────────────────────
  Drawer _buildDrawer() {
    return Drawer(
      backgroundColor: Colors.black,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // — top user card —
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              color: Colors.green,
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/player_profile.png'),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('adminP',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold)),
                        Text('@adminPUser',
                            style:
                                TextStyle(color: Colors.white70, fontSize: 14)),
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
                              builder: (_) => const ProfileEditPage()));
                    },
                  )
                ],
              ),
            ),
            const SizedBox(height: 10),

            // — quick links —
            _drawerTile(
              icon: Icons.person,
              title: 'Friends',
              onTap: () => _push(const FriendsPage()),
            ),
            _drawerTile(
              icon: Icons.person_pin,
              title: 'Coach',
              onTap: () => _push(CoachPage()),
            ),
            const SizedBox(height: 8),

            // — GENERAL —
            ExpansionTile(
              title: _expTitle('General'),
              collapsedIconColor: Colors.greenAccent,
              iconColor: Colors.greenAccent,
              backgroundColor: Colors.grey[900],
              collapsedBackgroundColor: Colors.grey[900],
              childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
              children: _general.map(_buildGeneralTile).toList(),
            ),

            // — PREFERENCES —
            ExpansionTile(
              title: _expTitle('Preferences'),
              collapsedIconColor: Colors.greenAccent,
              iconColor: Colors.greenAccent,
              backgroundColor: Colors.grey[900],
              collapsedBackgroundColor: Colors.grey[900],
              childrenPadding: const EdgeInsets.symmetric(horizontal: 10),
              children: _prefs
                  .map((e) => _drawerTile(
                        icon: e['icon'] as IconData,
                        title: e['title'] as String,
                        onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('${e['title']} tapped'))),
                      ))
                  .toList(),
            ),
            const SizedBox(height: 10),

            // — theme toggles —
            _themeTile(Icons.light_mode, 'Light Mode', ThemeMode.light),
            _themeTile(Icons.dark_mode,  'Dark Mode',  ThemeMode.dark),
            _themeTile(Icons.settings,   'System Default', ThemeMode.system),

            const SizedBox(height: 10),

            // — logout —
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

  // ----------------------------------------------------------------
  // helpers
  // ----------------------------------------------------------------
  Widget _expTitle(String t) => Text(t,
      style: const TextStyle(
          color: Colors.greenAccent, fontSize: 16, fontWeight: FontWeight.bold));

  ListTile _drawerTile(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.greenAccent),
      title: Text(title, style: const TextStyle(color: Colors.white)),
      trailing: const Icon(Icons.chevron_right, color: Colors.white30),
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
    );
  }

  // push helper
  void _push(Widget page) =>
      Navigator.push(context, MaterialPageRoute(builder: (_) => page));

  // general items handler
  ListTile _buildGeneralTile(Map<String, dynamic> item) {
    final title = item['title'] as String;
    return _drawerTile(
      icon: item['icon'] as IconData,
      title: title,
      onTap: () {
        switch (title) {
          case 'Family Members':
            _push(FamilyMembersPage());
            break;
          case 'Reports':
            _push(ReportsPage());
            break;
          case 'Settings':
            _push(const PlayerSettingsPage());
            break;
          default:
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('$title tapped')));
        }
      },
    );
  }

  // theme tile
  ListTile _themeTile(IconData icon, String title, ThemeMode mode) =>
      ListTile(
        leading: Icon(icon, color: Colors.greenAccent),
        title: Text(title, style: const TextStyle(color: Colors.white)),
        onTap: () {
          widget.onThemeChanged(mode);
          Navigator.pop(context);
        },
      );

  // ───────────────────────── Scaffold ──────────────────────────
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SportConnect'),
        backgroundColor: Colors.green,
      ),
      drawer: _buildDrawer(),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey,
        backgroundColor: Colors.green,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_soccer), label: 'Sportfields'),
          BottomNavigationBarItem(
              icon: Icon(Icons.sports_score), label: 'Matches'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Teams'),
          BottomNavigationBarItem(
              icon: Icon(Icons.fitness_center), label: 'Training'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'DM'),
        ],
      ),
    );
  }
}
