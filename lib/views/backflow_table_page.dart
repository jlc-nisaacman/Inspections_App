// lib/views/backflow_table_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/backflow_data.dart';
import '../models/pagination.dart';
import '../services/data_service.dart';
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
  ConnectionStatus _connectionStatus = ConnectionStatus.noNetwork;
  bool _hasOfflineData = false;

  // Backward compatibility getter
  bool get _isOnline => _connectionStatus == ConnectionStatus.connected;

  // Services
  final DataService _dataService = DataService();

  // Scroll controllers
  final ScrollController _horizontalScrollController = ScrollController();
  final ScrollController _verticalScrollController = ScrollController();

  // Search-related properties
  String? _searchTerm;
  String? _searchColumn;
  DateTime? _startDate;
  DateTime? _endDate;
  bool _filterEmptyDates = true; // Enabled by default

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
    final status = await _dataService.getDetailedConnectionStatus();
    
    setState(() {
      _connectionStatus = status;
    });

    if (status != ConnectionStatus.connected) {
      final count = await _dataService.getBackflowCount();
      setState(() {
        _hasOfflineData = count > 0;
      });
    }
  }

  // Fetch data using DataService
  Future<void> fetchData({int page = 1, bool forceOnline = false}) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _currentPage = page;
    });

    try {
      final apiResponse = await _dataService.getBackflow(
        page: page,
        searchTerm: _searchTerm,
        searchColumn: _searchColumn,
        startDate: _startDate,
        endDate: _endDate,
        filterEmptyDates: _filterEmptyDates,
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

  Future<void> _syncData() async {
    final status = await _dataService.getDetailedConnectionStatus();
    setState(() {
      _connectionStatus = status;
    });
    
    if (status == ConnectionStatus.connected) {
      setState(() {
        _isLoading = true;
      });

      try {
        await fetchData(page: _currentPage, forceOnline: true);
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data refreshed successfully'),
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
              content: Text('Refresh failed: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } else {
      _showConnectionHelp();
    }
  }

  Future<void> _retryConnection() async {
    await _checkConnectivityAndData();
    
    if (mounted) {
      if (_connectionStatus == ConnectionStatus.connected) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Connection restored!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              _connectionStatus == ConnectionStatus.noNetwork
                  ? 'Still no network connection'
                  : 'Server still unreachable',
            ),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  void _showConnectionHelp() {
    String title;
    String message;
    List<String> actions;
    
    if (_connectionStatus == ConnectionStatus.noNetwork) {
      title = 'No Internet Connection';
      message = 'Your device is not connected to any network.';
      actions = [
        '• Connect to WiFi',
        '• Enable cellular data',
        '• Check airplane mode is off',
      ];
    } else {
      title = 'Cannot Reach Server';
      message = 'Your device has internet, but the inspection server is unreachable.';
      actions = [
        '• Verify you\'re on the correct WiFi network',
        '• Server may be temporarily down',
        '• Work offline - data will sync later',
      ];
    }
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              _connectionStatus == ConnectionStatus.noNetwork 
                  ? Icons.signal_wifi_off 
                  : Icons.cloud_off,
              color: _connectionStatus == ConnectionStatus.noNetwork 
                  ? Colors.grey 
                  : Colors.orange,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(title)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 16),
            const Text(
              'Try these steps:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...actions.map((action) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(action, style: const TextStyle(fontSize: 14)),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.pop(context);
              _retryConnection();
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry Connection'),
          ),
        ],
      ),
    );
  }

  void _performSearch(
    String? searchTerm, 
    String? searchColumn, 
    DateTime? startDate, 
    DateTime? endDate,
    bool filterEmptyDates
  ) {
    setState(() {
      _searchTerm = searchTerm;
      _searchColumn = (searchColumn != null && searchTerm != null) ? searchColumn : null;
      _startDate = startDate;
      _endDate = endDate;
      _filterEmptyDates = filterEmptyDates;
    });
    fetchData();
  }

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

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => SearchDialog(
        searchColumns: _searchColumns,
        onSearch: _performSearch,
      ),
    );
  }

  void _navigateToDetailView(BackflowData item) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => BackflowDetailView(backflowData: item),
      ),
    );
  }

  Widget _buildConnectionStatus() {
    Color statusColor;
    IconData statusIcon;
    String statusText;
    
    switch (_connectionStatus) {
      case ConnectionStatus.connected:
        statusColor = Colors.green;
        statusIcon = Icons.cloud_done;
        statusText = 'Connected';
        break;
      case ConnectionStatus.noNetwork:
        statusColor = Colors.grey;
        statusIcon = Icons.signal_wifi_off;
        statusText = 'No Network';
        break;
      case ConnectionStatus.serverUnreachable:
        statusColor = Colors.orange;
        statusIcon = Icons.cloud_off;
        statusText = 'Server Unreachable';
        break;
    }
    
    return GestureDetector(
      onTap: _connectionStatus != ConnectionStatus.connected 
          ? _showConnectionHelp 
          : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: statusColor, width: 1),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(statusIcon, size: 16, color: statusColor),
            const SizedBox(width: 4),
            Text(
              statusText,
              style: TextStyle(
                fontSize: 12,
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
            if (_connectionStatus != ConnectionStatus.connected) ...[
              const SizedBox(width: 4),
              Icon(Icons.help_outline, size: 14, color: statusColor),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Backflow Tests${_searchTerm != null ? ' (Filtered)' : ''}',
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
            tooltip: 'Search backflow tests',
          ),
        ],
      ),
      body: Column(
        children: [
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
                  ? const Center(child: Text('No backflow tests found'))
                  : _buildMobileList(),
          ),
        ],
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
                    item.form.ownerOfProperty.isNotEmpty ? item.form.ownerOfProperty : 'Unknown',
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.form.deviceLocation.isNotEmpty)
                        Text(item.form.deviceLocation),
                      if (item.form.mailingAddress.isNotEmpty)
                        Text(
                          item.form.mailingAddress,
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      Text(
                        'Date: ${item.formattedDate}',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12),
                      ),
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
        
        if (_pagination != null) _buildPaginationControls(),
      ],
    );
  }

  Widget _buildPaginationControls() {
    if (_pagination == null) return const SizedBox.shrink();

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