import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:convert';
import '../../../services/api_service.dart';

class RegisterSportFieldPage extends StatefulWidget {
  const RegisterSportFieldPage({super.key});

  @override
  State<RegisterSportFieldPage> createState() => _RegisterSportFieldPageState();
}

class _RegisterSportFieldPageState extends State<RegisterSportFieldPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _sportsController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  bool _availableForFemale = true;
  String? _imagePath;
  bool _isLoading = false;

  Future<void> _pickImage() async {
    // In a real app, you would implement image picking here
    // For demonstration, we'll just set a placeholder
    setState(() {
      _imagePath = 'assets/field_placeholder.jpg';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
          content: Text('Image selection would be implemented here')),
    );
  }

  Future<void> _registerField() async {
    // Validate input fields
    final String name = _nameController.text.trim();
    final String location = _locationController.text.trim();
    final String price = _priceController.text.trim();
    final String sports = _sportsController.text.trim();

    if (name.isEmpty || location.isEmpty || price.isEmpty || sports.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all required fields')),
      );
      return;
    }

    // Show loading indicator
    setState(() {
      _isLoading = true;
    });

    try {
      // Prepare field data
      final newField = {
        'field_name': name,
        'location': location,
        'field_image': _imagePath ?? '',
        'rent_price_per_hour': double.tryParse(price) ?? 0.0,
        'suitable_sports': sports,
        'available_for_female': _availableForFemale,
        'comments': _commentsController.text.trim(),
      };

      // Call API to register field and handle the response properly
      try {
        await ApiService.registerField(newField);

        // Show success message
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Field registered successfully!')),
          );
          Navigator.pop(context);
        }
      } catch (e) {
        // More specific error handling for registration
        print("API error: $e");
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Failed to register field: $e')),
          );
        }
      }
    } catch (e) {
      // This catches errors in getting user profile or other setup steps
      print("Setup error: $e");
      // Show error message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to register field: $e')),
        );
      }
    } finally {
      // Hide loading indicator
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Register Sport Field'),
        backgroundColor: Colors.green,
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Register a New Sport Field',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),

                // Field Image
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.greenAccent),
                    ),
                    child: _imagePath == null
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(Icons.add_a_photo,
                                  size: 40, color: Colors.greenAccent),
                              SizedBox(height: 8),
                              Text(
                                'Tap to add field image',
                                style: TextStyle(color: Colors.greenAccent),
                              ),
                            ],
                          )
                        : ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              _imagePath!,
                              fit: BoxFit.cover,
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 20),

                // Field Name
                _buildTextField(
                  controller: _nameController,
                  label: 'Field Name *',
                  hint: 'Enter field name',
                ),
                const SizedBox(height: 16),

                // Location
                _buildTextField(
                  controller: _locationController,
                  label: 'Location *',
                  hint: 'Enter field location',
                ),
                const SizedBox(height: 16),

                // Price per Hour
                _buildTextField(
                  controller: _priceController,
                  label: 'Price per Hour (SAR) *',
                  hint: 'Enter rental price',
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),

                // Suitable Sports
                _buildTextField(
                  controller: _sportsController,
                  label: 'Suitable Sports *',
                  hint: 'e.g. Football, Tennis, Basketball',
                ),
                const SizedBox(height: 16),

                // Available for Female
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[900],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: SwitchListTile(
                    title: const Text(
                      'Available for Rental',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'When enabled, players and coaches can see and book this field',
                      style: TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    value: _availableForFemale,
                    onChanged: (value) {
                      setState(() {
                        _availableForFemale = value;
                      });
                    },
                    activeColor: Colors.green,
                  ),
                ),
                const SizedBox(height: 16),

                // Additional Comments
                _buildTextField(
                  controller: _commentsController,
                  label: 'Additional Comments',
                  hint: 'Any special notes about the field',
                  maxLines: 3,
                ),
                const SizedBox(height: 24),

                // Register Button
                Center(
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _registerField,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32, vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Register Field',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                  ),
                ),
              ],
            ),
          ),
          // Loading overlay
          if (_isLoading)
            Container(
              color: Colors.black.withOpacity(0.5),
              child: const Center(
                child: CircularProgressIndicator(color: Colors.green),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.greenAccent),
        ),
        const SizedBox(height: 4),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          maxLines: maxLines,
          style: const TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.white54),
            filled: true,
            fillColor: Colors.grey[900],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
            contentPadding: const EdgeInsets.all(12),
          ),
        ),
      ],
    );
  }
}
