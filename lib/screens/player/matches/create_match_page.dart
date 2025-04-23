import 'package:flutter/material.dart';

import 'search_enemy_team_page.dart';

class CreateMatchPage extends StatefulWidget {
  const CreateMatchPage({super.key});

  @override
  State<CreateMatchPage> createState() => _CreateMatchPageState();
}

class _CreateMatchPageState extends State<CreateMatchPage> {
  String? _selectedSport;
  String? _selectedField;
  String? _selectedMatchType;
  bool _inviteEnemyTeam = false;

  final List<String> _sportTypes = ['Soccer', 'Basketball', 'Tennis'];
  final List<Map<String, String>> _availableFields = [
    {
      'name': 'Sunny Soccer Field',
      'location': 'Riyadh',
    },
    {
      'name': 'Basketball Court',
      'location': 'Jeddah',
    },
    {
      'name': 'Tennis Court',
      'location': 'Dammam',
    },
  ];

  final List<String> _matchTypes = ['Tournament', 'Casual'];

  void _navigateToSearchEnemyTeam(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SearchEnemyTeamPage()),
    );
  }

  void _createMatch() {
    if (_selectedSport == null ||
        _selectedField == null ||
        _selectedMatchType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all fields')),
      );
      return;
    }

    if (_inviteEnemyTeam) {
      _navigateToSearchEnemyTeam(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Match created successfully!')),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Match'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Sport Type',
                  border: OutlineInputBorder(),
                ),
                value: _selectedSport,
                items: _sportTypes
                    .map((sport) => DropdownMenuItem(
                          value: sport,
                          child: Text(sport),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedSport = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Select Field',
                  border: OutlineInputBorder(),
                ),
                value: _selectedField,
                items: _availableFields
                    .map((field) => DropdownMenuItem(
                          value: field['name'],
                          child: Text('${field['name']} (${field['location']})'),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedField = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  labelText: 'Match Type',
                  border: OutlineInputBorder(),
                ),
                value: _selectedMatchType,
                items: _matchTypes
                    .map((type) => DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        ))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedMatchType = value;
                  });
                },
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Enemy Team:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  Switch(
                    value: _inviteEnemyTeam,
                    onChanged: (value) {
                      setState(() {
                        _inviteEnemyTeam = value;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ],
              ),
              if (!_inviteEnemyTeam)
                ElevatedButton(
                  onPressed: () => _navigateToSearchEnemyTeam(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding:
                        const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Search for Enemy Team',
                    style: TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _createMatch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding:
                      const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text(
                  'Create Match',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
