import 'package:flutter/material.dart';

class InvitePlayerPage extends StatefulWidget {
  const InvitePlayerPage({super.key});

  @override
  State<InvitePlayerPage> createState() => _InvitePlayerPageState();
}

class _InvitePlayerPageState extends State<InvitePlayerPage> {
  // For date, time, and sport
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  String _selectedSport = 'Soccer';

  // For inviting players
  final TextEditingController _playerNameController = TextEditingController();
  final List<String> _invitedPlayers = [];

  // Predefined list of sports
  final List<String> _sportTypes = ['Soccer', 'Basketball', 'Tennis'];

  void _invitePlayer() {
    final name = _playerNameController.text.trim();
    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a player name')),
      );
      return;
    }
    setState(() {
      _invitedPlayers.add(name);
      _playerNameController.clear();
    });
  }

  void _createSession() {
    final dateStr = _dateController.text.trim();
    final timeStr = _timeController.text.trim();

    if (dateStr.isEmpty || timeStr.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a date and time')),
      );
      return;
    }
    // You could also validate date/time format here.

    // For demonstration, we just show a snackBar with the details:
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Session Created!\n'
          'Sport: $_selectedSport\n'
          'Date: $dateStr @ $timeStr\n'
          'Players Invited: ${_invitedPlayers.join(", ")}',
        ),
      ),
    );

    // Pop back to CoachTrainingPage or wherever you want
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Create Training Session',
          style: TextStyle(color: Colors.greenAccent),
        ),
        iconTheme: const IconThemeData(color: Colors.greenAccent),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Sport Type Dropdown
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.grey[900],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.greenAccent),
              ),
              child: DropdownButton<String>(
                value: _selectedSport,
                dropdownColor: Colors.grey[900],
                iconEnabledColor: Colors.greenAccent,
                style: const TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                ),
                underline: const SizedBox(),
                onChanged: (String? newValue) {
                  setState(() => _selectedSport = newValue!);
                },
                items: _sportTypes.map((sport) {
                  return DropdownMenuItem<String>(
                    value: sport,
                    child: Text(sport),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 16),

            // Date Field
            TextField(
              controller: _dateController,
              style: const TextStyle(color: Colors.greenAccent),
              decoration: InputDecoration(
                labelText: 'Session Date (YYYY-MM-DD)',
                labelStyle: const TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.greenAccent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.greenAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.greenAccent),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Time Field
            TextField(
              controller: _timeController,
              style: const TextStyle(color: Colors.greenAccent),
              decoration: InputDecoration(
                labelText: 'Session Time (HH:mm)',
                labelStyle: const TextStyle(
                  color: Colors.greenAccent,
                  fontWeight: FontWeight.bold,
                ),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.greenAccent),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.greenAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Colors.greenAccent),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Player Name & Invite
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _playerNameController,
                    style: const TextStyle(color: Colors.greenAccent),
                    decoration: InputDecoration(
                      labelText: 'Player Name',
                      labelStyle: const TextStyle(
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.bold,
                      ),
                      filled: true,
                      fillColor: Colors.grey[900],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.greenAccent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.greenAccent),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Colors.greenAccent),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _invitePlayer,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14, horizontal: 16),
                  ),
                  child: const Text(
                    'Invite',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // List of invited players
            Expanded(
              child: _invitedPlayers.isNotEmpty
                  ? ListView.builder(
                      itemCount: _invitedPlayers.length,
                      itemBuilder: (context, index) {
                        final player = _invitedPlayers[index];
                        return Card(
                          color: Colors.grey[900],
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          shadowColor: Colors.greenAccent,
                          child: ListTile(
                            leading: const Icon(Icons.person,
                                color: Colors.greenAccent),
                            title: Text(
                              player,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        );
                      },
                    )
                  : const Center(
                      child: Text(
                        'No players invited yet.',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
            ),

            // Create Session
            ElevatedButton(
              onPressed: _createSession,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 14, horizontal: 50),
              ),
              child: const Text(
                'Create Session',
                style: TextStyle(fontSize: 16, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
