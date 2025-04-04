import 'package:flutter/material.dart';

class ReportsPage extends StatelessWidget {
   ReportsPage({Key? key}) : super(key: key);

  // Example list of 6 reports
  // Each has a "coachReview", "sport", "emoji", and "improvement"
  final List<Map<String, String>> _reports = [
    {
      'coachReview': 'Great hustle and tackling during the match!',
      'sport': 'Football',
      'emoji': '⚽',
      'improvement': 'Focus on passing accuracy and positioning.',
    },
    {
      'coachReview': 'Solid shooting form, keep it up!',
      'sport': 'Basketball',
      'emoji': '🏀',
      'improvement': 'Improve dribbling with your non-dominant hand.',
    },
    {
      'coachReview': 'Excellent baseline game, strong forehand swings!',
      'sport': 'Tennis',
      'emoji': '🎾',
      'improvement': 'Work on your backhand consistency and footwork.',
    },
    {
      'coachReview': 'Your ball control is improving quickly.',
      'sport': 'Football',
      'emoji': '⚽',
      'improvement': 'Be mindful of quick decision-making under pressure.',
    },
    {
      'coachReview': 'Nice court vision and teamwork!',
      'sport': 'Basketball',
      'emoji': '🏀',
      'improvement': 'Try to reduce turnovers by practicing precise passes.',
    },
    {
      'coachReview': 'Impressive stamina and strong serves!',
      'sport': 'Tennis',
      'emoji': '🎾',
      'improvement': 'Focus on slice variation and volley techniques.',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark theme
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // Go back
        ),
        title: const Text('Reports', style: TextStyle(color: Colors.white)),
      ),
      body: ListView.builder(
        itemCount: _reports.length,
        itemBuilder: (context, index) {
          final report = _reports[index];
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
                    // Coach Review
                    Text(
                      'Coach Review:',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      report['coachReview'] ?? '',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // Sport + Emoji
                    Row(
                      children: [
                        Text(
                          report['emoji'] ?? '',
                          style: const TextStyle(fontSize: 24),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          report['sport'] ?? '',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Points of Improvement
                    Text(
                      'Points of Improvement:',
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      report['improvement'] ?? '',
                      style: const TextStyle(color: Colors.white, fontSize: 14),
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
