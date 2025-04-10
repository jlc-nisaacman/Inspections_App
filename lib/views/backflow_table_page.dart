// lib/views/backflow_table_page.dart
import 'dart:convert';
import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../models/backflow_data.dart';
import '../models/pagination.dart';
import '../models/api_response_backflow.dart';
import '../config/app_config.dart';
import 'search.dart';
import 'backflow_detail_view.dart';

class BackflowTablePage extends StatefulWidget {
  const BackflowTablePage({super.key});

  @override
  BackflowTablePageState createState() => BackflowTablePageState();
}

class BackflowTablePageState extends State<BackflowTablePage> {
  // Data and pagination
  List<BackflowData> _data = [];
  Pagination? _pagination;
  bool _isLoading = false;
  String? _errorMessage;

  // Scroll controllers for horizontal and vertical scrolling
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  // Search-related properties
  String? _searchTerm;
  String? _searchColumn;
  DateTime? _startDate;
  DateTime? _endDate;

  // Define searchable columns
  static const List<String> _searchColumns = [
    'owner_of_property', 
    'device_location', 
    'mailing_address', 
    'date'
  ];

  // Current page for pagination
  int _currentPage = 1;

  @override
  void dispose() {
    // Dispose scroll controllers to prevent memory leaks
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Fetch data when screen is first loaded
    fetchData();
  }

  // Determine if current platform is desktop
  bool get _isDesktopPlatform {
    if (kIsWeb) return false;
    return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  }

