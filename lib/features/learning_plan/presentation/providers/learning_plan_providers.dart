import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'learning_plan_providers.g.dart';

/// Selected Topics Provider - Set of selected topic names
@riverpod
class SelectedTopics extends _$SelectedTopics {
  @override
  Set<String> build() {
    return {};
  }

  void toggle(String topic) {
    if (state.contains(topic)) {
      state = {...state}..remove(topic);
    } else {
      state = {...state, topic};
    }
  }

  void clear() {
    state = {};
  }
}

/// Smart Learning Mode Provider
@riverpod
class SmartLearningMode extends _$SmartLearningMode {
  @override
  bool build() {
    return false;
  }

  void set(bool value) {
    state = value;
  }
}

/// Is Generating Questions Provider
@riverpod
class IsGeneratingQuestions extends _$IsGeneratingQuestions {
  @override
  bool build() {
    return false;
  }

  void set(bool value) {
    state = value;
  }
}
