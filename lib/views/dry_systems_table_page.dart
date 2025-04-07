// lib/views/dry_systems_table_page.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/dry_system_data.dart';
import '../models/pagination.dart';
import '../models/api_response_dry_system.dart'; // Import the new class
import '../config/app_config.dart';
import 'dry_system_detail_view.dart';

class DrySystemsTablePage extends StatefulWidget {
  const DrySystemsTablePage({super.key});

  @override
  DrySystemsTablePageState createState() => DrySystemsTablePageState();
}

class DrySystemsTablePageState extends State<DrySystemsTablePage> {
  List<DrySystemData> _data = [];
  Pagination? _pagination;
  bool _isLoading = false;
  String? _errorMessage;

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
      final response = await http.get(
        Uri.parse(AppConfig.getEndpointUrl(
          AppConfig.drySystemsEndpoint, 
          queryParams: {'page': page}
        )),
      );
      
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonResponse = jsonDecode(response.body);
        final apiResponse = ApiResponseDrySystem.fromJson(jsonResponse);
        
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

  void _navigateToDetailView(DrySystemData item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => DrySystemDetailView(drySystemData: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Dry Systems',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            // Pagination controls
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
      ),
    );
  }
}