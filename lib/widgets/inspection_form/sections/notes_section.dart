// lib/widgets/inspection_form/sections/notes_section.dart

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../providers/notes_provider.dart';
import '../shared/section_card.dart';

class NotesSection extends ConsumerWidget {
  const NotesSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notes = ref.watch(notesProvider);
    final notifier = ref.read(notesProvider.notifier);

    return SectionCard(
      title: 'Additional Notes',
      icon: Icons.note,
      children: [
        TextFormField(
          initialValue: notes.adjustments,
          decoration: const InputDecoration(
            labelText: 'Adjustments or Corrections Made',
            border: OutlineInputBorder(),
            hintText: 'Describe any adjustments or corrections...',
          ),
          maxLines: 3,
          onChanged: notifier.updateAdjustments,
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: notes.explanation,
          decoration: const InputDecoration(
            labelText: 'Explanation of Any "No" Answers',
            border: OutlineInputBorder(),
            hintText: 'Explain any "No" answers from the checklist...',
          ),
          maxLines: 3,
          onChanged: notifier.updateExplanation,
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: notes.explanationContinued,
          decoration: const InputDecoration(
            labelText: 'Explanation (Continued)',
            border: OutlineInputBorder(),
            hintText: 'Continue explanation if needed...',
          ),
          maxLines: 3,
          onChanged: notifier.updateExplanationContinued,
        ),
        const SizedBox(height: 16),
        TextFormField(
          initialValue: notes.notes,
          decoration: const InputDecoration(
            labelText: 'General Notes',
            border: OutlineInputBorder(),
            hintText: 'Any additional notes or observations...',
          ),
          maxLines: 5,
          onChanged: notifier.updateNotes,
        ),
      ],
    );
  }
}
