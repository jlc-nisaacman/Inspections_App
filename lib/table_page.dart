import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'models.dart';

class JsonTableScreen extends StatefulWidget {
  const JsonTableScreen({super.key});

  @override
  JsonTableScreenState createState() => JsonTableScreenState();
}

class JsonTableScreenState extends State<JsonTableScreen> {
  List<InspectionData> _data = [];
  Pagination? _pagination;
  bool _isLoading = false;
  String? _errorMessage;
  
  Future<void> fetchData({int page = 1}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    
    try {
      final response = await http.get(
        Uri.parse('http://192.168.0.37:8081/inspections?page=$page'),
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Inspections',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 30,
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
          actions: [
            ElevatedButton.icon(
              onPressed: () => fetchData(),
              label: const Text('Download'),
              icon: const Icon(Icons.download_for_offline_rounded),
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
                                        columns: const [
                                          DataColumn(label: Text('Date')),
                                          DataColumn(label: Text('Inspector')),
                                          DataColumn(label: Text('Location')),
                                          DataColumn(label: Text('City/State')),
                                          DataColumn(label: Text('PDF')),
                                        ],
                                        rows: _data.map((item) {
                                          return DataRow(
                                            cells: [
                                              DataCell(Text(item.formattedDate)),
                                              DataCell(Text(item.inspector)),
                                              DataCell(Text(item.location)),
                                              DataCell(Text(item.locationCityState)),
                                              DataCell(Text(item.pdfPath)),
                                            ],
                                          );
                                        }).toList(),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              if (_pagination != null)
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      IconButton(
                                        icon: const Icon(Icons.arrow_back),
                                        onPressed: _pagination!.currentPage > 1
                                            ? () => fetchData(page: _pagination!.currentPage - 1)
                                            : null,
                                      ),
                                      Text(
                                        'Page ${_pagination!.currentPage} of ${_pagination!.totalPages}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.arrow_forward),
                                        onPressed: _pagination!.currentPage < _pagination!.totalPages
                                            ? () => fetchData(page: _pagination!.currentPage + 1)
                                            : null,
                                      ),
                                    ],
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