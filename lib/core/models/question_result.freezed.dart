// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

QuestionResult _$QuestionResultFromJson(Map<String, dynamic> json) {
  return _QuestionResult.fromJson(json);
}

/// @nodoc
mixin _$QuestionResult {
  String get questionId => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  String get questionText => throw _privateConstructorUsedError;
  String get correctAnswer => throw _privateConstructorUsedError;
  String get userAnswer => throw _privateConstructorUsedError;
  bool get isCorrect => throw _privateConstructorUsedError;
  int get difficulty => throw _privateConstructorUsedError;
  int get hintsUsed => throw _privateConstructorUsedError;
  int get timeSpentSeconds => throw _privateConstructorUsedError;
  String get leitidee => throw _privateConstructorUsedError;
  String get thema => throw _privateConstructorUsedError;
  String get unterthema => throw _privateConstructorUsedError;
  String get gradeLevel => throw _privateConstructorUsedError;
  String get courseType => throw _privateConstructorUsedError;
  @JsonKey(name: 'timestamp')
  int get timestamp =>
      throw _privateConstructorUsedError; // Use int for Firestore Timestamp
  int get xpEarned => throw _privateConstructorUsedError;
  int get coinsEarned => throw _privateConstructorUsedError;
  String? get feedback => throw _privateConstructorUsedError;

  /// Serializes this QuestionResult to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionResultCopyWith<QuestionResult> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionResultCopyWith<$Res> {
  factory $QuestionResultCopyWith(
          QuestionResult value, $Res Function(QuestionResult) then) =
      _$QuestionResultCopyWithImpl<$Res, QuestionResult>;
  @useResult
  $Res call(
      {String questionId,
      String userId,
      String sessionId,
      String questionText,
      String correctAnswer,
      String userAnswer,
      bool isCorrect,
      int difficulty,
      int hintsUsed,
      int timeSpentSeconds,
      String leitidee,
      String thema,
      String unterthema,
      String gradeLevel,
      String courseType,
      @JsonKey(name: 'timestamp') int timestamp,
      int xpEarned,
      int coinsEarned,
      String? feedback});
}

