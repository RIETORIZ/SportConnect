import 'package:flutter/material.dart';

class FamilyMembersPage extends StatefulWidget {
  const FamilyMembersPage({Key? key}) : super(key: key);

  @override
  State<FamilyMembersPage> createState() => _FamilyMembersPageState();
}

class _FamilyMembersPageState extends State<FamilyMembersPage> {
  final List<Map<String, dynamic>> _familyMembers = [
    {
      'name': 'Ahmed Ali ',
      'age': 15,
      'gender': 'Male',
      'friends': ['Khalid Omar', 'Yousef Hassan', 'Faisal Abdullah'],
      'matches': [
        {
          'date': '2023-03-15',
          'location': 'Riyadh Sports Complex',
          'teams': 'Al-Saud FC vs Al-Nassr Youth',
          'coach': 'Coach Sami',
          'result': '2-1'
        },
        {
          'date': '2023-04-20',
          'location': 'King Fahd Stadium',
          'teams': 'School All-Stars vs City Champions',
          'coach': 'Coach Ahmed',
          'result': '3-3'
        },
      ],
    },
    {
      'name': 'Razan ',
      'age': 20,
      'gender': 'Female',
      'friends': ['Noura Ahmed', 'Sara Mohammed', 'Amira Khalid'],
      'matches': [
        {
          'date': '2023-05-10',
          'location': 'Princess Sara Academy',
          'teams': 'Golden Eagles vs Silver Falcons',
          'coach': 'Coach Fatima',
          'result': '4-0'
        }
      ],
    },
    {
      'name': 'adminC',
      'age': 16,
      'gender': 'Male',
      'friends': ['Coach Friend 1', 'Coach Friend 2'],
      'matches': []
    },
    {
      'name': 'adminR',
      'age': 17,
      'gender': 'Male',
      'friends': ['Renter Friend 1', 'Renter Friend 2'],
      'matches': []
    }
  ];

  void _addFamilyMember() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Family Member'),
        content: const Text('This feature is under development'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _deleteMember(String member) {
    setState(() {
      _familyMembers.removeWhere((m) => m['name'] == member);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$member removed')),
    );
  }

  void _dmMember(String member) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(title: Text('Chat with $member')),
          body: const Center(child: Text('Chat interface')),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final minorMembers = _familyMembers.where((m) => m['age'] < 18).toList();

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Family Members',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: ElevatedButton.icon(
              onPressed: _addFamilyMember,
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text(
                'Add Family Member',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),
          Expanded(
            child: minorMembers.isEmpty
                ? const Center(
                    child: Text('No family members under 18',
                        style: TextStyle(color: Colors.white70)),
                  )
                : ListView.builder(
                    itemCount: minorMembers.length,
                    itemBuilder: (context, idx) {
                      final member = minorMembers[idx];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Card(
                          color: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Personal Info
                                Text(
                                  member['name'],
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  'Age: ${member['age']} | Gender: ${member['gender']}',
                                  style: const TextStyle(color: Colors.white70),
                                ),
                                const SizedBox(height: 16),

                                // Friends Section
                                const Text(
                                  'Friends:',
                                  style: TextStyle(
                                    color: Colors.greenAccent,
                                    fontSize: 16,
                                  ),
                                ),
                                ...(member['friends'] as List)
                                    .map<Widget>((friend) => Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 4),
                                          child: Text(
                                            '• $friend',
                                            style: const TextStyle(
                                                color: Colors.white70),
                                          ),
                                        ))
                                    .toList(),
                                const SizedBox(height: 16),

                                // Matches Section
                                if ((member['matches'] as List).isNotEmpty) ...[
                                  const Text(
                                    'Recent Matches:',
                                    style: TextStyle(
                                      color: Colors.greenAccent,
                                      fontSize: 16,
                                    ),
                                  ),
                                  ...(member['matches'] as List)
                                      .map<Widget>((match) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 4),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${match['date']}: ${match['teams']}',
                                                  style: const TextStyle(
                                                      color: Colors.white),
                                                ),
                                                Text(
                                                  'Location: ${match['location']}',
                                                  style: const TextStyle(
                                                      color: Colors.white70),
                                                ),
                                                Text(
                                                  'Coach: ${match['coach']} | Result: ${match['result']}',
                                                  style: const TextStyle(
                                                      color: Colors.white70),
                                                ),
                                                const Divider(
                                                    color: Colors.grey),
                                              ],
                                            ),
                                          ))
                                      .toList(),
                                ],

                                // Action Buttons
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () =>
                                          _dmMember(member['name']),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.green,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        'Message',
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    ElevatedButton(
                                      onPressed: () =>
                                          _deleteMember(member['name']),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Text(
                                        'Remove',
                                        style: TextStyle(color: Colors.white),
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
          ),
        ],
      ),
    );
  }
}
