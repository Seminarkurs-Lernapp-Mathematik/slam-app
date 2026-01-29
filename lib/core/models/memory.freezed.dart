// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'memory.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Memory _$MemoryFromJson(Map<String, dynamic> json) {
  return _Memory.fromJson(json);
}

/// @nodoc
mixin _$Memory {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get questionId => throw _privateConstructorUsedError;
  String get questionText => throw _privateConstructorUsedError;
  String get topic => throw _privateConstructorUsedError;
  String get subtopic => throw _privateConstructorUsedError;
  String get leitidee => throw _privateConstructorUsedError;
  int get difficulty => throw _privateConstructorUsedError;
  int get afbLevel =>
      throw _privateConstructorUsedError; // SM-2 Algorithm variables
  double get easeFactor => throw _privateConstructorUsedError;
  int get interval =>
      throw _privateConstructorUsedError; // Days until next review
  int get repetitions =>
      throw _privateConstructorUsedError; // Number of successful reviews
// Review tracking
  DateTime get lastReviewedAt => throw _privateConstructorUsedError;
  DateTime get nextReviewAt => throw _privateConstructorUsedError; // Statistics
  int get reviewCount => throw _privateConstructorUsedError;
  double get averageQuality => throw _privateConstructorUsedError;
  int? get lastQuality => throw _privateConstructorUsedError; // Review history
  List<ReviewRecord> get reviewHistory =>
      throw _privateConstructorUsedError; // Metadata
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isArchived => throw _privateConstructorUsedError;

  /// Serializes this Memory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Memory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $MemoryCopyWith<Memory> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MemoryCopyWith<$Res> {
  factory $MemoryCopyWith(Memory value, $Res Function(Memory) then) =
      _$MemoryCopyWithImpl<$Res, Memory>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String questionId,
      String questionText,
      String topic,
      String subtopic,
      String leitidee,
      int difficulty,
      int afbLevel,
      double easeFactor,
      int interval,
      int repetitions,
      DateTime lastReviewedAt,
      DateTime nextReviewAt,
      int reviewCount,
      double averageQuality,
      int? lastQuality,
      List<ReviewRecord> reviewHistory,
      DateTime createdAt,
      DateTime updatedAt,
      bool isArchived});
}

/// @nodoc
class _$MemoryCopyWithImpl<$Res, $Val extends Memory>
    implements $MemoryCopyWith<$Res> {
  _$MemoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Memory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? questionId = null,
    Object? questionText = null,
    Object? topic = null,
    Object? subtopic = null,
    Object? leitidee = null,
    Object? difficulty = null,
    Object? afbLevel = null,
    Object? easeFactor = null,
    Object? interval = null,
    Object? repetitions = null,
    Object? lastReviewedAt = null,
    Object? nextReviewAt = null,
    Object? reviewCount = null,
    Object? averageQuality = null,
    Object? lastQuality = freezed,
    Object? reviewHistory = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isArchived = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      questionText: null == questionText
          ? _value.questionText
          : questionText // ignore: cast_nullable_to_non_nullable
              as String,
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      subtopic: null == subtopic
          ? _value.subtopic
          : subtopic // ignore: cast_nullable_to_non_nullable
              as String,
      leitidee: null == leitidee
          ? _value.leitidee
          : leitidee // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
      afbLevel: null == afbLevel
          ? _value.afbLevel
          : afbLevel // ignore: cast_nullable_to_non_nullable
              as int,
      easeFactor: null == easeFactor
          ? _value.easeFactor
          : easeFactor // ignore: cast_nullable_to_non_nullable
              as double,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      repetitions: null == repetitions
          ? _value.repetitions
          : repetitions // ignore: cast_nullable_to_non_nullable
              as int,
      lastReviewedAt: null == lastReviewedAt
          ? _value.lastReviewedAt
          : lastReviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      nextReviewAt: null == nextReviewAt
          ? _value.nextReviewAt
          : nextReviewAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      averageQuality: null == averageQuality
          ? _value.averageQuality
          : averageQuality // ignore: cast_nullable_to_non_nullable
              as double,
      lastQuality: freezed == lastQuality
          ? _value.lastQuality
          : lastQuality // ignore: cast_nullable_to_non_nullable
              as int?,
      reviewHistory: null == reviewHistory
          ? _value.reviewHistory
          : reviewHistory // ignore: cast_nullable_to_non_nullable
              as List<ReviewRecord>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$MemoryImplCopyWith<$Res> implements $MemoryCopyWith<$Res> {
  factory _$$MemoryImplCopyWith(
          _$MemoryImpl value, $Res Function(_$MemoryImpl) then) =
      __$$MemoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String questionId,
      String questionText,
      String topic,
      String subtopic,
      String leitidee,
      int difficulty,
      int afbLevel,
      double easeFactor,
      int interval,
      int repetitions,
      DateTime lastReviewedAt,
      DateTime nextReviewAt,
      int reviewCount,
      double averageQuality,
      int? lastQuality,
      List<ReviewRecord> reviewHistory,
      DateTime createdAt,
      DateTime updatedAt,
      bool isArchived});
}

