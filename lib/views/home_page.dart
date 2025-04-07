import 'package:flutter/material.dart';
import 'inspections_table_page.dart';
import 'dry_systems_table_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  // List of quick action cards
  final List<QuickActionItem> _quickActions = [
    QuickActionItem(
      title: 'All Inspections',
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
            settings: const RouteSettings(arguments: 1), // Navigate to Dry Systems tab
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
            builder: (context) => const InspectionTableScreen(),
            settings: const RouteSettings(arguments: 2), // Navigate to Pump Systems tab
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
            builder: (context) => const InspectionTableScreen(),
            settings: const RouteSettings(arguments: 3), // Navigate to Backflow tab
          ),
        );
      },
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: LayoutBuilder(
          builder: (context, constraints) {
            // Determine the number of columns based on screen width
            int crossAxisCount = constraints.maxWidth > 600 ? 2 : 1;
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Welcome Banner
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Theme.of(context).colorScheme.primaryContainer,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to the\nJohn L. Carter Inspection Manager',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onPrimaryContainer,
                            ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),

                // Quick Actions Grid
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        crossAxisSpacing: 16,
                        mainAxisSpacing: 16,
                        childAspectRatio: crossAxisCount == 2 ? 1.2 : 2, // Adjust aspect ratio based on columns
                      ),
                      itemCount: _quickActions.length,
                      itemBuilder: (context, index) {
                        return _QuickActionCard(action: _quickActions[index]);
                      },
                    ),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// Quick Action Item Model
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

// Quick Action Card Widget
class _QuickActionCard extends StatelessWidget {
  final QuickActionItem action;

  const _QuickActionCard({required this.action});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Adjust text sizes based on available width
        double titleFontSize = constraints.maxWidth > 200 ? 18.0 : 16.0;
        double descriptionFontSize = constraints.maxWidth > 200 ? 14.0 : 12.0;
        double iconSize = constraints.maxWidth > 200 ? 48.0 : 36.0;

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: InkWell(
            onTap: () => action.onTap(context),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    action.icon,
                    size: iconSize,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    action.title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: titleFontSize,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    action.description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontSize: descriptionFontSize,
                        ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}