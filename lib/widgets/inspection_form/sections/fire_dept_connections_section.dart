// lib/widgets/inspection_form/sections/fire_dept_connections_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/checklist_providers.dart';
import '../shared/section_card.dart';
import '../shared/yes_no_na_radio.dart';

class FireDeptConnectionsSection extends ConsumerWidget {
  const FireDeptConnectionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      title: '4. Fire Dept. Connections',
      icon: Icons.fire_truck,
      children: [
        YesNoNaRadio(
          question: 'Are fire dept. connections in satisfactory condition?',
          questionKey: 'are_fd_connections_satisfactory',
          provider: fireDeptConnectionsProvider,
        ),
        YesNoNaRadio(
          question: 'Are caps in place?',
          questionKey: 'are_caps_in_place',
          provider: fireDeptConnectionsProvider,
        ),
        YesNoNaRadio(
          question: 'Is fire dept. connection easily accessible?',
          questionKey: 'is_fd_connection_accessible',
          provider: fireDeptConnectionsProvider,
        ),
        YesNoNaRadio(
          question: 'Automatic drain valve in place?',
          questionKey: 'automatic_drain_valve_in_place',
          provider: fireDeptConnectionsProvider,
        ),
      ],
    );
  }
}
