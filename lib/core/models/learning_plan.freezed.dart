// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'learning_plan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

LearningPlan _$LearningPlanFromJson(Map<String, dynamic> json) {
  return _LearningPlan.fromJson(json);
}

/// @nodoc
mixin _$LearningPlan {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  List<String> get goals => throw _privateConstructorUsedError;
  List<TopicSelection> get selectedTopics => throw _privateConstructorUsedError;
  bool get smartLearningEnabled => throw _privateConstructorUsedError;
  DateTime? get targetDate => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime get updatedAt => throw _privateConstructorUsedError;
  bool get isActive => throw _privateConstructorUsedError;
  LearningPlanProgress get progress => throw _privateConstructorUsedError;
  List<SessionSummary> get sessions => throw _privateConstructorUsedError;
  LearningPlanMetadata get metadata => throw _privateConstructorUsedError;

  /// Serializes this LearningPlan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LearningPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LearningPlanCopyWith<LearningPlan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningPlanCopyWith<$Res> {
  factory $LearningPlanCopyWith(
          LearningPlan value, $Res Function(LearningPlan) then) =
      _$LearningPlanCopyWithImpl<$Res, LearningPlan>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      List<String> goals,
      List<TopicSelection> selectedTopics,
      bool smartLearningEnabled,
      DateTime? targetDate,
      DateTime createdAt,
      DateTime updatedAt,
      bool isActive,
      LearningPlanProgress progress,
      List<SessionSummary> sessions,
      LearningPlanMetadata metadata});

  $LearningPlanProgressCopyWith<$Res> get progress;
  $LearningPlanMetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class _$LearningPlanCopyWithImpl<$Res, $Val extends LearningPlan>
    implements $LearningPlanCopyWith<$Res> {
  _$LearningPlanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LearningPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? goals = null,
    Object? selectedTopics = null,
    Object? smartLearningEnabled = null,
    Object? targetDate = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isActive = null,
    Object? progress = null,
    Object? sessions = null,
    Object? metadata = null,
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
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      goals: null == goals
          ? _value.goals
          : goals // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedTopics: null == selectedTopics
          ? _value.selectedTopics
          : selectedTopics // ignore: cast_nullable_to_non_nullable
              as List<TopicSelection>,
      smartLearningEnabled: null == smartLearningEnabled
          ? _value.smartLearningEnabled
          : smartLearningEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      targetDate: freezed == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as LearningPlanProgress,
      sessions: null == sessions
          ? _value.sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<SessionSummary>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as LearningPlanMetadata,
    ) as $Val);
  }

  /// Create a copy of LearningPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LearningPlanProgressCopyWith<$Res> get progress {
    return $LearningPlanProgressCopyWith<$Res>(_value.progress, (value) {
      return _then(_value.copyWith(progress: value) as $Val);
    });
  }

  /// Create a copy of LearningPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $LearningPlanMetadataCopyWith<$Res> get metadata {
    return $LearningPlanMetadataCopyWith<$Res>(_value.metadata, (value) {
      return _then(_value.copyWith(metadata: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$LearningPlanImplCopyWith<$Res>
    implements $LearningPlanCopyWith<$Res> {
  factory _$$LearningPlanImplCopyWith(
          _$LearningPlanImpl value, $Res Function(_$LearningPlanImpl) then) =
      __$$LearningPlanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String name,
      List<String> goals,
      List<TopicSelection> selectedTopics,
      bool smartLearningEnabled,
      DateTime? targetDate,
      DateTime createdAt,
      DateTime updatedAt,
      bool isActive,
      LearningPlanProgress progress,
      List<SessionSummary> sessions,
      LearningPlanMetadata metadata});

  @override
  $LearningPlanProgressCopyWith<$Res> get progress;
  @override
  $LearningPlanMetadataCopyWith<$Res> get metadata;
}

/// @nodoc
class __$$LearningPlanImplCopyWithImpl<$Res>
    extends _$LearningPlanCopyWithImpl<$Res, _$LearningPlanImpl>
    implements _$$LearningPlanImplCopyWith<$Res> {
  __$$LearningPlanImplCopyWithImpl(
      _$LearningPlanImpl _value, $Res Function(_$LearningPlanImpl) _then)
      : super(_value, _then);

  /// Create a copy of LearningPlan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? name = null,
    Object? goals = null,
    Object? selectedTopics = null,
    Object? smartLearningEnabled = null,
    Object? targetDate = freezed,
    Object? createdAt = null,
    Object? updatedAt = null,
    Object? isActive = null,
    Object? progress = null,
    Object? sessions = null,
    Object? metadata = null,
  }) {
    return _then(_$LearningPlanImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      goals: null == goals
          ? _value._goals
          : goals // ignore: cast_nullable_to_non_nullable
              as List<String>,
      selectedTopics: null == selectedTopics
          ? _value._selectedTopics
          : selectedTopics // ignore: cast_nullable_to_non_nullable
              as List<TopicSelection>,
      smartLearningEnabled: null == smartLearningEnabled
          ? _value.smartLearningEnabled
          : smartLearningEnabled // ignore: cast_nullable_to_non_nullable
              as bool,
      targetDate: freezed == targetDate
          ? _value.targetDate
          : targetDate // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      isActive: null == isActive
          ? _value.isActive
          : isActive // ignore: cast_nullable_to_non_nullable
              as bool,
      progress: null == progress
          ? _value.progress
          : progress // ignore: cast_nullable_to_non_nullable
              as LearningPlanProgress,
      sessions: null == sessions
          ? _value._sessions
          : sessions // ignore: cast_nullable_to_non_nullable
              as List<SessionSummary>,
      metadata: null == metadata
          ? _value.metadata
          : metadata // ignore: cast_nullable_to_non_nullable
              as LearningPlanMetadata,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningPlanImpl implements _LearningPlan {
  const _$LearningPlanImpl(
      {required this.id,
      required this.userId,
      required this.name,
      final List<String> goals = const [],
      final List<TopicSelection> selectedTopics = const [],
      this.smartLearningEnabled = false,
      this.targetDate,
      required this.createdAt,
      required this.updatedAt,
      this.isActive = true,
      required this.progress,
      final List<SessionSummary> sessions = const [],
      required this.metadata})
      : _goals = goals,
        _selectedTopics = selectedTopics,
        _sessions = sessions;

  factory _$LearningPlanImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningPlanImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String name;
  final List<String> _goals;
  @override
  @JsonKey()
  List<String> get goals {
    if (_goals is EqualUnmodifiableListView) return _goals;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_goals);
  }

  final List<TopicSelection> _selectedTopics;
  @override
  @JsonKey()
  List<TopicSelection> get selectedTopics {
    if (_selectedTopics is EqualUnmodifiableListView) return _selectedTopics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_selectedTopics);
  }

  @override
  @JsonKey()
  final bool smartLearningEnabled;
  @override
  final DateTime? targetDate;
  @override
  final DateTime createdAt;
  @override
  final DateTime updatedAt;
  @override
  @JsonKey()
  final bool isActive;
  @override
  final LearningPlanProgress progress;
  final List<SessionSummary> _sessions;
  @override
  @JsonKey()
  List<SessionSummary> get sessions {
    if (_sessions is EqualUnmodifiableListView) return _sessions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_sessions);
  }

  @override
  final LearningPlanMetadata metadata;

  @override
  String toString() {
    return 'LearningPlan(id: $id, userId: $userId, name: $name, goals: $goals, selectedTopics: $selectedTopics, smartLearningEnabled: $smartLearningEnabled, targetDate: $targetDate, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive, progress: $progress, sessions: $sessions, metadata: $metadata)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningPlanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.name, name) || other.name == name) &&
            const DeepCollectionEquality().equals(other._goals, _goals) &&
            const DeepCollectionEquality()
                .equals(other._selectedTopics, _selectedTopics) &&
            (identical(other.smartLearningEnabled, smartLearningEnabled) ||
                other.smartLearningEnabled == smartLearningEnabled) &&
            (identical(other.targetDate, targetDate) ||
                other.targetDate == targetDate) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.isActive, isActive) ||
                other.isActive == isActive) &&
            (identical(other.progress, progress) ||
                other.progress == progress) &&
            const DeepCollectionEquality().equals(other._sessions, _sessions) &&
            (identical(other.metadata, metadata) ||
                other.metadata == metadata));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      name,
      const DeepCollectionEquality().hash(_goals),
      const DeepCollectionEquality().hash(_selectedTopics),
      smartLearningEnabled,
      targetDate,
      createdAt,
      updatedAt,
      isActive,
      progress,
      const DeepCollectionEquality().hash(_sessions),
      metadata);

  /// Create a copy of LearningPlan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningPlanImplCopyWith<_$LearningPlanImpl> get copyWith =>
      __$$LearningPlanImplCopyWithImpl<_$LearningPlanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningPlanImplToJson(
      this,
    );
  }
}

