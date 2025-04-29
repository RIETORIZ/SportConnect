import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

class SearchEnemyTeamPage extends StatefulWidget {
  final String? sport;
  final String? region;

  const SearchEnemyTeamPage({
    super.key,
    this.sport,
    this.region,
  });

  @override
  State<SearchEnemyTeamPage> createState() => _SearchEnemyTeamPageState();
}

class _SearchEnemyTeamPageState extends State<SearchEnemyTeamPage> {
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
      // Modify this to use a specific endpoint to search by team ID
      final results = await ApiService.getTeamMatches(
        sport: widget.sport,
        region: widget.region,
        experienceLevel: _selectedLevel,
        // Add team_id parameter
        // teamId: widget.teamId, // If you're passing team ID from previous screen
      );

      setState(() {
        _matchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load team matches: $e';
        _isLoading = false;
      });
    }
  }

  void _selectTeam(dynamic team) {
    // Return the selected team to the previous screen
    Navigator.pop(context, team);
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
                ElevatedButton(
                  onPressed: () => _selectTeam(match),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: matchType == 'team'
                      ? const Text('Select Team')
                      : matchType == 'roster'
                          ? const Text('Select Players')
                          : const Text('Find More Teams'),
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
        ...players.map((player) => Padding(
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
        title: const Text('Search Enemy Team'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Filter section
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.grey[900],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose Experience Level:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 8),
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
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.green),
                        ),
                        SizedBox(height: 20),
                        Text(
                          'Searching for teams...',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                      ],
                    ),
                  )
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
                              'No matches found. Try adjusting your search criteria.',
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
