// lib/models/booking.dart

class FieldBooking {
  final int bookingId;
  final int fieldId;
  final int userId;
  final DateTime bookingDate;
  final String bookingStartTime;
  final String bookingEndTime;
  final String paymentMethod;
  final double totalPrice;
  String? fieldName; // Not from DB, but useful for UI
  String? userName; // Not from DB, but useful for UI

  FieldBooking({
    required this.bookingId,
    required this.fieldId,
    required this.userId,
    required this.bookingDate,
    required this.bookingStartTime,
    required this.bookingEndTime,
    required this.paymentMethod,
    required this.totalPrice,
    this.fieldName,
    this.userName,
  });

  factory FieldBooking.fromJson(Map<String, dynamic> json) {
    return FieldBooking(
      bookingId: json['booking_id'],
      fieldId: json['field_id'],
      userId: json['user_id'],
      bookingDate: DateTime.parse(json['booking_date']),
      bookingStartTime: json['booking_start_time'],
      bookingEndTime: json['booking_end_time'],
      paymentMethod: json['payment_method'],
      totalPrice: double.parse(json['total_price'].toString()),
      fieldName: json['field_name'],
      userName: json['user_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'booking_id': bookingId,
      'field_id': fieldId,
      'user_id': userId,
      'booking_date':
          bookingDate.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
      'booking_start_time': bookingStartTime,
      'booking_end_time': bookingEndTime,
      'payment_method': paymentMethod,
      'total_price': totalPrice,
    };
  }
}

class Reservation {
  final int id;
  final int fieldId;
  final int userId;
  final int? matchId;
  final DateTime reservedAt;
  String? fieldName; // Not from DB, but useful for UI
  String? userName; // Not from DB, but useful for UI

  Reservation({
    required this.id,
    required this.fieldId,
    required this.userId,
    this.matchId,
    required this.reservedAt,
    this.fieldName,
    this.userName,
  });

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'],
      fieldId: json['field_id'],
      userId: json['user_id'],
      matchId: json['match_id'],
      reservedAt: DateTime.parse(json['reserved_at']),
      fieldName: json['field_name'],
      userName: json['user_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'field_id': fieldId,
      'user_id': userId,
      'match_id': matchId,
      'reserved_at':
          reservedAt.toIso8601String().split('T')[0], // Format as YYYY-MM-DD
    };
  }
}
