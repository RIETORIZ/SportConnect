import 'package:flutter/material.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({Key? key}) : super(key: key);

  @override
  _TeamsPageState createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  // Example data: Some teams the user is a member of, others not.
  // Each team has a "sport" and "isMember" bool to indicate membership.
  final List<Map<String, dynamic>> _allTeams = [
    {
      'teamName': 'Riyadh Rangers',
      'sport': 'Soccer',
      'isMember': true,
    },
    {
      'teamName': 'Jeddah Jets',
      'sport': 'Basketball',
      'isMember': false,
    },
    {
      'teamName': 'Dammam Dynamos',
      'sport': 'Soccer',
      'isMember': true,
    },
    {
      'teamName': 'Mecca Mavericks',
      'sport': 'Tennis',
      'isMember': false,
    },
    {
      'teamName': 'Medina Meteors',
      'sport': 'Basketball',
      'isMember': false,
    },
  ];

  // Separate the teams based on membership
  List<Map<String, dynamic>> get currentTeams =>
      _allTeams.where((team) => team['isMember'] == true).toList();

  List<Map<String, dynamic>> get otherTeams =>
      _allTeams.where((team) => team['isMember'] == false).toList();

  // Example placeholder for "Join Team"
  void _joinTeam() {
    // Implement your "join" logic or navigation here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Join Team feature is not implemented!')),
    );
  }

  // Example placeholder for "Create Team"
  void _createTeam() {
    // Implement your "create" logic or navigation here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create Team feature is not implemented!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Same dark background
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Two buttons at the top: Join Team, Create Team
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _joinTeam,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Join Team',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _createTeam,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Create Team',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Current Teams section
            if (currentTeams.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Current Teams',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (currentTeams.isNotEmpty) const SizedBox(height: 10),

            if (currentTeams.isNotEmpty)
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: currentTeams.length,
                  itemBuilder: (context, index) {
                    final team = currentTeams[index];
                    return Card(
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(
                          Icons.group,
                          color: Colors.greenAccent,
                        ),
                        // Add sport next to team name
                        title: Text(
                          '${team['teamName']} (${team['sport']})',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: const Text(
                          'You are a member of this team',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
              ),

            if (currentTeams.isNotEmpty && otherTeams.isNotEmpty)
              const SizedBox(height: 20),

            // Other Teams section
            if (otherTeams.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Other Teams',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (otherTeams.isNotEmpty) const SizedBox(height: 10),

            if (otherTeams.isNotEmpty)
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: otherTeams.length,
                  itemBuilder: (context, index) {
                    final team = otherTeams[index];
                    return ListTile(
                      leading: const Icon(
                        Icons.group,
                        color: Colors.greenAccent,
                      ),
                      // Sport next to team name
                      title: Text(
                        '${team['teamName']} (${team['sport']})',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: const Text(
                        'You are not a member of this team',
                        style: TextStyle(color: Colors.grey),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
