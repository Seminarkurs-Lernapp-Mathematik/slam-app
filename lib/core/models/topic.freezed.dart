// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'topic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Topic _$TopicFromJson(Map<String, dynamic> json) {
  return _Topic.fromJson(json);
}

/// @nodoc
mixin _$Topic {
  String get id => throw _privateConstructorUsedError;
  String get topicKey =>
      throw _privateConstructorUsedError; // e.g., "Analysis|Ableitungen|Potenzregel"
  String get title => throw _privateConstructorUsedError;
  String get mainTopic => throw _privateConstructorUsedError;
  String? get subtopic => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  int get progress => throw _privateConstructorUsedError; // 0-100
  int get completed => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  bool get needsMoreQuestions => throw _privateConstructorUsedError;
  String? get lastSessionId => throw _privateConstructorUsedError;
  int get avgAccuracy => throw _privateConstructorUsedError; // 0-100
  String? get level => throw _privateConstructorUsedError;

  /// Serializes this Topic to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopicCopyWith<Topic> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicCopyWith<$Res> {
  factory $TopicCopyWith(Topic value, $Res Function(Topic) then) =
      _$TopicCopyWithImpl<$Res, Topic>;
  @useResult
  $Res call(
      {String id,
      String topicKey,
      String title,
      String mainTopic,
      String? subtopic,
      String? description,
      int progress,
      int completed,
      int total,
      bool needsMoreQuestions,
      String? lastSessionId,
      int avgAccuracy,
      String? level});
}

/// @nodoc
class _$TopicCopyWithImpl<$Res, $Val extends Topic>
    implements $TopicCopyWith<$Res> {
  _$TopicCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topicKey = null,
    Object? title = null,
    Object? mainTopic = null,
    Object? subtopic = freezed,
    Object? description = freezed,
    Object? progress = null,
    Object? completed = null,
    Object? total = null,
    Object? needsMoreQuestions = null,
    Object? lastSessionId = freezed,
    Object? avgAccuracy = null,
    Object? level = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      topicKey: null == topicKey
          ? _value.topicKey
          : topicKey // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      mainTopic: null == mainTopic
          ? _value.mainTopic
          : mainTopic // ignore: cast_nullable_to_non_nullable
              as String,
      subtopic: freezed == subtopic
          ? _value.subtopic
          : subtopic // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      needsMoreQuestions: null == needsMoreQuestions
          ? _value.needsMoreQuestions
          : needsMoreQuestions // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSessionId: freezed == lastSessionId
          ? _value.lastSessionId
          : lastSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      avgAccuracy: null == avgAccuracy
          ? _value.avgAccuracy
          : avgAccuracy // ignore: cast_nullable_to_non_nullable
              as int,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TopicImplCopyWith<$Res> implements $TopicCopyWith<$Res> {
  factory _$$TopicImplCopyWith(
          _$TopicImpl value, $Res Function(_$TopicImpl) then) =
      __$$TopicImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String topicKey,
      String title,
      String mainTopic,
      String? subtopic,
      String? description,
      int progress,
      int completed,
      int total,
      bool needsMoreQuestions,
      String? lastSessionId,
      int avgAccuracy,
      String? level});
}