abstract class _LearningPlan implements LearningPlan {
  const factory _LearningPlan(
      {required final String id,
      required final String userId,
      required final String name,
      final List<String> goals,
      final List<TopicSelection> selectedTopics,
      final bool smartLearningEnabled,
      final DateTime? targetDate,
      required final DateTime createdAt,
      required final DateTime updatedAt,
      final bool isActive,
      required final LearningPlanProgress progress,
      final List<SessionSummary> sessions,
      required final LearningPlanMetadata metadata}) = _$LearningPlanImpl;

  factory _LearningPlan.fromJson(Map<String, dynamic> json) =
      _$LearningPlanImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get name;
  @override
  List<String> get goals;
  @override
  List<TopicSelection> get selectedTopics;
  @override
  bool get smartLearningEnabled;
  @override
  DateTime? get targetDate;
  @override
  DateTime get createdAt;
  @override
  DateTime get updatedAt;
  @override
  bool get isActive;
  @override
  LearningPlanProgress get progress;
  @override
  List<SessionSummary> get sessions;
  @override
  LearningPlanMetadata get metadata;

  /// Create a copy of LearningPlan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LearningPlanImplCopyWith<_$LearningPlanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopicSelection _$TopicSelectionFromJson(Map<String, dynamic> json) {
  return _TopicSelection.fromJson(json);
}

