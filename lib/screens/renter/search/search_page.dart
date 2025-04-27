import 'package:flutter/material.dart';
import '../../../services/api_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<dynamic> _allFields = [];
  List<dynamic> _filteredFields = [];
  bool _isLoading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchAllFields();
  }

  Future<void> _fetchAllFields() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final fields = await ApiService.getSportsFields();
      setState(() {
        _allFields = fields;
        _filteredFields = List.from(_allFields);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load fields: $e';
        _isLoading = false;
      });
    }
  }

  void _filterFields(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredFields = List.from(_allFields);
      });
      return;
    }

    final lowercaseQuery = query.toLowerCase();
    setState(() {
      _filteredFields = _allFields.where((field) {
        final name = field['field_name'].toString().toLowerCase();
        final location = field['location'].toString().toLowerCase();
        final sports = field['suitable_sports'].toString().toLowerCase();

        return name.contains(lowercaseQuery) ||
            location.contains(lowercaseQuery) ||
            sports.contains(lowercaseQuery);
      }).toList();
    });
  }

  void _showFieldDetails(dynamic field) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.grey[900],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Field name as title
            Text(
              field['field_name'] ?? 'Unnamed Field',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Field image if available
            if (field['field_image'] != null && field['field_image'].isNotEmpty)
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  field['field_image'],
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[800],
                      child: const Center(
                        child: Icon(
                          Icons.sports_soccer,
                          color: Colors.greenAccent,
                          size: 64,
                        ),
                      ),
                    );
                  },
                ),
              )
            else
              Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Center(
                  child: Icon(
                    Icons.sports_soccer,
                    color: Colors.greenAccent,
                    size: 64,
                  ),
                ),
              ),
            const SizedBox(height: 20),

            // Field details
            _detailRow(
                Icons.location_on, 'Location', field['location'] ?? 'Unknown'),
            _detailRow(
                Icons.sports, 'Sports', field['suitable_sports'] ?? 'Various'),
            _detailRow(Icons.money, 'Price',
                '${field['rent_price_per_hour'] ?? 0} SAR/hour'),
            _detailRow(
              Icons.person,
              'Owner',
              field['renter_name'] ?? 'Unknown',
            ),
            _detailRow(
              Icons.star,
              'Rating',
              '${field['review'] ?? 0.0} / 5.0',
            ),

            // Availability
            ListTile(
              leading: Icon(
                field['available_for_female'] == true
                    ? Icons.check_circle
                    : Icons.cancel,
                color: field['available_for_female'] == true
                    ? Colors.green
                    : Colors.red,
              ),
              title: const Text(
                'Availability Status',
                style: TextStyle(color: Colors.white),
              ),
              subtitle: Text(
                field['available_for_female'] == true
                    ? 'Field is currently available for booking'
                    : 'Field is currently not available',
                style: TextStyle(
                  color: field['available_for_female'] == true
                      ? Colors.green
                      : Colors.red,
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Comments/Description section if available
            if (field['comments'] != null && field['comments'].isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Description',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    field['comments'],
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),

            const SizedBox(height: 24),

            // Book Field button (functionality to be added later)
            if (field['available_for_female'] == true)
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // To be implemented later for booking
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Booking feature coming soon!')),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Book Field',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _detailRow(IconData icon, String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.greenAccent, size: 20),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 14,
                ),
              ),
              Text(
                value,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        children: [
          // Search bar
          Padding(
            padding: const EdgeInsets.all(16),
            child: TextField(
              controller: _searchController,
              onChanged: _filterFields,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Search fields by name, location, or sports...',
                hintStyle: const TextStyle(color: Colors.white54),
                prefixIcon: const Icon(Icons.search, color: Colors.greenAccent),
                filled: true,
                fillColor: Colors.grey[900],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.white54),
                        onPressed: () {
                          _searchController.clear();
                          _filterFields('');
                        },
                      )
                    : null,
              ),
            ),
          ),

          // Results or loading indicator
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.green),
                  )
                : _error != null
                    ? Center(
                        child: Text(
                          _error!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      )
                    : _filteredFields.isEmpty
                        ? const Center(
                            child: Text(
                              'No fields found',
                              style: TextStyle(color: Colors.white),
                            ),
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            itemCount: _filteredFields.length,
                            itemBuilder: (context, index) {
                              final field = _filteredFields[index];
                              return Card(
                                color: Colors.grey[900],
                                margin: const EdgeInsets.only(bottom: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: InkWell(
                                  onTap: () => _showFieldDetails(field),
                                  borderRadius: BorderRadius.circular(12),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: Row(
                                      children: [
                                        // Field thumbnail
                                        Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                            color: Colors.grey[800],
                                            borderRadius:
                                                BorderRadius.circular(8),
                                            image: field['field_image'] !=
                                                        null &&
                                                    field['field_image']
                                                        .isNotEmpty
                                                ? DecorationImage(
                                                    image: NetworkImage(
                                                        field['field_image']),
                                                    fit: BoxFit.cover,
                                                  )
                                                : null,
                                          ),
                                          child: field['field_image'] == null ||
                                                  field['field_image'].isEmpty
                                              ? const Icon(
                                                  Icons.sports_soccer,
                                                  color: Colors.greenAccent,
                                                  size: 30,
                                                )
                                              : null,
                                        ),
                                        const SizedBox(width: 16),
                                        // Field info
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                field['field_name'] ??
                                                    'Unnamed Field',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                field['location'] ??
                                                    'Unknown location',
                                                style: const TextStyle(
                                                  color: Colors.white70,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '${field['rent_price_per_hour'] ?? 0} SAR/hour',
                                                style: const TextStyle(
                                                  color: Colors.greenAccent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Availability indicator
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color:
                                                field['available_for_female'] ==
                                                        true
                                                    ? Colors.green
                                                    : Colors.red,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            field['available_for_female'] ==
                                                    true
                                                ? 'Available'
                                                : 'Unavailable',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