/// @nodoc
class __$$TopicImplCopyWithImpl<$Res>
    extends _$TopicCopyWithImpl<$Res, _$TopicImpl>
    implements _$$TopicImplCopyWith<$Res> {
  __$$TopicImplCopyWithImpl(
      _$TopicImpl _value, $Res Function(_$TopicImpl) _then)
      : super(_value, _then);

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? topicKey = null,
    Object? title = null,
    Object? mainTopic = null,
    Object? subtopic = freezed,
    Object? description = freezed,
    Object? progress = null,
    Object? completed = null,
    Object? total = null,
    Object? needsMoreQuestions = null,
    Object? lastSessionId = freezed,
    Object? avgAccuracy = null,
    Object? level = freezed,
  }) {
    return _then(_$TopicImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      topicKey: null == topicKey
          ? _value.topicKey
          : topicKey // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      mainTopic: null == mainTopic
          ? _value.mainTopic
          : mainTopic // ignore: cast_nullable_to_non_nullable
              as String,
      subtopic: freezed == subtopic
          ? _value.subtopic
          : subtopic // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      needsMoreQuestions: null == needsMoreQuestions
          ? _value.needsMoreQuestions
          : needsMoreQuestions // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSessionId: freezed == lastSessionId
          ? _value.lastSessionId
          : lastSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      avgAccuracy: null == avgAccuracy
          ? _value.avgAccuracy
          : avgAccuracy // ignore: cast_nullable_to_non_nullable
              as int,
      level: freezed == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TopicImpl extends _Topic {
  const _$TopicImpl(
      {required this.id,
      required this.topicKey,
      required this.title,
      required this.mainTopic,
      this.subtopic,
      this.description,
      this.progress = 0,
      this.completed = 0,
      this.total = 0,
      this.needsMoreQuestions = false,
      this.lastSessionId,
      this.avgAccuracy = 0,
      this.level})
      : super._();

  factory _$TopicImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopicImplFromJson(json);

  @override
  final String id;
  @override
  final String topicKey;
// e.g., "Analysis|Ableitungen|Potenzregel"
  @override
  final String title;
  @override
  final String mainTopic;
  @override
  final String? subtopic;
  @override
  final String? description;
  @override
  @JsonKey()
  final int progress;
// 0-100
  @override
  @JsonKey()
  final int completed;
  @override
  @JsonKey()
  final int total;
  @override
  @JsonKey()
  final bool needsMoreQuestions;
  @override
  final String? lastSessionId;
  @override
  @JsonKey()
  final int avgAccuracy;
// 0-100
  @override
  final String? level;

  @override
  String toString() {
    return 'Topic(id: $id, topicKey: $topicKey, title: $title, mainTopic: $mainTopic, subtopic: $subtopic, description: $description, progress: $progress, completed: $completed, total: $total, needsMoreQuestions: $needsMoreQuestions, lastSessionId: $lastSessionId, avgAccuracy: $avgAccuracy, level: $level)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopicImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.topicKey, topicKey) ||
                other.topicKey == topicKey) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.mainTopic, mainTopic) ||
                other.mainTopic == mainTopic) &&
            (identical(other.subtopic, subtopic) ||
                other.subtopic == subtopic) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.needsMoreQuestions, needsMoreQuestions) ||
                other.needsMoreQuestions == needsMoreQuestions) &&
            (identical(other.lastSessionId, lastSessionId) ||
                other.lastSessionId == lastSessionId) &&
            (identical(other.avgAccuracy, avgAccuracy) ||
                other.avgAccuracy == avgAccuracy) &&
            (identical(other.level, level) || other.level == level));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      topicKey,
      title,
      mainTopic,
      subtopic,
      description,
      progress,
      completed,
      total,
      needsMoreQuestions,
      lastSessionId,
      avgAccuracy,
      level);

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopicImplCopyWith<_$TopicImpl> get copyWith =>
      __$$TopicImplCopyWithImpl<_$TopicImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopicImplToJson(
      this,
    );
  }
}

abstract class _Topic extends Topic {
  const factory _Topic(
      {required final String id,
      required final String topicKey,
      required final String title,
      required final String mainTopic,
      final String? subtopic,
      final String? description,
      final int progress,
      final int completed,
      final int total,
      final bool needsMoreQuestions,
      final String? lastSessionId,
      final int avgAccuracy,
      final String? level}) = _$TopicImpl;
  const _Topic._() : super._();

  factory _Topic.fromJson(Map<String, dynamic> json) = _$TopicImpl.fromJson;

