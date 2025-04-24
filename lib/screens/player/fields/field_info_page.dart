// lib/screens/player/fields/field_info_page.dart

import 'package:flutter/material.dart';
import '../../../services/field_service.dart';
import '../../../widgets/facility_row.dart'; // Import the FacilityRow widget
import 'package:intl/intl.dart';

class FieldInfoPage extends StatefulWidget {
  final int fieldId;
  final String fieldName;
  final String location;
  final String imagePath;
  final bool suitableForWomen;
  final double rentPricePerHour;
  final String suitableSports;

  const FieldInfoPage({
    super.key,
    required this.fieldId,
    required this.fieldName,
    required this.location,
    required this.imagePath,
    required this.suitableForWomen,
    required this.rentPricePerHour,
    required this.suitableSports,
  });

  @override
  State<FieldInfoPage> createState() => _FieldInfoPageState();
}

class _FieldInfoPageState extends State<FieldInfoPage> {
  bool _isLoading = false;
  String _errorMessage = '';
  DateTime? _selectedDate;
  TimeOfDay? _startTime;
  TimeOfDay? _endTime;
  String _selectedPaymentMethod = 'Credit Card';
  final List<String> _paymentMethods = [
    'Credit Card',
    'Apple Pay',
    'Google Pay',
    'PayPal'
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime.now().add(const Duration(days: 1));
    _startTime = const TimeOfDay(hour: 10, minute: 0);
    _endTime = const TimeOfDay(hour: 12, minute: 0);
  }