/// @nodoc
mixin _$TopicSelection {
  String get leitidee => throw _privateConstructorUsedError;
  String get thema => throw _privateConstructorUsedError;
  String get unterthema => throw _privateConstructorUsedError;
  int get priority => throw _privateConstructorUsedError;
  String? get reason => throw _privateConstructorUsedError;

  /// Serializes this TopicSelection to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopicSelection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopicSelectionCopyWith<TopicSelection> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicSelectionCopyWith<$Res> {
  factory $TopicSelectionCopyWith(
          TopicSelection value, $Res Function(TopicSelection) then) =
      _$TopicSelectionCopyWithImpl<$Res, TopicSelection>;
  @useResult
  $Res call(
      {String leitidee,
      String thema,
      String unterthema,
      int priority,
      String? reason});
}

/// @nodoc
class _$TopicSelectionCopyWithImpl<$Res, $Val extends TopicSelection>
    implements $TopicSelectionCopyWith<$Res> {
  _$TopicSelectionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopicSelection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leitidee = null,
    Object? thema = null,
    Object? unterthema = null,
    Object? priority = null,
    Object? reason = freezed,
  }) {
    return _then(_value.copyWith(
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
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TopicSelectionImplCopyWith<$Res>
    implements $TopicSelectionCopyWith<$Res> {
  factory _$$TopicSelectionImplCopyWith(_$TopicSelectionImpl value,
          $Res Function(_$TopicSelectionImpl) then) =
      __$$TopicSelectionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String leitidee,
      String thema,
      String unterthema,
      int priority,
      String? reason});
}

/// @nodoc
class __$$TopicSelectionImplCopyWithImpl<$Res>
    extends _$TopicSelectionCopyWithImpl<$Res, _$TopicSelectionImpl>
    implements _$$TopicSelectionImplCopyWith<$Res> {
  __$$TopicSelectionImplCopyWithImpl(
      _$TopicSelectionImpl _value, $Res Function(_$TopicSelectionImpl) _then)
      : super(_value, _then);

  /// Create a copy of TopicSelection
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leitidee = null,
    Object? thema = null,
    Object? unterthema = null,
    Object? priority = null,
    Object? reason = freezed,
  }) {
    return _then(_$TopicSelectionImpl(
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
      priority: null == priority
          ? _value.priority
          : priority // ignore: cast_nullable_to_non_nullable
              as int,
      reason: freezed == reason
          ? _value.reason
          : reason // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TopicSelectionImpl implements _TopicSelection {
  const _$TopicSelectionImpl(
      {required this.leitidee,
      required this.thema,
      required this.unterthema,
      this.priority = 0,
      this.reason});

  factory _$TopicSelectionImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopicSelectionImplFromJson(json);

  @override
  final String leitidee;
  @override
  final String thema;
  @override
  final String unterthema;
  @override
  @JsonKey()
  final int priority;
  @override
  final String? reason;

  @override
  String toString() {
    return 'TopicSelection(leitidee: $leitidee, thema: $thema, unterthema: $unterthema, priority: $priority, reason: $reason)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopicSelectionImpl &&
            (identical(other.leitidee, leitidee) ||
                other.leitidee == leitidee) &&
            (identical(other.thema, thema) || other.thema == thema) &&
            (identical(other.unterthema, unterthema) ||
                other.unterthema == unterthema) &&
            (identical(other.priority, priority) ||
                other.priority == priority) &&
            (identical(other.reason, reason) || other.reason == reason));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, leitidee, thema, unterthema, priority, reason);

  /// Create a copy of TopicSelection
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopicSelectionImplCopyWith<_$TopicSelectionImpl> get copyWith =>
      __$$TopicSelectionImplCopyWithImpl<_$TopicSelectionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopicSelectionImplToJson(
      this,
    );
  }
}

