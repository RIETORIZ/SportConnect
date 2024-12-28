import 'package:flutter/material.dart';

class DirectMessagesPage extends StatelessWidget {
  const DirectMessagesPage({super.key});

  @override
  Widget build(BuildContext context) {
    // Fake DM data
    final List<Map<String, String>> _messages = [
      {
        'sender': 'Player1',
        'message': 'Hi Coach, looking forward to the next training session!',
        'time': '10:30 AM',
      },
      {
        'sender': 'Coach',
        'message': 'Great to hear, Player1! See you then.',
        'time': '10:35 AM',
      },
      {
        'sender': 'Player2',
        'message': 'Coach, can we have a strategy meeting this weekend?',
        'time': '11:00 AM',
      },
      {
        'sender': 'Coach',
        'message': 'Absolutely, Player2. Let\'s meet on Saturday at 5 PM.',
        'time': '11:15 AM',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Direct Messages'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _messages.isNotEmpty
            ? ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  bool isCoach = msg['sender'] == 'Coach';
                  return Align(
                    alignment:
                        isCoach ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 15),
                      margin: const EdgeInsets.symmetric(vertical: 5),
                      decoration: BoxDecoration(
                        color: isCoach
                            ? Colors.orangeAccent
                            : Colors.grey[300],
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(15),
                          topRight: const Radius.circular(15),
                          bottomLeft:
                              isCoach ? const Radius.circular(15) : Radius.zero,
                          bottomRight:
                              isCoach ? Radius.zero : const Radius.circular(15),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: isCoach
                            ? CrossAxisAlignment.end
                            : CrossAxisAlignment.start,
                        children: [
                          Text(
                            msg['message']!,
                            style: TextStyle(
                              color: isCoach ? Colors.white : Colors.black,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            msg['time']!,
                            style: TextStyle(
                              color: isCoach
                                  ? Colors.white70
                                  : Colors.black54,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              )
            : const Center(
                child: Text(
                  'No messages yet.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
      ),
    );
  }
}