  @override
  String get id;
  @override
  String get topicKey; // e.g., "Analysis|Ableitungen|Potenzregel"
  @override
  String get title;
  @override
  String get mainTopic;
  @override
  String? get subtopic;
  @override
  String? get description;
  @override
  int get progress; // 0-100
  @override
  int get completed;
  @override
  int get total;
  @override
  bool get needsMoreQuestions;
  @override
  String? get lastSessionId;
  @override
  int get avgAccuracy; // 0-100
  @override
  String? get level;

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopicImplCopyWith<_$TopicImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopicProgress _$TopicProgressFromJson(Map<String, dynamic> json) {
  return _TopicProgress.fromJson(json);
}

/// @nodoc
mixin _$TopicProgress {
  String get topicKey => throw _privateConstructorUsedError;
  int get questionsCompleted => throw _privateConstructorUsedError;
  int get totalQuestions => throw _privateConstructorUsedError;
  String? get lastSessionId => throw _privateConstructorUsedError;
  DateTime? get lastAccessed => throw _privateConstructorUsedError;
  bool get needsMoreQuestions => throw _privateConstructorUsedError;
  int get avgAccuracy => throw _privateConstructorUsedError; // 0-100
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TopicProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopicProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopicProgressCopyWith<TopicProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicProgressCopyWith<$Res> {
  factory $TopicProgressCopyWith(
          TopicProgress value, $Res Function(TopicProgress) then) =
      _$TopicProgressCopyWithImpl<$Res, TopicProgress>;
  @useResult
  $Res call(
      {String topicKey,
      int questionsCompleted,
      int totalQuestions,
      String? lastSessionId,
      DateTime? lastAccessed,
      bool needsMoreQuestions,
      int avgAccuracy,
      DateTime? createdAt});
}

/// @nodoc
class _$TopicProgressCopyWithImpl<$Res, $Val extends TopicProgress>
    implements $TopicProgressCopyWith<$Res> {
  _$TopicProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopicProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topicKey = null,
    Object? questionsCompleted = null,
    Object? totalQuestions = null,
    Object? lastSessionId = freezed,
    Object? lastAccessed = freezed,
    Object? needsMoreQuestions = null,
    Object? avgAccuracy = null,
    Object? createdAt = freezed,
  }) {
    return _then(_value.copyWith(
      topicKey: null == topicKey
          ? _value.topicKey
          : topicKey // ignore: cast_nullable_to_non_nullable
              as String,
      questionsCompleted: null == questionsCompleted
          ? _value.questionsCompleted
          : questionsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      lastSessionId: freezed == lastSessionId
          ? _value.lastSessionId
          : lastSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastAccessed: freezed == lastAccessed
          ? _value.lastAccessed
          : lastAccessed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      needsMoreQuestions: null == needsMoreQuestions
          ? _value.needsMoreQuestions
          : needsMoreQuestions // ignore: cast_nullable_to_non_nullable
              as bool,
      avgAccuracy: null == avgAccuracy
          ? _value.avgAccuracy
          : avgAccuracy // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TopicProgressImplCopyWith<$Res>
    implements $TopicProgressCopyWith<$Res> {
  factory _$$TopicProgressImplCopyWith(
          _$TopicProgressImpl value, $Res Function(_$TopicProgressImpl) then) =
      __$$TopicProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String topicKey,
      int questionsCompleted,
      int totalQuestions,
      String? lastSessionId,
      DateTime? lastAccessed,
      bool needsMoreQuestions,
      int avgAccuracy,
      DateTime? createdAt});
}

/// @nodoc
class __$$TopicProgressImplCopyWithImpl<$Res>
    extends _$TopicProgressCopyWithImpl<$Res, _$TopicProgressImpl>
    implements _$$TopicProgressImplCopyWith<$Res> {
  __$$TopicProgressImplCopyWithImpl(
      _$TopicProgressImpl _value, $Res Function(_$TopicProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of TopicProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? topicKey = null,
    Object? questionsCompleted = null,
    Object? totalQuestions = null,
    Object? lastSessionId = freezed,
    Object? lastAccessed = freezed,
    Object? needsMoreQuestions = null,
    Object? avgAccuracy = null,
    Object? createdAt = freezed,
  }) {
    return _then(_$TopicProgressImpl(
      topicKey: null == topicKey
          ? _value.topicKey
          : topicKey // ignore: cast_nullable_to_non_nullable
              as String,
      questionsCompleted: null == questionsCompleted
          ? _value.questionsCompleted
          : questionsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      lastSessionId: freezed == lastSessionId
          ? _value.lastSessionId
          : lastSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastAccessed: freezed == lastAccessed
          ? _value.lastAccessed
          : lastAccessed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      needsMoreQuestions: null == needsMoreQuestions
          ? _value.needsMoreQuestions
          : needsMoreQuestions // ignore: cast_nullable_to_non_nullable
              as bool,
      avgAccuracy: null == avgAccuracy
          ? _value.avgAccuracy
          : avgAccuracy // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TopicProgressImpl extends _TopicProgress {
  const _$TopicProgressImpl(
      {required this.topicKey,
      this.questionsCompleted = 0,
      this.totalQuestions = 0,
      this.lastSessionId,
      this.lastAccessed,
      this.needsMoreQuestions = false,
      this.avgAccuracy = 0,
      this.createdAt})
      : super._();

  factory _$TopicProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopicProgressImplFromJson(json);

  @override
  final String topicKey;
  @override
  @JsonKey()
  final int questionsCompleted;
  @override
  @JsonKey()
  final int totalQuestions;
  @override
  final String? lastSessionId;
  @override
  final DateTime? lastAccessed;
  @override
  @JsonKey()
  final bool needsMoreQuestions;
  @override
  @JsonKey()
  final int avgAccuracy;
// 0-100
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'TopicProgress(topicKey: $topicKey, questionsCompleted: $questionsCompleted, totalQuestions: $totalQuestions, lastSessionId: $lastSessionId, lastAccessed: $lastAccessed, needsMoreQuestions: $needsMoreQuestions, avgAccuracy: $avgAccuracy, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopicProgressImpl &&
            (identical(other.topicKey, topicKey) ||
                other.topicKey == topicKey) &&
            (identical(other.questionsCompleted, questionsCompleted) ||
                other.questionsCompleted == questionsCompleted) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.lastSessionId, lastSessionId) ||
                other.lastSessionId == lastSessionId) &&
            (identical(other.lastAccessed, lastAccessed) ||
                other.lastAccessed == lastAccessed) &&
            (identical(other.needsMoreQuestions, needsMoreQuestions) ||
                other.needsMoreQuestions == needsMoreQuestions) &&
            (identical(other.avgAccuracy, avgAccuracy) ||
                other.avgAccuracy == avgAccuracy) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      topicKey,
      questionsCompleted,
      totalQuestions,
      lastSessionId,
      lastAccessed,
      needsMoreQuestions,
      avgAccuracy,
      createdAt);

  /// Create a copy of TopicProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopicProgressImplCopyWith<_$TopicProgressImpl> get copyWith =>
      __$$TopicProgressImplCopyWithImpl<_$TopicProgressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopicProgressImplToJson(
      this,
    );
  }
}

abstract class _TopicProgress extends TopicProgress {
  const factory _TopicProgress(
      {required final String topicKey,
      final int questionsCompleted,
      final int totalQuestions,
      final String? lastSessionId,
      final DateTime? lastAccessed,
      final bool needsMoreQuestions,
      final int avgAccuracy,
      final DateTime? createdAt}) = _$TopicProgressImpl;
  const _TopicProgress._() : super._();

