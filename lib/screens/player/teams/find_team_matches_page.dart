import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

class FindTeamMatchesPage extends StatefulWidget {
  final int teamId;
  final String teamName;
  final String sport;
  final String region;

  const FindTeamMatchesPage({
    Key? key,
    required this.teamId,
    required this.teamName,
    required this.sport,
    required this.region,
  }) : super(key: key);

  @override
  _FindTeamMatchesPageState createState() => _FindTeamMatchesPageState();
}

class _FindTeamMatchesPageState extends State<FindTeamMatchesPage> {
  bool _isLoading = true;
  List<dynamic> _matchResults = [];
  String? _error;
  String? _selectedLevel;

  final List<String> _levels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'Professional'
  ];

  @override
  void initState() {
    super.initState();
    _fetchTeamMatches();
  }

  Future<void> _fetchTeamMatches() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await ApiService.getTeamMatches(
        sport: widget.sport,
        region: widget.region,
        experienceLevel: _selectedLevel,
      );

      setState(() {
        _matchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching team matches: $e');
      setState(() {
        _error = 'Failed to load team matches: $e';
        _isLoading = false;
      });
    }
  }

  void _challengeTeam(dynamic matchData) {
    if (matchData['match_type'] == 'team') {
      _showChallengeTeamDialog(matchData);
    } else if (matchData['match_type'] == 'roster') {
      _showInvitePlayersDialog(matchData);
    }
  }

  void _showChallengeTeamDialog(dynamic matchData) {
    final teamName = matchData['team_name'];
    final teamId = matchData['team_id'];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Challenge Team',
          style: TextStyle(color: Colors.white),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Send a challenge to $teamName?',
              style: const TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              'This will send a notification to the team captain asking them to accept your challenge.',
              style: const TextStyle(color: Colors.white70, fontSize: 14),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              // Here you would call your API to send the challenge
              // ApiService.sendTeamChallenge(widget.teamId, teamId);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Challenge sent to $teamName!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Send Challenge'),
          ),
        ],
      ),
    );
  }

  void _showInvitePlayersDialog(dynamic matchData) {
    final players = matchData['players'] as List;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: const Text(
          'Invite Players',
          style: TextStyle(color: Colors.white),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'The following players match your team:',
                style: TextStyle(color: Colors.white),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 200,
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: players.length,
                  itemBuilder: (context, index) {
                    final player = players[index];
                    return CheckboxListTile(
                      title: Text(
                        player['username'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Text(
                        'Experience: ${player['experience_level']}',
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                      value: true, // Default selected
                      activeColor: Colors.green,
                      checkColor: Colors.white,
                      onChanged: (value) {
                        // In a real app, you'd track selected players
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel', style: TextStyle(color: Colors.red)),
          ),
          ElevatedButton(
            onPressed: () {
              // Here you would call your API to invite the players
              // ApiService.invitePlayers(widget.teamId, selectedPlayerIds);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Invitations sent to selected players!')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            child: const Text('Send Invitations'),
          ),
        ],
      ),
    );
  }

  Widget _buildMatchCard(dynamic match) {
    final team = match['team'];
    final matchData = match['match'];
    final matchType = matchData['match_type'];

    return Card(
      color: Colors.grey[900],
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Team info
            Text(
              team['team_name'],
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.greenAccent, size: 16),
                const SizedBox(width: 4),
                Text(
                  team['region'] ?? 'Unknown',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(width: 16),
                Icon(Icons.sports, color: Colors.greenAccent, size: 16),
                const SizedBox(width: 4),
                Text(
                  team['team_sport'] ?? 'Various sports',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Row(
              children: [
                Icon(Icons.star, color: Colors.greenAccent, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Experience: ${team['experience_level'] ?? 'Unknown'}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const SizedBox(width: 16),
                Icon(Icons.group, color: Colors.greenAccent, size: 16),
                const SizedBox(width: 4),
                Text(
                  'Players: ${team['player_count'] ?? 0}',
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            ),

            const Divider(color: Colors.white24, height: 24),

            // Match result
            if (matchType == 'team')
              _buildTeamMatch(matchData)
            else if (matchType == 'roster')
              _buildRosterMatch(matchData)
            else
              _buildNoMatch(),

            const SizedBox(height: 16),

            // Action buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (matchType != 'none')
                  ElevatedButton(
                    onPressed: () => _challengeTeam(matchData),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: matchType == 'team'
                        ? const Text('Challenge Team')
                        : const Text('Invite Players'),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTeamMatch(dynamic matchData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.green),
            const SizedBox(width: 8),
            const Text(
              'Team Match Found!',
              style: TextStyle(
                color: Colors.green,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(
          'Team: ${matchData['team_name']}',
          style: const TextStyle(color: Colors.white),
        ),
        const SizedBox(height: 4),
        Text(
          'Players: ${matchData['player_count']}',
          style: const TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 4),
        Text(
          'Average Age: ${matchData['avg_age']?.toStringAsFixed(1) ?? 'Unknown'}',
          style: const TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  Widget _buildRosterMatch(dynamic matchData) {
    final players = matchData['players'] as List;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.people, color: Colors.amber),
            const SizedBox(width: 8),
            const Text(
              'Player Roster Match',
              style: TextStyle(
                color: Colors.amber,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'No team match found. Here are players you can invite:',
          style: TextStyle(color: Colors.white70),
        ),
        const SizedBox(height: 8),
        ...players.take(3).map((player) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.greenAccent, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      player['username'],
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  Text(
                    player['experience_level'],
                    style: const TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
            )),
        if (players.length > 3)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              '+ ${players.length - 3} more players',
              style: const TextStyle(
                  color: Colors.white70, fontStyle: FontStyle.italic),
            ),
          ),
      ],
    );
  }

  Widget _buildNoMatch() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Icon(Icons.error_outline, color: Colors.redAccent),
            const SizedBox(width: 8),
            const Text(
              'No Matches Found',
              style: TextStyle(
                color: Colors.redAccent,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Try changing your search criteria or check back later.',
          style: TextStyle(color: Colors.white70),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text('Matches for ${widget.teamName}'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Team info and filter header
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[900],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Team info
                Text(
                  widget.teamName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.sports, color: Colors.greenAccent, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      widget.sport,
                      style: const TextStyle(color: Colors.white70),
                    ),
                    const SizedBox(width: 16),
                    Icon(Icons.location_on,
                        color: Colors.greenAccent, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      widget.region,
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Level dropdown and search button
                Row(
                  children: [
                    // Level dropdown
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        value: _selectedLevel,
                        hint: const Text('Experience Level',
                            style: TextStyle(color: Colors.white70)),
                        dropdownColor: Colors.grey[800],
                        style: const TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[800],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 8),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _selectedLevel = value;
                          });
                        },
                        items: _levels
                            .map((level) => DropdownMenuItem(
                                  value: level,
                                  child: Text(level),
                                ))
                            .toList(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Search button
                    ElevatedButton(
                      onPressed: _fetchTeamMatches,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text('Find Matches'),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Results section
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.green))
                : _error != null
                    ? Center(
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                          textAlign: TextAlign.center,
                        ),
                      )
                    : _matchResults.isEmpty
                        ? const Center(
                            child: Text(
                              'No matches found for your team. Try adjusting your search criteria.',
                              style: TextStyle(color: Colors.white70),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            itemCount: _matchResults.length,
                            itemBuilder: (context, index) {
                              return _buildMatchCard(_matchResults[index]);
                            },
                          ),
          ),
        ],
      ),
    );
  }
}