abstract class _TopicSelection implements TopicSelection {
  const factory _TopicSelection(
      {required final String leitidee,
      required final String thema,
      required final String unterthema,
      final int priority,
      final String? reason}) = _$TopicSelectionImpl;

  factory _TopicSelection.fromJson(Map<String, dynamic> json) =
      _$TopicSelectionImpl.fromJson;

  @override
  String get leitidee;
  @override
  String get thema;
  @override
  String get unterthema;
  @override
  int get priority;
  @override
  String? get reason;

  /// Create a copy of TopicSelection
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopicSelectionImplCopyWith<_$TopicSelectionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LearningPlanProgress _$LearningPlanProgressFromJson(Map<String, dynamic> json) {
  return _LearningPlanProgress.fromJson(json);
}

/// @nodoc
mixin _$LearningPlanProgress {
  int get totalTopics => throw _privateConstructorUsedError;
  int get completedTopics => throw _privateConstructorUsedError;
  double get avgAccuracy => throw _privateConstructorUsedError;
  int get totalQuestions => throw _privateConstructorUsedError;
  int get correctAnswers => throw _privateConstructorUsedError;
  int get totalXpEarned => throw _privateConstructorUsedError;

  /// Serializes this LearningPlanProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LearningPlanProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LearningPlanProgressCopyWith<LearningPlanProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningPlanProgressCopyWith<$Res> {
  factory $LearningPlanProgressCopyWith(LearningPlanProgress value,
          $Res Function(LearningPlanProgress) then) =
      _$LearningPlanProgressCopyWithImpl<$Res, LearningPlanProgress>;
  @useResult
  $Res call(
      {int totalTopics,
      int completedTopics,
      double avgAccuracy,
      int totalQuestions,
      int correctAnswers,
      int totalXpEarned});
}

/// @nodoc
class _$LearningPlanProgressCopyWithImpl<$Res,
        $Val extends LearningPlanProgress>
    implements $LearningPlanProgressCopyWith<$Res> {
  _$LearningPlanProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LearningPlanProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalTopics = null,
    Object? completedTopics = null,
    Object? avgAccuracy = null,
    Object? totalQuestions = null,
    Object? correctAnswers = null,
    Object? totalXpEarned = null,
  }) {
    return _then(_value.copyWith(
      totalTopics: null == totalTopics
          ? _value.totalTopics
          : totalTopics // ignore: cast_nullable_to_non_nullable
              as int,
      completedTopics: null == completedTopics
          ? _value.completedTopics
          : completedTopics // ignore: cast_nullable_to_non_nullable
              as int,
      avgAccuracy: null == avgAccuracy
          ? _value.avgAccuracy
          : avgAccuracy // ignore: cast_nullable_to_non_nullable
              as double,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      correctAnswers: null == correctAnswers
          ? _value.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      totalXpEarned: null == totalXpEarned
          ? _value.totalXpEarned
          : totalXpEarned // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LearningPlanProgressImplCopyWith<$Res>
    implements $LearningPlanProgressCopyWith<$Res> {
  factory _$$LearningPlanProgressImplCopyWith(_$LearningPlanProgressImpl value,
          $Res Function(_$LearningPlanProgressImpl) then) =
      __$$LearningPlanProgressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int totalTopics,
      int completedTopics,
      double avgAccuracy,
      int totalQuestions,
      int correctAnswers,
      int totalXpEarned});
}

/// @nodoc
class __$$LearningPlanProgressImplCopyWithImpl<$Res>
    extends _$LearningPlanProgressCopyWithImpl<$Res, _$LearningPlanProgressImpl>
    implements _$$LearningPlanProgressImplCopyWith<$Res> {
  __$$LearningPlanProgressImplCopyWithImpl(_$LearningPlanProgressImpl _value,
      $Res Function(_$LearningPlanProgressImpl) _then)
      : super(_value, _then);

  /// Create a copy of LearningPlanProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalTopics = null,
    Object? completedTopics = null,
    Object? avgAccuracy = null,
    Object? totalQuestions = null,
    Object? correctAnswers = null,
    Object? totalXpEarned = null,
  }) {
    return _then(_$LearningPlanProgressImpl(
      totalTopics: null == totalTopics
          ? _value.totalTopics
          : totalTopics // ignore: cast_nullable_to_non_nullable
              as int,
      completedTopics: null == completedTopics
          ? _value.completedTopics
          : completedTopics // ignore: cast_nullable_to_non_nullable
              as int,
      avgAccuracy: null == avgAccuracy
          ? _value.avgAccuracy
          : avgAccuracy // ignore: cast_nullable_to_non_nullable
              as double,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      correctAnswers: null == correctAnswers
          ? _value.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      totalXpEarned: null == totalXpEarned
          ? _value.totalXpEarned
          : totalXpEarned // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningPlanProgressImpl implements _LearningPlanProgress {
  const _$LearningPlanProgressImpl(
      {required this.totalTopics,
      required this.completedTopics,
      required this.avgAccuracy,
      required this.totalQuestions,
      required this.correctAnswers,
      required this.totalXpEarned});

  factory _$LearningPlanProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningPlanProgressImplFromJson(json);

  @override
  final int totalTopics;
  @override
  final int completedTopics;
  @override
  final double avgAccuracy;
  @override
  final int totalQuestions;
  @override
  final int correctAnswers;
  @override
  final int totalXpEarned;

  @override
  String toString() {
    return 'LearningPlanProgress(totalTopics: $totalTopics, completedTopics: $completedTopics, avgAccuracy: $avgAccuracy, totalQuestions: $totalQuestions, correctAnswers: $correctAnswers, totalXpEarned: $totalXpEarned)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningPlanProgressImpl &&
            (identical(other.totalTopics, totalTopics) ||
                other.totalTopics == totalTopics) &&
            (identical(other.completedTopics, completedTopics) ||
                other.completedTopics == completedTopics) &&
            (identical(other.avgAccuracy, avgAccuracy) ||
                other.avgAccuracy == avgAccuracy) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            (identical(other.totalXpEarned, totalXpEarned) ||
                other.totalXpEarned == totalXpEarned));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, totalTopics, completedTopics,
      avgAccuracy, totalQuestions, correctAnswers, totalXpEarned);

  /// Create a copy of LearningPlanProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningPlanProgressImplCopyWith<_$LearningPlanProgressImpl>
      get copyWith =>
          __$$LearningPlanProgressImplCopyWithImpl<_$LearningPlanProgressImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningPlanProgressImplToJson(
      this,
    );
  }
}