/// @nodoc
class __$$MemoryImplCopyWithImpl<$Res>
    extends _$MemoryCopyWithImpl<$Res, _$MemoryImpl>
    implements _$$MemoryImplCopyWith<$Res> {
  __$$MemoryImplCopyWithImpl(
      _$MemoryImpl _value, $Res Function(_$MemoryImpl) _then)
      : super(_value, _then);

  /// Create a copy of Memory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? questionId = null,
    Object? questionText = null,
    Object? topic = null,
    Object? subtopic = null,
    Object? leitidee = null,
    Object? difficulty = null,
    Object? afbLevel = null,
    Object? easeFactor = null,
    Object? interval = null,
    Object? repetitions = null,
    Object? lastReviewedAt = null,
    Object? nextReviewAt = null,
    Object? reviewCount = null,
    Object? averageQuality = null,
    Object? lastQuality = freezed,
    Object? reviewHistory = null,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isArchived = null,
  }) {
    return _then(_$MemoryImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      questionText: null == questionText
          ? _value.questionText
          : questionText // ignore: cast_nullable_to_non_nullable
              as String,
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      subtopic: null == subtopic
          ? _value.subtopic
          : subtopic // ignore: cast_nullable_to_non_nullable
              as String,
      leitidee: null == leitidee
          ? _value.leitidee
          : leitidee // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
      afbLevel: null == afbLevel
          ? _value.afbLevel
          : afbLevel // ignore: cast_nullable_to_non_nullable
              as int,
      easeFactor: null == easeFactor
          ? _value.easeFactor
          : easeFactor // ignore: cast_nullable_to_non_nullable
              as double,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      repetitions: null == repetitions
          ? _value.repetitions
          : repetitions // ignore: cast_nullable_to_non_nullable
              as int,
      lastReviewedAt: null == lastReviewedAt
          ? _value.lastReviewedAt
          : lastReviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      nextReviewAt: null == nextReviewAt
          ? _value.nextReviewAt
          : nextReviewAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      reviewCount: null == reviewCount
          ? _value.reviewCount
          : reviewCount // ignore: cast_nullable_to_non_nullable
              as int,
      averageQuality: null == averageQuality
          ? _value.averageQuality
          : averageQuality // ignore: cast_nullable_to_non_nullable
              as double,
      lastQuality: freezed == lastQuality
          ? _value.lastQuality
          : lastQuality // ignore: cast_nullable_to_non_nullable
              as int?,
      reviewHistory: null == reviewHistory
          ? _value._reviewHistory
          : reviewHistory // ignore: cast_nullable_to_non_nullable
              as List<ReviewRecord>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isArchived: null == isArchived
          ? _value.isArchived
          : isArchived // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$MemoryImpl implements _Memory {
  const _$MemoryImpl(
      {required this.id,
      required this.userId,
      required this.questionId,
      required this.questionText,
      required this.topic,
      required this.subtopic,
      required this.leitidee,
      this.difficulty = 3,
      this.afbLevel = 1,
      this.easeFactor = 2.5,
      this.interval = 0,
      this.repetitions = 0,
      required this.lastReviewedAt,
      required this.nextReviewAt,
      this.reviewCount = 0,
      this.averageQuality = 0.0,
      this.lastQuality,
      final List<ReviewRecord> reviewHistory = const [],
      required this.createdAt,
      required this.updatedAt,
      this.isArchived = false})
      : _reviewHistory = reviewHistory;

  factory _$MemoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$MemoryImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String questionId;
  @override
  final String questionText;
  @override
  final String topic;
  @override
  final String subtopic;
  @override
  final String leitidee;
  @override
  @JsonKey()
  final int difficulty;
  @override
  @JsonKey()
  final int afbLevel;
// SM-2 Algorithm variables
  @override
  @JsonKey()
  final double easeFactor;
  @override
  @JsonKey()
  final int interval;
// Days until next review
  @override
  @JsonKey()
  final int repetitions;
// Number of successful reviews
// Review tracking
  @override
  final DateTime lastReviewedAt;
  @override
  final DateTime nextReviewAt;
// Statistics
  @override
  @JsonKey()
  final int reviewCount;
  @override
  @JsonKey()
  final double averageQuality;
  @override
  final int? lastQuality;
// Review history
  final List<ReviewRecord> _reviewHistory;
// Review history
  @override
  @JsonKey()
  List<ReviewRecord> get reviewHistory {
    if (_reviewHistory is EqualUnmodifiableListView) return _reviewHistory;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_reviewHistory);
  }

// Metadata
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final bool isArchived;

  @override
  String toString() {
    return 'Memory(id: $id, userId: $userId, questionId: $questionId, questionText: $questionText, topic: $topic, subtopic: $subtopic, leitidee: $leitidee, difficulty: $difficulty, afbLevel: $afbLevel, easeFactor: $easeFactor, interval: $interval, repetitions: $repetitions, lastReviewedAt: $lastReviewedAt, nextReviewAt: $nextReviewAt, reviewCount: $reviewCount, averageQuality: $averageQuality, lastQuality: $lastQuality, reviewHistory: $reviewHistory, createdAt: $createdAt, updatedAt: $updatedAt, isArchived: $isArchived)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$MemoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.questionText, questionText) ||
                other.questionText == questionText) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.subtopic, subtopic) ||
                other.subtopic == subtopic) &&
            (identical(other.leitidee, leitidee) ||
                other.leitidee == leitidee) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.afbLevel, afbLevel) ||
                other.afbLevel == afbLevel) &&
            (identical(other.easeFactor, easeFactor) ||
                other.easeFactor == easeFactor) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.repetitions, repetitions) ||
                other.repetitions == repetitions) &&
            (identical(other.lastReviewedAt, lastReviewedAt) ||
                other.lastReviewedAt == lastReviewedAt) &&
            (identical(other.nextReviewAt, nextReviewAt) ||
                other.nextReviewAt == nextReviewAt) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            (identical(other.averageQuality, averageQuality) ||
                other.averageQuality == averageQuality) &&
            (identical(other.lastQuality, lastQuality) ||
                other.lastQuality == lastQuality) &&
            const DeepCollectionEquality()
                .equals(other._reviewHistory, _reviewHistory) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isArchived, isArchived) ||
                other.isArchived == isArchived));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
        runtimeType,
        id,
        userId,
        questionId,
        questionText,
        topic,
        subtopic,
        leitidee,
        difficulty,
        afbLevel,
        easeFactor,
        interval,
        repetitions,
        lastReviewedAt,
        nextReviewAt,
        reviewCount,
        averageQuality,
        lastQuality,
        const DeepCollectionEquality().hash(_reviewHistory),
        createdAt,
        updatedAt,
        isArchived
      ]);

  /// Create a copy of Memory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$MemoryImplCopyWith<_$MemoryImpl> get copyWith =>
      __$$MemoryImplCopyWithImpl<_$MemoryImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$MemoryImplToJson(
      this,
    );
  }
}

