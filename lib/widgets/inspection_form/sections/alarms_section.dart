// lib/widgets/inspection_form/sections/alarms_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/checklist_providers.dart';
import '../shared/section_card.dart';
import '../shared/yes_no_na_radio.dart';

class AlarmsSection extends ConsumerWidget {
  const AlarmsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      title: '11. Alarms',
      icon: Icons.alarm,
      children: [
        YesNoNaRadio(
          question: 'Does water motor gong work?',
          questionKey: 'does_water_motor_gong_work',
          provider: alarmsProvider,
        ),
        YesNoNaRadio(
          question: 'Does electric bell work?',
          questionKey: 'does_electric_bell_work',
          provider: alarmsProvider,
        ),
        YesNoNaRadio(
          question: 'Are water flow alarms operational?',
          questionKey: 'are_water_flow_alarms_operational',
          provider: alarmsProvider,
        ),
        YesNoNaRadio(
          question: 'Are all tamper switches operational?',
          questionKey: 'are_tamper_switches_operational',
          provider: alarmsProvider,
        ),
        YesNoNaRadio(
          question: 'Did alarm panel clear after test?',
          questionKey: 'did_alarm_panel_clear',
          provider: alarmsProvider,
        ),
      ],
    );
  }
}
