
class AppConfig {
  // Base URL for all API requests
  static const String baseUrl = 'http://192.168.0.37:8081';

  // Method to construct full URL for different endpoints
  static String getEndpointUrl(String endpoint, {Map<String, dynamic>? queryParams}) {
    // Construct the full URL
    Uri uri = Uri.parse('$baseUrl$endpoint');

    // Add query parameters if provided
    if (queryParams != null) {
      uri = uri.replace(queryParameters: queryParams.map((key, value) => MapEntry(key, value.toString())));
    }

    return uri.toString();
  }

  // Predefined endpoint paths
  static const String inspectionsEndpoint = '/inspections';
  static const String drySystemsEndpoint = '/dry-systems';
  static const String pumpSystemsEndpoint = '/pump-systems';
  static const String backflowEndpoint = '/backflow';
}