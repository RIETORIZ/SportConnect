import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TrainingPage extends StatefulWidget {
  const TrainingPage({super.key});

  @override
  State<TrainingPage> createState() => _TrainingPageState();
}

class _TrainingPageState extends State<TrainingPage> {
  // For demo, we have a fixed coach name & sport:
  final String _coachName = 'Coach John';
  final String _coachSport = 'Soccer';

  // We'll treat 2025-03-20 as "today"
  final DateTime now = DateTime(2025, 3, 20);

  // Example sessions
  final List<Map<String, String>> _sessions = [
    {
      'title': 'Morning Drills',
      'date': '2025-03-20',
      'time': '08:00',
    },
    {
      'title': 'Fitness Training',
      'date': '2025-03-21',
      'time': '10:00',
    },
    {
      'title': 'Strategy Meeting',
      'date': '2025-03-18',
      'time': '19:00',
    },
  ];

  DateTime _parseDateTime(Map<String, String> session) {
    final dateStr = session['date'] ?? '2000-01-01';
    final timeStr = session['time'] ?? '00:00';
    return DateFormat('yyyy-MM-dd HH:mm').parse('$dateStr $timeStr');
  }

  @override
  Widget build(BuildContext context) {
    // Separate upcoming from past sessions
    final upcoming = _sessions.where((s) {
      final dt = _parseDateTime(s);
      return dt.isAfter(now);
    }).toList();

    final previous = _sessions.where((s) {
      final dt = _parseDateTime(s);
      return dt.isBefore(now) || dt.isAtSameMomentAs(now);
    }).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Training Sessions',
            style: TextStyle(color: Colors.greenAccent)),
        backgroundColor: Colors.black,
        iconTheme: const IconThemeData(color: Colors.greenAccent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Coach + Sport Info at top
            Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              shadowColor: Colors.greenAccent,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Coach: $_coachName',
                      style: const TextStyle(
                          color: Colors.greenAccent, fontSize: 18),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sport: $_coachSport',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Scheduled Sessions
            if (upcoming.isNotEmpty)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Scheduled Sessions',
                  style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            if (upcoming.isNotEmpty) const SizedBox(height: 10),
            if (upcoming.isNotEmpty)
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: upcoming.length,
                  itemBuilder: (context, index) {
                    final session = upcoming[index];
                    return Card(
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shadowColor: Colors.greenAccent,
                      child: ListTile(
                        leading: const Icon(Icons.access_time,
                            color: Colors.greenAccent),
                        title: Text(
                          session['title']!,
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
            if (upcoming.isNotEmpty && previous.isNotEmpty)
              const SizedBox(height: 20),

            // Previous Sessions
            if (previous.isNotEmpty)
              const Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Previous Sessions',
                  style: TextStyle(
                      color: Colors.greenAccent,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
              ),
            if (previous.isNotEmpty) const SizedBox(height: 10),
            if (previous.isNotEmpty)
              Expanded(
                flex: 1,
                child: ListView.builder(
                  itemCount: previous.length,
                  itemBuilder: (context, index) {
                    final session = previous[index];
                    return Card(
                      color: Colors.grey[900],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      shadowColor: Colors.greenAccent,
                      child: ListTile(
                        leading: const Icon(Icons.check_circle_outline,
                            color: Colors.greenAccent),
                        title: Text(
                          session['title']!,
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
            if (upcoming.isEmpty && previous.isEmpty)
              const Expanded(
                child: Center(
                  child: Text('No training sessions found.',
                      style: TextStyle(color: Colors.white)),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
