// lib/providers/notes_provider.dart

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'states/notes_state.dart';

class NotesNotifier extends StateNotifier<NotesState> {
  NotesNotifier() : super(NotesState.initial());

  void updateAdjustments(String value) {
    state = state.copyWith(adjustments: value);
  }

  void updateExplanation(String value) {
    state = state.copyWith(explanation: value);
  }

  void updateExplanationContinued(String value) {
    state = state.copyWith(explanationContinued: value);
  }

  void updateNotes(String value) {
    state = state.copyWith(notes: value);
  }

  void reset() {
    state = NotesState.initial();
  }
}

final notesProvider = StateNotifierProvider<NotesNotifier, NotesState>((ref) {
  return NotesNotifier();
});