  // Fetch data from API
  Future<void> fetchData({int page = 1}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentPage = page;
    });

    try {
      final response = await http.get(
        Uri.parse(
          AppConfig.getEndpointUrl(
            AppConfig.backflowEndpoint,
            queryParams: {'page': page},
            searchTerm: _searchTerm,
            searchColumn: _searchColumn,
            startDate: _startDate != null 
              ? DateFormat('yyyy-MM-dd').format(_startDate!) 
              : null,
            endDate: _endDate != null 
              ? DateFormat('yyyy-MM-dd').format(_endDate!) 
              : null,
          ),
        ),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final apiResponse = ApiResponseBackflow.fromJson(jsonResponse);

        setState(() {
          _data = apiResponse.data;
          _pagination = apiResponse.pagination;
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _data = [];
        _pagination = null;
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  // Perform search with given parameters
  void _performSearch(
    String? searchTerm, 
    String? searchColumn, 
    DateTime? startDate, 
    DateTime? endDate
  ) {
    setState(() {
      _searchTerm = searchTerm;
      _searchColumn = (searchColumn != null && searchTerm != null) ? searchColumn : null;
      _startDate = startDate;
      _endDate = endDate;
    });
    fetchData(); // Reload data with search parameters
  }

  // Build a summary of the current search
  String _buildSearchSummary() {
    List<String> summary = [];

    if (_searchTerm != null) {
      summary.add('Term: $_searchTerm${_searchColumn != null ? ' in $_searchColumn' : ''}');
    }

    if (_startDate != null) {
      summary.add('From: ${DateFormat('yyyy-MM-dd').format(_startDate!)}');
    }

    if (_endDate != null) {
      summary.add('To: ${DateFormat('yyyy-MM-dd').format(_endDate!)}');
    }

    return summary.join(' | ');
  }

  // Show search dialog
  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => SearchDialog(
        searchColumns: _searchColumns,
        onSearch: _performSearch,
      ),
    );
  }

  // Navigate to detail view
  void _navigateToDetailView(BackflowData item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BackflowDetailView(backflowData: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Backflow Tests${_searchTerm != null ? ": Search Results" : ""}',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            // Search Button
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _showSearchDialog,
              tooltip: 'Search',
            ),
            
            // Pagination controls
            if (_pagination != null && !_isLoading) ...[
              // Previous Page Button
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _currentPage > 1
                    ? () => fetchData(page: _currentPage - 1)
                    : null,
                tooltip: 'Previous Page',
              ),
              
              // Current Page Indicator
              Center(
                child: Text(
                  '$_currentPage/${_pagination!.totalPages}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              
              // Next Page Button
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _currentPage < _pagination!.totalPages
                    ? () => fetchData(page: _currentPage + 1)
                    : null,
                tooltip: 'Next Page',
              ),
              const SizedBox(width: 8),
            ],
            
            // Refresh Button
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => fetchData(),
              tooltip: 'Refresh',
            ),
          ],
        ),
        body: Column(
          children: [
            // Search Summary Banner
            if (_searchTerm != null || _startDate != null || _endDate != null)
              Container(
                color: Colors.blue.shade50,
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        _buildSearchSummary(),
                        style: const TextStyle(
                          color: Colors.blue,
                          fontStyle: FontStyle.italic,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    // Clear Search Button
                    IconButton(
                      icon: const Icon(Icons.clear, color: Colors.blue),
                      onPressed: () {
                        setState(() {
                          _searchTerm = null;
                          _searchColumn = null;
                          _startDate = null;
                          _endDate = null;
                        });
                        fetchData();
                      },
                    ),
                  ],
                ),
              ),

            // Loading Indicator
            if (_isLoading)
              const Expanded(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              )
            // Error Message
            else if (_errorMessage != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Error: $_errorMessage',
                        style: const TextStyle(color: Colors.red),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => fetchData(),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              )
            // Data Table
            else
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return _data.isEmpty
                        ? const Center(child: Text('No data'))
                        : _isDesktopPlatform
                            ? ScrollbarTheme(
                                data: ScrollbarThemeData(
                                  thumbColor: MaterialStateProperty.all(Colors.grey.shade400),
                                  trackColor: MaterialStateProperty.all(Colors.grey.shade200),
                                  thickness: MaterialStateProperty.all(10),
                                  radius: const Radius.circular(5),
                                ),
                                child: Scrollbar(
                                  controller: _horizontalScrollController,
                                  scrollbarOrientation: ScrollbarOrientation.bottom,
                                  child: Scrollbar(
                                    controller: _verticalScrollController,
                                    child: SingleChildScrollView(
                                      controller: _horizontalScrollController,
                                      scrollDirection: Axis.horizontal,
                                      child: SingleChildScrollView(
                                        controller: _verticalScrollController,
                                        scrollDirection: Axis.vertical,
                                        child: ConstrainedBox(
                                          constraints: BoxConstraints(
                                            minWidth: constraints.maxWidth,
                                          ),
                                          child: DataTable(
                                            showCheckboxColumn: false,
                                            columns: const [
                                              DataColumn(label: Text('Date')),
                                              DataColumn(label: Text('Client')),
                                              DataColumn(label: Text('Device Location')),
                                              DataColumn(label: Text('Address')),
                                              DataColumn(label: Text('PDF')),
                                            ],
                                            rows: _data.map((item) {
                                              return DataRow(
                                                onSelectChanged: (_) => 
                                                  _navigateToDetailView(item),
                                                cells: [
                                                  DataCell(
                                                    Text(item.formattedDate),
                                                  ),
                                                  DataCell(
                                                    Text(item.form.ownerOfProperty),
                                                  ),
                                                  DataCell(
                                                    Text(item.form.deviceLocation),
                                                  ),
                                                  DataCell(
                                                    Text(item.form.mailingAddress),
                                                  ),
                                                  DataCell(
                                                    Text(item.form.pdfPath),
                                                  ),
                                                ],
                                              );
                                            }).toList(),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: constraints.maxWidth,
                                  ),
                                  child: SingleChildScrollView(
                                    scrollDirection: Axis.vertical,
                                    child: DataTable(
                                      showCheckboxColumn: false,
                                      columns: const [
                                        DataColumn(label: Text('Date')),
                                        DataColumn(label: Text('Client')),
                                        DataColumn(label: Text('Device Location')),
                                        DataColumn(label: Text('Address')),
                                        DataColumn(label: Text('PDF')),
                                      ],
                                      rows: _data.map((item) {
                                        return DataRow(
                                          onSelectChanged: (_) => 
                                            _navigateToDetailView(item),
                                          cells: [
                                            DataCell(
                                              Text(item.formattedDate),
                                            ),
                                            DataCell(
                                              Text(item.form.ownerOfProperty),
                                            ),
                                            DataCell(
                                              Text(item.form.deviceLocation),
                                            ),
                                            DataCell(
                                              Text(item.form.mailingAddress),
                                            ),
                                            DataCell(
                                              Text(item.form.pdfPath),
                                            ),
                                          ],
                                        );
                                      }).toList(),
                                    ),
                                  ),
                                ),
                              );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}