// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'question_session_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$demoQuestionsHash() => r'4135a6fd52ac2195633ab4c034789091348a0260';

/// Demo Questions Provider - Sample questions with LaTeX
///
/// Copied from [demoQuestions].
@ProviderFor(demoQuestions)
final demoQuestionsProvider =
    AutoDisposeProvider<List<Map<String, dynamic>>>.internal(
  demoQuestions,
  name: r'demoQuestionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$demoQuestionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DemoQuestionsRef = AutoDisposeProviderRef<List<Map<String, dynamic>>>;
String _$currentQuestionIndexHash() =>
    r'446da66f94d4279f27b6a54569deb0f54742adee';

/// Current Question Index Provider
///
/// Copied from [CurrentQuestionIndex].
@ProviderFor(CurrentQuestionIndex)
final currentQuestionIndexProvider =
    AutoDisposeNotifierProvider<CurrentQuestionIndex, int>.internal(
  CurrentQuestionIndex.new,
  name: r'currentQuestionIndexProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentQuestionIndexHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentQuestionIndex = AutoDisposeNotifier<int>;
String _$currentAnswerHash() => r'c04185fe6e3cfbece02f369ad384a0f604b3ece6';

/// Current Answer Provider
///
/// Copied from [CurrentAnswer].
@ProviderFor(CurrentAnswer)
final currentAnswerProvider =
    AutoDisposeNotifierProvider<CurrentAnswer, String>.internal(
  CurrentAnswer.new,
  name: r'currentAnswerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$currentAnswerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CurrentAnswer = AutoDisposeNotifier<String>;
String _$hintsUsedHash() => r'141bf2266b3e49b6f1dbdfcf359cfc14e6297b10';

/// Hints Used Provider
///
/// Copied from [HintsUsed].
@ProviderFor(HintsUsed)
final hintsUsedProvider = AutoDisposeNotifierProvider<HintsUsed, int>.internal(
  HintsUsed.new,
  name: r'hintsUsedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$hintsUsedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HintsUsed = AutoDisposeNotifier<int>;
String _$showFeedbackHash() => r'3c4e6eb4688cc67c51c61d8a81533407028902d4';

/// Show Feedback Provider
///
/// Copied from [ShowFeedback].
@ProviderFor(ShowFeedback)
final showFeedbackProvider =
    AutoDisposeNotifierProvider<ShowFeedback, bool>.internal(
  ShowFeedback.new,
  name: r'showFeedbackProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$showFeedbackHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$ShowFeedback = AutoDisposeNotifier<bool>;
String _$lastXPEarnedHash() => r'fe2da3b1393fbd36b7191ae3ea016622aadb30da';

/// Last XP Earned Provider
///
/// Copied from [LastXPEarned].
@ProviderFor(LastXPEarned)
final lastXPEarnedProvider =
    AutoDisposeNotifierProvider<LastXPEarned, int>.internal(
  LastXPEarned.new,
  name: r'lastXPEarnedProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$lastXPEarnedHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$LastXPEarned = AutoDisposeNotifier<int>;
String _$skippedQuestionsHash() => r'202f07b6a91b75abca4f56f6a5aa73b992872e4a';

/// Skipped Questions Provider
///
/// Copied from [SkippedQuestions].
@ProviderFor(SkippedQuestions)
final skippedQuestionsProvider =
    AutoDisposeNotifierProvider<SkippedQuestions, Set<int>>.internal(
  SkippedQuestions.new,
  name: r'skippedQuestionsProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$skippedQuestionsHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SkippedQuestions = AutoDisposeNotifier<Set<int>>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
