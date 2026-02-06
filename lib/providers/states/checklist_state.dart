// lib/providers/states/checklist_state.dart

enum ChecklistAnswer { yes, no, na, unanswered }

class ChecklistState {
  final Map<String, ChecklistAnswer> answers;
  final Map<String, String> values; // For numeric/text inputs (PSI, temperature, years, etc.)

  ChecklistState({
    required this.answers,
    Map<String, String>? values,
  }) : values = values ?? {};

  factory ChecklistState.initial(List<String> questionKeys, {List<String>? valueKeys}) {
    return ChecklistState(
      answers: {for (var key in questionKeys) key: ChecklistAnswer.unanswered},
      values: {for (var key in (valueKeys ?? [])) key: ''},
    );
  }

  ChecklistState copyWith({
    Map<String, ChecklistAnswer>? answers,
    Map<String, String>? values,
  }) {
    return ChecklistState(
      answers: answers ?? Map.from(this.answers),
      values: values ?? Map.from(this.values),
    );
  }

  ChecklistState setAnswer(String key, ChecklistAnswer answer) {
    final newAnswers = Map<String, ChecklistAnswer>.from(answers);
    newAnswers[key] = answer;
    return ChecklistState(
      answers: newAnswers,
      values: values,
    );
  }

  ChecklistState setValue(String key, String value) {
    final newValues = Map<String, String>.from(values);
    newValues[key] = value;
    return ChecklistState(
      answers: answers,
      values: newValues,
    );
  }

  ChecklistState autoFillNA() {
    final newAnswers = <String, ChecklistAnswer>{};
    for (var key in answers.keys) {
      newAnswers[key] = ChecklistAnswer.na;
    }
    // Keep values unchanged when auto-filling N/A
    return ChecklistState(
      answers: newAnswers,
      values: values,
    );
  }

  ChecklistAnswer getAnswer(String key) {
    return answers[key] ?? ChecklistAnswer.unanswered;
  }

  String getValue(String key) {
    return values[key] ?? '';
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
