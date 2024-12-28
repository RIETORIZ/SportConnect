import 'package:flutter/material.dart';

class ReserveSportFieldPage extends StatefulWidget {
  const ReserveSportFieldPage({super.key});

  @override
  State<ReserveSportFieldPage> createState() => _ReserveSportFieldPageState();
}

class _ReserveSportFieldPageState extends State<ReserveSportFieldPage> {
  final List<Map<String, String>> _availableFields = [
    {
      'name': 'Central Soccer Field',
      'location': 'Riyadh',
      'image': 'assets/soccer_field.png',
    },
    {
      'name': 'Eastside Tennis Court',
      'location': 'Jeddah',
      'image': 'assets/soccer_field.png',
    },
    {
      'name': 'Westside Basketball Court',
      'location': 'Dammam',
      'image': 'assets/soccer_field.png',
    },
  ];

  void _reserveField(Map<String, String> field) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Reserved "${field['name']}"')),
    );
    setState(() {
      _availableFields.remove(field);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reserve Sport Field'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _availableFields.isNotEmpty
            ? ListView.builder(
                itemCount: _availableFields.length,
                itemBuilder: (context, index) {
                  final field = _availableFields[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(15),
                          child: Image.asset(
                            field['image']!,
                            fit: BoxFit.cover,
                            height: 150,
                            width: double.infinity,
                          ),
                        ),
                        ListTile(
                          title: Text(
                            field['name']!,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, color: Colors.orange),
                          ),
                          subtitle: Text('Location: ${field['location']}'),
                          trailing: ElevatedButton(
                            onPressed: () => _reserveField(field),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            child: const Text(
                              'Reserve',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              )
            : const Center(
                child: Text(
                  'No available fields to reserve.',
                  style: TextStyle(fontSize: 18),
                ),
              ),
      ),
    );
  }
}
