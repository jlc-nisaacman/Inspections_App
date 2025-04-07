import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/inspection_data.dart';
import '../models/pagination.dart';
import '../models/api_response.dart';
import '../config/app_config.dart';
import 'detail_view.dart';

class TableScreen extends StatefulWidget {
  const TableScreen({super.key});

  @override
  TableScreenState createState() => TableScreenState();
}

class TableScreenState extends State<TableScreen> {
  List<InspectionData> _data = [];
  Pagination? _pagination;
  bool _isLoading = false;
  String? _errorMessage;
  
  // Navigation state
  int _selectedIndex = 0;
  final List<String> _viewOptions = ['Inspections', 'Dry', 'Pump', 'Backflow'];
  
  // Mapping of view options to their respective endpoints
  final Map<String, String> _endpointMap = {
    'Inspections': AppConfig.inspectionsEndpoint,
    'Dry': AppConfig.drySystemsEndpoint,
    'Pump': AppConfig.pumpSystemsEndpoint,
    'Backflow': AppConfig.backflowEndpoint,
  };
  
  @override
  void initState() {
    super.initState();
    // Automatically fetch data when the screen is first loaded
    fetchData();
  }
  
  Future<void> fetchData({int page = 1}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      // Get the current endpoint based on selected view
      final endpoint = _endpointMap[_viewOptions[_selectedIndex]] ?? AppConfig.inspectionsEndpoint;
      
      final response = await http.get(
        Uri.parse(AppConfig.getEndpointUrl(endpoint, queryParams: {'page': page})),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final apiResponse = ApiResponse.fromJson(jsonResponse);
        
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

  void _navigateToDetailView(InspectionData item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InspectionDetailView(inspectionData: item),
      ),
    );
  }
  
  void _onNavItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      // Fetch data for the newly selected tab
      fetchData();
    });
  }
  
  // Helper method to get the appropriate icon for each option
  IconData _getIconForOption(String option) {
    switch (option) {
      case 'Inspections':
        return Icons.assignment;
      case 'Dry':
        return Icons.compress;
      case 'Pump':
        return Icons.plumbing;
      case 'Backflow':
        return Icons.compare_arrows;
      default:
        return Icons.assignment;
    }
  }

  @override
  Widget build(BuildContext context) {
    // Rest of the build method remains the same as in the previous version
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            _viewOptions[_selectedIndex],
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            // Only show pagination controls if we have pagination data and we're not loading
            if (_pagination != null && !_isLoading) ...[
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: _pagination!.currentPage > 1
                    ? () => fetchData(page: _pagination!.currentPage - 1)
                    : null,
                tooltip: 'Previous Page',
              ),
              Center(
                child: Text(
                  '${_pagination!.currentPage}/${_pagination!.totalPages}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: _pagination!.currentPage < _pagination!.totalPages
                    ? () => fetchData(page: _pagination!.currentPage + 1)
                    : null,
                tooltip: 'Next Page',
              ),
              const SizedBox(width: 8),
            ],
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => fetchData(),
              tooltip: 'Refresh',
            ),
          ],
        ),
        body: Column(
          children: [
            if (_isLoading)
              const Expanded(
                child: Center(child: CircularProgressIndicator()),
              )
            else if (_errorMessage != null)
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Error: $_errorMessage', style: const TextStyle(color: Colors.red)),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () => fetchData(),
                        child: const Text('Try Again'),
                      ),
                    ],
                  ),
                ),
              )
            else
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return _data.isEmpty
                        ? const Center(child: Text('No data'))
                        : Column(
                            children: [
                              Expanded(
                                child: SingleChildScrollView(
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
                                          DataColumn(label: Text('Inspector')),
                                          DataColumn(label: Text('Location')),
                                          DataColumn(label: Text('City/State')),
                                          DataColumn(label: Text('PDF')),
                                        ],
                                        rows: _data.map((item) {
                                          return DataRow(
                                            onSelectChanged: (_) => _navigateToDetailView(item),
                                            cells: [
                                              DataCell(Text(item.formattedDate)),
                                              DataCell(Text(item.form.inspector)),
                                              DataCell(Text(item.form.location)),
                                              DataCell(Text(item.form.locationCityState)),
                                              DataCell(Text(item.form.pdfPath)),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          );
                  },
                ),
              ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed, // Important when you have more than 3 items
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).colorScheme.primary,
          unselectedItemColor: Theme.of(context).colorScheme.onSurfaceVariant,
          onTap: _onNavItemTapped,
          items: _viewOptions.map((option) {
            return BottomNavigationBarItem(
              icon: Icon(_getIconForOption(option)),
              label: option,
            );
          }).toList(),
        ),
      ),
    );
  }
}