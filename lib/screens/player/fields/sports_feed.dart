// lib/screens/player/fields/sports_feed.dart

import 'package:flutter/material.dart';
import '../../../models/sports_field.dart';
import '../../../services/field_service.dart';
import 'field_info_page.dart';

class SportsFeed extends StatefulWidget {
  const SportsFeed({super.key});

  @override
  _SportsFeedState createState() => _SportsFeedState();
}

class _SportsFeedState extends State<SportsFeed> {
  String _selectedFieldType = 'All';
  List<SportsField> _fields = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadSportsFields();
  }

  Future<void> _loadSportsFields() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      List<dynamic> fieldsJson = [];

      try {
        // Try to load recommended fields first
        fieldsJson = await FieldService.getRecommendedFields();
      } catch (e) {
        print('Failed to get recommended fields: $e');
        // If that fails, get all fields instead
        fieldsJson = await FieldService.getSportsFields();
      }

      // Convert JSON to SportsField objects
      final loadedFields = fieldsJson
          .map((fieldJson) => SportsField.fromJson(fieldJson))
          .toList();

      setState(() {
        _fields = loadedFields;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load sports fields: ${e.toString()}';
        _isLoading = false;
      });
    }
  }

  void _navigateToFieldInfo(BuildContext context, SportsField field) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FieldInfoPage(
          fieldId: field.fieldId,
          fieldName: field.fieldName,
          location: field.location,
          imagePath: field.fieldImage ?? 'assets/soccer_field.png',
          suitableForWomen: field.availableForFemale,
          rentPricePerHour: field.rentPricePerHour,
          suitableSports: field.suitableSports,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    List<SportsField> filteredFields = _selectedFieldType == 'All'
        ? _fields
        : _fields.where((field) {
            return field.suitableSports
                .toLowerCase()
                .contains(_selectedFieldType.toLowerCase());
          }).toList();

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: DropdownButton<String>(
                  value: _selectedFieldType,
                  isExpanded: true,
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
              //IconButton(
              //icon: const Icon(Icons.refresh),
              //onPressed: _loadSportsFields,
              //tooltip: 'Refresh fields',
              //),
            ],
          ),
        ),
        Expanded(
          child: _isLoading
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : _errorMessage.isNotEmpty
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.error_outline,
                            color: Colors.red,
                            size: 60,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _errorMessage,
                            style: const TextStyle(color: Colors.red),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: _loadSportsFields,
                            child: const Text('Try Again'),
                          ),
                        ],
                      ),
                    )
                  : filteredFields.isEmpty
                      ? const Center(
                          child: Text('No sports fields found for this type.'),
                        )
                      : ListView.builder(
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
                                      onTap: () =>
                                          _navigateToFieldInfo(context, field),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(25),
                                        child: field.fieldImage != null &&
                                                !field.fieldImage!
                                                    .startsWith('assets/')
                                            ? Image.network(
                                                field.fieldImage!,
                                                fit: BoxFit.cover,
                                                height: 150,
                                                width: double.infinity,
                                                errorBuilder: (context, error,
                                                    stackTrace) {
                                                  return Image.asset(
                                                    'assets/soccer_field.png',
                                                    fit: BoxFit.cover,
                                                    height: 150,
                                                    width: double.infinity,
                                                  );
                                                },
                                              )
                                            : Image.asset(
                                                field.fieldImage ??
                                                    'assets/soccer_field.png',
                                                fit: BoxFit.cover,
                                                height: 150,
                                                width: double.infinity,
                                              ),
                                      ),
                                    ),
                                    ListTile(
                                      title: Text(
                                        field.fieldName,
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      ),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Location: ${field.location}',
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            'Price: \$${field.rentPricePerHour.toStringAsFixed(2)}/hour',
                                            style: const TextStyle(
                                                color: Colors.grey),
                                          ),
                                          if (field.availableForFemale)
                                            const Text(
                                              'Available for Women 🙋‍♀️',
                                              style: TextStyle(
                                                  color: Colors.green),
                                            ),
                                        ],
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
                                            borderRadius:
                                                BorderRadius.circular(20),
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