abstract class _Memory implements Memory {
  const factory _Memory(
      {required final String id,
      required final String userId,
      required final String questionId,
      required final String questionText,
      required final String topic,
      required final String subtopic,
      required final String leitidee,
      final int difficulty,
      final int afbLevel,
      final double easeFactor,
      final int interval,
      final int repetitions,
      required final DateTime lastReviewedAt,
      required final DateTime nextReviewAt,
      final int reviewCount,
      final double averageQuality,
      final int? lastQuality,
      final List<ReviewRecord> reviewHistory,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final bool isArchived}) = _$MemoryImpl;

  factory _Memory.fromJson(Map<String, dynamic> json) = _$MemoryImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get questionId;
  @override
  String get questionText;
  @override
  String get topic;
  @override
  String get subtopic;
  @override
  String get leitidee;
  @override
  int get difficulty;
  @override
  int get afbLevel; // SM-2 Algorithm variables
  @override
  double get easeFactor;
  @override
  int get interval; // Days until next review
  @override
  int get repetitions; // Number of successful reviews
// Review tracking
  @override
  DateTime get lastReviewedAt;
  @override
  DateTime get nextReviewAt; // Statistics
  @override
  int get reviewCount;
  @override
  double get averageQuality;
  @override
  int? get lastQuality; // Review history
  @override
  List<ReviewRecord> get reviewHistory; // Metadata
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  bool get isArchived;