/// @nodoc
class _$QuestionResultCopyWithImpl<$Res, $Val extends QuestionResult>
    implements $QuestionResultCopyWith<$Res> {
  _$QuestionResultCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? userId = null,
    Object? sessionId = null,
    Object? questionText = null,
    Object? correctAnswer = null,
    Object? userAnswer = null,
    Object? isCorrect = null,
    Object? difficulty = null,
    Object? hintsUsed = null,
    Object? timeSpentSeconds = null,
    Object? leitidee = null,
    Object? thema = null,
    Object? unterthema = null,
    Object? gradeLevel = null,
    Object? courseType = null,
    Object? timestamp = null,
    Object? xpEarned = null,
    Object? coinsEarned = null,
    Object? feedback = freezed,
  }) {
    return _then(_value.copyWith(
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      questionText: null == questionText
          ? _value.questionText
          : questionText // ignore: cast_nullable_to_non_nullable
              as String,
      correctAnswer: null == correctAnswer
          ? _value.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      userAnswer: null == userAnswer
          ? _value.userAnswer
          : userAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
      hintsUsed: null == hintsUsed
          ? _value.hintsUsed
          : hintsUsed // ignore: cast_nullable_to_non_nullable
              as int,
      timeSpentSeconds: null == timeSpentSeconds
          ? _value.timeSpentSeconds
          : timeSpentSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      leitidee: null == leitidee
          ? _value.leitidee
          : leitidee // ignore: cast_nullable_to_non_nullable
              as String,
      thema: null == thema
          ? _value.thema
          : thema // ignore: cast_nullable_to_non_nullable
              as String,
      unterthema: null == unterthema
          ? _value.unterthema
          : unterthema // ignore: cast_nullable_to_non_nullable
              as String,
      gradeLevel: null == gradeLevel
          ? _value.gradeLevel
          : gradeLevel // ignore: cast_nullable_to_non_nullable
              as String,
      courseType: null == courseType
          ? _value.courseType
          : courseType // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      xpEarned: null == xpEarned
          ? _value.xpEarned
          : xpEarned // ignore: cast_nullable_to_non_nullable
              as int,
      coinsEarned: null == coinsEarned
          ? _value.coinsEarned
          : coinsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      feedback: freezed == feedback
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionResultImplCopyWith<$Res>
    implements $QuestionResultCopyWith<$Res> {
  factory _$$QuestionResultImplCopyWith(_$QuestionResultImpl value,
          $Res Function(_$QuestionResultImpl) then) =
      __$$QuestionResultImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String questionId,
      String userId,
      String sessionId,
      String questionText,
      String correctAnswer,
      String userAnswer,
      bool isCorrect,
      int difficulty,
      int hintsUsed,
      int timeSpentSeconds,
      String leitidee,
      String thema,
      String unterthema,
      String gradeLevel,
      String courseType,
      @JsonKey(name: 'timestamp') int timestamp,
      int xpEarned,
      int coinsEarned,
      String? feedback});
}

/// @nodoc
class __$$QuestionResultImplCopyWithImpl<$Res>
    extends _$QuestionResultCopyWithImpl<$Res, _$QuestionResultImpl>
    implements _$$QuestionResultImplCopyWith<$Res> {
  __$$QuestionResultImplCopyWithImpl(
      _$QuestionResultImpl _value, $Res Function(_$QuestionResultImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuestionResult
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? userId = null,
    Object? sessionId = null,
    Object? questionText = null,
    Object? correctAnswer = null,
    Object? userAnswer = null,
    Object? isCorrect = null,
    Object? difficulty = null,
    Object? hintsUsed = null,
    Object? timeSpentSeconds = null,
    Object? leitidee = null,
    Object? thema = null,
    Object? unterthema = null,
    Object? gradeLevel = null,
    Object? courseType = null,
    Object? timestamp = null,
    Object? xpEarned = null,
    Object? coinsEarned = null,
    Object? feedback = freezed,
  }) {
    return _then(_$QuestionResultImpl(
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      questionText: null == questionText
          ? _value.questionText
          : questionText // ignore: cast_nullable_to_non_nullable
              as String,
      correctAnswer: null == correctAnswer
          ? _value.correctAnswer
          : correctAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      userAnswer: null == userAnswer
          ? _value.userAnswer
          : userAnswer // ignore: cast_nullable_to_non_nullable
              as String,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
      hintsUsed: null == hintsUsed
          ? _value.hintsUsed
          : hintsUsed // ignore: cast_nullable_to_non_nullable
              as int,
      timeSpentSeconds: null == timeSpentSeconds
          ? _value.timeSpentSeconds
          : timeSpentSeconds // ignore: cast_nullable_to_non_nullable
              as int,
      leitidee: null == leitidee
          ? _value.leitidee
          : leitidee // ignore: cast_nullable_to_non_nullable
              as String,
      thema: null == thema
          ? _value.thema
          : thema // ignore: cast_nullable_to_non_nullable
              as String,
      unterthema: null == unterthema
          ? _value.unterthema
          : unterthema // ignore: cast_nullable_to_non_nullable
              as String,
      gradeLevel: null == gradeLevel
          ? _value.gradeLevel
          : gradeLevel // ignore: cast_nullable_to_non_nullable
              as String,
      courseType: null == courseType
          ? _value.courseType
          : courseType // ignore: cast_nullable_to_non_nullable
              as String,
      timestamp: null == timestamp
          ? _value.timestamp
          : timestamp // ignore: cast_nullable_to_non_nullable
              as int,
      xpEarned: null == xpEarned
          ? _value.xpEarned
          : xpEarned // ignore: cast_nullable_to_non_nullable
              as int,
      coinsEarned: null == coinsEarned
          ? _value.coinsEarned
          : coinsEarned // ignore: cast_nullable_to_non_nullable
              as int,
      feedback: freezed == feedback
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionResultImpl
    with DiagnosticableTreeMixin
    implements _QuestionResult {
  const _$QuestionResultImpl(
      {required this.questionId,
      required this.userId,
      required this.sessionId,
      required this.questionText,
      required this.correctAnswer,
      required this.userAnswer,
      required this.isCorrect,
      required this.difficulty,
      required this.hintsUsed,
      required this.timeSpentSeconds,
      required this.leitidee,
      required this.thema,
      required this.unterthema,
      required this.gradeLevel,
      required this.courseType,
      @JsonKey(name: 'timestamp') this.timestamp = 0,
      this.xpEarned = 0,
      this.coinsEarned = 0,
      this.feedback});

  factory _$QuestionResultImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionResultImplFromJson(json);

  @override
  final String questionId;
  @override
  final String userId;
  @override
  final String sessionId;
  @override
  final String questionText;
  @override
  final String correctAnswer;
  @override
  final String userAnswer;
  @override
  final bool isCorrect;
  @override
  final int difficulty;
  @override
  final int hintsUsed;
  @override
  final int timeSpentSeconds;
  @override
  final String leitidee;
  @override
  final String thema;
  @override
  final String unterthema;
  @override
  final String gradeLevel;
  @override
  final String courseType;
  @override
  @JsonKey(name: 'timestamp')
  final int timestamp;
// Use int for Firestore Timestamp
  @override
  @JsonKey()
  final int xpEarned;
  @override
  @JsonKey()
  final int coinsEarned;
  @override
  final String? feedback;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'QuestionResult(questionId: $questionId, userId: $userId, sessionId: $sessionId, questionText: $questionText, correctAnswer: $correctAnswer, userAnswer: $userAnswer, isCorrect: $isCorrect, difficulty: $difficulty, hintsUsed: $hintsUsed, timeSpentSeconds: $timeSpentSeconds, leitidee: $leitidee, thema: $thema, unterthema: $unterthema, gradeLevel: $gradeLevel, courseType: $courseType, timestamp: $timestamp, xpEarned: $xpEarned, coinsEarned: $coinsEarned, feedback: $feedback)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'QuestionResult'))
      ..add(DiagnosticsProperty('questionId', questionId))
      ..add(DiagnosticsProperty('userId', userId))
      ..add(DiagnosticsProperty('sessionId', sessionId))
      ..add(DiagnosticsProperty('questionText', questionText))
      ..add(DiagnosticsProperty('correctAnswer', correctAnswer))
      ..add(DiagnosticsProperty('userAnswer', userAnswer))
      ..add(DiagnosticsProperty('isCorrect', isCorrect))
      ..add(DiagnosticsProperty('difficulty', difficulty))
      ..add(DiagnosticsProperty('hintsUsed', hintsUsed))
      ..add(DiagnosticsProperty('timeSpentSeconds', timeSpentSeconds))
      ..add(DiagnosticsProperty('leitidee', leitidee))
      ..add(DiagnosticsProperty('thema', thema))
      ..add(DiagnosticsProperty('unterthema', unterthema))
      ..add(DiagnosticsProperty('gradeLevel', gradeLevel))
      ..add(DiagnosticsProperty('courseType', courseType))
      ..add(DiagnosticsProperty('timestamp', timestamp))
      ..add(DiagnosticsProperty('xpEarned', xpEarned))
      ..add(DiagnosticsProperty('coinsEarned', coinsEarned))
      ..add(DiagnosticsProperty('feedback', feedback));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionResultImpl &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.questionText, questionText) ||
                other.questionText == questionText) &&
            (identical(other.correctAnswer, correctAnswer) ||
                other.correctAnswer == correctAnswer) &&
            (identical(other.userAnswer, userAnswer) ||
                other.userAnswer == userAnswer) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.hintsUsed, hintsUsed) ||
                other.hintsUsed == hintsUsed) &&
            (identical(other.timeSpentSeconds, timeSpentSeconds) ||
                other.timeSpentSeconds == timeSpentSeconds) &&
            (identical(other.leitidee, leitidee) ||
                other.leitidee == leitidee) &&
            (identical(other.thema, thema) || other.thema == thema) &&
            (identical(other.unterthema, unterthema) ||
                other.unterthema == unterthema) &&
            (identical(other.gradeLevel, gradeLevel) ||
                other.gradeLevel == gradeLevel) &&
            (identical(other.courseType, courseType) ||
                other.courseType == courseType) &&
            (identical(other.timestamp, timestamp) ||
                other.timestamp == timestamp) &&
            (identical(other.xpEarned, xpEarned) ||
                other.xpEarned == xpEarned) &&
            (identical(other.coinsEarned, coinsEarned) ||
                other.coinsEarned == coinsEarned) &&
            (identical(other.feedback, feedback) ||
                other.feedback == feedback));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        questionId,
        userId,
        sessionId,
        questionText,
        correctAnswer,
        userAnswer,
        isCorrect,
        difficulty,
        hintsUsed,
        timeSpentSeconds,
        leitidee,
        thema,
        unterthema,
        gradeLevel,
        courseType,
        timestamp,
        xpEarned,
        coinsEarned,
        feedback
      ]);

  /// Create a copy of QuestionResult
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionResultImplCopyWith<_$QuestionResultImpl> get copyWith =>
      __$$QuestionResultImplCopyWithImpl<_$QuestionResultImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionResultImplToJson(
      this,
    );
  }
}

