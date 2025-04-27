import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'register_sport_field_page.dart';
import '../../../services/api_service.dart';

class SportFieldsPage extends StatefulWidget {
  const SportFieldsPage({super.key});

  @override
  State<SportFieldsPage> createState() => _SportFieldsPageState();
}

class _SportFieldsPageState extends State<SportFieldsPage> {
  late Future<List<dynamic>> _fieldsFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fieldsFuture = _fetchFields();
  }

  Future<List<dynamic>> _fetchFields() async {
    try {
      print("Fetching sports fields...");
      final fields = await ApiService.getSportsFields();
      print("Fetched ${fields.length} fields");
      // Log the first field if available
      if (fields.isNotEmpty) {
        print("First field: ${fields[0].fieldName}");
      }
      return fields;
    } catch (e) {
      print('Error fetching fields: $e');
      // Show the error to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load fields: $e')),
      );
      return [];
    }
  }

  Future<void> _refreshFields() async {
    setState(() {
      _fieldsFuture = _fetchFields();
    });
  }

  Future<void> _toggleFieldAvailability(int fieldId, bool currentStatus) async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Call API to update field availability
      await ApiService.updateField(fieldId, {
        'available_for_female': !currentStatus,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Field availability updated')),
      );

      // Refresh fields list
      _refreshFields();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update field: $e')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _navigateToAddField() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const RegisterSportFieldPage(),
      ),
    ).then((result) {
      // Refresh the fields list when returning with a success result
      if (result == true) {
        print("Field added successfully, refreshing list...");
        _refreshFields();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: RefreshIndicator(
        onRefresh: _refreshFields,
        color: Colors.green,
        child: FutureBuilder<List<dynamic>>(
          future: _fieldsFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(color: Colors.green),
              );
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  'Error loading fields: ${snapshot.error}',
                  style: const TextStyle(color: Colors.white),
                ),
              );
            }

            final fields = snapshot.data ?? [];

            if (fields.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'No fields registered yet',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _navigateToAddField,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text(
                        'Add Field',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }

            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: fields.length,
              itemBuilder: (context, index) {
                final field = fields[index];
                return Card(
                  color: Colors.grey[900],
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Field image
                      field['field_image'] != null &&
                              field['field_image'].isNotEmpty
                          ? ClipRRect(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(12),
                                topRight: Radius.circular(12),
                              ),
                              child: Image.network(
                                field['field_image'],
                                height: 150,
                                width: double.infinity,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  // Placeholder if image fails to load
                                  return Container(
                                    height: 150,
                                    color: Colors.grey[800],
                                    child: const Center(
                                      child: Icon(
                                        Icons.sports_soccer,
                                        color: Colors.greenAccent,
                                        size: 50,
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Container(
                              height: 150,
                              color: Colors.grey[800],
                              child: const Center(
                                child: Icon(
                                  Icons.sports_soccer,
                                  color: Colors.greenAccent,
                                  size: 50,
                                ),
                              ),
                            ),

                      // Field details
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              field['field_name'] ?? 'Unnamed Field',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                const Icon(
                                  Icons.location_on,
                                  color: Colors.greenAccent,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    field['location'] ?? 'Unknown location',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.sports,
                                  color: Colors.greenAccent,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    field['suitable_sports'] ??
                                        'Various sports',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.money,
                                  color: Colors.greenAccent,
                                  size: 20,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '${field['rent_price_per_hour'] ?? 0} SAR/hour',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // Availability toggle
                                Row(
                                  children: [
                                    Text(
                                      'Available:',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    ),
                                    Switch(
                                      value: field['available_for_female'] ??
                                          false,
                                      onChanged: _isLoading
                                          ? null
                                          : (value) => _toggleFieldAvailability(
                                                field['field_id'],
                                                field['available_for_female'] ??
                                                    false,
                                              ),
                                      activeColor: Colors.green,
                                    ),
                                  ],
                                ),
                                // Edit button
                                ElevatedButton(
                                  onPressed: () {
                                    // Navigate to edit field page
                                    // This will be implemented later
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: const Text(
                                    'Edit Field',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _navigateToAddField,
        backgroundColor: Colors.green,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Add Field',
          style: TextStyle(color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
