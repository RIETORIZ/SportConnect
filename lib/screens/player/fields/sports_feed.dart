import 'package:flutter/material.dart';

import 'field_info_page.dart';

class SportsFeed extends StatefulWidget {
  const SportsFeed({super.key});

  @override
  _SportsFeedState createState() => _SportsFeedState();
}

class _SportsFeedState extends State<SportsFeed> {
  String _selectedFieldType = 'All';

  final List<Map<String, String>> _fields = [
    {
      'name': 'Sunny Soccer Field',
      'location': 'Riyadh',
      'image': 'assets/sunny-soccer-field-picture-demo.jpg',
      'suitableForWomen': 'false',
    },
    {
      'name': 'Basketball Court',
      'location': 'Jeddah',
      'image': 'assets/basketball.jpeg',
      'suitableForWomen': 'true',
    },
    {
      'name': 'Tennis Court',
      'location': 'Dammam',
      'image': 'assets/tennis.jpg',
      'suitableForWomen': 'false',
    },
  ];

  void _navigateToFieldInfo(BuildContext context, Map<String, String> field) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FieldInfoPage(
          fieldName: field['name']!,
          location: field['location']!,
          imagePath: field['image']!,
          suitableForWomen: field['suitableForWomen'] == 'true',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> filteredFields = _selectedFieldType == 'All'
        ? _fields
        : _fields.where((field) {
            return field['name']!
                .toLowerCase()
                .contains(_selectedFieldType.toLowerCase());
          }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: DropdownButton<String>(
            value: _selectedFieldType,
            onChanged: (String? newValue) {
              setState(() {
                _selectedFieldType = newValue!;
              });
            },
            items: <String>['All', 'Soccer', 'Basketball', 'Tennis']
                .map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: filteredFields.length,
            itemBuilder: (context, index) {
              final field = filteredFields[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  elevation: 5,
                  shadowColor: Colors.greenAccent,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () => _navigateToFieldInfo(context, field),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.asset(
                            field['image']!,
                            fit: BoxFit.cover,
                            height: 150,
                            width: double.infinity,
                          ),
                        ),
                      ),
                      ListTile(
                        title: Text(
                          field['name']!,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.green),
                        ),
                        subtitle: Text(
                          'Location: ${field['location']}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        trailing: IconButton(
                          icon: const Icon(Icons.more_vert),
                          onPressed: () {
                            _navigateToFieldInfo(context, field);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 20),
                          ),
                          onPressed: () {
                            _navigateToFieldInfo(context, field);
                          },
                          child: const Text(
                            'Reserve Now',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
