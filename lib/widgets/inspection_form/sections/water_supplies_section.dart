// lib/widgets/inspection_form/sections/water_supplies_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/checklist_providers.dart';
import '../shared/section_card.dart';
import '../shared/yes_no_na_radio.dart';

class WaterSuppliesSection extends ConsumerWidget {
  const WaterSuppliesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SectionCard(
      title: '2. Water Supplies',
      icon: Icons.water_drop,
      children: [
        YesNoNaRadio(
          question: 'Was a main drain water flow test conducted?',
          questionKey: 'was_main_drain_test_conducted',
          provider: waterSuppliesProvider,
          required: true,
        ),
      ],
    );
  }
}
