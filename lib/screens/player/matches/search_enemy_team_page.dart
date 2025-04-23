import 'package:flutter/material.dart';

class SearchEnemyTeamPage extends StatefulWidget {
  const SearchEnemyTeamPage({super.key});

  @override
  State<SearchEnemyTeamPage> createState() => _SearchEnemyTeamPageState();
}

class _SearchEnemyTeamPageState extends State<SearchEnemyTeamPage> {
  bool _isMatchmaking = true;

  void _cancelMatchmaking() {
    setState(() {
      _isMatchmaking = false;
    });
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Matchmaking cancelled')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Enemy Team'),
      ),
      body: Center(
        child: _isMatchmaking
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Searching for an enemy team...',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _cancelMatchmaking,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 24),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cancel Matchmaking',
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ],
              )
            : const Text('Matchmaking cancelled'),
      ),
    );
  }
}
