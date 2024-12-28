import 'package:flutter/material.dart';

import 'create_match_page.dart';

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
