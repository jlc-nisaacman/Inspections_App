import 'package:flutter/material.dart';
import 'inspections_table_page.dart';
import 'dry_systems_table_page.dart';
import 'pump_system_table_page.dart';
import 'backflow_table_page.dart';
import 'offline_settings_page.dart';
import '../services/data_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  final DataService _dataService = DataService();
  bool _isOnline = false;
  bool _hasOfflineData = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final isOnline = await _dataService.isOnline();
    final hasOfflineData = await _dataService.hasOfflineData();
    
    setState(() {
      _isOnline = isOnline;
      _hasOfflineData = hasOfflineData;
      _isLoading = false;
    });
  }

  // List of quick action cards
  late final List<QuickActionItem> _quickActions = [
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

    return Container(
      margin: const EdgeInsets.all(12), // Reduced margin
      padding: const EdgeInsets.all(10), // Reduced padding
      decoration: BoxDecoration(
        color: _isOnline ? Colors.green.withValues(alpha: 0.1) : Colors.orange.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _isOnline ? Colors.green : Colors.orange,
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Icon(
            _isOnline ? Icons.cloud_done : Icons.cloud_off,
            color: _isOnline ? Colors.green : Colors.orange,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isOnline ? 'Online Mode' : 'Offline Mode',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: _isOnline ? Colors.green : Colors.orange,
                  ),
                ),
                Text(
                  _isOnline 
                    ? 'Connected to server'
                    : _hasOfflineData 
                      ? 'Using cached data'
                      : 'No cached data available',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const OfflineSettingsPage(),
                ),
              ).then((_) => _checkStatus()); // Refresh status when returning
            },
            icon: const Icon(Icons.settings),
            tooltip: 'Offline Settings',
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
            // Determine the number of columns based on screen width
            int crossAxisCount = constraints.maxWidth > 600 ? 3 : 2;
            
            return RefreshIndicator(
              onRefresh: _checkStatus,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    // Connection status
                    _buildConnectionStatus(),
                    
                    // Quick actions grid
                    Padding(
                      padding: const EdgeInsets.all(12), // Reduced padding
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Quick Actions',
                            style: TextStyle(
                              fontSize: 22, // Slightly reduced
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 12), // Reduced spacing
                          GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: crossAxisCount,
                              crossAxisSpacing: 12, // Reduced spacing
                              mainAxisSpacing: 12,  // Reduced spacing
                              childAspectRatio: 1.3, // Adjusted ratio for better fit
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
                    
                    // Offline notice if needed
                    if (!_isOnline && !_hasOfflineData)
                      Container(
                        margin: const EdgeInsets.all(12), // Reduced margin
                        padding: const EdgeInsets.all(12), // Reduced padding
                        decoration: BoxDecoration(
                          color: Colors.orange.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: Column(
                          children: [
                            const Icon(
                              Icons.cloud_off,
                              size: 40, // Reduced icon size
                              color: Colors.orange,
                            ),
                            const SizedBox(height: 8), // Reduced spacing
                            const Text(
                              'No Offline Data',
                              style: TextStyle(
                                fontSize: 16, // Reduced font size
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 6), // Reduced spacing
                            const Text(
                              'Connect to the internet to sync data for offline use.',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: Colors.grey),
                            ),
                            const SizedBox(height: 8), // Reduced spacing
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
          padding: const EdgeInsets.all(12), // Reduced padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Important: minimize size
            children: [
              Icon(
                action.icon,
                size: 36, // Reduced icon size
                color: isEnabled 
                  ? Theme.of(context).primaryColor 
                  : Colors.grey,
              ),
              const SizedBox(height: 8), // Reduced spacing
              Flexible( // Allow text to flex
                child: Text(
                  action.title,
                  style: TextStyle(
                    fontSize: 14, // Reduced font size
                    fontWeight: FontWeight.w600,
                    color: isEnabled ? null : Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2, // Allow wrapping
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(height: 4),
              Flexible( // Allow description to flex
                child: Text(
                  action.description,
                  style: TextStyle(
                    fontSize: 10, // Reduced font size
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
                  size: 14, // Reduced icon size
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