  factory _TopicProgress.fromJson(Map<String, dynamic> json) =
      _$TopicProgressImpl.fromJson;

  @override
  String get topicKey;
  @override
  int get questionsCompleted;
  @override
  int get totalQuestions;
  @override
  String? get lastSessionId;
  @override
  DateTime? get lastAccessed;
  @override
  bool get needsMoreQuestions;
  @override
  int get avgAccuracy; // 0-100
  @override
  DateTime? get createdAt;

  /// Create a copy of TopicProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopicProgressImplCopyWith<_$TopicProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LearningSession _$LearningSessionFromJson(Map<String, dynamic> json) {
  return _LearningSession.fromJson(json);
}

/// @nodoc
mixin _$LearningSession {
  String get sessionId => throw _privateConstructorUsedError;
  dynamic get learningPlanItemId =>
      throw _privateConstructorUsedError; // int or string
  String get generatedQuestionsId => throw _privateConstructorUsedError;
  int get questionsTotal => throw _privateConstructorUsedError;
  int get questionsCompleted => throw _privateConstructorUsedError;
  int get totalXpEarned => throw _privateConstructorUsedError;
  int get avgAccuracy => throw _privateConstructorUsedError;
  int get totalTimeSpent => throw _privateConstructorUsedError; // seconds
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get endedAt => throw _privateConstructorUsedError;

  /// Serializes this LearningSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LearningSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LearningSessionCopyWith<LearningSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningSessionCopyWith<$Res> {
  factory $LearningSessionCopyWith(
          LearningSession value, $Res Function(LearningSession) then) =
      _$LearningSessionCopyWithImpl<$Res, LearningSession>;
  @useResult
  $Res call(
      {String sessionId,
      dynamic learningPlanItemId,
      String generatedQuestionsId,
      int questionsTotal,
      int questionsCompleted,
      int totalXpEarned,
      int avgAccuracy,
      int totalTimeSpent,
      DateTime startedAt,
      DateTime? endedAt});
}

/// @nodoc
class _$LearningSessionCopyWithImpl<$Res, $Val extends LearningSession>
    implements $LearningSessionCopyWith<$Res> {
  _$LearningSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LearningSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? learningPlanItemId = freezed,
    Object? generatedQuestionsId = null,
    Object? questionsTotal = null,
    Object? questionsCompleted = null,
    Object? totalXpEarned = null,
    Object? avgAccuracy = null,
    Object? totalTimeSpent = null,
    Object? startedAt = null,
    Object? endedAt = freezed,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      learningPlanItemId: freezed == learningPlanItemId
          ? _value.learningPlanItemId
          : learningPlanItemId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      generatedQuestionsId: null == generatedQuestionsId
          ? _value.generatedQuestionsId
          : generatedQuestionsId // ignore: cast_nullable_to_non_nullable
              as String,
      questionsTotal: null == questionsTotal
          ? _value.questionsTotal
          : questionsTotal // ignore: cast_nullable_to_non_nullable
              as int,
      questionsCompleted: null == questionsCompleted
          ? _value.questionsCompleted
          : questionsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalXpEarned: null == totalXpEarned
          ? _value.totalXpEarned
          : totalXpEarned // ignore: cast_nullable_to_non_nullable
              as int,
      avgAccuracy: null == avgAccuracy
          ? _value.avgAccuracy
          : avgAccuracy // ignore: cast_nullable_to_non_nullable
              as int,
      totalTimeSpent: null == totalTimeSpent
          ? _value.totalTimeSpent
          : totalTimeSpent // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LearningSessionImplCopyWith<$Res>
    implements $LearningSessionCopyWith<$Res> {
  factory _$$LearningSessionImplCopyWith(_$LearningSessionImpl value,
          $Res Function(_$LearningSessionImpl) then) =
      __$$LearningSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      dynamic learningPlanItemId,
      String generatedQuestionsId,
      int questionsTotal,
      int questionsCompleted,
      int totalXpEarned,
      int avgAccuracy,
      int totalTimeSpent,
      DateTime startedAt,
      DateTime? endedAt});
}

