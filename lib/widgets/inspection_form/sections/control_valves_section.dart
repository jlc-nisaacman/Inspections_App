// lib/widgets/inspection_form/sections/control_valves_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/checklist_providers.dart';
import '../shared/section_card.dart';
import '../shared/yes_no_na_radio.dart';

class ControlValvesSection extends ConsumerWidget {
  const ControlValvesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      title: '3. Control Valves',
      icon: Icons.settings,
      children: [
        YesNoNaRadio(
          question: 'Are all sprinkler system main control valves open?',
          questionKey: 'are_main_control_valves_open',
          provider: controlValvesProvider,
        ),
        YesNoNaRadio(
          question: 'Are all other valves in proper position?',
          questionKey: 'are_other_valves_proper',
          provider: controlValvesProvider,
        ),
        YesNoNaRadio(
          question: 'Are all control valves sealed or supervised?',
          questionKey: 'are_control_valves_sealed',
          provider: controlValvesProvider,
        ),
        YesNoNaRadio(
          question: 'Are all control valves in good condition and free of leaks?',
          questionKey: 'are_control_valves_good_condition',
          provider: controlValvesProvider,
        ),
      ],
    );
  }
}
