import 'package:flutter/material.dart';
import 'reserve_sport_field_page.dart';

class MatchesPlayedPage extends StatelessWidget {
  const MatchesPlayedPage({super.key});

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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ReserveSportFieldPage(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text(
              'Reserve Sport Field',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Matches Played',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: _matches.length,
              itemBuilder: (context, index) {
                final match = _matches[index];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: const Icon(Icons.sports_soccer, color: Colors.orange),
                    title: Text('${match['teamA']} vs ${match['teamB']}'),
                    subtitle: Text('Date: ${match['date']}'),
                    trailing: Text(
                      'Result: ${match['result']}',
                      style: const TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