/// @nodoc
class __$$LearningSessionImplCopyWithImpl<$Res>
    extends _$LearningSessionCopyWithImpl<$Res, _$LearningSessionImpl>
    implements _$$LearningSessionImplCopyWith<$Res> {
  __$$LearningSessionImplCopyWithImpl(
      _$LearningSessionImpl _value, $Res Function(_$LearningSessionImpl) _then)
      : super(_value, _then);

  /// Create a copy of LearningSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? learningPlanItemId = freezed,
    Object? generatedQuestionsId = null,
    Object? questionsTotal = null,
    Object? questionsCompleted = null,
    Object? totalXpEarned = null,
    Object? avgAccuracy = null,
    Object? totalTimeSpent = null,
    Object? startedAt = null,
    Object? endedAt = freezed,
  }) {
    return _then(_$LearningSessionImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      learningPlanItemId: freezed == learningPlanItemId
          ? _value.learningPlanItemId
          : learningPlanItemId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      generatedQuestionsId: null == generatedQuestionsId
          ? _value.generatedQuestionsId
          : generatedQuestionsId // ignore: cast_nullable_to_non_nullable
              as String,
      questionsTotal: null == questionsTotal
          ? _value.questionsTotal
          : questionsTotal // ignore: cast_nullable_to_non_nullable
              as int,
      questionsCompleted: null == questionsCompleted
          ? _value.questionsCompleted
          : questionsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalXpEarned: null == totalXpEarned
          ? _value.totalXpEarned
          : totalXpEarned // ignore: cast_nullable_to_non_nullable
              as int,
      avgAccuracy: null == avgAccuracy
          ? _value.avgAccuracy
          : avgAccuracy // ignore: cast_nullable_to_non_nullable
              as int,
      totalTimeSpent: null == totalTimeSpent
          ? _value.totalTimeSpent
          : totalTimeSpent // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: freezed == endedAt
          ? _value.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningSessionImpl extends _LearningSession {
  const _$LearningSessionImpl(
      {required this.sessionId,
      required this.learningPlanItemId,
      required this.generatedQuestionsId,
      required this.questionsTotal,
      this.questionsCompleted = 0,
      this.totalXpEarned = 0,
      this.avgAccuracy = 0,
      this.totalTimeSpent = 0,
      required this.startedAt,
      this.endedAt})
      : super._();

  factory _$LearningSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningSessionImplFromJson(json);

  @override
  final String sessionId;
  @override
  final dynamic learningPlanItemId;
// int or string
  @override
  final String generatedQuestionsId;
  @override
  final int questionsTotal;
  @override
  @JsonKey()
  final int questionsCompleted;
  @override
  @JsonKey()
  final int totalXpEarned;
  @override
  @JsonKey()
  final int avgAccuracy;
  @override
  @JsonKey()
  final int totalTimeSpent;
// seconds
  @override
  final DateTime startedAt;
  @override
  final DateTime? endedAt;

  @override
  String toString() {
    return 'LearningSession(sessionId: $sessionId, learningPlanItemId: $learningPlanItemId, generatedQuestionsId: $generatedQuestionsId, questionsTotal: $questionsTotal, questionsCompleted: $questionsCompleted, totalXpEarned: $totalXpEarned, avgAccuracy: $avgAccuracy, totalTimeSpent: $totalTimeSpent, startedAt: $startedAt, endedAt: $endedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningSessionImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            const DeepCollectionEquality()
                .equals(other.learningPlanItemId, learningPlanItemId) &&
            (identical(other.generatedQuestionsId, generatedQuestionsId) ||
                other.generatedQuestionsId == generatedQuestionsId) &&
            (identical(other.questionsTotal, questionsTotal) ||
                other.questionsTotal == questionsTotal) &&
            (identical(other.questionsCompleted, questionsCompleted) ||
                other.questionsCompleted == questionsCompleted) &&
            (identical(other.totalXpEarned, totalXpEarned) ||
                other.totalXpEarned == totalXpEarned) &&
            (identical(other.avgAccuracy, avgAccuracy) ||
                other.avgAccuracy == avgAccuracy) &&
            (identical(other.totalTimeSpent, totalTimeSpent) ||
                other.totalTimeSpent == totalTimeSpent) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.endedAt, endedAt) || other.endedAt == endedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sessionId,
      const DeepCollectionEquality().hash(learningPlanItemId),
      generatedQuestionsId,
      questionsTotal,
      questionsCompleted,
      totalXpEarned,
      avgAccuracy,
      totalTimeSpent,
      startedAt,
      endedAt);

  /// Create a copy of LearningSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningSessionImplCopyWith<_$LearningSessionImpl> get copyWith =>
      __$$LearningSessionImplCopyWithImpl<_$LearningSessionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningSessionImplToJson(
      this,
    );
  }
}

