import 'package:flutter/material.dart';

class UserChatPage extends StatefulWidget {
  final String username;

  const UserChatPage({super.key, required this.username});

  @override
  State<UserChatPage> createState() => _UserChatPageState();
}

class _UserChatPageState extends State<UserChatPage> {
  // Example chat messages
  final List<Map<String, String>> _messages = [
    {
      'sender': 'Coach',
      'text': 'مرحبا ${DateTime.now().microsecondsSinceEpoch}',
      'time': '10:30 AM',
    },
    {
      'sender': 'Coach',
      'text': 'كيف حالك؟',
      'time': '10:31 AM',
    },
    // ...
  ];

  final TextEditingController _messageController = TextEditingController();

  // For demonstration, we treat "Coach" as the user
  // if message is from "Coach", align right, else left
  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({
        'sender': 'Coach',
        'text': text,
        'time': 'Now',
      });
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.username),
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: ListView.builder(
              reverse: false,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                final isCoach = (msg['sender'] == 'Coach');
                return Align(
                  alignment:
                      isCoach ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 5,
                      horizontal: 10,
                    ),
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                      horizontal: 15,
                    ),
                    decoration: BoxDecoration(
                      color: isCoach ? Colors.blue : Colors.grey[300],
                      borderRadius: isCoach
                          ? const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomLeft: Radius.circular(15),
                              topRight: Radius.circular(15),
                            )
                          : const BorderRadius.only(
                              topLeft: Radius.circular(15),
                              bottomRight: Radius.circular(15),
                              topRight: Radius.circular(15),
                            ),
                    ),
                    child: Column(
                      crossAxisAlignment: isCoach
                          ? CrossAxisAlignment.end
                          : CrossAxisAlignment.start,
                      children: [
                        Text(
                          msg['text']!,
                          style: TextStyle(
                            color: isCoach ? Colors.white : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          msg['time']!,
                          style: TextStyle(
                            color: isCoach ? Colors.white70 : Colors.black54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          // Text field + send button at bottom
          Container(
            color: Colors.grey[200],
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                // Text input
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: 'اكتب رسالة...',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                // Send button
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: const Text('إرسال'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
