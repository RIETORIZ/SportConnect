import 'package:flutter/material.dart';

class CoachTrainingPage extends StatefulWidget {
  const CoachTrainingPage({super.key});

  @override
  State<CoachTrainingPage> createState() => _CoachTrainingPageState();
}

class _CoachTrainingPageState extends State<CoachTrainingPage> {
  final List<Map<String, String>> _trainingSessions = [
    {
      'title': 'Morning Soccer Drills',
      'date': '2024-04-15',
      'image': 'assets/soccer_field.png',
    },
    {
      'title': 'Evening Fitness Training',
      'date': '2024-04-20',
      'image': 'assets/soccer_field.png',
    },
  ];

  final TextEditingController _sessionTitleController = TextEditingController();
  final TextEditingController _sessionDateController = TextEditingController();

  void _createNewSession() {
    final title = _sessionTitleController.text.trim();
    final date = _sessionDateController.text.trim();

    if (title.isEmpty || date.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter both title and date')),
      );
      return;
    }

    setState(() {
      _trainingSessions.add({
        'title': title,
        'date': date,
        'image': 'assets/soccer_field.png',
      });
      _sessionTitleController.clear();
      _sessionDateController.clear();
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('New Training Session Created')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: _sessionTitleController,
            decoration: const InputDecoration(
              labelText: 'Session Title',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _sessionDateController,
            decoration: const InputDecoration(
              labelText: 'Session Date (YYYY-MM-DD)',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _createNewSession,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Create Session',
              style: TextStyle(fontSize: 16, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          const Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Training Sessions:',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: _trainingSessions.isNotEmpty
                ? ListView.builder(
                    itemCount: _trainingSessions.length,
                    itemBuilder: (context, index) {
                      final session = _trainingSessions[index];
                      return Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 4,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.asset(
                              session['image']!,
                              width: 50,
                              height: 50,
                              fit: BoxFit.cover,
                            ),
                          ),
                          title: Text(session['title']!),
                          subtitle: Text('Date: ${session['date']}'),
                        ),
                      );
                    },
                  )
                : const Center(
                    child: Text('No training sessions created yet.'),
                  ),
          ),
        ],
      ),
    );
  }
}
