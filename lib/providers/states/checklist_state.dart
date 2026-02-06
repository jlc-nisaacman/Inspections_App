// lib/providers/states/checklist_state.dart

enum ChecklistAnswer { yes, no, na, unanswered }

class ChecklistState {
  final Map<String, ChecklistAnswer> answers;

  ChecklistState({required this.answers});

  factory ChecklistState.initial(List<String> questionKeys) {
    return ChecklistState(
      answers: {for (var key in questionKeys) key: ChecklistAnswer.unanswered},
    );
  }

  ChecklistState copyWith({Map<String, ChecklistAnswer>? answers}) {
    return ChecklistState(
      answers: answers ?? Map.from(this.answers),
    );
  }

  ChecklistState setAnswer(String key, ChecklistAnswer answer) {
    final newAnswers = Map<String, ChecklistAnswer>.from(answers);
    newAnswers[key] = answer;
    return ChecklistState(answers: newAnswers);
  }

  ChecklistState autoFillNA() {
    final newAnswers = <String, ChecklistAnswer>{};
    for (var key in answers.keys) {
      newAnswers[key] = ChecklistAnswer.na;
    }
    return ChecklistState(answers: newAnswers);
  }

  ChecklistAnswer getAnswer(String key) {
    return answers[key] ?? ChecklistAnswer.unanswered;
  }

  String getAnswerString(String key) {
    final answer = getAnswer(key);
    switch (answer) {
      case ChecklistAnswer.yes:
        return 'Yes';
      case ChecklistAnswer.no:
        return 'No';
      case ChecklistAnswer.na:
        return 'N/A';
      case ChecklistAnswer.unanswered:
        return '';
    }
  }

  bool get isComplete {
    return !answers.values.contains(ChecklistAnswer.unanswered);
  }

  bool get hasNoAnswers {
    return answers.values.contains(ChecklistAnswer.no);
  }

  List<String> getNoAnswerKeys() {
    return answers.entries
        .where((entry) => entry.value == ChecklistAnswer.no)
        .map((entry) => entry.key)
        .toList();
  }
}
