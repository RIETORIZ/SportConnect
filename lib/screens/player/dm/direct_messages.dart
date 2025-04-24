import 'package:flutter/material.dart';

import 'user_chat_page.dart';

class DMOverviewPage extends StatefulWidget {
  const DMOverviewPage({Key? key}) : super(key: key);

  @override
  State<DMOverviewPage> createState() => _DMOverviewPageState();
}

class _DMOverviewPageState extends State<DMOverviewPage> {
  // Example pinned conversations
  final List<Map<String, String>> pinnedConversations = [
    {
      'username': 'SIR',
      'lastMessage': 'منشورًا Giant Crab شارك',
      'time': '7 س',
      'imageUrl': 'assets/pin_user.jpg', // or null if you have no image
    },
  ];

  // Example all conversations
  final List<Map<String, String>> allConversations = [
    {
      'username': 'ulonononoo Oo',
      'lastMessage': 'شاركت منشورًا',
      'time': '4 س',
      'imageUrl': 'assets/user1.jpg',
    },
    {
      'username': 'JustMajedd ..',
      'lastMessage': 'شاركت منشورًا',
      'time': '8 س',
      'imageUrl': 'assets/user2.jpg',
    },
    {
      'username': 'itsTikno Yzed',
      'lastMessage': 'شاركت منشورًا',
      'time': '10 مارس',
      'imageUrl': 'assets/user3.jpg',
    },
    {
      'username': '0xrushy Rushy',
      'lastMessage': 'ارسلت الريكوست ديسكورد',
      'time': '14 مارس',
      'imageUrl': 'assets/user4.jpg',
    },
    // ... add as many as you want
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // AppBar with black background, green accent, etc. if you want
      appBar: AppBar(
        title: const Text('المحادثات'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // "Pinned Conversations" section
          if (pinnedConversations.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'المحادثات المثبتة',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          if (pinnedConversations.isNotEmpty)
            SizedBox(
              height: 90,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: pinnedConversations.length,
                itemBuilder: (context, index) {
                  final convo = pinnedConversations[index];
                  return GestureDetector(
                    onTap: () {
                      // Navigate to user chat page
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserChatPage(
                            username: convo['username']!,
                          ),
                        ),
                      );
                    },
                    child: Container(
                      width: 70,
                      margin: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          CircleAvatar(
                            radius: 25,
                            backgroundImage: convo['imageUrl'] != null
                                ? AssetImage(convo['imageUrl']!)
                                : null,
                            child: convo['imageUrl'] == null
                                ? const Icon(Icons.person)
                                : null,
                          ),
                          const SizedBox(height: 5),
                          Text(
                            convo['username']!,
                            style: const TextStyle(
                              fontSize: 12,
                              overflow: TextOverflow.ellipsis,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

          // "All Conversations" section
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'كل المحادثات',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: allConversations.length,
              itemBuilder: (context, index) {
                final convo = allConversations[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: convo['imageUrl'] != null
                        ? AssetImage(convo['imageUrl']!)
                        : null,
                    child: convo['imageUrl'] == null
                        ? const Icon(Icons.person)
                        : null,
                  ),
                  title: Text(convo['username']!),
                  subtitle: Text(convo['lastMessage']!),
                  trailing: Text(convo['time']!),
                  onTap: () {
                    // Navigate to user chat
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => UserChatPage(
                          username: convo['username']!,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
