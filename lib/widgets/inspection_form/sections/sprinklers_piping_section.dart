// lib/widgets/inspection_form/sections/sprinklers_piping_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/checklist_providers.dart';
import '../shared/section_card.dart';
import '../shared/yes_no_na_radio.dart';

class SprinklersPipingSection extends ConsumerStatefulWidget {
  const SprinklersPipingSection({super.key});

  @override
  ConsumerState<SprinklersPipingSection> createState() => _SprinklersPipingSectionState();
}

class _SprinklersPipingSectionState extends ConsumerState<SprinklersPipingSection> {
  final TextEditingController _dryTypeYearController = TextEditingController();
  final TextEditingController _quickResponseYearController = TextEditingController();
  final TextEditingController _standardResponseYearController = TextEditingController();
  final TextEditingController _gaugesYearController = TextEditingController();

  String? _dryTypeResult;
  String? _quickResponseResult;
  String? _standardResponseResult;
  String? _gaugesResult;

  @override
  void dispose() {
    _dryTypeYearController.dispose();
    _quickResponseYearController.dispose();
    _standardResponseYearController.dispose();
    _gaugesYearController.dispose();
    super.dispose();
  }

  void _calculateAge(TextEditingController controller, int maxAge, Function(String?) setResult) {
    final yearText = controller.text.trim();
    if (yearText.isEmpty) {
      setResult(null);
      return;
    }

    final year = int.tryParse(yearText);
    if (year == null) {
      setResult('Invalid');
      return;
    }

    final currentYear = DateTime.now().year;
    final age = currentYear - year;

    if (age < 0) {
      setResult('Invalid');
    } else if (age <= maxAge) {
      setResult('Yes');
    } else {
      setResult('No');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SectionCard(
      title: '12. Sprinklers/Piping',
      icon: Icons.plumbing,
      children: [
        YesNoNaRadio(
          question: 'Are a minimum of 6 spare sprinklers readily available?',
          questionKey: 'are_6_spare_sprinklers_available',
          provider: sprinklersPipingProvider,
        ),
        YesNoNaRadio(
          question: 'Is condition of piping and other system components satisfactory?',
          questionKey: 'is_piping_condition_satisfactory',
          provider: sprinklersPipingProvider,
        ),
        const SizedBox(height: 16),
        const Text(
          'Sprinkler Head Age Verification:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _buildYearInput(
          'Dry Type Heads Installation Year',
          _dryTypeYearController,
          10,
          _dryTypeResult,
          (result) => setState(() => _dryTypeResult = result),
        ),
        const SizedBox(height: 12),
        _buildYearInput(
          'Quick Response Heads Installation Year',
          _quickResponseYearController,
          20,
          _quickResponseResult,
          (result) => setState(() => _quickResponseResult = result),
        ),
        const SizedBox(height: 12),
        _buildYearInput(
          'Standard Response Heads Installation Year',
          _standardResponseYearController,
          50,
          _standardResponseResult,
          (result) => setState(() => _standardResponseResult = result),
        ),
        const SizedBox(height: 16),
        const Text(
          'Gauge Testing:',
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: 12),
        _buildYearInput(
          'Gauges Last Tested/Replaced Year',
          _gaugesYearController,
          5,
          _gaugesResult,
          (result) => setState(() => _gaugesResult = result),
        ),
      ],
    );
  }

  Widget _buildYearInput(
    String label,
    TextEditingController controller,
    int maxAge,
    String? result,
    Function(String?) setResult,
  ) {
    Color? resultColor;
    if (result == 'Yes') {
      resultColor = Colors.green;
    } else if (result == 'No') {
      resultColor = Colors.red;
    } else if (result == 'Invalid') {
      resultColor = Colors.orange;
    }

    return Row(
      children: [
        Expanded(
          flex: 2,
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: label,
              border: const OutlineInputBorder(),
              isDense: true,
              helperText: 'Must be ≤ $maxAge years old',
            ),
            keyboardType: TextInputType.number,
            onChanged: (_) => _calculateAge(controller, maxAge, setResult),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          width: 80,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: resultColor?.withOpacity(0.1) ?? Colors.grey[100],
            border: Border.all(color: resultColor ?? Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              result ?? 'N/A',
              style: TextStyle(
                color: resultColor ?? Colors.grey[600],
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
