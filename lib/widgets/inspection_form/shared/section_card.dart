// lib/widgets/inspection_form/shared/section_card.dart

import 'package:flutter/material.dart';

class SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;
  final bool isDisabled;

  const SectionCard({
    super.key,
    required this.title,
    required this.icon,
    required this.children,
    this.isDisabled = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isDisabled) {
      return Card(
        color: Colors.grey[100],
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(Icons.block, color: Colors.grey[400]),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.grey[600],
                            decoration: TextDecoration.lineThrough,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Not applicable (auto-filled with N/A)',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            if (children.isNotEmpty) ...[
              const SizedBox(height: 16),
              ...children,
            ],
          ],
        ),
      ),
    );
  }
}
