class ApiResponse {
  final List<InspectionData> data;
  final Pagination pagination;

  ApiResponse({required this.data, required this.pagination});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      data: (json['data'] as List)
          .map((item) => InspectionData.fromJson(item as Map<String, dynamic>))
          .toList(),
      pagination: Pagination.fromJson(json['pagination'] as Map<String, dynamic>),
    );
  }
}

class Pagination {
  final int currentPage;
  final int pageSize;
  final int totalItems;
  final int totalPages;

  Pagination({
    required this.currentPage,
    required this.pageSize,
    required this.totalItems,
    required this.totalPages,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['currentPage'] as int,
      pageSize: json['pageSize'] as int,
      totalItems: json['totalItems'] as int,
      totalPages: json['totalPages'] as int,
    );
  }
}

class InspectionData {
  final String date;
  final String inspector;
  final String location;
  final String locationCityState;
  final String pdfPath;

  InspectionData({
    required this.date,
    required this.inspector,
    required this.location,
    required this.locationCityState,
    required this.pdfPath,
  });

  // Getter for formatted date
  String get formattedDate {
    try {
      final DateTime dateTime = DateTime.parse(date);
      return "${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}";
    } catch (e) {
      return date; // Return original if parsing fails
    }
  }

  factory InspectionData.fromJson(Map<String, dynamic> json) {
    return InspectionData(
      date: json['DATE']?.toString() ?? 'N/A',
      inspector: json['INSPECTOR']?.toString() ?? 'N/A',
      location: json['LOCATION']?.toString() ?? 'N/A',
      locationCityState: json['CITY  STATE_2']?.toString() ?? 'N/A',
      pdfPath: json['pdf_path']?.toString() ?? 'N/A',
    );
  }
}