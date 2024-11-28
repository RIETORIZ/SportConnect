// lib/main.dart

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart'; // Ensure login.dart is in the same lib directory

void main() {
  runApp(const SportConnectApp());
}

class SportConnectApp extends StatefulWidget {
  const SportConnectApp({super.key});

  @override
  State<SportConnectApp> createState() => _SportConnectAppState();
}

class _SportConnectAppState extends State<SportConnectApp> {
  ThemeMode _themeMode = ThemeMode.system;
  bool _isLoggedIn = false;
  String _loggedInEmail = '';

  @override
  void initState() {
    super.initState();
    _loadLoginState();
  }

  // Load login state from SharedPreferences
  Future<void> _loadLoginState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
      _loggedInEmail = prefs.getString('loggedInEmail') ?? '';
    });
  }

  void _changeThemeMode(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  // Handle user login
  Future<void> _handleLogin(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', true);
    await prefs.setString('loggedInEmail', email);
    setState(() {
      _isLoggedIn = true;
      _loggedInEmail = email;
    });
  }

  // Handle user logout
  Future<void> _handleLogout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('loggedInEmail');
    setState(() {
      _isLoggedIn = false;
      _loggedInEmail = '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SportConnect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
        primaryColor: Colors.green,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.green,
          foregroundColor: Colors.white,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF1B5E20),
          selectedItemColor: Colors.yellowAccent,
          unselectedItemColor: Colors.white,
        ),
      ),
      darkTheme: ThemeData.dark(),
      themeMode: _themeMode,
      home: _isLoggedIn
          ? HomeScreen(
              onThemeChanged: _changeThemeMode,
              onLogout: _handleLogout,
              loggedInEmail: _loggedInEmail,
            )
          : LoginScreen(
              onLogin: _handleLogin,
            ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  final Function(ThemeMode) onThemeChanged;
  final VoidCallback onLogout;
  final String loggedInEmail;

  const HomeScreen({
    super.key,
    required this.onThemeChanged,
    required this.onLogout,
    required this.loggedInEmail,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of widgets for BottomNavigationBar
  static final List<Widget> _widgetOptions = <Widget>[
    SportsFeed(),
    MatchesPage(),
    TeamSearchPage(),
    TrainingPage(),
    DirectMessages(),
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
            icon: Icon(Icons.group), // Corrected from Icons.group_search
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
        selectedItemColor: Colors.yellowAccent,
        unselectedItemColor: Colors.white,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // To show all labels
      ),
    );
  }
}

class MatchesPlayed extends StatefulWidget {
  const MatchesPlayed({super.key});

  @override
  _MatchesPlayedState createState() => _MatchesPlayedState();
}

class _MatchesPlayedState extends State<MatchesPlayed> {
  final List<Map<String, String>> _matches = const [
    {
      'teamA': 'Riyadh Rangers',
      'teamB': 'Jeddah Jets',
      'date': '2024-05-20',
      'result': '2-1',
    },
    {
      'teamA': 'Dammam Dynamos',
      'teamB': 'Riyadh Rangers',
      'date': '2024-06-15',
      'result': '1-3',
    },
    {
      'teamA': 'Jeddah Jets',
      'teamB': 'Dammam Dynamos',
      'date': '2024-07-10',
      'result': '0-0',
    },
  ];

  // Function to navigate to CreateMatchPage
  void _navigateToCreateMatch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateMatchPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // "Create Match" Button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _navigateToCreateMatch(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Create Match',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        // "Matches Played" Header
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Matches Played',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // List of Matches
        Expanded(
          child: ListView.builder(
            itemCount: _matches.length,
            itemBuilder: (context, index) {
              final match = _matches[index];
              return ListTile(
                leading: const Icon(Icons.sports_soccer, color: Colors.green),
                title: Text('${match['teamA']} vs ${match['teamB']}'),
                subtitle: Text('Date: ${match['date']}'),
                trailing: Text('Result: ${match['result']}'),
              );
            },
          ),
        ),
      ],
    );
  }
}

class CreateMatchPage extends StatefulWidget {
  const CreateMatchPage({super.key});

  @override
  State<CreateMatchPage> createState() => _CreateMatchPageState();
}

class _CreateMatchPageState extends State<CreateMatchPage> {
  String? _selectedSport;
  String? _selectedField;
  String? _selectedMatchType;
  bool _inviteEnemyTeam = false;

  final List<String> _sportTypes = ['Soccer', 'Basketball', 'Tennis'];
  final List<Map<String, String>> _availableFields = [
    {
      'name': 'Sunny Soccer Field',
      'location': 'Riyadh',
    },
    {
      'name': 'Basketball Court',
      'location': 'Jeddah',
    },
    {
      'name': 'Tennis Court',
      'location': 'Dammam',
    },
  ];

