// lib/providers/states/notes_state.dart

class NotesState {
  final String adjustments;
  final String explanation;
  final String explanationContinued;
  final String notes;

  NotesState({
    required this.adjustments,
    required this.explanation,
    required this.explanationContinued,
    required this.notes,
  });

  factory NotesState.initial() {
    return NotesState(
      adjustments: '',
      explanation: '',
      explanationContinued: '',
      notes: '',
    );
  }

  NotesState copyWith({
    String? adjustments,
    String? explanation,
    String? explanationContinued,
    String? notes,
  }) {
    return NotesState(
      adjustments: adjustments ?? this.adjustments,
      explanation: explanation ?? this.explanation,
      explanationContinued: explanationContinued ?? this.explanationContinued,
      notes: notes ?? this.notes,
    );
  }

  bool get isComplete {
    // Notes are optional, so always complete
    return true;
  }
}
