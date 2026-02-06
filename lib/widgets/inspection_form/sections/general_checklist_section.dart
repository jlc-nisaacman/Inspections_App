// lib/widgets/inspection_form/sections/general_checklist_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/checklist_providers.dart';
import '../shared/section_card.dart';
import '../shared/yes_no_na_radio.dart';

class GeneralChecklistSection extends ConsumerWidget {
  const GeneralChecklistSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      title: '1. General',
      icon: Icons.checklist,
      children: [
        YesNoNaRadio(
          question: 'Is the building occupied?',
          questionKey: 'is_building_occupied',
          provider: generalChecklistProvider,
          required: true,
        ),
        YesNoNaRadio(
          question: 'Are all systems in service?',
          questionKey: 'are_all_systems_in_service',
          provider: generalChecklistProvider,
          required: true,
        ),
        YesNoNaRadio(
          question: 'Are FP systems same as last inspection?',
          questionKey: 'are_fp_systems_same',
          provider: generalChecklistProvider,
          required: true,
        ),
        YesNoNaRadio(
          question: 'Is hydraulic nameplate securely attached and legible?',
          questionKey: 'hydraulic_nameplate_secure',
          provider: generalChecklistProvider,
          required: true,
        ),
      ],
    );
  }
}
