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