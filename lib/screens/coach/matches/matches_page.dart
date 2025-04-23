import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'create_match_page.dart';

class MatchesPage extends StatefulWidget {
  const MatchesPage({super.key});

  @override
  _MatchesPageState createState() => _MatchesPageState();
}

class _MatchesPageState extends State<MatchesPage> {
  final List<Map<String, String>> _allMatches = [
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
    {
      'teamA': 'Mecca Mavericks',
      'teamB': 'Medina Meteors',
      'date': '2025-09-01',
      'time': '18:00',
    },
    {
      'teamA': 'Riyadh Rangers',
      'teamB': 'Dammam Dynamos',
      'date': '2025-09-05',
      'time': '20:00',
    },
  ];

  DateTime _parseMatchDate(Map<String, String> match) {
    String dateStr = match['date'] ?? '';
    if (match.containsKey('time')) {
      dateStr += ' ${match['time']}';
      return DateFormat('yyyy-MM-dd HH:mm').parse(dateStr);
    } else {
      return DateFormat('yyyy-MM-dd').parse(dateStr);
    }
  }

  String _formatMatchDate(Map<String, String> match) {
    final dt = _parseMatchDate(match);
    if (match.containsKey('time')) {
      return DateFormat('yyyy-MM-dd @ HH:mm').format(dt);
    } else {
      return DateFormat('yyyy-MM-dd').format(dt);
    }
  }

  void _navigateToCreateMatch() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CreateMatchPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final upcomingMatches = _allMatches.where((m) {
      final matchDate = _parseMatchDate(m);
      return matchDate.isAfter(now);
    }).toList();

    final playedMatches = _allMatches.where((m) {
      final matchDate = _parseMatchDate(m);
      return matchDate.isBefore(now) || matchDate.isAtSameMomentAs(now);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _navigateToCreateMatch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
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
            const SizedBox(height: 20),
            if (upcomingMatches.isNotEmpty)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Scheduled Matches',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (upcomingMatches.isNotEmpty) const SizedBox(height: 10),
            if (upcomingMatches.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: upcomingMatches.length,
                  itemBuilder: (context, index) {
                    final match = upcomingMatches[index];
                    return Card(
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 3,
                      child: ListTile(
                        leading: const Icon(
                          Icons.access_time,
                          color: Colors.greenAccent,
                        ),
                        title: Text(
                          '${match['teamA']} vs ${match['teamB']}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Text(
                          _formatMatchDate(match),
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
              ),
            if (upcomingMatches.isNotEmpty && playedMatches.isNotEmpty)
              const SizedBox(height: 20),
            if (playedMatches.isNotEmpty)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Matches Played',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (playedMatches.isNotEmpty) const SizedBox(height: 10),
            if (playedMatches.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: playedMatches.length,
                  itemBuilder: (context, index) {
                    final match = playedMatches[index];
                    return ListTile(
                      leading: const Icon(
                        Icons.sports_soccer,
                        color: Colors.greenAccent,
                      ),
                      title: Text(
                        '${match['teamA']} vs ${match['teamB']}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      subtitle: Text(
                        'Date: ${match['date']}',
                        style: const TextStyle(color: Colors.grey),
                      ),
                      trailing: match.containsKey('result')
                          ? Text(
                              'Result: ${match['result']}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )
                          : null,
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
