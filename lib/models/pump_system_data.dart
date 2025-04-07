// lib/models/pump_system_data.dart
import 'pump_system_form.dart';

class PumpSystemData {
  final PumpSystemForm form;

  PumpSystemData(this.form);

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
    return form.building.isNotEmpty ? form.building : 'N/A';
  }

  // Factory method to create PumpSystemData from JSON
  factory PumpSystemData.fromJson(Map<String, dynamic> json) {
    return PumpSystemData(PumpSystemForm.fromJson(json));
  }
}