abstract class _LearningPlanProgress implements LearningPlanProgress {
  const factory _LearningPlanProgress(
      {required final int totalTopics,
      required final int completedTopics,
      required final double avgAccuracy,
      required final int totalQuestions,
      required final int correctAnswers,
      required final int totalXpEarned}) = _$LearningPlanProgressImpl;

  factory _LearningPlanProgress.fromJson(Map<String, dynamic> json) =
      _$LearningPlanProgressImpl.fromJson;

  @override
  int get totalTopics;
  @override
  int get completedTopics;
  @override
  double get avgAccuracy;
  @override
  int get totalQuestions;
  @override
  int get correctAnswers;
  @override
  int get totalXpEarned;

  /// Create a copy of LearningPlanProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LearningPlanProgressImplCopyWith<_$LearningPlanProgressImpl>
      get copyWith => throw _privateConstructorUsedError;
}

SessionSummary _$SessionSummaryFromJson(Map<String, dynamic> json) {
  return _SessionSummary.fromJson(json);
}

/// @nodoc
mixin _$SessionSummary {
  String get sessionId => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime get completedAt => throw _privateConstructorUsedError;
  int get questionsAnswered => throw _privateConstructorUsedError;
  int get correctAnswers => throw _privateConstructorUsedError;
  int get xpEarned => throw _privateConstructorUsedError;

  /// Serializes this SessionSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SessionSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SessionSummaryCopyWith<SessionSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SessionSummaryCopyWith<$Res> {
  factory $SessionSummaryCopyWith(
          SessionSummary value, $Res Function(SessionSummary) then) =
      _$SessionSummaryCopyWithImpl<$Res, SessionSummary>;
  @useResult
  $Res call(
      {String sessionId,
      DateTime startedAt,
      DateTime completedAt,
      int questionsAnswered,
      int correctAnswers,
      int xpEarned});
}

