import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'invite_player_page.dart';
class CoachTrainingPage extends StatefulWidget {
  const CoachTrainingPage({Key? key}) : super(key: key);

  @override
  State<CoachTrainingPage> createState() => _CoachTrainingPageState();
}

class _CoachTrainingPageState extends State<CoachTrainingPage> {
  // We'll treat 2025-03-20 as the "current" date
  final DateTime now = DateTime(2025, 3, 20);

  // A sample list of training sessions with date/time
  final List<Map<String, String>> _trainingSessions = [
    {
      'title': 'Morning Soccer Drills',
      'date': '2024-04-15',
      'time': '08:00',
      'sport': 'Soccer',
    },
    {
      'title': 'Evening Fitness Training',
      'date': '2024-04-20',
      'time': '18:00',
      'sport': 'Basketball',
    },
    {
      'title': 'All-Day Tennis Practice',
      'date': '2025-03-20',
      'time': '09:00',
      'sport': 'Tennis',
    },
  ];

  DateTime _parseDateTime(Map<String, String> session) {
    // Combine date + time into a single DateTime
    final dateStr = session['date'] ?? '2000-01-01';
    final timeStr = session['time'] ?? '00:00';
    return DateFormat('yyyy-MM-dd HH:mm').parse('$dateStr $timeStr');
  }

  @override
  Widget build(BuildContext context) {
    // Separate into upcoming vs. previous sessions
    final upcomingSessions = _trainingSessions.where((session) {
      final dt = _parseDateTime(session);
      return dt.isAfter(now);
    }).toList();

    final previousSessions = _trainingSessions.where((session) {
      final dt = _parseDateTime(session);
      return dt.isBefore(now) || dt.isAtSameMomentAs(now);
    }).toList();

    void _navigateToCreateSession() {
      // Navigate to InvitePlayerPage (for date/hour, sport type, invites)
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const InvitePlayerPage()),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Coach Training',
          style: TextStyle(color: Colors.greenAccent),
        ),
        iconTheme: const IconThemeData(color: Colors.greenAccent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // "Create Training Session" Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _navigateToCreateSession,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Create Training Session',
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Upcoming Sessions
            if (upcomingSessions.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Upcoming Training Sessions',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (upcomingSessions.isNotEmpty) const SizedBox(height: 10),
            if (upcomingSessions.isNotEmpty)
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: upcomingSessions.length,
                  itemBuilder: (context, index) {
                    final session = upcomingSessions[index];
                    return Card(
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shadowColor: Colors.greenAccent,
                      child: ListTile(
                        leading: Icon(
                          Icons.access_time,
                          color: Colors.greenAccent,
                        ),
                        title: Text(
                          '${session['title']} (${session['sport']})',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Date: ${session['date']} @ ${session['time']}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
              ),

            if (upcomingSessions.isNotEmpty && previousSessions.isNotEmpty)
              const SizedBox(height: 20),

            // Previous Sessions
            if (previousSessions.isNotEmpty)
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Previous Training Sessions',
                  style: TextStyle(
                    color: Colors.greenAccent,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            if (previousSessions.isNotEmpty) const SizedBox(height: 10),
            if (previousSessions.isNotEmpty)
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: previousSessions.length,
                  itemBuilder: (context, index) {
                    final session = previousSessions[index];
                    return Card(
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      shadowColor: Colors.greenAccent,
                      child: ListTile(
                        leading: Icon(
                          Icons.check_circle_outline,
                          color: Colors.greenAccent,
                        ),
                        title: Text(
                          '${session['title']} (${session['sport']})',
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          'Date: ${session['date']} @ ${session['time']}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  },
                ),
              ),

            // If no sessions at all
            if (upcomingSessions.isEmpty && previousSessions.isEmpty)
              const Expanded(
                child: Center(
                  child: Text(
                    'No training sessions found.',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
