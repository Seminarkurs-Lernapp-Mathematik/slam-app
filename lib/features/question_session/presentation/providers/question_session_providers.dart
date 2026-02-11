import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'question_session_providers.g.dart';

/// Current Question Index Provider
@riverpod
class CurrentQuestionIndex extends _$CurrentQuestionIndex {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }

  void decrement() {
    if (state > 0) state--;
  }

  void reset() {
    state = 0;
  }
}

/// Current Answer Provider
@riverpod
class CurrentAnswer extends _$CurrentAnswer {
  @override
  String build() {
    return '';
  }

  void setAnswer(String answer) {
    state = answer;
  }

  void clear() {
    state = '';
  }
}

/// Hints Used Provider
@riverpod
class HintsUsed extends _$HintsUsed {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }

  void setLevel(int level) {
    state = level;
  }

  void reset() {
    state = 0;
  }
}

/// Show Feedback Provider
@riverpod
class ShowFeedback extends _$ShowFeedback {
  @override
  bool build() {
    return false;
  }

  void show() {
    state = true;
  }

  void hide() {
    state = false;
  }
}

/// Last XP Earned Provider
@riverpod
class LastXPEarned extends _$LastXPEarned {
  @override
  int build() {
    return 0;
  }

  void setXP(int xp) {
    state = xp;
  }
}

/// Skipped Questions Provider
@riverpod
class SkippedQuestions extends _$SkippedQuestions {
  @override
  Set<int> build() {
    return {};
  }

  void addSkipped(int index) {
    state = {...state, index};
  }

  void removeSkipped(int index) {
    state = {...state}..remove(index);
  }
}

