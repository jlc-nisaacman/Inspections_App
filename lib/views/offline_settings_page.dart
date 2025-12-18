// lib/views/offline_settings_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/data_service.dart';
import '../services/database_helper.dart';

class OfflineSettingsPage extends StatefulWidget {
  const OfflineSettingsPage({super.key});

  @override
  State<OfflineSettingsPage> createState() => _OfflineSettingsPageState();
}

class _OfflineSettingsPageState extends State<OfflineSettingsPage> {
  final DataService _dataService = DataService();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  
  bool _isLoading = false;
  ConnectionStatus _connectionStatus = ConnectionStatus.noNetwork;
  Map<String, DateTime?> _lastSyncTimes = {};
  Map<String, int> _recordCounts = {};
  Map<String, int>? _serverCounts;
  bool _isSyncing = false;
  String _syncProgress = '';

  // Backward compatibility getter
  bool get _isOnline => _connectionStatus == ConnectionStatus.connected;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final status = await _dataService.getDetailedConnectionStatus();
      final syncTimes = await _dataService.getLastSyncTimes();
      
      // Get record counts for each table
      final inspectionsCount = await _dbHelper.getInspectionsCount();
      final backflowCount = await _dbHelper.getBackflowCount();
      final pumpSystemsCount = await _dbHelper.getPumpSystemsCount();
      final drySystemsCount = await _dbHelper.getDrySystemsCount();

      // Get server counts if online
      Map<String, int>? serverCounts;
      if (status == ConnectionStatus.connected) {
        serverCounts = await _dataService.getServerStatistics();
      }

      setState(() {
        _connectionStatus = status;
        _lastSyncTimes = syncTimes;
        _recordCounts = {
          'inspections': inspectionsCount,
          'backflow': backflowCount,
          'pump_systems': pumpSystemsCount,
          'dry_systems': drySystemsCount,
        };
        _serverCounts = serverCounts;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _syncAllData() async {
    if (_connectionStatus != ConnectionStatus.connected) {
      _showConnectionHelp();
      return;
    }

    setState(() {
      _isSyncing = true;
      _syncProgress = 'Starting sync...';
    });

    try {
      await _dataService.syncAllData(
        onProgress: (stage, current, total) {
          if (mounted) {
            setState(() {
              if (total > 0) {
                _syncProgress = '$stage (Page $current of $total)';
              } else {
                _syncProgress = '$stage (Page $current)';
              }
            });
          }
        },
      );
      
      await _loadData(); // Refresh the data
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('All data synced successfully'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Sync failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isSyncing = false;
          _syncProgress = '';
        });
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
              _loadData();
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Offline Data'),
        content: const Text(
          'Are you sure you want to clear all offline data? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _dataService.clearCache();
        await _loadData(); // Refresh the data
        
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Offline data cleared successfully'),
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
              content: Text('Error clearing data: $e'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  String _formatLastSync(DateTime? lastSync) {
    if (lastSync == null) return 'Never';
    
    final now = DateTime.now();
    final difference = now.difference(lastSync);
    
    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inHours < 1) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inDays < 1) {
      return '${difference.inHours} hours ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('MMM dd, yyyy HH:mm').format(lastSync);
    }
  }

  Widget _buildConnectionStatus() {
    Color statusColor;
    IconData statusIcon;
    String statusTitle;
    String statusSubtitle;
    
    switch (_connectionStatus) {
      case ConnectionStatus.connected:
        statusColor = Colors.green;
        statusIcon = Icons.cloud_done;
        statusTitle = 'Connected';
        statusSubtitle = 'Connected to server';
        break;
      case ConnectionStatus.noNetwork:
        statusColor = Colors.grey;
        statusIcon = Icons.signal_wifi_off;
        statusTitle = 'No Network';
        statusSubtitle = 'No internet connection';
        break;
      case ConnectionStatus.serverUnreachable:
        statusColor = Colors.orange;
        statusIcon = Icons.cloud_off;
        statusTitle = 'Server Unreachable';
        statusSubtitle = 'Cannot connect to server';
        break;
    }

    return GestureDetector(
      onTap: _connectionStatus != ConnectionStatus.connected ? _showConnectionHelp : null,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(statusIcon, color: statusColor, size: 32),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      statusTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: statusColor,
                      ),
                    ),
                    Text(
                      statusSubtitle,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ),
              if (_connectionStatus != ConnectionStatus.connected)
                Icon(Icons.help_outline, color: statusColor, size: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDataTable(String title, String tableName) {
    final count = _recordCounts[tableName] ?? 0;
    final serverCount = _serverCounts?[tableName];
    final lastSync = _lastSyncTimes[tableName];
    
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Row(
                  children: [
                    Chip(
                      label: Text('$count cached'),
                      backgroundColor: count > 0 ? Colors.green.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.1),
                    ),
                    if (serverCount != null) ...[
                      const SizedBox(width: 8),
                      Chip(
                        label: Text('$serverCount total'),
                        backgroundColor: Colors.blue.withValues(alpha: 0.1),
                      ),
                    ],
                  ],
                ),
              ],
            ),
            const SizedBox(width: 8),
            Row(
              children: [
                Icon(
                  Icons.access_time,
                  size: 16,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 4),
                Text(
                  'Last sync: ${_formatLastSync(lastSync)}',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            if (serverCount != null && count < serverCount) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.sync_problem,
                      size: 12,
                      color: Colors.orange[700],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${serverCount - count} records not cached',
                      style: TextStyle(
                        fontSize: 11,
                        color: Colors.orange[700],
                      ),
                    ),
                  ],
                ),
              ),
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
        title: const Text('Offline Settings'),
      ),
      body: _isLoading
        ? const Center(child: CircularProgressIndicator())
        : RefreshIndicator(
            onRefresh: _loadData,
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Connection Status
                _buildConnectionStatus(),
                
                const SizedBox(height: 24),
                
                // Sync Controls
                const Text(
                  'Sync Controls',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isOnline && !_isSyncing ? _syncAllData : null,
                        icon: _isSyncing ? 
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ) : 
                          const Icon(Icons.sync),
                        label: Text(_isSyncing ? 'Syncing...' : 'Sync All Data'),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: !_isSyncing ? _clearAllData : null,
                        icon: const Icon(Icons.delete_outline),
                        label: const Text('Clear Cache'),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          foregroundColor: Colors.red,
                        ),
                      ),
                    ),
                  ],
                ),
                
                // Show sync progress
                if (_isSyncing) ...[
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _syncProgress,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                const SizedBox(height: 32),
                
                // Data Tables Status
                const Text(
                  'Cached Data',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                
                _buildDataTable('Inspections', 'inspections'),
                const SizedBox(height: 8),
                _buildDataTable('Backflow Tests', 'backflow'),
                const SizedBox(height: 8),
                _buildDataTable('Pump Systems', 'pump_systems'),
                const SizedBox(height: 8),
                _buildDataTable('Dry Systems', 'dry_systems'),
                
                const SizedBox(height: 32),
                
                // Information Card
                Card(
                  color: Colors.blue.withValues(alpha: 0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.info_outline,
                              color: Colors.blue[700],
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'How Offline Mode Works',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.blue[700],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          '• Data is automatically cached when you browse while online\n'
                          '• When offline, you can still search and view cached data\n'
                          '• Sync when back online to get the latest updates\n'
                          '• Search functionality works the same in both modes',
                          style: TextStyle(fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
    );
  }
}