  double _calculateTotalPrice() {
    if (_startTime == null || _endTime == null) return 0;

    // Convert TimeOfDay to minutes since midnight
    int startMinutes = _startTime!.hour * 60 + _startTime!.minute;
    int endMinutes = _endTime!.hour * 60 + _endTime!.minute;

    // Calculate duration in hours (handle cases where end time is before start time)
    double hours = (endMinutes - startMinutes) / 60;
    if (hours <= 0) hours += 24; // Assuming booking can span to next day

    return hours * widget.rentPricePerHour;
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 90)),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _selectStartTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _startTime ?? const TimeOfDay(hour: 10, minute: 0),
    );
    if (picked != null && picked != _startTime) {
      setState(() {
        _startTime = picked;

        // If end time is before start time or not set, update it to start time + 2 hours
        if (_endTime == null ||
            _timeToDouble(_endTime!) <= _timeToDouble(_startTime!)) {
          int hour = _startTime!.hour + 2;
          int minute = _startTime!.minute;
          if (hour >= 24) {
            hour -= 24;
          }
          _endTime = TimeOfDay(hour: hour, minute: minute);
        }
      });
    }
  }

  Future<void> _selectEndTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _endTime ?? const TimeOfDay(hour: 12, minute: 0),
    );
    if (picked != null && picked != _endTime) {
      setState(() {
        _endTime = picked;
      });
    }
  }

  double _timeToDouble(TimeOfDay time) {
    return time.hour + time.minute / 60.0;
  }

  Future<void> _bookField() async {
    if (_selectedDate == null || _startTime == null || _endTime == null) {
      setState(() {
        _errorMessage = 'Please select date and time for booking';
      });
      return;
    }

    // Validate that end time is after start time
    if (_timeToDouble(_startTime!) >= _timeToDouble(_endTime!)) {
      setState(() {
        _errorMessage = 'End time must be after start time';
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      // Format date and times as required by the API
      final bookingDate = DateFormat('yyyy-MM-dd').format(_selectedDate!);
      final startTime =
          '${_startTime!.hour.toString().padLeft(2, '0')}:${_startTime!.minute.toString().padLeft(2, '0')}';
      final endTime =
          '${_endTime!.hour.toString().padLeft(2, '0')}:${_endTime!.minute.toString().padLeft(2, '0')}';

      // Calculate total price
      final totalPrice = _calculateTotalPrice();

      // Call the booking service
      await FieldService.bookField(
        fieldId: widget.fieldId,
        bookingDate: bookingDate,
        bookingStartTime: startTime,
        bookingEndTime: endTime,
        paymentMethod: _selectedPaymentMethod,
        totalPrice: totalPrice,
      );

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Field booked successfully!')),
        );

        // Navigate back to the previous screen
        Navigator.pop(context);
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to book field: ${e.toString()}';
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> facilitiesList = [
      const FacilityRow(
        icon: Icons.local_parking,
        text: 'Parking Available',
      ),
      const SizedBox(height: 10),
      const FacilityRow(
        icon: Icons.people,
        text: 'Capacity: 200 people',
      ),
      const SizedBox(height: 10),
      const FacilityRow(
        icon: Icons.lightbulb,
        text: 'Lighting Available',
      ),
      const SizedBox(height: 10),
      FacilityRow(
        icon: Icons.sports,
        text: 'Sports: ${widget.suitableSports}',
      ),
    ];

    if (widget.suitableForWomen) {
      facilitiesList.addAll([
        const SizedBox(height: 10),
        const FacilityRow(
          icon: Icons.female,
          text: 'Suitable for Women 🙋‍♀️',
        ),
      ]);
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Field Information'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: widget.imagePath.startsWith('http')
                  ? Image.network(
                      widget.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                      errorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          'assets/soccer_field.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200,
                        );
                      },
                    )
                  : Image.asset(
                      widget.imagePath,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      height: 200,
                    ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.fieldName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            Text(
              'Location: ${widget.location}',
              style: const TextStyle(color: Colors.grey, fontSize: 18),
            ),
            Text(
              'Price: \$${widget.rentPricePerHour.toStringAsFixed(2)}/hour',
              style: const TextStyle(
                  color: Colors.green,
                  fontSize: 18,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const Text(
              'This field has a premium surface and is ideal for both recreational and competitive events. Available for booking 24/7 with top-notch facilities including lighting, seating, and changing rooms.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Facilities:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: facilitiesList,
            ),
            const SizedBox(height: 30),

            // Booking Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Book This Field',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date Picker
                  InkWell(
                    onTap: () => _selectDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 12, horizontal: 16),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.calendar_today),
                          const SizedBox(width: 10),
                          Text(
                            _selectedDate != null
                                ? DateFormat('yyyy-MM-dd')
                                    .format(_selectedDate!)
                                : 'Select Date',
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Time Pickers
                  Row(
                    children: [
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectStartTime(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time),
                                const SizedBox(width: 10),
                                Text(
                                  _startTime != null
                                      ? _startTime!.format(context)
                                      : 'Start Time',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: InkWell(
                          onTap: () => _selectEndTime(context),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                vertical: 12, horizontal: 16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade400),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: [
                                const Icon(Icons.access_time),
                                const SizedBox(width: 10),
                                Text(
                                  _endTime != null
                                      ? _endTime!.format(context)
                                      : 'End Time',
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Payment Method Dropdown
                  DropdownButtonFormField<String>(
                    decoration: const InputDecoration(
                      labelText: 'Payment Method',
                      border: OutlineInputBorder(),
                    ),
                    value: _selectedPaymentMethod,
                    items: _paymentMethods
                        .map((method) => DropdownMenuItem(
                              value: method,
                              child: Text(method),
                            ))
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPaymentMethod = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 16),

                  // Total Price
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total Price:',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '\$${_calculateTotalPrice().toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),

                  if (_errorMessage.isNotEmpty)
                    Padding(
                      padding: const EdgeInsets.only(top: 16),
                      child: Text(
                        _errorMessage,
                        style: const TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                  const SizedBox(height: 16),

                  // Book Now Button
                  Center(
                    child: _isLoading
                        ? const CircularProgressIndicator()
                        : ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                vertical: 12,
                                horizontal: 40,
                              ),
                            ),
                            onPressed: _bookField,
                            child: const Text(
                              'Book Now',
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
          ],
        ),
      ),
    );
  }
}
