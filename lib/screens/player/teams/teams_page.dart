import 'package:flutter/material.dart';
import 'find_team_matches_page.dart';

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
      'teamId': 1,
      'teamName': 'Riyadh Rangers',
      'sport': 'Soccer',
      'region': 'Riyadh',
      'isMember': true,
    },
    {
      'teamId': 2,
      'teamName': 'Jeddah Jets',
      'sport': 'Basketball',
      'region': 'Jeddah',
      'isMember': false,
    },
    {
      'teamId': 3,
      'teamName': 'Dammam Dynamos',
      'sport': 'Soccer',
      'region': 'Dammam',
      'isMember': true,
    },
    {
      'teamId': 4,
      'teamName': 'Mecca Mavericks',
      'sport': 'Tennis',
      'region': 'Mecca',
      'isMember': false,
    },
    {
      'teamId': 5,
      'teamName': 'Medina Meteors',
      'sport': 'Basketball',
      'region': 'Medina',
      'isMember': false,
    },
  ];

  // Separate the teams based on membership
  List<Map<String, dynamic>> get currentTeams =>
      _allTeams.where((team) => team['isMember'] == true).toList();

  List<Map<String, dynamic>> get otherTeams =>
      _allTeams.where((team) => team['isMember'] == false).toList();

  // Join an existing team
  void _joinTeam() {
    // Implement your "join" logic or navigation here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Join Team feature is not implemented!')),
    );
  }

  // Create a new team
  void _createTeam() {
    // Implement your "create" logic or navigation here
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Create Team feature is not implemented!')),
    );
  }

  // Find matches for a team using the matching algorithm
  void _findMatchesForTeam(Map<String, dynamic> team) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FindTeamMatchesPage(
          teamId: team['teamId'],
          teamName: team['teamName'],
          sport: team['sport'],
          region: team['region'],
        ),
      ),
    );
  }

  // View team details
  void _viewTeamDetails(Map<String, dynamic> team) {
    // For now, just show a dialog with team info
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(
          team['teamName'],
          style: const TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _infoRow(Icons.sports, 'Sport', team['sport']),
            const SizedBox(height: 8),
            _infoRow(Icons.location_on, 'Region', team['region']),
            const SizedBox(height: 8),
            _infoRow(
              Icons.group,
              'Status',
              team['isMember'] ? 'Member' : 'Not a member',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close', style: TextStyle(color: Colors.green)),
          ),
          if (team['isMember'])
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _findMatchesForTeam(team);
              },
              child: const Text('Find Matches',
                  style: TextStyle(color: Colors.green)),
            ),
        ],
      ),
    );
  }

  Widget _infoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, color: Colors.greenAccent, size: 20),
        const SizedBox(width: 8),
        Text(
          '$label:',
          style: const TextStyle(
            color: Colors.white70,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: const TextStyle(color: Colors.white),
        ),
      ],
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
                        subtitle: Row(
                          children: [
                            Icon(Icons.location_on,
                                color: Colors.greenAccent, size: 14),
                            SizedBox(width: 4),
                            Text(
                              team['region'],
                              style: TextStyle(color: Colors.white70),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.info_outline,
                                  color: Colors.blue),
                              onPressed: () => _viewTeamDetails(team),
                            ),
                            IconButton(
                              icon: const Icon(Icons.sports_soccer,
                                  color: Colors.green),
                              onPressed: () => _findMatchesForTeam(team),
                              tooltip: 'Find matches',
                            ),
                          ],
                        ),
                        onTap: () => _viewTeamDetails(team),
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
                      subtitle: Row(
                        children: [
                          Icon(Icons.location_on,
                              color: Colors.greenAccent, size: 14),
                          SizedBox(width: 4),
                          Text(
                            team['region'],
                            style: TextStyle(color: Colors.white70),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        icon:
                            const Icon(Icons.info_outline, color: Colors.blue),
                        onPressed: () => _viewTeamDetails(team),
                      ),
                      onTap: () => _viewTeamDetails(team),
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