abstract class _LearningSession extends LearningSession {
  const factory _LearningSession(
      {required final String sessionId,
      required final dynamic learningPlanItemId,
      required final String generatedQuestionsId,
      required final int questionsTotal,
      final int questionsCompleted,
      final int totalXpEarned,
      final int avgAccuracy,
      final int totalTimeSpent,
      required final DateTime startedAt,
      final DateTime? endedAt}) = _$LearningSessionImpl;
  const _LearningSession._() : super._();

  factory _LearningSession.fromJson(Map<String, dynamic> json) =
      _$LearningSessionImpl.fromJson;

  @override
  String get sessionId;
  @override
  dynamic get learningPlanItemId; // int or string
  @override
  String get generatedQuestionsId;
  @override
  int get questionsTotal;
  @override
  int get questionsCompleted;
  @override
  int get totalXpEarned;
  @override
  int get avgAccuracy;
  @override
  int get totalTimeSpent; // seconds
  @override
  DateTime get startedAt;
  @override
  DateTime? get endedAt;

  /// Create a copy of LearningSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LearningSessionImplCopyWith<_$LearningSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LearningPlanItem _$LearningPlanItemFromJson(Map<String, dynamic> json) {
  return _LearningPlanItem.fromJson(json);
}

/// @nodoc
mixin _$LearningPlanItem {
  int get id => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  List<String> get themes => throw _privateConstructorUsedError; // Topic keys
  DateTime? get examDate => throw _privateConstructorUsedError;
  String? get examTitle => throw _privateConstructorUsedError;
  int get progress => throw _privateConstructorUsedError; // 0-100
  int get completed => throw _privateConstructorUsedError;
  int get total => throw _privateConstructorUsedError;
  DateTime? get lastAccessed => throw _privateConstructorUsedError;

  /// Serializes this LearningPlanItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LearningPlanItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LearningPlanItemCopyWith<LearningPlanItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningPlanItemCopyWith<$Res> {
  factory $LearningPlanItemCopyWith(
          LearningPlanItem value, $Res Function(LearningPlanItem) then) =
      _$LearningPlanItemCopyWithImpl<$Res, LearningPlanItem>;
  @useResult
  $Res call(
      {int id,
      String title,
      List<String> themes,
      DateTime? examDate,
      String? examTitle,
      int progress,
      int completed,
      int total,
      DateTime? lastAccessed});
}

