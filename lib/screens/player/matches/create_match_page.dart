import 'package:flutter/material.dart';
import '../../../services/api_service.dart';
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
  Map<String, dynamic>? _selectedEnemyTeam;
  bool _isLoading = false;

  // Controllers for date and time
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  final List<String> _sportTypes = ['Soccer', 'Basketball', 'Tennis'];
  List<Map<String, dynamic>> _availableFields = [];
  String? _selectedRegion;

  final List<String> _matchTypes = ['Tournament', 'Casual'];

  @override
  void initState() {
    super.initState();
    _fetchAvailableFields();
  }

  Future<void> _fetchAvailableFields() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Fetch available fields from API
      final fields = await ApiService.getAvailableFields();

      setState(() {
        _availableFields = fields
            .map((field) => {
                  'id': field.fieldId,
                  'name': field.fieldName,
                  'location': field.location,
                  'region': field.location.split(',').first.trim(),
                  'sports': field.suitableSports,
                })
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching fields: $e');
      setState(() {
        // Fallback to example fields if API fails
        _availableFields = [
          {
            'id': 1,
            'name': 'Sunny Soccer Field',
            'location': 'Riyadh',
            'region': 'Riyadh',
            'sports': 'Soccer',
          },
          {
            'id': 2,
            'name': 'Basketball Court',
            'location': 'Jeddah',
            'region': 'Jeddah',
            'sports': 'Basketball',
          },
          {
            'id': 3,
            'name': 'Tennis Court',
            'location': 'Dammam',
            'region': 'Dammam',
            'sports': 'Tennis',
          },
        ];
        _isLoading = false;
      });
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.green,
              onPrimary: Colors.white,
              surface: Color(0xFF303030),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _dateController.text =
            "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.green,
              onPrimary: Colors.white,
              surface: Color(0xFF303030),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _timeController.text =
            "${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}";
      });
    }
  }

  Future<void> _navigateToSearchEnemyTeam(BuildContext context) async {
    // Get the region from selected field
    final selectedFieldData = _availableFields.firstWhere(
      (field) => field['name'] == _selectedField,
      orElse: () => {'region': null},
    );

    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchEnemyTeamPage(
          sport: _selectedSport,
          region: selectedFieldData['region'],
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _selectedEnemyTeam = result;
        _inviteEnemyTeam = true;
      });
    }
  }

  Future<void> _createMatch() async {
    // Validate required fields
    if (_selectedSport == null ||
        _selectedField == null ||
        _selectedMatchType == null ||
        _dateController.text.isEmpty ||
        _timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields')),
      );
      return;
    }

    // Get field ID
    final fieldId = _availableFields.firstWhere(
      (field) => field['name'] == _selectedField,
      orElse: () => {'id': 0},
    )['id'];

    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare match data
      final matchData = {
        'field_id': fieldId,
        'match_date': _dateController.text,
        'match_time': _timeController.text,
        'match_type': _selectedMatchType,
        'sport': _selectedSport,
        // Don't include team1_id automatically - it's now optional
      };

      // If you have the current user's team and want to include it, you can:
      try {
        final userTeamId = await getCurrentUserTeamId();
        if (userTeamId != null) {
          matchData['team1_id'] = userTeamId;
        }
      } catch (e) {
        print(
            'No team found for current user, continuing without team1_id: $e');
        // Continue without team1_id - it's optional now
      }

      // If enemy team is selected, add its info
      if (_selectedEnemyTeam != null) {
        final enemyTeam = _selectedEnemyTeam!['team'];
        matchData['team2_id'] = enemyTeam['team_id'];
      }

      // Call the API service to create the match
      await ApiService.createMatch(matchData);

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Match created successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to create match: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Update this method to return null if no teams are found
  Future<int?> getCurrentUserTeamId() async {
    try {
      // Get the user's teams
      final teams = await ApiService.getUserTeams();

      // If the user has teams, return the ID of the first one
      if (teams.isNotEmpty) {
        return teams.first.teamId;
      }

      // If no teams found, return null instead of throwing an exception
      return null;
    } catch (e) {
      print('Error getting current user team ID: $e');
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Create Match'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Sport Type Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Sport Type *',
                      labelStyle: TextStyle(color: Colors.greenAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                      filled: true,
                      fillColor: Colors.grey[900],
                    ),
                    dropdownColor: Colors.grey[900],
                    style: TextStyle(color: Colors.white),
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

                  // Field Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Select Field *',
                      labelStyle: TextStyle(color: Colors.greenAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                      filled: true,
                      fillColor: Colors.grey[900],
                    ),
                    dropdownColor: Colors.grey[900],
                    style: TextStyle(color: Colors.white),
                    value: _selectedField,
                    items: _availableFields
                        .where((field) =>
                            _selectedSport == null ||
                            field['sports']
                                .toString()
                                .toLowerCase()
                                .contains(_selectedSport!.toLowerCase()))
                        .map((field) => DropdownMenuItem<String>(
                              value: field['name'] as String,
                              child: Text(
                                  '${field['name']} (${field['location']})'),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedField = value;
                        // Update region based on selected field
                        if (value != null) {
                          _selectedRegion = _availableFields.firstWhere(
                            (field) => field['name'] == value,
                            orElse: () => {'region': null},
                          )['region'];
                        }
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Match Type Dropdown
                  DropdownButtonFormField<String>(
                    decoration: InputDecoration(
                      labelText: 'Match Type *',
                      labelStyle: TextStyle(color: Colors.greenAccent),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide(color: Colors.greenAccent),
                      ),
                      filled: true,
                      fillColor: Colors.grey[900],
                    ),
                    dropdownColor: Colors.grey[900],
                    style: TextStyle(color: Colors.white),
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

                  // Date and Time fields
                  Row(
                    children: [
                      // Date field
                      Expanded(
                        child: TextField(
                          controller: _dateController,
                          readOnly: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Date *',
                            labelStyle: TextStyle(color: Colors.greenAccent),
                            filled: true,
                            fillColor: Colors.grey[900],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.greenAccent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.greenAccent),
                            ),
                            suffixIcon: Icon(Icons.calendar_today,
                                color: Colors.greenAccent),
                          ),
                          onTap: () => _selectDate(context),
                        ),
                      ),
                      const SizedBox(width: 16),
                      // Time field
                      Expanded(
                        child: TextField(
                          controller: _timeController,
                          readOnly: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            labelText: 'Time *',
                            labelStyle: TextStyle(color: Colors.greenAccent),
                            filled: true,
                            fillColor: Colors.grey[900],
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.greenAccent),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.greenAccent),
                            ),
                            suffixIcon: Icon(Icons.access_time,
                                color: Colors.greenAccent),
                          ),
                          onTap: () => _selectTime(context),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Enemy Team Section
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: Colors.greenAccent.withOpacity(0.5)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Find Enemy Team:',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Switch(
                              value: _inviteEnemyTeam,
                              onChanged: (value) {
                                setState(() {
                                  _inviteEnemyTeam = value;
                                  if (!value) {
                                    _selectedEnemyTeam = null;
                                  }
                                });
                              },
                              activeColor: Colors.green,
                            ),
                          ],
                        ),
                        if (_selectedEnemyTeam != null) ...[
                          const SizedBox(height: 16),
                          const Text(
                            'Selected Team:',
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.3),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.group, color: Colors.greenAccent),
                                SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        _selectedEnemyTeam!['team']
                                            ['team_name'],
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        'Region: ${_selectedEnemyTeam!['team']['region'] ?? 'Unknown'}',
                                        style: TextStyle(color: Colors.white70),
                                      ),
                                    ],
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.close, color: Colors.red),
                                  onPressed: () {
                                    setState(() {
                                      _selectedEnemyTeam = null;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                        ] else if (_inviteEnemyTeam) ...[
                          const SizedBox(height: 16),
                          Center(
                            child: ElevatedButton.icon(
                              onPressed: () =>
                                  _navigateToSearchEnemyTeam(context),
                              icon: Icon(Icons.search, color: Colors.white),
                              label: Text(
                                'Search for Enemy Team',
                                style: TextStyle(color: Colors.white),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                padding: EdgeInsets.symmetric(
                                    horizontal: 24, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Create Match Button
                  Center(
                    child: ElevatedButton(
                      onPressed: _createMatch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Create Match',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.7),
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.green),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
