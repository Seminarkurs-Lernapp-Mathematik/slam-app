// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'topic.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Topic {
  String get id;
  String get topicKey; // e.g., "Analysis|Ableitungen|Potenzregel"
  String get title;
  String get mainTopic;
  String? get subtopic;
  String? get description;
  int get progress; // 0-100
  int get completed;
  int get total;
  bool get needsMoreQuestions;
  String? get lastSessionId;
  int get avgAccuracy; // 0-100
  String? get level;

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TopicCopyWith<Topic> get copyWith =>
      _$TopicCopyWithImpl<Topic>(this as Topic, _$identity);

  /// Serializes this Topic to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Topic &&
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

  @override
  String toString() {
    return 'Topic(id: $id, topicKey: $topicKey, title: $title, mainTopic: $mainTopic, subtopic: $subtopic, description: $description, progress: $progress, completed: $completed, total: $total, needsMoreQuestions: $needsMoreQuestions, lastSessionId: $lastSessionId, avgAccuracy: $avgAccuracy, level: $level)';
  }
}

/// @nodoc
abstract mixin class $TopicCopyWith<$Res> {
  factory $TopicCopyWith(Topic value, $Res Function(Topic) _then) =
      _$TopicCopyWithImpl;
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
class _$TopicCopyWithImpl<$Res> implements $TopicCopyWith<$Res> {
  _$TopicCopyWithImpl(this._self, this._then);

  final Topic _self;
  final $Res Function(Topic) _then;

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
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      topicKey: null == topicKey
          ? _self.topicKey
          : topicKey // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      mainTopic: null == mainTopic
          ? _self.mainTopic
          : mainTopic // ignore: cast_nullable_to_non_nullable
              as String,
      subtopic: freezed == subtopic
          ? _self.subtopic
          : subtopic // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      needsMoreQuestions: null == needsMoreQuestions
          ? _self.needsMoreQuestions
          : needsMoreQuestions // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSessionId: freezed == lastSessionId
          ? _self.lastSessionId
          : lastSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      avgAccuracy: null == avgAccuracy
          ? _self.avgAccuracy
          : avgAccuracy // ignore: cast_nullable_to_non_nullable
              as int,
      level: freezed == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _Topic implements Topic {
  const _Topic(
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
      this.level});
  factory _Topic.fromJson(Map<String, dynamic> json) => _$TopicFromJson(json);

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

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TopicCopyWith<_Topic> get copyWith =>
      __$TopicCopyWithImpl<_Topic>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TopicToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Topic &&
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

  @override
  String toString() {
    return 'Topic(id: $id, topicKey: $topicKey, title: $title, mainTopic: $mainTopic, subtopic: $subtopic, description: $description, progress: $progress, completed: $completed, total: $total, needsMoreQuestions: $needsMoreQuestions, lastSessionId: $lastSessionId, avgAccuracy: $avgAccuracy, level: $level)';
  }
}

/// @nodoc
abstract mixin class _$TopicCopyWith<$Res> implements $TopicCopyWith<$Res> {
  factory _$TopicCopyWith(_Topic value, $Res Function(_Topic) _then) =
      __$TopicCopyWithImpl;
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
class __$TopicCopyWithImpl<$Res> implements _$TopicCopyWith<$Res> {
  __$TopicCopyWithImpl(this._self, this._then);

  final _Topic _self;
  final $Res Function(_Topic) _then;

  /// Create a copy of Topic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_Topic(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      topicKey: null == topicKey
          ? _self.topicKey
          : topicKey // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      mainTopic: null == mainTopic
          ? _self.mainTopic
          : mainTopic // ignore: cast_nullable_to_non_nullable
              as String,
      subtopic: freezed == subtopic
          ? _self.subtopic
          : subtopic // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      needsMoreQuestions: null == needsMoreQuestions
          ? _self.needsMoreQuestions
          : needsMoreQuestions // ignore: cast_nullable_to_non_nullable
              as bool,
      lastSessionId: freezed == lastSessionId
          ? _self.lastSessionId
          : lastSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      avgAccuracy: null == avgAccuracy
          ? _self.avgAccuracy
          : avgAccuracy // ignore: cast_nullable_to_non_nullable
              as int,
      level: freezed == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
mixin _$TopicProgress {
  String get topicKey;
  int get questionsCompleted;
  int get totalQuestions;
  String? get lastSessionId;
  DateTime? get lastAccessed;
  bool get needsMoreQuestions;
  int get avgAccuracy; // 0-100
  DateTime? get createdAt;

  /// Create a copy of TopicProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TopicProgressCopyWith<TopicProgress> get copyWith =>
      _$TopicProgressCopyWithImpl<TopicProgress>(
          this as TopicProgress, _$identity);

  /// Serializes this TopicProgress to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TopicProgress &&
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

  @override
  String toString() {
    return 'TopicProgress(topicKey: $topicKey, questionsCompleted: $questionsCompleted, totalQuestions: $totalQuestions, lastSessionId: $lastSessionId, lastAccessed: $lastAccessed, needsMoreQuestions: $needsMoreQuestions, avgAccuracy: $avgAccuracy, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $TopicProgressCopyWith<$Res> {
  factory $TopicProgressCopyWith(
          TopicProgress value, $Res Function(TopicProgress) _then) =
      _$TopicProgressCopyWithImpl;
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
class _$TopicProgressCopyWithImpl<$Res>
    implements $TopicProgressCopyWith<$Res> {
  _$TopicProgressCopyWithImpl(this._self, this._then);

  final TopicProgress _self;
  final $Res Function(TopicProgress) _then;

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
    return _then(_self.copyWith(
      topicKey: null == topicKey
          ? _self.topicKey
          : topicKey // ignore: cast_nullable_to_non_nullable
              as String,
      questionsCompleted: null == questionsCompleted
          ? _self.questionsCompleted
          : questionsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuestions: null == totalQuestions
          ? _self.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      lastSessionId: freezed == lastSessionId
          ? _self.lastSessionId
          : lastSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastAccessed: freezed == lastAccessed
          ? _self.lastAccessed
          : lastAccessed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      needsMoreQuestions: null == needsMoreQuestions
          ? _self.needsMoreQuestions
          : needsMoreQuestions // ignore: cast_nullable_to_non_nullable
              as bool,
      avgAccuracy: null == avgAccuracy
          ? _self.avgAccuracy
          : avgAccuracy // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TopicProgress implements TopicProgress {
  const _TopicProgress(
      {required this.topicKey,
      this.questionsCompleted = 0,
      this.totalQuestions = 0,
      this.lastSessionId,
      this.lastAccessed,
      this.needsMoreQuestions = false,
      this.avgAccuracy = 0,
      this.createdAt});
  factory _TopicProgress.fromJson(Map<String, dynamic> json) =>
      _$TopicProgressFromJson(json);

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

  /// Create a copy of TopicProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TopicProgressCopyWith<_TopicProgress> get copyWith =>
      __$TopicProgressCopyWithImpl<_TopicProgress>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TopicProgressToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TopicProgress &&
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

  @override
  String toString() {
    return 'TopicProgress(topicKey: $topicKey, questionsCompleted: $questionsCompleted, totalQuestions: $totalQuestions, lastSessionId: $lastSessionId, lastAccessed: $lastAccessed, needsMoreQuestions: $needsMoreQuestions, avgAccuracy: $avgAccuracy, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$TopicProgressCopyWith<$Res>
    implements $TopicProgressCopyWith<$Res> {
  factory _$TopicProgressCopyWith(
          _TopicProgress value, $Res Function(_TopicProgress) _then) =
      __$TopicProgressCopyWithImpl;
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
class __$TopicProgressCopyWithImpl<$Res>
    implements _$TopicProgressCopyWith<$Res> {
  __$TopicProgressCopyWithImpl(this._self, this._then);

  final _TopicProgress _self;
  final $Res Function(_TopicProgress) _then;

  /// Create a copy of TopicProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_TopicProgress(
      topicKey: null == topicKey
          ? _self.topicKey
          : topicKey // ignore: cast_nullable_to_non_nullable
              as String,
      questionsCompleted: null == questionsCompleted
          ? _self.questionsCompleted
          : questionsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalQuestions: null == totalQuestions
          ? _self.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      lastSessionId: freezed == lastSessionId
          ? _self.lastSessionId
          : lastSessionId // ignore: cast_nullable_to_non_nullable
              as String?,
      lastAccessed: freezed == lastAccessed
          ? _self.lastAccessed
          : lastAccessed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      needsMoreQuestions: null == needsMoreQuestions
          ? _self.needsMoreQuestions
          : needsMoreQuestions // ignore: cast_nullable_to_non_nullable
              as bool,
      avgAccuracy: null == avgAccuracy
          ? _self.avgAccuracy
          : avgAccuracy // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$LearningSession {
  String get sessionId;
  dynamic get learningPlanItemId; // int or string
  String get generatedQuestionsId;
  int get questionsTotal;
  int get questionsCompleted;
  int get totalXpEarned;
  int get avgAccuracy;
  int get totalTimeSpent; // seconds
  DateTime get startedAt;
  DateTime? get endedAt;

  /// Create a copy of LearningSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LearningSessionCopyWith<LearningSession> get copyWith =>
      _$LearningSessionCopyWithImpl<LearningSession>(
          this as LearningSession, _$identity);

  /// Serializes this LearningSession to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LearningSession &&
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

  @override
  String toString() {
    return 'LearningSession(sessionId: $sessionId, learningPlanItemId: $learningPlanItemId, generatedQuestionsId: $generatedQuestionsId, questionsTotal: $questionsTotal, questionsCompleted: $questionsCompleted, totalXpEarned: $totalXpEarned, avgAccuracy: $avgAccuracy, totalTimeSpent: $totalTimeSpent, startedAt: $startedAt, endedAt: $endedAt)';
  }
}

/// @nodoc
abstract mixin class $LearningSessionCopyWith<$Res> {
  factory $LearningSessionCopyWith(
          LearningSession value, $Res Function(LearningSession) _then) =
      _$LearningSessionCopyWithImpl;
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
class _$LearningSessionCopyWithImpl<$Res>
    implements $LearningSessionCopyWith<$Res> {
  _$LearningSessionCopyWithImpl(this._self, this._then);

  final LearningSession _self;
  final $Res Function(LearningSession) _then;

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
    return _then(_self.copyWith(
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      learningPlanItemId: freezed == learningPlanItemId
          ? _self.learningPlanItemId
          : learningPlanItemId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      generatedQuestionsId: null == generatedQuestionsId
          ? _self.generatedQuestionsId
          : generatedQuestionsId // ignore: cast_nullable_to_non_nullable
              as String,
      questionsTotal: null == questionsTotal
          ? _self.questionsTotal
          : questionsTotal // ignore: cast_nullable_to_non_nullable
              as int,
      questionsCompleted: null == questionsCompleted
          ? _self.questionsCompleted
          : questionsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalXpEarned: null == totalXpEarned
          ? _self.totalXpEarned
          : totalXpEarned // ignore: cast_nullable_to_non_nullable
              as int,
      avgAccuracy: null == avgAccuracy
          ? _self.avgAccuracy
          : avgAccuracy // ignore: cast_nullable_to_non_nullable
              as int,
      totalTimeSpent: null == totalTimeSpent
          ? _self.totalTimeSpent
          : totalTimeSpent // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: null == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: freezed == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _LearningSession implements LearningSession {
  const _LearningSession(
      {required this.sessionId,
      required this.learningPlanItemId,
      required this.generatedQuestionsId,
      required this.questionsTotal,
      this.questionsCompleted = 0,
      this.totalXpEarned = 0,
      this.avgAccuracy = 0,
      this.totalTimeSpent = 0,
      required this.startedAt,
      this.endedAt});
  factory _LearningSession.fromJson(Map<String, dynamic> json) =>
      _$LearningSessionFromJson(json);

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

  /// Create a copy of LearningSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LearningSessionCopyWith<_LearningSession> get copyWith =>
      __$LearningSessionCopyWithImpl<_LearningSession>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LearningSessionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LearningSession &&
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

  @override
  String toString() {
    return 'LearningSession(sessionId: $sessionId, learningPlanItemId: $learningPlanItemId, generatedQuestionsId: $generatedQuestionsId, questionsTotal: $questionsTotal, questionsCompleted: $questionsCompleted, totalXpEarned: $totalXpEarned, avgAccuracy: $avgAccuracy, totalTimeSpent: $totalTimeSpent, startedAt: $startedAt, endedAt: $endedAt)';
  }
}

/// @nodoc
abstract mixin class _$LearningSessionCopyWith<$Res>
    implements $LearningSessionCopyWith<$Res> {
  factory _$LearningSessionCopyWith(
          _LearningSession value, $Res Function(_LearningSession) _then) =
      __$LearningSessionCopyWithImpl;
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
class __$LearningSessionCopyWithImpl<$Res>
    implements _$LearningSessionCopyWith<$Res> {
  __$LearningSessionCopyWithImpl(this._self, this._then);

  final _LearningSession _self;
  final $Res Function(_LearningSession) _then;

  /// Create a copy of LearningSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_LearningSession(
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      learningPlanItemId: freezed == learningPlanItemId
          ? _self.learningPlanItemId
          : learningPlanItemId // ignore: cast_nullable_to_non_nullable
              as dynamic,
      generatedQuestionsId: null == generatedQuestionsId
          ? _self.generatedQuestionsId
          : generatedQuestionsId // ignore: cast_nullable_to_non_nullable
              as String,
      questionsTotal: null == questionsTotal
          ? _self.questionsTotal
          : questionsTotal // ignore: cast_nullable_to_non_nullable
              as int,
      questionsCompleted: null == questionsCompleted
          ? _self.questionsCompleted
          : questionsCompleted // ignore: cast_nullable_to_non_nullable
              as int,
      totalXpEarned: null == totalXpEarned
          ? _self.totalXpEarned
          : totalXpEarned // ignore: cast_nullable_to_non_nullable
              as int,
      avgAccuracy: null == avgAccuracy
          ? _self.avgAccuracy
          : avgAccuracy // ignore: cast_nullable_to_non_nullable
              as int,
      totalTimeSpent: null == totalTimeSpent
          ? _self.totalTimeSpent
          : totalTimeSpent // ignore: cast_nullable_to_non_nullable
              as int,
      startedAt: null == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      endedAt: freezed == endedAt
          ? _self.endedAt
          : endedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
mixin _$LearningPlanItem {
  int get id;
  String get title;
  List<String> get themes; // Topic keys
  DateTime? get examDate;
  String? get examTitle;
  int get progress; // 0-100
  int get completed;
  int get total;
  DateTime? get lastAccessed;

  /// Create a copy of LearningPlanItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $LearningPlanItemCopyWith<LearningPlanItem> get copyWith =>
      _$LearningPlanItemCopyWithImpl<LearningPlanItem>(
          this as LearningPlanItem, _$identity);

  /// Serializes this LearningPlanItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is LearningPlanItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.title, title) || other.title == title) &&
            const DeepCollectionEquality().equals(other.themes, themes) &&
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
      const DeepCollectionEquality().hash(themes),
      examDate,
      examTitle,
      progress,
      completed,
      total,
      lastAccessed);

  @override
  String toString() {
    return 'LearningPlanItem(id: $id, title: $title, themes: $themes, examDate: $examDate, examTitle: $examTitle, progress: $progress, completed: $completed, total: $total, lastAccessed: $lastAccessed)';
  }
}

/// @nodoc
abstract mixin class $LearningPlanItemCopyWith<$Res> {
  factory $LearningPlanItemCopyWith(
          LearningPlanItem value, $Res Function(LearningPlanItem) _then) =
      _$LearningPlanItemCopyWithImpl;
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
class _$LearningPlanItemCopyWithImpl<$Res>
    implements $LearningPlanItemCopyWith<$Res> {
  _$LearningPlanItemCopyWithImpl(this._self, this._then);

  final LearningPlanItem _self;
  final $Res Function(LearningPlanItem) _then;

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
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      themes: null == themes
          ? _self.themes
          : themes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      examDate: freezed == examDate
          ? _self.examDate
          : examDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      examTitle: freezed == examTitle
          ? _self.examTitle
          : examTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      lastAccessed: freezed == lastAccessed
          ? _self.lastAccessed
          : lastAccessed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _LearningPlanItem implements LearningPlanItem {
  const _LearningPlanItem(
      {required this.id,
      required this.title,
      final List<String> themes = const [],
      this.examDate,
      this.examTitle,
      this.progress = 0,
      this.completed = 0,
      this.total = 0,
      this.lastAccessed})
      : _themes = themes;
  factory _LearningPlanItem.fromJson(Map<String, dynamic> json) =>
      _$LearningPlanItemFromJson(json);

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

  /// Create a copy of LearningPlanItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$LearningPlanItemCopyWith<_LearningPlanItem> get copyWith =>
      __$LearningPlanItemCopyWithImpl<_LearningPlanItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$LearningPlanItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _LearningPlanItem &&
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

  @override
  String toString() {
    return 'LearningPlanItem(id: $id, title: $title, themes: $themes, examDate: $examDate, examTitle: $examTitle, progress: $progress, completed: $completed, total: $total, lastAccessed: $lastAccessed)';
  }
}

/// @nodoc
abstract mixin class _$LearningPlanItemCopyWith<$Res>
    implements $LearningPlanItemCopyWith<$Res> {
  factory _$LearningPlanItemCopyWith(
          _LearningPlanItem value, $Res Function(_LearningPlanItem) _then) =
      __$LearningPlanItemCopyWithImpl;
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
class __$LearningPlanItemCopyWithImpl<$Res>
    implements _$LearningPlanItemCopyWith<$Res> {
  __$LearningPlanItemCopyWithImpl(this._self, this._then);

  final _LearningPlanItem _self;
  final $Res Function(_LearningPlanItem) _then;

  /// Create a copy of LearningPlanItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
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
    return _then(_LearningPlanItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      title: null == title
          ? _self.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      themes: null == themes
          ? _self._themes
          : themes // ignore: cast_nullable_to_non_nullable
              as List<String>,
      examDate: freezed == examDate
          ? _self.examDate
          : examDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      examTitle: freezed == examTitle
          ? _self.examTitle
          : examTitle // ignore: cast_nullable_to_non_nullable
              as String?,
      progress: null == progress
          ? _self.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as int,
      completed: null == completed
          ? _self.completed
          : completed // ignore: cast_nullable_to_non_nullable
              as int,
      total: null == total
          ? _self.total
          : total // ignore: cast_nullable_to_non_nullable
              as int,
      lastAccessed: freezed == lastAccessed
          ? _self.lastAccessed
          : lastAccessed // ignore: cast_nullable_to_non_nullable
              as DateTime?,
    ));
  }
}

// dart format on