/// @nodoc
class _$LearningPlanItemCopyWithImpl<$Res, $Val extends LearningPlanItem>
    implements $LearningPlanItemCopyWith<$Res> {
  _$LearningPlanItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LearningPlanItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? themes = null,
    Object? examDate = freezed,
    Object? examTitle = freezed,
    Object? progress = null,
    Object? completed = null,
    Object? total = null,
    Object? lastAccessed = freezed,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      themes: null == themes
          ? _value.themes
          : themes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      examDate: freezed == examDate
          ? _value.examDate
          : examDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      examTitle: freezed == examTitle
          ? _value.examTitle
          : examTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      lastAccessed: freezed == lastAccessed
          ? _value.lastAccessed
          : lastAccessed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LearningPlanItemImplCopyWith<$Res>
    implements $LearningPlanItemCopyWith<$Res> {
  factory _$$LearningPlanItemImplCopyWith(_$LearningPlanItemImpl value,
          $Res Function(_$LearningPlanItemImpl) then) =
      __$$LearningPlanItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int id,
      String title,
      List<String> themes,
      DateTime? examDate,
      String? examTitle,
      int progress,
      int completed,
      int total,
      DateTime? lastAccessed});
}

/// @nodoc
class __$$LearningPlanItemImplCopyWithImpl<$Res>
    extends _$LearningPlanItemCopyWithImpl<$Res, _$LearningPlanItemImpl>
    implements _$$LearningPlanItemImplCopyWith<$Res> {
  __$$LearningPlanItemImplCopyWithImpl(_$LearningPlanItemImpl _value,
      $Res Function(_$LearningPlanItemImpl) _then)
      : super(_value, _then);

  /// Create a copy of LearningPlanItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? title = null,
    Object? themes = null,
    Object? examDate = freezed,
    Object? examTitle = freezed,
    Object? progress = null,
    Object? completed = null,
    Object? total = null,
    Object? lastAccessed = freezed,
  }) {
    return _then(_$LearningPlanItemImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      themes: null == themes
          ? _value._themes
          : themes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      examDate: freezed == examDate
          ? _value.examDate
          : examDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      examTitle: freezed == examTitle
          ? _value.examTitle
          : examTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _value.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _value.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      lastAccessed: freezed == lastAccessed
          ? _value.lastAccessed
          : lastAccessed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningPlanItemImpl extends _LearningPlanItem {
  const _$LearningPlanItemImpl(
      {required this.id,
      required this.title,
      final List<String> themes = const [],
      this.examDate,
      this.examTitle,
      this.progress = 0,
      this.completed = 0,
      this.total = 0,
      this.lastAccessed})
      : _themes = themes,
        super._();

  factory _$LearningPlanItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningPlanItemImplFromJson(json);

  @override
  final int id;
  @override
  final String title;
  final List<String> _themes;
  @override
  @JsonKey()
  List<String> get themes {
    if (_themes is EqualUnmodifiableListView) return _themes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_themes);
  }

// Topic keys
  @override
  final DateTime? examDate;
  @override
  final String? examTitle;
  @override
  @JsonKey()
  final int progress;
// 0-100
  @override
  @JsonKey()
  final int completed;
  @override
  @JsonKey()
  final int total;
  @override
  final DateTime? lastAccessed;

  @override
  String toString() {
    return 'LearningPlanItem(id: $id, title: $title, themes: $themes, examDate: $examDate, examTitle: $examTitle, progress: $progress, completed: $completed, total: $total, lastAccessed: $lastAccessed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningPlanItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other._themes, _themes) &&
            (identical(other.examDate, examDate) ||
                other.examDate == examDate) &&
            (identical(other.examTitle, examTitle) ||
                other.examTitle == examTitle) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            (identical(other.completed, completed) ||
                other.completed == completed) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.lastAccessed, lastAccessed) ||
                other.lastAccessed == lastAccessed));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      title,
      const DeepCollectionEquality().hash(_themes),
      examDate,
      examTitle,
      progress,
      completed,
      total,
      lastAccessed);

  /// Create a copy of LearningPlanItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningPlanItemImplCopyWith<_$LearningPlanItemImpl> get copyWith =>
      __$$LearningPlanItemImplCopyWithImpl<_$LearningPlanItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningPlanItemImplToJson(
      this,
    );
  }
}

abstract class _LearningPlanItem extends LearningPlanItem {
  const factory _LearningPlanItem(
      {required final int id,
      required final String title,
      final List<String> themes,
      final DateTime? examDate,
      final String? examTitle,
      final int progress,
      final int completed,
      final int total,
      final DateTime? lastAccessed}) = _$LearningPlanItemImpl;
  const _LearningPlanItem._() : super._();

  factory _LearningPlanItem.fromJson(Map<String, dynamic> json) =
      _$LearningPlanItemImpl.fromJson;

  @override
  int get id;
  @override
  String get title;
  @override
  List<String> get themes; // Topic keys
  @override
  DateTime? get examDate;
  @override
  String? get examTitle;
  @override
  int get progress; // 0-100
  @override
  int get completed;
  @override
  int get total;
  @override
  DateTime? get lastAccessed;

  /// Create a copy of LearningPlanItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LearningPlanItemImplCopyWith<_$LearningPlanItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
