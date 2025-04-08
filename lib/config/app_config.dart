class AppConfig {
  // Base URL for all API requests
  static const String baseUrl = 'http://192.168.0.37:8081';

  // Method to construct full URL for different endpoints
  static String getEndpointUrl(
    String endpoint, {
    Map<String, dynamic>? queryParams,
    String? searchTerm,
    String? searchColumn,
    String? startDate,
    String? endDate,
  }) {
    // Start with base query params if provided
    final params = queryParams ?? {};

    // Add search parameters if provided
    if (searchTerm != null) {
      params['search'] = searchTerm;
    }
    if (searchColumn != null) {
      params['column'] = searchColumn;
    }
    if (startDate != null) {
      params['start_date'] = startDate;
    }
    if (endDate != null) {
      params['end_date'] = endDate;
    }

    // Construct the full URL
    Uri uri = Uri.parse('$baseUrl$endpoint');
    uri = uri.replace(queryParameters: params.map((key, value) => MapEntry(key, value.toString())));

    return uri.toString();
  }

  // Predefined endpoint paths
  static const String inspectionsEndpoint = '/inspections';
  static const String drySystemsEndpoint = '/dry-systems';
  static const String pumpSystemsEndpoint = '/pump-systems';
  static const String backflowEndpoint = '/backflow';
}