  /// Create a copy of Memory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$MemoryImplCopyWith<_$MemoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ReviewRecord _$ReviewRecordFromJson(Map<String, dynamic> json) {
  return _ReviewRecord.fromJson(json);
}

/// @nodoc
mixin _$ReviewRecord {
  DateTime get reviewedAt => throw _privateConstructorUsedError;
  int get quality => throw _privateConstructorUsedError; // 0-5 (SM-2)
  double get easeFactor => throw _privateConstructorUsedError;
  int get interval => throw _privateConstructorUsedError;
  DateTime get nextReviewAt => throw _privateConstructorUsedError;
  int get repetitions => throw _privateConstructorUsedError;

  /// Serializes this ReviewRecord to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReviewRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReviewRecordCopyWith<ReviewRecord> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReviewRecordCopyWith<$Res> {
  factory $ReviewRecordCopyWith(
          ReviewRecord value, $Res Function(ReviewRecord) then) =
      _$ReviewRecordCopyWithImpl<$Res, ReviewRecord>;
  @useResult
  $Res call(
      {DateTime reviewedAt,
      int quality,
      double easeFactor,
      int interval,
      DateTime nextReviewAt,
      int repetitions});
}

/// @nodoc
class _$ReviewRecordCopyWithImpl<$Res, $Val extends ReviewRecord>
    implements $ReviewRecordCopyWith<$Res> {
  _$ReviewRecordCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReviewRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reviewedAt = null,
    Object? quality = null,
    Object? easeFactor = null,
    Object? interval = null,
    Object? nextReviewAt = null,
    Object? repetitions = null,
  }) {
    return _then(_value.copyWith(
      reviewedAt: null == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as int,
      easeFactor: null == easeFactor
          ? _value.easeFactor
          : easeFactor // ignore: cast_nullable_to_non_nullable
              as double,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      nextReviewAt: null == nextReviewAt
          ? _value.nextReviewAt
          : nextReviewAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      repetitions: null == repetitions
          ? _value.repetitions
          : repetitions // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ReviewRecordImplCopyWith<$Res>
    implements $ReviewRecordCopyWith<$Res> {
  factory _$$ReviewRecordImplCopyWith(
          _$ReviewRecordImpl value, $Res Function(_$ReviewRecordImpl) then) =
      __$$ReviewRecordImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {DateTime reviewedAt,
      int quality,
      double easeFactor,
      int interval,
      DateTime nextReviewAt,
      int repetitions});
}

/// @nodoc
class __$$ReviewRecordImplCopyWithImpl<$Res>
    extends _$ReviewRecordCopyWithImpl<$Res, _$ReviewRecordImpl>
    implements _$$ReviewRecordImplCopyWith<$Res> {
  __$$ReviewRecordImplCopyWithImpl(
      _$ReviewRecordImpl _value, $Res Function(_$ReviewRecordImpl) _then)
      : super(_value, _then);

  /// Create a copy of ReviewRecord
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? reviewedAt = null,
    Object? quality = null,
    Object? easeFactor = null,
    Object? interval = null,
    Object? nextReviewAt = null,
    Object? repetitions = null,
  }) {
    return _then(_$ReviewRecordImpl(
      reviewedAt: null == reviewedAt
          ? _value.reviewedAt
          : reviewedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      quality: null == quality
          ? _value.quality
          : quality // ignore: cast_nullable_to_non_nullable
              as int,
      easeFactor: null == easeFactor
          ? _value.easeFactor
          : easeFactor // ignore: cast_nullable_to_non_nullable
              as double,
      interval: null == interval
          ? _value.interval
          : interval // ignore: cast_nullable_to_non_nullable
              as int,
      nextReviewAt: null == nextReviewAt
          ? _value.nextReviewAt
          : nextReviewAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      repetitions: null == repetitions
          ? _value.repetitions
          : repetitions // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ReviewRecordImpl implements _ReviewRecord {
  const _$ReviewRecordImpl(
      {required this.reviewedAt,
      required this.quality,
      required this.easeFactor,
      required this.interval,
      required this.nextReviewAt,
      required this.repetitions});

  factory _$ReviewRecordImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReviewRecordImplFromJson(json);

  @override
  final DateTime reviewedAt;
  @override
  final int quality;
// 0-5 (SM-2)
  @override
  final double easeFactor;
  @override
  final int interval;
  @override
  final DateTime nextReviewAt;
  @override
  final int repetitions;

  @override
  String toString() {
    return 'ReviewRecord(reviewedAt: $reviewedAt, quality: $quality, easeFactor: $easeFactor, interval: $interval, nextReviewAt: $nextReviewAt, repetitions: $repetitions)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReviewRecordImpl &&
            (identical(other.reviewedAt, reviewedAt) ||
                other.reviewedAt == reviewedAt) &&
            (identical(other.quality, quality) || other.quality == quality) &&
            (identical(other.easeFactor, easeFactor) ||
                other.easeFactor == easeFactor) &&
            (identical(other.interval, interval) ||
                other.interval == interval) &&
            (identical(other.nextReviewAt, nextReviewAt) ||
                other.nextReviewAt == nextReviewAt) &&
            (identical(other.repetitions, repetitions) ||
                other.repetitions == repetitions));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, reviewedAt, quality, easeFactor,
      interval, nextReviewAt, repetitions);

  /// Create a copy of ReviewRecord
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReviewRecordImplCopyWith<_$ReviewRecordImpl> get copyWith =>
      __$$ReviewRecordImplCopyWithImpl<_$ReviewRecordImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ReviewRecordImplToJson(
      this,
    );
  }
}

abstract class _ReviewRecord implements ReviewRecord {
  const factory _ReviewRecord(
      {required final DateTime reviewedAt,
      required final int quality,
      required final double easeFactor,
      required final int interval,
      required final DateTime nextReviewAt,
      required final int repetitions}) = _$ReviewRecordImpl;

  factory _ReviewRecord.fromJson(Map<String, dynamic> json) =
      _$ReviewRecordImpl.fromJson;

  @override
  DateTime get reviewedAt;
  @override
  int get quality; // 0-5 (SM-2)
  @override
  double get easeFactor;
  @override
  int get interval;
  @override
  DateTime get nextReviewAt;
  @override
  int get repetitions;

  /// Create a copy of ReviewRecord
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReviewRecordImplCopyWith<_$ReviewRecordImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
