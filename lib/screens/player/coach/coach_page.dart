import 'package:flutter/material.dart';

class CoachPage extends StatelessWidget {
   CoachPage({Key? key}) : super(key: key);

  // Example list of coaches
  // Two for Football, one Basketball, one Tennis
  final List<Map<String, String>> _coaches = [
    {
      'name': 'Coach Nasser',
      'sport': 'Football',
      'emoji': '⚽',
    },
    {
      'name': 'Coach Salem',
      'sport': 'Football',
      'emoji': '⚽',
    },
    {
      'name': 'Coach Amir',
      'sport': 'Basketball',
      'emoji': '🏀',
    },
    {
      'name': 'Coach Lamis',
      'sport': 'Tennis',
      'emoji': '🎾',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Black background for your SC theme
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // Go back
        ),
        title: const Text(
          'Coaches',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: ListView.builder(
        itemCount: _coaches.length,
        itemBuilder: (context, index) {
          final coach = _coaches[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.grey[900],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 5,
              shadowColor: Colors.greenAccent,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Name + Sport
                    Row(
                      children: [
                        Text(
                          coach['emoji'] ?? '',
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 10),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              coach['name'] ?? '',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              coach['sport'] ?? '',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // DM + Manage Subscription buttons
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            // Implement DM logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('DM ${coach['name']} pressed'),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'DM',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            // Manage subscription logic
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Manage subscription for ${coach['name']}',
                                ),
                              ),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Manage Subscription',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
