// lib/views/pump_system_table_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/pump_system_data.dart';
import '../models/pagination.dart';
import '../services/data_service.dart';
import 'search.dart';
import 'pump_system_detail_view.dart';

class PumpSystemsTablePage extends StatefulWidget {
  const PumpSystemsTablePage({super.key});

  @override
  PumpSystemsTablePageState createState() => PumpSystemsTablePageState();
}

class PumpSystemsTablePageState extends State<PumpSystemsTablePage> {
  // Data and pagination
  List<PumpSystemData> _data = [];
  Pagination? _pagination;
  bool _isLoading = false;
  String? _errorMessage;
  bool _isOnline = false;
  bool _hasOfflineData = false;

  // Services
  final DataService _dataService = DataService();

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
    'report_to', 
    'building', 
    'city_state', 
    'pdf_path'
  ];

  // Current page for pagination
  int _currentPage = 1;

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    _verticalScrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _checkConnectivityAndData();
    fetchData();
  }

  Future<void> _checkConnectivityAndData() async {
    final isOnline = await _dataService.isOnline();
    final hasOfflineData = await _dataService.hasOfflineData();
    
    setState(() {
      _isOnline = isOnline;
      _hasOfflineData = hasOfflineData;
    });
  }

  // bool get _isDesktopPlatform {
  //   if (kIsWeb) return false;
  //   return Platform.isWindows || Platform.isLinux || Platform.isMacOS;
  // }

  // Fetch data using DataService (handles online/offline automatically)
  Future<void> fetchData({int page = 1, bool forceOnline = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentPage = page;
    });

    try {
      final apiResponse = await _dataService.getPumpSystems(
        page: page,
        searchTerm: _searchTerm,
        searchColumn: _searchColumn,
        startDate: _startDate,
        endDate: _endDate,
        forceOnline: forceOnline,
      );

      setState(() {
        _data = apiResponse.data;
        _pagination = apiResponse.pagination;
        _isLoading = false;
      });

      await _checkConnectivityAndData();
    } catch (e) {
      setState(() {
        _data = [];
        _pagination = null;
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  // Force sync with server
  Future<void> _syncData() async {
    if (!_isOnline) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('No internet connection available for sync'),
            backgroundColor: Colors.orange,
          ),
        );
      }
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _dataService.syncAllData();
      await fetchData(page: _currentPage);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Data synced successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
    fetchData();
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
  void _navigateToDetailView(PumpSystemData item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => PumpSystemDetailView(pumpSystemData: item),
      ),
    );
  }

  // Build connection status indicator
  Widget _buildConnectionStatus() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: _isOnline ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(
          color: _isOnline ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            _isOnline ? Icons.cloud_done : Icons.cloud_off,
            size: 16,
            color: _isOnline ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 4),
          Text(
            _isOnline ? 'Online' : 'Offline',
            style: TextStyle(
              fontSize: 12,
              color: _isOnline ? Colors.green : Colors.orange,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            'Pump Systems${_searchTerm != null ? ' (Filtered)' : ''}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: _buildConnectionStatus(),
            ),
            IconButton(
              icon: const Icon(Icons.sync),
              onPressed: _isLoading ? null : _syncData,
              tooltip: 'Sync with server',
            ),
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: _showSearchDialog,
              tooltip: 'Search pump systems',
            ),
          ],
        ),
        body: Column(
          children: [
            // Offline indicator
            if (!_isOnline && _hasOfflineData)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                color: Colors.orange.withValues(alpha: 0.1),
                child: const Text(
                  'You are viewing cached data. Connect to internet to sync latest updates.',
                  style: TextStyle(color: Colors.orange, fontSize: 12),
                  textAlign: TextAlign.center,
                ),
              ),
            
            // Search summary
            if (_searchTerm != null || _startDate != null || _endDate != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                color: Colors.blue.withValues(alpha: 0.1),
                child: Row(
                  children: [
                    const Icon(Icons.filter_alt, size: 16, color: Colors.blue),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Filters: ${_buildSearchSummary()}',
                        style: const TextStyle(fontSize: 12, color: Colors.blue),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          _searchTerm = null;
                          _searchColumn = null;
                          _startDate = null;
                          _endDate = null;
                        });
                        fetchData();
                      },
                      child: const Text('Clear', style: TextStyle(fontSize: 12)),
                    ),
                  ],
                ),
              ),

            // Main content
            Expanded(
              child: _isLoading 
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage != null
                  ? Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _isOnline ? Icons.error : Icons.cloud_off,
                            size: 48,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _isOnline ? 'Error loading data' : 'No offline data available',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _errorMessage!,
                            style: const TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => fetchData(page: _currentPage),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : _data.isEmpty
                    ? const Center(child: Text('No pump systems found'))
                    : _buildMobileList(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileList() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _data.length,
            itemBuilder: (context, index) {
              final item = _data[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: ListTile(
                  title: Text(
                    item.form.reportTo.isNotEmpty ? item.form.reportTo : 'Unknown',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.form.building.isNotEmpty)
                        Text(item.form.building),
                      if (item.form.cityState.isNotEmpty)
                        Text(
                          item.form.cityState,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      Text(
                        'Date: ${item.formattedDate}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
                      // PDF Path row
                      Row(
                        children: [
                          Icon(
                            Icons.picture_as_pdf,
                            size: 14,
                            color: item.form.pdfPath.isNotEmpty ? Colors.red : Colors.grey,
                          ),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              item.form.pdfPath.isNotEmpty ? item.form.pdfPath : 'No PDF available',
                              style: TextStyle(
                                color: item.form.pdfPath.isNotEmpty ? Colors.grey[600] : Colors.grey,
                                fontSize: 11,
                                fontStyle: item.form.pdfPath.isNotEmpty ? null : FontStyle.italic,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                  onTap: () => _navigateToDetailView(item),
                ),
              );
            },
          ),
        ),
        
        // Pagination controls
        if (_pagination != null) _buildPaginationControls(),
      ],
    );
  }

  Widget _buildPaginationControls() {
    if (_pagination == null) return const SizedBox.shrink();

    // Calculate hasNext and hasPrevious since they're not in the Pagination model
    final hasPrevious = _pagination!.currentPage > 1;
    final hasNext = _pagination!.currentPage < _pagination!.totalPages;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border(top: BorderSide(color: Colors.grey[300]!)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton.icon(
            onPressed: hasPrevious && !_isLoading
                ? () => fetchData(page: _currentPage - 1)
                : null,
            icon: const Icon(Icons.arrow_back, size: 16),
            label: const Text('Previous'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Page ${_pagination!.currentPage} of ${_pagination!.totalPages}',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
              Text(
                '${_pagination!.totalItems} total items',
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              ),
            ],
          ),
          ElevatedButton.icon(
            onPressed: hasNext && !_isLoading
                ? () => fetchData(page: _currentPage + 1)
                : null,
            icon: const Icon(Icons.arrow_forward, size: 16),
            label: const Text('Next'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
          ),
        ],
      ),
    );
  }
}