  final List<String> _matchTypes = ['Tournament', 'Casual'];

  // Function to navigate to SearchEnemyTeamPage
  void _navigateToSearchEnemyTeam(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchEnemyTeamPage()),
    );
  }

  // Function to handle form submission
  void _createMatch() {
    if (_selectedSport == null ||
        _selectedField == null ||
        _selectedMatchType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    if (_inviteEnemyTeam) {
      _navigateToSearchEnemyTeam(context);
    } else {
      // Implement invite enemy team functionality
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Match created successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Match'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Select Sport Type
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Sport Type',
                  border: OutlineInputBorder(),
                ),
                value: _selectedSport,
                items: _sportTypes
                    .map((sport) => DropdownMenuItem(
                          value: sport,
                          child: Text(sport),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSport = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Select Field
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Field',
                  border: OutlineInputBorder(),
                ),
                value: _selectedField,
                items: _availableFields
                    .map((field) => DropdownMenuItem(
                          value: field['name'],
                          child: Text('${field['name']} (${field['location']})'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedField = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Select Match Type
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Match Type',
                  border: OutlineInputBorder(),
                ),
                value: _selectedMatchType,
                items: _matchTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMatchType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              // Invite Enemy Team or Search
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Enemy Team:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: _inviteEnemyTeam,
                    onChanged: (value) {
                      setState(() {
                        _inviteEnemyTeam = value;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ],
              ),
              if (!_inviteEnemyTeam)
                ElevatedButton(
                  onPressed: () => _navigateToSearchEnemyTeam(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Search for Enemy Team',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              const SizedBox(height: 30),
              // Create Match Button
              ElevatedButton(
                onPressed: _createMatch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Create Match',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchEnemyTeamPage extends StatefulWidget {
  const SearchEnemyTeamPage({super.key});

  @override
  State<SearchEnemyTeamPage> createState() => _SearchEnemyTeamPageState();
}

class _SearchEnemyTeamPageState extends State<SearchEnemyTeamPage> {
  bool _isMatchmaking = true;

  // Simulate matchmaking delay
  @override
  void initState() {
    super.initState();
    // Simulate matchmaking process (e.g., search for enemy team)
    // Here, you can implement actual matchmaking logic or API calls
  }

  void _cancelMatchmaking() {
    setState(() {
      _isMatchmaking = false;
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Matchmaking cancelled')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Enemy Team'),
      ),
      body: Center(
        child: _isMatchmaking
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Searching for an enemy team...',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _cancelMatchmaking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cancel Matchmaking',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              )
            : const Text('Matchmaking cancelled'),
      ),
    );
  }
}

class SportsFeed extends StatefulWidget {
  const SportsFeed({super.key});

  @override
  _SportsFeedState createState() => _SportsFeedState();
}

class _SportsFeedState extends State<SportsFeed> {
  String _selectedFieldType = 'All';

  final List<Map<String, String>> _fields = [
    {
      'name': 'Sunny Soccer Field',
      'location': 'Riyadh',
      'image': 'assets/sunny-soccer-field-picture-demo.jpg',
      'suitableForWomen': 'false',
    },
    {
      'name': 'Basketball Court',
      'location': 'Jeddah',
      'image': 'assets/basketball.jpeg',
      'suitableForWomen': 'true',
    },
    {
      'name': 'Tennis Court',
      'location': 'Dammam',
      'image': 'assets/tennis.jpg',
      'suitableForWomen': 'false',
    },
  ];

  void _navigateToFieldInfo(BuildContext context, Map<String, String> field) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FieldInfoPage(
          fieldName: field['name']!,
          location: field['location']!,
          imagePath: field['image']!,
          suitableForWomen: field['suitableForWomen'] == 'true',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Filter fields based on selected type
    List<Map<String, String>> filteredFields = _selectedFieldType == 'All'
        ? _fields
        : _fields.where((field) {
            return field['name']!
                .toLowerCase()
                .contains(_selectedFieldType.toLowerCase());
          }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: _selectedFieldType,
            onChanged: (String? newValue) {
              setState(() {
                _selectedFieldType = newValue!;
              });
            },
            items: <String>['All', 'Soccer', 'Basketball', 'Tennis']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredFields.length,
            itemBuilder: (context, index) {
              final field = filteredFields[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                  shadowColor: Colors.greenAccent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => _navigateToFieldInfo(context, field),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            field['image']!,
                            fit: BoxFit.cover,
                            height: 150,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          field['name']!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        subtitle: Text(
                          'Location: ${field['location']}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            _navigateToFieldInfo(context, field);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellowAccent,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                          ),
                          onPressed: () {
                            _navigateToFieldInfo(context, field);
                          },
                          child: const Text(
                            'Reserve Now',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class FieldInfoPage extends StatelessWidget {
  final String fieldName;
  final String location;
  final String imagePath;
  final bool suitableForWomen; // New property

  const FieldInfoPage({
    super.key,
    required this.fieldName,
    required this.location,
    required this.imagePath,
    required this.suitableForWomen, // Initialize in constructor
  });

  @override
  Widget build(BuildContext context) {
    // Define the list of facilities
    List<Widget> facilitiesList = [
      const FacilityRow(
        icon: Icons.local_parking,
        text: 'Parking Available',
      ),
      const SizedBox(height: 10),
      const FacilityRow(
        icon: Icons.people,
        text: 'Capacity: 200 people',
      ),
      const SizedBox(height: 10),
      const FacilityRow(
        icon: Icons.lightbulb,
        text: 'Lighting Available',
      ),
    ];

    // Conditionally add "Suitable for Women 🙋‍♀️" if applicable
    if (suitableForWomen) {
      facilitiesList.addAll([
        const SizedBox(height: 10),
        const FacilityRow(
          icon: Icons.sports_basketball,
          text: 'Suitable for Women 🙋‍♀️',
        ),
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Information'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 200,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              fieldName,
              style: const TextStyle(
                  fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Location: $location',
              style: const TextStyle(color: Colors.grey, fontSize: 18),
            ),
            const SizedBox(height: 16),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'This field has a premium surface and is ideal for both recreational and competitive events. Available for booking 24/7 with top-notch facilities including lighting, seating, and changing rooms.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Facilities:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: facilitiesList,
            ),
            const SizedBox(height: 16),
            Center(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellowAccent,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 20),
                ),
                onPressed: () {
                  // Implement your reservation logic here
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Field Reserved')),
                  );
                },
                child: const Text(
                  'Reserve Now',
                  style: TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FacilityRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const FacilityRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.green, size: 30),
        const SizedBox(width: 10),
        Text(text, style: const TextStyle(fontSize: 16)),
      ],
    );
  }
}

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  _MatchesPageState createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  final List<Map<String, String>> _matches = const [
    {
      'teamA': 'Riyadh Rangers',
      'teamB': 'Jeddah Jets',
      'date': '2024-05-20',
      'result': '2-1',
    },
    {
      'teamA': 'Dammam Dynamos',
      'teamB': 'Riyadh Rangers',
      'date': '2024-06-15',
      'result': '1-3',
    },
    {
      'teamA': 'Jeddah Jets',
      'teamB': 'Dammam Dynamos',
      'date': '2024-07-10',
      'result': '0-0',
    },
  ];

  // Function to navigate to CreateMatchPage
  void _navigateToCreateMatch(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateMatchPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // "Create Match" Button
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: ElevatedButton(
            onPressed: () => _navigateToCreateMatch(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Create Match',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
        ),
        // "Matches Played" Header
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Matches Played',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
        ),
        // List of Matches
        Expanded(
          child: ListView.builder(
            itemCount: _matches.length,
            itemBuilder: (context, index) {
              final match = _matches[index];
              return ListTile(
                leading: const Icon(Icons.sports_soccer, color: Colors.green),
                title: Text('${match['teamA']} vs ${match['teamB']}'),
                subtitle: Text('Date: ${match['date']}'),
                trailing: Text('Result: ${match['result']}'),
              );
            },
          ),
        ),
      ],
    );
  }
}

class TeamSearchPage extends StatefulWidget {
  const TeamSearchPage({super.key});

  @override
  _TeamSearchPageState createState() => _TeamSearchPageState();
}

class _TeamSearchPageState extends State<TeamSearchPage> {
  String _searchQuery = '';
  final List<String> _teams = [
    'Riyadh Rangers',
    'Jeddah Jets',
    'Dammam Dynamos',
    'Mecca Mavericks',
    'Medina Meteors',
  ];

  @override
  Widget build(BuildContext context) {
    List<String> _filteredTeams = _teams
        .where((team) =>
            team.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Team Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Search Teams',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: _filteredTeams.isNotEmpty
                  ? ListView.builder(
                      itemCount: _filteredTeams.length,
                      itemBuilder: (context, index) {
                        final team = _filteredTeams[index];
                        return ListTile(
                          leading: const Icon(Icons.group, color: Colors.green),
                          title: Text(team),
                          onTap: () {
                            // Implement team details or actions
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Selected Team: $team')),
                            );
                          },
                        );
                      },
                    )
                  : const Center(
                      child: Text('No teams found.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class TrainingPage extends StatelessWidget {
  const TrainingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Training Sessions'),
      ),
      body: Center(
        child: Text(
          'Training creation interface for coaches will be here.',
          style: TextStyle(fontSize: 18, color: Colors.grey[700]),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

class DirectMessages extends StatelessWidget {
  const DirectMessages({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Direct Messages'),
    );
  }
}
