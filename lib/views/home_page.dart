import 'package:flutter/material.dart';
import 'inspections_table_page.dart';
import 'dry_systems_table_page.dart';
import 'pump_system_table_page.dart';
import 'backflow_table_page.dart';
import 'offline_settings_page.dart';
import 'system_config_page.dart';
import '../services/data_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final DataService _dataService = DataService();
  ConnectionStatus _connectionStatus = ConnectionStatus.noNetwork;
  bool _hasOfflineData = false;
  bool _isLoading = true;

  // Backward compatibility getter
  bool get _isOnline => _connectionStatus == ConnectionStatus.connected;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final status = await _dataService.getDetailedConnectionStatus();
    final hasOfflineData = await _dataService.hasOfflineData();
    
    setState(() {
      _connectionStatus = status;
      _hasOfflineData = hasOfflineData;
      _isLoading = false;
    });
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
              _checkStatus();
            },
            icon: const Icon(Icons.refresh, size: 18),
            label: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  // List of quick action cards
  late final List<QuickActionItem> _quickActions = [
    QuickActionItem(
      title: 'New Annual Inspection',
      icon: Icons.add_circle,
      description: 'Create a new annual inspection form',
      onTap: (BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const SystemConfigPage(),
          ),
        );
      },
    ),
    QuickActionItem(
      title: 'Annual Inspections',
      icon: Icons.assignment,
      description: 'View all fire protection system inspections',
      onTap: (BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const InspectionTableScreen(),
          ),
        );
      },
    ),
    QuickActionItem(
      title: 'Dry Systems',
      icon: Icons.compress,
      description: 'View dry system inspections',
      onTap: (BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const DrySystemsTablePage(),
          ),
        );
      },
    ),
    QuickActionItem(
      title: 'Pump Systems',
      icon: Icons.plumbing,
      description: 'Review fire pump system inspections',
      onTap: (BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const PumpSystemsTablePage(),
          ),
        );
      },
    ),
    QuickActionItem(
      title: 'Backflow',
      icon: Icons.compare_arrows,
      description: 'Check backflow test details',
      onTap: (BuildContext context) {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => const BackflowTablePage(),
          ),
        );
      },
    ),
  ];

  Widget _buildConnectionStatus() {
    if (_isLoading) {
      return const SizedBox.shrink();
    }

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
        statusSubtitle = _hasOfflineData ? 'Using cached data' : 'No cached data available';
        break;
      case ConnectionStatus.serverUnreachable:
        statusColor = Colors.orange;
        statusIcon = Icons.cloud_off;
        statusTitle = 'Server Unreachable';
        statusSubtitle = _hasOfflineData ? 'Using cached data' : 'No cached data available';
        break;
    }

    return GestureDetector(
      onTap: _connectionStatus != ConnectionStatus.connected ? _showConnectionHelp : null,
      child: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: statusColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: statusColor, width: 1),
        ),
        child: Row(
          children: [
            Icon(statusIcon, color: statusColor),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    statusTitle,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                  Text(
                    statusSubtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            if (_connectionStatus != ConnectionStatus.connected)
              Icon(Icons.help_outline, size: 20, color: statusColor),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'JLC Inspection',
          style: TextStyle(fontWeight: FontWeight.w600),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OfflineSettingsPage(),
                ),
              ).then((_) => _checkStatus());
            },
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
          ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
          
          return RefreshIndicator(
            onRefresh: _checkStatus,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  _buildConnectionStatus(),
                  
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Quick Actions',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 12),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 1.3,
                          ),
                          itemCount: _quickActions.length,
                          itemBuilder: (context, index) {
                            final action = _quickActions[index];
                            return _QuickActionCard(
                              action: action,
                              isEnabled: _isOnline || _hasOfflineData,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  
                  if (!_isOnline && !_hasOfflineData)
                    Container(
                      margin: const EdgeInsets.all(12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.orange.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange),
                      ),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.cloud_off,
                            size: 40,
                            color: Colors.orange,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'No Offline Data',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.orange,
                            ),
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Connect to the internet to sync data for offline use.',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton.icon(
                            onPressed: _checkStatus,
                            icon: const Icon(Icons.refresh),
                            label: const Text('Check Connection'),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final QuickActionItem action;
  final bool isEnabled;

  const _QuickActionCard({
    required this.action,
    required this.isEnabled,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: isEnabled ? 4 : 1,
      child: InkWell(
        onTap: isEnabled ? () => action.onTap(context) : null,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                action.icon,
                size: 36,
                color: isEnabled 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey,
              ),
              const SizedBox(height: 8),
              Flexible(
                child: Text(
                  action.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: isEnabled ? null : Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  action.description,
                  style: TextStyle(
                    fontSize: 10,
                    color: isEnabled ? Colors.grey[600] : Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              if (!isEnabled) ...[
                const SizedBox(height: 4),
                Icon(
                  Icons.cloud_off,
                  size: 14,
                  color: Colors.grey,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class QuickActionItem {
  final String title;
  final IconData icon;
  final String description;
  final Function(BuildContext) onTap;

  QuickActionItem({
    required this.title,
    required this.icon,
    required this.description,
    required this.onTap,
  });
}