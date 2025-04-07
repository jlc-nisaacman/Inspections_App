// lib/models/dry_system_data.dart
import 'dry_system_form.dart';

class DrySystemData {
  final DrySystemForm form;

  DrySystemData(this.form);

  // Getter for formatted date
  String get formattedDate {
    try {
      if (form.date.isEmpty) {
        return 'N/A';
      }

      // Try parsing as DateTime (handles different date formats)
      DateTime? dateTime;

      // First attempt: Try parsing as ISO format
      try {
        dateTime = DateTime.parse(form.date);
      } catch (e) {
        // If that fails, try alternate formats or return original
        return form.date;
      }

      // Format the date consistently
      return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return form.date; // Return original if parsing fails
    }
  }

  // Getter for location (with fallback)
  String get displayLocation {
    return form.location.isNotEmpty ? form.location : 'N/A';
  }

  // Factory method to create DrySystemData from JSON
  factory DrySystemData.fromJson(Map<String, dynamic> json) {
    return DrySystemData(DrySystemForm.fromJson(json));
  }
}