/// @nodoc
class _$SessionSummaryCopyWithImpl<$Res, $Val extends SessionSummary>
    implements $SessionSummaryCopyWith<$Res> {
  _$SessionSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SessionSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? startedAt = null,
    Object? completedAt = null,
    Object? questionsAnswered = null,
    Object? correctAnswers = null,
    Object? xpEarned = null,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: null == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      questionsAnswered: null == questionsAnswered
          ? _value.questionsAnswered
          : questionsAnswered // ignore: cast_nullable_to_non_nullable
              as int,
      correctAnswers: null == correctAnswers
          ? _value.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      xpEarned: null == xpEarned
          ? _value.xpEarned
          : xpEarned // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SessionSummaryImplCopyWith<$Res>
    implements $SessionSummaryCopyWith<$Res> {
  factory _$$SessionSummaryImplCopyWith(_$SessionSummaryImpl value,
          $Res Function(_$SessionSummaryImpl) then) =
      __$$SessionSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      DateTime startedAt,
      DateTime completedAt,
      int questionsAnswered,
      int correctAnswers,
      int xpEarned});
}

/// @nodoc
class __$$SessionSummaryImplCopyWithImpl<$Res>
    extends _$SessionSummaryCopyWithImpl<$Res, _$SessionSummaryImpl>
    implements _$$SessionSummaryImplCopyWith<$Res> {
  __$$SessionSummaryImplCopyWithImpl(
      _$SessionSummaryImpl _value, $Res Function(_$SessionSummaryImpl) _then)
      : super(_value, _then);

  /// Create a copy of SessionSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? startedAt = null,
    Object? completedAt = null,
    Object? questionsAnswered = null,
    Object? correctAnswers = null,
    Object? xpEarned = null,
  }) {
    return _then(_$SessionSummaryImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: null == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      questionsAnswered: null == questionsAnswered
          ? _value.questionsAnswered
          : questionsAnswered // ignore: cast_nullable_to_non_nullable
              as int,
      correctAnswers: null == correctAnswers
          ? _value.correctAnswers
          : correctAnswers // ignore: cast_nullable_to_non_nullable
              as int,
      xpEarned: null == xpEarned
          ? _value.xpEarned
          : xpEarned // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SessionSummaryImpl implements _SessionSummary {
  const _$SessionSummaryImpl(
      {required this.sessionId,
      required this.startedAt,
      required this.completedAt,
      required this.questionsAnswered,
      required this.correctAnswers,
      required this.xpEarned});

  factory _$SessionSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$SessionSummaryImplFromJson(json);

  @override
  final String sessionId;
  @override
  final DateTime startedAt;
  @override
  final DateTime completedAt;
  @override
  final int questionsAnswered;
  @override
  final int correctAnswers;
  @override
  final int xpEarned;

  @override
  String toString() {
    return 'SessionSummary(sessionId: $sessionId, startedAt: $startedAt, completedAt: $completedAt, questionsAnswered: $questionsAnswered, correctAnswers: $correctAnswers, xpEarned: $xpEarned)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SessionSummaryImpl &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.questionsAnswered, questionsAnswered) ||
                other.questionsAnswered == questionsAnswered) &&
            (identical(other.correctAnswers, correctAnswers) ||
                other.correctAnswers == correctAnswers) &&
            (identical(other.xpEarned, xpEarned) ||
                other.xpEarned == xpEarned));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, sessionId, startedAt,
      completedAt, questionsAnswered, correctAnswers, xpEarned);

  /// Create a copy of SessionSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SessionSummaryImplCopyWith<_$SessionSummaryImpl> get copyWith =>
      __$$SessionSummaryImplCopyWithImpl<_$SessionSummaryImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SessionSummaryImplToJson(
      this,
    );
  }
}

