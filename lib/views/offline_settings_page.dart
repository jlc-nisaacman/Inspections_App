// lib/views/offline_settings_page.dart
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/data_service.dart';
import '../services/database_helper.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';

class OfflineSettingsPage extends StatefulWidget {
  const OfflineSettingsPage({super.key});

  @override
  State<OfflineSettingsPage> createState() => _OfflineSettingsPageState();
}

class _OfflineSettingsPageState extends State<OfflineSettingsPage> {
  final DataService _dataService = DataService();
  final DatabaseHelper _dbHelper = DatabaseHelper();
  final AuthService _authService = AuthService();
  final UserService _userService = UserService();
  final TextEditingController _uuidController = TextEditingController();
  
  bool _isLoading = false;
  ConnectionStatus _connectionStatus = ConnectionStatus.noNetwork;
  Map<String, DateTime?> _lastSyncTimes = {};
  Map<String, int> _recordCounts = {};
  bool _isSyncing = false;
  String _syncProgress = '';
  bool _hasUuid = false;
  String? _userName;
  bool _isValidatingUuid = false;

  // Backward compatibility getter
  bool get _isOnline => _connectionStatus == ConnectionStatus.connected;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  @override
  void dispose() {
    _uuidController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Load UUID and user name
      final uuid = await _authService.getUuid();
      if (uuid != null) {
        _uuidController.text = uuid;
      }
      _hasUuid = await _authService.hasUuid();
      _userName = await _authService.getUserName();

      final status = await _dataService.getDetailedConnectionStatus();
      final syncTimes = await _dataService.getLastSyncTimes();
      
      // Get record counts for each table
      final inspectionsCount = await _dbHelper.getInspectionsCount();
      final backflowCount = await _dbHelper.getBackflowCount();
      final pumpSystemsCount = await _dbHelper.getPumpSystemsCount();
      final drySystemsCount = await _dbHelper.getDrySystemsCount();

      setState(() {
        _connectionStatus = status;
        _lastSyncTimes = syncTimes;
        _recordCounts = {
          'inspections': inspectionsCount,
          'backflow': backflowCount,
          'pump_systems': pumpSystemsCount,
          'dry_systems': drySystemsCount,
        };
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _validateAndSaveUuid() async {
    final uuid = _uuidController.text.trim();
    
    if (uuid.isEmpty) {
      _showMessage('UUID cannot be empty', isError: true);
      return;
    }

    setState(() {
      _isValidatingUuid = true;
      _userName = null;
    });

    try {
      // Fetch users from API to validate UUID
      final users = await _userService.fetchUsers();
      final matchingUser = users.firstWhere(
        (user) => user['uuid'] == uuid,
        orElse: () => {},
      );

      if (matchingUser.isEmpty) {
        setState(() {
          _isValidatingUuid = false;
        });
        _showMessage('Invalid UUID - user not found', isError: true);
        return;
      }

      // Check if user is revoked
      if (matchingUser['revoked'] == true) {
        setState(() {
          _isValidatingUuid = false;
        });
        _showMessage('Access revoked for this user', isError: true);
        return;
      }

      // Save UUID and user name
      final uuidSuccess = await _authService.setUuid(uuid);
      final userName = matchingUser['name'] as String;
      final nameSuccess = await _authService.setUserName(userName);
      
      if (uuidSuccess && nameSuccess) {
        setState(() {
          _hasUuid = true;
          _userName = userName;
          _isValidatingUuid = false;
        });
        _showMessage('UUID saved successfully');
      } else {
        setState(() {
          _isValidatingUuid = false;
        });
        _showMessage('Failed to save UUID', isError: true);
      }
    } catch (e) {
      setState(() {
        _isValidatingUuid = false;
      });
      _showMessage('Error validating UUID: $e', isError: true);
    }
  }

  Future<void> _clearUuid() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear UUID'),
        content: const Text('Are you sure you want to clear the saved UUID? You will need to enter it again to sync with the server.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final success = await _authService.clearUuid();
      if (success) {
        _uuidController.clear();
        setState(() {
          _hasUuid = false;
          _userName = null;
        });
        _showMessage('UUID cleared');
      } else {
        _showMessage('Failed to clear UUID', isError: true);
      }
    }
  }

  Future<void> _syncAllData() async {
    if (!_hasUuid) {
      _showMessage('Please enter your UUID before syncing', isError: true);
      return;
    }

    setState(() {
      _isSyncing = true;
      _syncProgress = 'Starting sync...';
    });

    try {
      await _dataService.syncAllData(
        onProgress: (message, currentPage, totalPages) {
          if (mounted) {
            setState(() {
              _syncProgress = totalPages > 0 
                  ? '$message ($currentPage/$totalPages)' 
                  : message;
            });
          }
        },
      );
      
      await _loadData(); // Refresh data
      
      if (mounted) {
        _showMessage('All data synced successfully');
      }
    } catch (e) {
      if (mounted) {
        _showMessage('Error syncing data: $e', isError: true);
      }
    } finally {
      setState(() {
        _isSyncing = false;
        _syncProgress = '';
      });
    }
  }

  Future<void> _clearAllData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Offline Data'),
        content: const Text(
          'Are you sure you want to clear all offline cached data? '
          'This action cannot be undone.',
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
          _showMessage('Offline data cleared successfully');
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        
        if (mounted) {
          _showMessage('Error clearing data: $e', isError: true);
        }
      }
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
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
        '• Check if your UUID is correct',
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
            Text(title),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message),
            const SizedBox(height: 16),
            ...actions.map((action) => Padding(
              padding: const EdgeInsets.only(bottom: 4),
              child: Text(action),
            )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
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

  Widget _buildUuidSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  _hasUuid ? Icons.verified_user : Icons.lock_outline,
                  color: _hasUuid ? Colors.green : Colors.orange,
                ),
                const SizedBox(width: 8),
                const Text(
                  'API Authentication',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              _hasUuid 
                  ? 'UUID is configured. API requests will be authenticated.'
                  : 'Enter your UUID to authenticate API requests.',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _uuidController,
              decoration: InputDecoration(
                labelText: 'UUID',
                border: const OutlineInputBorder(),
                hintText: 'Enter your UUID here',
                suffixIcon: _isValidatingUuid
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: Padding(
                          padding: EdgeInsets.all(12.0),
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                      )
                    : _hasUuid
                        ? const Icon(Icons.check_circle, color: Colors.green)
                        : null,
              ),
              maxLines: 1,
              enabled: !_isValidatingUuid,
            ),
            if (_userName != null) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.person, color: Colors.green),
                    const SizedBox(width: 8),
                    Text(
                      'Hello $_userName',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isValidatingUuid ? null : _validateAndSaveUuid,
                    child: _isValidatingUuid
                        ? const Text('Validating...')
                        : const Text('Save UUID'),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton(
                    onPressed: _hasUuid && !_isValidatingUuid ? _clearUuid : null,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                    ),
                    child: const Text('Clear'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
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
      onTap: _connectionStatus != ConnectionStatus.connected 
          ? _showConnectionHelp 
          : null,
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
                Chip(
                  label: Text('$count cached'),
                  backgroundColor: count > 0 
                      ? Colors.green.withValues(alpha: 0.1) 
                      : Colors.grey.withValues(alpha: 0.1),
                ),
              ],
            ),
            const SizedBox(height: 8),
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
                  // UUID Authentication Section (NEW)
                  _buildUuidSection(),
                  
                  const SizedBox(height: 16),
                  
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
                          onPressed: _isOnline && !_isSyncing && _hasUuid 
                              ? _syncAllData 
                              : null,
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
                            '• Enter your UUID to authenticate with the server\n'
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