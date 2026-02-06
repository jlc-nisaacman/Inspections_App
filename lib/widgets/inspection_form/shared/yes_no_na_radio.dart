// lib/widgets/inspection_form/shared/yes_no_na_radio.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/states/checklist_state.dart';

class YesNoNaRadio extends ConsumerWidget {
  final String question;
  final String questionKey;
  final StateNotifierProvider<dynamic, ChecklistState> provider;
  final bool required;

  const YesNoNaRadio({
    super.key,
    required this.question,
    required this.questionKey,
    required this.provider,
    this.required = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(provider);
    final notifier = ref.read(provider.notifier);
    final answer = state.getAnswer(questionKey);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question + (required ? ' *' : ''),
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: RadioListTile<ChecklistAnswer>(
                  title: const Text('Yes'),
                  value: ChecklistAnswer.yes,
                  groupValue: answer,
                  onChanged: (value) {
                    if (value != null) {
                      notifier.setAnswer(questionKey, value);
                    }
                  },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Expanded(
                child: RadioListTile<ChecklistAnswer>(
                  title: const Text('No'),
                  value: ChecklistAnswer.no,
                  groupValue: answer,
                  onChanged: (value) {
                    if (value != null) {
                      notifier.setAnswer(questionKey, value);
                    }
                  },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
              Expanded(
                child: RadioListTile<ChecklistAnswer>(
                  title: const Text('N/A'),
                  value: ChecklistAnswer.na,
                  groupValue: answer,
                  onChanged: (value) {
                    if (value != null) {
                      notifier.setAnswer(questionKey, value);
                    }
                  },
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