abstract class _SessionSummary implements SessionSummary {
  const factory _SessionSummary(
      {required final String sessionId,
      required final DateTime startedAt,
      required final DateTime completedAt,
      required final int questionsAnswered,
      required final int correctAnswers,
      required final int xpEarned}) = _$SessionSummaryImpl;

  factory _SessionSummary.fromJson(Map<String, dynamic> json) =
      _$SessionSummaryImpl.fromJson;

  @override
  String get sessionId;
  @override
  DateTime get startedAt;
  @override
  DateTime get completedAt;
  @override
  int get questionsAnswered;
  @override
  int get correctAnswers;
  @override
  int get xpEarned;

  /// Create a copy of SessionSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SessionSummaryImplCopyWith<_$SessionSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LearningPlanMetadata _$LearningPlanMetadataFromJson(Map<String, dynamic> json) {
  return _LearningPlanMetadata.fromJson(json);
}

/// @nodoc
mixin _$LearningPlanMetadata {
  String get gradeLevel => throw _privateConstructorUsedError;
  String get courseType => throw _privateConstructorUsedError;

  /// Serializes this LearningPlanMetadata to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LearningPlanMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LearningPlanMetadataCopyWith<LearningPlanMetadata> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LearningPlanMetadataCopyWith<$Res> {
  factory $LearningPlanMetadataCopyWith(LearningPlanMetadata value,
          $Res Function(LearningPlanMetadata) then) =
      _$LearningPlanMetadataCopyWithImpl<$Res, LearningPlanMetadata>;
  @useResult
  $Res call({String gradeLevel, String courseType});
}

