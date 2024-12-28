import 'package:flutter/material.dart';

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
