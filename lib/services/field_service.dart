// lib/services/field_service.dart

import 'api_service.dart';
import '../models/sports_field.dart';
import '../models/booking.dart';

class FieldService {
  // Get all sports fields
  static Future<List<SportsField>> getSportsFields() async {
    return await ApiService.getSportsFields();
  }

  // Get details of a specific field
  static Future<SportsField> getFieldDetails(int fieldId) async {
    return await ApiService.getFieldDetails(fieldId);
  }

  // Register a new field (for renters)
  static Future<SportsField> registerField({
    required String fieldName,
    required String location,
    required double rentPricePerHour,
    required String suitableSports,
    required bool availableForFemale,
    String? fieldImage,
    String? comments,
  }) async {
    final fieldData = {
      'field_name': fieldName,
      'location': location,
      'rent_price_per_hour': rentPricePerHour,
      'suitable_sports': suitableSports,
      'available_for_female': availableForFemale,
      if (fieldImage != null) 'field_image': fieldImage,
      if (comments != null) 'comments': comments,
    };

    return await ApiService.registerField(fieldData);
  }

  // Get recommended fields for the user
  static Future<List<SportsField>> getRecommendedFields() async {
    return await ApiService.getRecommendedFields();
  }

  // Book a field
  static Future<FieldBooking> bookField({
    required int fieldId,
    required String bookingDate,
    required String bookingStartTime,
    required String bookingEndTime,
    required String paymentMethod,
    required double totalPrice,
  }) async {
    final bookingData = {
      'field_id': fieldId,
      'booking_date': bookingDate,
      'booking_start_time': bookingStartTime,
      'booking_end_time': bookingEndTime,
      'payment_method': paymentMethod,
      'total_price': totalPrice,
    };

    return await ApiService.createBooking(bookingData);
  }
}
