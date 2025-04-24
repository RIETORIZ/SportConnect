// lib/models/sports_field.dart

class SportsField {
  final int fieldId;
  final String fieldName;
  final String location;
  final String? fieldImage;
  final double rentPricePerHour;
  final String suitableSports;
  final bool availableForFemale;
  final int renterId;
  final String? comments;
  final double review;
  String? renterName; // Not from DB, but useful for UI

  SportsField({
    required this.fieldId,
    required this.fieldName,
    required this.location,
    this.fieldImage,
    required this.rentPricePerHour,
    required this.suitableSports,
    required this.availableForFemale,
    required this.renterId,
    this.comments,
    this.review = 0.0,
    this.renterName,
  });

  factory SportsField.fromJson(Map<String, dynamic> json) {
    return SportsField(
      fieldId: json['field_id'],
      fieldName: json['field_name'],
      location: json['location'],
      fieldImage: json['field_image'],
      rentPricePerHour: double.parse(json['rent_price_per_hour'].toString()),
      suitableSports: json['suitable_sports'],
      availableForFemale: json['available_for_female'] ?? false,
      renterId: json['renter_id'],
      comments: json['comments'],
      review: json['review']?.toDouble() ?? 0.0,
      renterName: json['renter_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'field_id': fieldId,
      'field_name': fieldName,
      'location': location,
      'field_image': fieldImage,
      'rent_price_per_hour': rentPricePerHour,
      'suitable_sports': suitableSports,
      'available_for_female': availableForFemale,
      'renter_id': renterId,
      'comments': comments,
      'review': review,
    };
  }
}
