// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_feed_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$liveFeedDifficultyHash() =>
    r'2ebcecc306327a1a1e2ce8fc8b37d5823f832bed';

/// Current Difficulty Level Provider (1-10)
///
/// Copied from [LiveFeedDifficulty].
@ProviderFor(LiveFeedDifficulty)
final liveFeedDifficultyProvider =
    AutoDisposeNotifierProvider<LiveFeedDifficulty, double>.internal(
  LiveFeedDifficulty.new,
  name: r'liveFeedDifficultyProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$liveFeedDifficultyHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LiveFeedDifficulty = AutoDisposeNotifier<double>;
String _$questionBufferHash() => r'2c321da4ed3a1b5639eb8996883bfcbdc7bd65a1';

/// Question Buffer Provider (caching system)
///
/// Copied from [QuestionBuffer].
@ProviderFor(QuestionBuffer)
final questionBufferProvider =
    AutoDisposeNotifierProvider<QuestionBuffer, List<Question>>.internal(
  QuestionBuffer.new,
  name: r'questionBufferProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$questionBufferHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$QuestionBuffer = AutoDisposeNotifier<List<Question>>;
String _$currentLiveFeedQuestionHash() =>
    r'3383e0f30ba7747f5cf1c3aa30f5410b2f4a3b6b';

/// Current Live Feed Question Provider
///
/// Copied from [CurrentLiveFeedQuestion].
@ProviderFor(CurrentLiveFeedQuestion)
final currentLiveFeedQuestionProvider =
    AutoDisposeNotifierProvider<CurrentLiveFeedQuestion, Question?>.internal(
  CurrentLiveFeedQuestion.new,
  name: r'currentLiveFeedQuestionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentLiveFeedQuestionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentLiveFeedQuestion = AutoDisposeNotifier<Question?>;
String _$liveFeedAnswerHash() => r'c3d6081a3ad71ea2f88b24040c521b2fa1dec528';

/// Live Feed Answer Provider
///
/// Copied from [LiveFeedAnswer].
@ProviderFor(LiveFeedAnswer)
final liveFeedAnswerProvider =
    AutoDisposeNotifierProvider<LiveFeedAnswer, String>.internal(
  LiveFeedAnswer.new,
  name: r'liveFeedAnswerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$liveFeedAnswerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LiveFeedAnswer = AutoDisposeNotifier<String>;
String _$consecutiveCorrectHash() =>
    r'2d0b2ce3d9e26b28e58406f61f773af525dd31e8';

/// Consecutive Correct Answers Counter
///
/// Copied from [ConsecutiveCorrect].
@ProviderFor(ConsecutiveCorrect)
final consecutiveCorrectProvider =
    AutoDisposeNotifierProvider<ConsecutiveCorrect, int>.internal(
  ConsecutiveCorrect.new,
  name: r'consecutiveCorrectProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$consecutiveCorrectHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConsecutiveCorrect = AutoDisposeNotifier<int>;
String _$consecutiveWrongHash() => r'75328f71fca559e6d2fecc946c0e05228383e142';

/// Consecutive Wrong Answers Counter
///
/// Copied from [ConsecutiveWrong].
@ProviderFor(ConsecutiveWrong)
final consecutiveWrongProvider =
    AutoDisposeNotifierProvider<ConsecutiveWrong, int>.internal(
  ConsecutiveWrong.new,
  name: r'consecutiveWrongProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$consecutiveWrongHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ConsecutiveWrong = AutoDisposeNotifier<int>;
String _$liveFeedQuestionsAnsweredHash() =>
    r'c067e797a6633003ba58161b0e08993993af58c5';

/// Total Questions Answered in Live Feed
///
/// Copied from [LiveFeedQuestionsAnswered].
@ProviderFor(LiveFeedQuestionsAnswered)
final liveFeedQuestionsAnsweredProvider =
    AutoDisposeNotifierProvider<LiveFeedQuestionsAnswered, int>.internal(
  LiveFeedQuestionsAnswered.new,
  name: r'liveFeedQuestionsAnsweredProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$liveFeedQuestionsAnsweredHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LiveFeedQuestionsAnswered = AutoDisposeNotifier<int>;
String _$liveFeedCorrectAnswersHash() =>
    r'81cc346b5f01c573ab89185f80eb6368c8cf258f';

/// Total Correct Answers in Live Feed
///
/// Copied from [LiveFeedCorrectAnswers].
@ProviderFor(LiveFeedCorrectAnswers)
final liveFeedCorrectAnswersProvider =
    AutoDisposeNotifierProvider<LiveFeedCorrectAnswers, int>.internal(
  LiveFeedCorrectAnswers.new,
  name: r'liveFeedCorrectAnswersProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$liveFeedCorrectAnswersHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LiveFeedCorrectAnswers = AutoDisposeNotifier<int>;
String _$liveFeedHintsUsedHash() => r'5f224a2e5363c5aad7fd1ffb0b353c9506b22375';

/// Live Feed Hint Count
///
/// Copied from [LiveFeedHintsUsed].
@ProviderFor(LiveFeedHintsUsed)
final liveFeedHintsUsedProvider =
    AutoDisposeNotifierProvider<LiveFeedHintsUsed, int>.internal(
  LiveFeedHintsUsed.new,
  name: r'liveFeedHintsUsedProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$liveFeedHintsUsedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LiveFeedHintsUsed = AutoDisposeNotifier<int>;
String _$isEvaluatingHash() => r'20712f83936d5be51497623ec378d9a8f75db431';

/// Is Evaluating Answer
///
/// Copied from [IsEvaluating].
@ProviderFor(IsEvaluating)
final isEvaluatingProvider =
    AutoDisposeNotifierProvider<IsEvaluating, bool>.internal(
  IsEvaluating.new,
  name: r'isEvaluatingProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$isEvaluatingHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$IsEvaluating = AutoDisposeNotifier<bool>;
String _$liveFeedShowFeedbackHash() =>
    r'ea024c562e6260741d89191625499e86f5fdd1b2';

/// Show Feedback
///
/// Copied from [LiveFeedShowFeedback].
@ProviderFor(LiveFeedShowFeedback)
final liveFeedShowFeedbackProvider =
    AutoDisposeNotifierProvider<LiveFeedShowFeedback, bool>.internal(
  LiveFeedShowFeedback.new,
  name: r'liveFeedShowFeedbackProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$liveFeedShowFeedbackHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LiveFeedShowFeedback = AutoDisposeNotifier<bool>;
String _$lastEvaluationResultHash() =>
    r'cd0b366ae46f1aa522002a756a9d4086187f6007';

/// Last Evaluation Result
///
/// Copied from [LastEvaluationResult].
@ProviderFor(LastEvaluationResult)
final lastEvaluationResultProvider = AutoDisposeNotifierProvider<
    LastEvaluationResult, Map<String, dynamic>?>.internal(
  LastEvaluationResult.new,
  name: r'lastEvaluationResultProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$lastEvaluationResultHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LastEvaluationResult = AutoDisposeNotifier<Map<String, dynamic>?>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
