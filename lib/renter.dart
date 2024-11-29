import 'package:flutter/material.dart';

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
        title: const Text('Renter Menu'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_box),
            onPressed: () {
              // Navigate to Register Sport Field Page
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const RegisterSportFieldPage(),
                ),
              );
            },
            tooltip: 'Register Sport Field',
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _widgetOptions.elementAt(_selectedIndex),
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
        selectedItemColor: Colors.yellow, // Renter selected color
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
      ),
    );
  }
}

class RegisterSportFieldPage extends StatelessWidget {
  const RegisterSportFieldPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController locationController = TextEditingController();
    final TextEditingController priceController = TextEditingController();

    void _registerField() {
      final String name = nameController.text.trim();
      final String location = locationController.text.trim();
      final String price = priceController.text.trim();

      if (name.isEmpty || location.isEmpty || price.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please fill in all fields')),
        );
        return;
      }

      // Logic to save the field (e.g., API call or local state)
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Field registered successfully!')),
      );
      Navigator.pop(context); // Go back to the previous screen
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Sport Field'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Register a New Sport Field',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Field Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(
                labelText: 'Location',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: priceController,
              decoration: const InputDecoration(
                labelText: 'Price per Hour',
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton(
                onPressed: _registerField,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.yellow, // Button color for renter
                  padding: const EdgeInsets.symmetric(
                      vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Register Field',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SportFieldsPage extends StatelessWidget {
  const SportFieldsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('List of Sport Fields'),
    );
  }
}

class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text('Search for Fields'),
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
