import 'package:flutter/material.dart';

// Import your AddFriendPage
import 'add_friend_page.dart';  // Adjust path to wherever you place AddFriendPage

class FriendsPage extends StatefulWidget {
  const FriendsPage({Key? key}) : super(key: key);

  @override
  State<FriendsPage> createState() => _FriendsPageState();
}

class _FriendsPageState extends State<FriendsPage> {
  // Arabic friend names, each with 'online' status.
  // If online = false, we show "Last online X".
  final List<Map<String, dynamic>> _friends = [
    {
      'name': 'خالد',
      'avatar': 'assets/khaled_avatar.png',
      'online': false,
      'time': '4mo',
    },
    {
      'name': 'عبدالله',
      'avatar': 'assets/abdullah_avatar.png',
      'online': false,
      'time': '5mo',
    },
    {
      'name': 'مي',
      'avatar': 'assets/may_avatar.png',
      'online': false,
      'time': '5mo',
    },
    {
      'name': 'عبدالرحمن',
      'avatar': 'assets/abdelrahman_avatar.png',
      'online': true,
    },
  ];

  void _navigateToAddFriends() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const AddFriendPage(),
      ),
    );
  }

  void _useContacts() {
    // Implement device contact logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Use device contacts logic here')),
    );
  }

  void _shareProfileCode() {
    // Implement share code logic
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Share profile code logic here')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dark theme background
      backgroundColor: Colors.black,

      appBar: AppBar(
        // Black AppBar
        backgroundColor: Colors.black,

        // Back arrow
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context), // Go back
        ),

        // Title & "Add Friends" button
        title: Row(
          children: [
            const Expanded(
              child: Text(
                'Friends',
                style: TextStyle(color: Colors.white),
              ),
            ),
            ElevatedButton.icon(
              onPressed: _navigateToAddFriends, // Navigate to AddFriendPage
              icon: const Icon(Icons.person_add, color: Colors.white),
              label: const Text('Add Friends', style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[800],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            )
          ],
        ),

        // Move search icon to the right side (AppBar actions)
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.white),
            onPressed: () {
              // Implement search friends logic if needed
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Search tapped')),
              );
            },
          ),
        ],
      ),

      body: Column(
        children: [
          // “Import from Contacts” + “Share Code” buttons
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 16),
            color: Colors.grey[900],
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _useContacts,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Use Contacts',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _shareProfileCode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Share Code',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Friend list
          Expanded(
            child: _friends.isNotEmpty
                ? ListView.builder(
                    itemCount: _friends.length,
                    itemBuilder: (context, index) {
                      final friend = _friends[index];

                      // If friend is online, show "Online"; else "Last online X"
                      String subtitle;
                      if (friend['online'] == true) {
                        subtitle = 'Online';
                      } else {
                        final t = friend['time'] ?? '';
                        subtitle = 'Last online $t';
                      }

                      return ListTile(
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage:
                                  AssetImage(friend['avatar'].toString()),
                              radius: 25,
                            ),
                            // Online indicator if "online" == true
                            if (friend['online'] == true)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  width: 12,
                                  height: 12,
                                  decoration: BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: Colors.black,
                                      width: 2,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        title: Text(
                          friend['name'].toString(),
                          style: const TextStyle(color: Colors.white),
                        ),
                        subtitle: Text(
                          subtitle,
                          style: const TextStyle(color: Colors.white70),
                        ),
                        onTap: () {
                          // Show friend detail or open chat
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Open chat with ${friend['name']}'),
                            ),
                          );
                        },
                      );
                    },
                  )
                : const Center(
                    child: Text(
                      'No friends yet.',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
