import 'package:flutter/material.dart';

class InvitePlayerPage extends StatefulWidget {
  const InvitePlayerPage({super.key});

  @override
  State<InvitePlayerPage> createState() => _InvitePlayerPageState();
}

class _InvitePlayerPageState extends State<InvitePlayerPage> {
  final TextEditingController _playerNameController = TextEditingController();
  final List<String> _invitedPlayers = [];

  void _invitePlayer() {
    final playerName = _playerNameController.text.trim();
    if (playerName.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a player name')),
      );
      return;
    }
    setState(() {
      _invitedPlayers.add(playerName);
      _playerNameController.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Player "$playerName" invited')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Invite Player'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _playerNameController,
              decoration: const InputDecoration(
                labelText: 'Player Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: _invitePlayer,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                padding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 30),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Invite Player',
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Players Invited:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: _invitedPlayers.isNotEmpty
                  ? ListView.builder(
                      itemCount: _invitedPlayers.length,
                      itemBuilder: (context, index) {
                        final player = _invitedPlayers[index];
                        return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(vertical: 8),
                          child: ListTile(
                            leading:
                                const Icon(Icons.person, color: Colors.orange),
                            title: Text(player),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text('No players invited yet.'),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