/// @nodoc
class _$LearningPlanMetadataCopyWithImpl<$Res,
        $Val extends LearningPlanMetadata>
    implements $LearningPlanMetadataCopyWith<$Res> {
  _$LearningPlanMetadataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LearningPlanMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gradeLevel = null,
    Object? courseType = null,
  }) {
    return _then(_value.copyWith(
      gradeLevel: null == gradeLevel
          ? _value.gradeLevel
          : gradeLevel // ignore: cast_nullable_to_non_nullable
              as String,
      courseType: null == courseType
          ? _value.courseType
          : courseType // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LearningPlanMetadataImplCopyWith<$Res>
    implements $LearningPlanMetadataCopyWith<$Res> {
  factory _$$LearningPlanMetadataImplCopyWith(_$LearningPlanMetadataImpl value,
          $Res Function(_$LearningPlanMetadataImpl) then) =
      __$$LearningPlanMetadataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String gradeLevel, String courseType});
}

/// @nodoc
class __$$LearningPlanMetadataImplCopyWithImpl<$Res>
    extends _$LearningPlanMetadataCopyWithImpl<$Res, _$LearningPlanMetadataImpl>
    implements _$$LearningPlanMetadataImplCopyWith<$Res> {
  __$$LearningPlanMetadataImplCopyWithImpl(_$LearningPlanMetadataImpl _value,
      $Res Function(_$LearningPlanMetadataImpl) _then)
      : super(_value, _then);

  /// Create a copy of LearningPlanMetadata
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gradeLevel = null,
    Object? courseType = null,
  }) {
    return _then(_$LearningPlanMetadataImpl(
      gradeLevel: null == gradeLevel
          ? _value.gradeLevel
          : gradeLevel // ignore: cast_nullable_to_non_nullable
              as String,
      courseType: null == courseType
          ? _value.courseType
          : courseType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LearningPlanMetadataImpl implements _LearningPlanMetadata {
  const _$LearningPlanMetadataImpl(
      {required this.gradeLevel, required this.courseType});

  factory _$LearningPlanMetadataImpl.fromJson(Map<String, dynamic> json) =>
      _$$LearningPlanMetadataImplFromJson(json);

  @override
  final String gradeLevel;
  @override
  final String courseType;

  @override
  String toString() {
    return 'LearningPlanMetadata(gradeLevel: $gradeLevel, courseType: $courseType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LearningPlanMetadataImpl &&
            (identical(other.gradeLevel, gradeLevel) ||
                other.gradeLevel == gradeLevel) &&
            (identical(other.courseType, courseType) ||
                other.courseType == courseType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, gradeLevel, courseType);

  /// Create a copy of LearningPlanMetadata
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LearningPlanMetadataImplCopyWith<_$LearningPlanMetadataImpl>
      get copyWith =>
          __$$LearningPlanMetadataImplCopyWithImpl<_$LearningPlanMetadataImpl>(
              this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LearningPlanMetadataImplToJson(
      this,
    );
  }
}

abstract class _LearningPlanMetadata implements LearningPlanMetadata {
  const factory _LearningPlanMetadata(
      {required final String gradeLevel,
      required final String courseType}) = _$LearningPlanMetadataImpl;

  factory _LearningPlanMetadata.fromJson(Map<String, dynamic> json) =
      _$LearningPlanMetadataImpl.fromJson;

  @override
  String get gradeLevel;
  @override
  String get courseType;

  /// Create a copy of LearningPlanMetadata
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LearningPlanMetadataImplCopyWith<_$LearningPlanMetadataImpl>
      get copyWith => throw _privateConstructorUsedError;
}
