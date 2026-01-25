import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../core/models/question.dart';

part 'live_feed_providers.g.dart';

/// Current Difficulty Level Provider (1-10)
@riverpod
class LiveFeedDifficulty extends _$LiveFeedDifficulty {
  @override
  double build() {
    return 5.0; // Start at medium difficulty
  }

  void increase() {
    state = (state + 0.5).clamp(1.0, 10.0);
  }

  void decrease() {
    state = (state - 0.5).clamp(1.0, 10.0);
  }

  void setDifficulty(double value) {
    state = value.clamp(1.0, 10.0);
  }
}

/// Question Buffer Provider (caching system)
@riverpod
class QuestionBuffer extends _$QuestionBuffer {
  static const int bufferSize = 5;

  @override
  List<Question> build() {
    return [];
  }

  void addQuestion(Question question) {
    state = [...state, question];
  }

  Question? getNext() {
    if (state.isEmpty) return null;
    final question = state.first;
    state = state.skip(1).toList();
    return question;
  }

  void clear() {
    state = [];
  }

  bool get needsRefill => state.length < bufferSize;
}

/// Current Live Feed Question Provider
@riverpod
class CurrentLiveFeedQuestion extends _$CurrentLiveFeedQuestion {
  @override
  Question? build() {
    return null;
  }

  void setQuestion(Question question) {
    state = question;
  }

  void clear() {
    state = null;
  }
}

/// Live Feed Answer Provider
@riverpod
class LiveFeedAnswer extends _$LiveFeedAnswer {
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

/// Consecutive Correct Answers Counter
@riverpod
class ConsecutiveCorrect extends _$ConsecutiveCorrect {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
    // Auto-increase difficulty after 2 correct in a row
    if (state >= 2) {
      // Trigger difficulty increase
      state = 0;
    }
  }

  void reset() {
    state = 0;
  }
}

/// Consecutive Wrong Answers Counter
@riverpod
class ConsecutiveWrong extends _$ConsecutiveWrong {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
    // Auto-decrease difficulty after 2 wrong in a row
    if (state >= 2) {
      // Trigger difficulty decrease
      state = 0;
    }
  }

  void reset() {
    state = 0;
  }
}

/// Total Questions Answered in Live Feed
@riverpod
class LiveFeedQuestionsAnswered extends _$LiveFeedQuestionsAnswered {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }

  void reset() {
    state = 0;
  }
}

/// Total Correct Answers in Live Feed
@riverpod
class LiveFeedCorrectAnswers extends _$LiveFeedCorrectAnswers {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }

  void reset() {
    state = 0;
  }
}

/// Live Feed Hint Count
@riverpod
class LiveFeedHintsUsed extends _$LiveFeedHintsUsed {
  @override
  int build() {
    return 0;
  }

  void increment() {
    state++;
  }

  void reset() {
    state = 0;
  }
}

/// Is Evaluating Answer
@riverpod
class IsEvaluating extends _$IsEvaluating {
  @override
  bool build() {
    return false;
  }

  void setEvaluating(bool value) {
    state = value;
  }
}

/// Show Feedback
@riverpod
class LiveFeedShowFeedback extends _$LiveFeedShowFeedback {
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

/// Last Evaluation Result
@riverpod
class LastEvaluationResult extends _$LastEvaluationResult {
  @override
  Map<String, dynamic>? build() {
    return null;
  }

  void setResult(Map<String, dynamic> result) {
    state = result;
  }

  void clear() {
    state = null;
  }
}
