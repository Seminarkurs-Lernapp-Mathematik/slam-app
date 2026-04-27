// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'live_feed_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$liveFeedDifficultyHash() =>
    r'e129ddfea9c0b9d72797fbfdd6e7cb0af095254d';

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
    r'7d5f78493d841605bfeb1a446611cac0ac9c1a80';

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
String _$consecutiveWrongHash() => r'403a9bbc965a7f769fd06f10ecffaffaba0c8c72';

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
String _$liveFeedQuestionGeneratorHash() =>
    r'ba3464f9425e96b4124d808af9dfaf036dcf7da1';

/// Live Feed Question Generator
///
/// Copied from [LiveFeedQuestionGenerator].
@ProviderFor(LiveFeedQuestionGenerator)
final liveFeedQuestionGeneratorProvider =
    AutoDisposeNotifierProvider<LiveFeedQuestionGenerator, bool>.internal(
  LiveFeedQuestionGenerator.new,
  name: r'liveFeedQuestionGeneratorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$liveFeedQuestionGeneratorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LiveFeedQuestionGenerator = AutoDisposeNotifier<bool>;
String _$liveFeedQueueHash() => r'0ffbd0b8f9c34ee02066401d9e1d0ff58b76710c';

/// Live Feed Queue Provider with Caching
///
/// Copied from [LiveFeedQueue].
@ProviderFor(LiveFeedQueue)
final liveFeedQueueProvider =
    AutoDisposeNotifierProvider<LiveFeedQueue, LiveFeedQueueState>.internal(
  LiveFeedQueue.new,
  name: r'liveFeedQueueProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$liveFeedQueueHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LiveFeedQueue = AutoDisposeNotifier<LiveFeedQueueState>;
String _$selectedOptionHash() => r'bae61e502fa7f1ed1a0cbffd2c7e33f40f967c59';

/// Selected Option Provider (tracks which MCQ option was selected)
///
/// Copied from [SelectedOption].
@ProviderFor(SelectedOption)
final selectedOptionProvider =
    AutoDisposeNotifierProvider<SelectedOption, String?>.internal(
  SelectedOption.new,
  name: r'selectedOptionProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$selectedOptionHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SelectedOption = AutoDisposeNotifier<String?>;
String _$woHaengtsInputHash() => r'f53a82c7939dfefdaf4842f35554fd15906d06b5';

/// "Wo haengts?" text input provider
///
/// Copied from [WoHaengtsInput].
@ProviderFor(WoHaengtsInput)
final woHaengtsInputProvider =
    AutoDisposeNotifierProvider<WoHaengtsInput, String>.internal(
  WoHaengtsInput.new,
  name: r'woHaengtsInputProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$woHaengtsInputHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WoHaengtsInput = AutoDisposeNotifier<String>;
String _$showWoHaengtsHash() => r'8fb47338484fa4e64705f970096e6920e1b6e3c7';

/// Whether "Wo haengts?" section should be shown
///
/// Copied from [ShowWoHaengts].
@ProviderFor(ShowWoHaengts)
final showWoHaengtsProvider =
    AutoDisposeNotifierProvider<ShowWoHaengts, bool>.internal(
  ShowWoHaengts.new,
  name: r'showWoHaengtsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$showWoHaengtsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ShowWoHaengts = AutoDisposeNotifier<bool>;
String _$liveFeedEvaluatorHash() => r'8989e2e83c6a294382ab81c2fc4006f9b2307b9a';

/// Live Feed Evaluator Provider
/// This provider listens for new evaluation results and saves them to Firestore.
///
/// Copied from [LiveFeedEvaluator].
@ProviderFor(LiveFeedEvaluator)
final liveFeedEvaluatorProvider =
    AutoDisposeNotifierProvider<LiveFeedEvaluator, void>.internal(
  LiveFeedEvaluator.new,
  name: r'liveFeedEvaluatorProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$liveFeedEvaluatorHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LiveFeedEvaluator = AutoDisposeNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