abstract class _QuestionResult implements QuestionResult {
  const factory _QuestionResult(
      {required final String questionId,
      required final String userId,
      required final String sessionId,
      required final String questionText,
      required final String correctAnswer,
      required final String userAnswer,
      required final bool isCorrect,
      required final int difficulty,
      required final int hintsUsed,
      required final int timeSpentSeconds,
      required final String leitidee,
      required final String thema,
      required final String unterthema,
      required final String gradeLevel,
      required final String courseType,
      @JsonKey(name: 'timestamp') final int timestamp,
      final int xpEarned,
      final int coinsEarned,
      final String? feedback}) = _$QuestionResultImpl;

  factory _QuestionResult.fromJson(Map<String, dynamic> json) =
      _$QuestionResultImpl.fromJson;

  @override
  String get questionId;
  @override
  String get userId;
  @override
  String get sessionId;
  @override
  String get questionText;
  @override
  String get correctAnswer;
  @override
  String get userAnswer;
  @override
  bool get isCorrect;
  @override
  int get difficulty;
  @override
  int get hintsUsed;
  @override
  int get timeSpentSeconds;
  @override
  String get leitidee;
  @override
  String get thema;
  @override
  String get unterthema;
  @override
  String get gradeLevel;
  @override
  String get courseType;
  @override
  @JsonKey(name: 'timestamp')
  int get timestamp; // Use int for Firestore Timestamp
  @override
  int get xpEarned;
  @override
  int get coinsEarned;
  @override
  String? get feedback;

  /// Create a copy of QuestionResult
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionResultImplCopyWith<_$QuestionResultImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
