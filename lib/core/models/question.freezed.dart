// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Question {
  String get id;
  QuestionType get type;
  int get difficulty; // 1-10
  String get topic;
  String get subtopic;
  String get question; // LaTeX formatted
  List<QuestionOption>? get options; // For multiple-choice
  List<QuestionHint> get hints;
  String get solution;
  String get explanation;
  GeoGebraData? get geogebra;
  bool get hasGeoGebraVisualization;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QuestionCopyWith<Question> get copyWith =>
      _$QuestionCopyWithImpl<Question>(this as Question, _$identity);

  /// Serializes this Question to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Question &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.subtopic, subtopic) ||
                other.subtopic == subtopic) &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality().equals(other.options, options) &&
            const DeepCollectionEquality().equals(other.hints, hints) &&
            (identical(other.solution, solution) ||
                other.solution == solution) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            (identical(other.geogebra, geogebra) ||
                other.geogebra == geogebra) &&
            (identical(
                    other.hasGeoGebraVisualization, hasGeoGebraVisualization) ||
                other.hasGeoGebraVisualization == hasGeoGebraVisualization));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      difficulty,
      topic,
      subtopic,
      question,
      const DeepCollectionEquality().hash(options),
      const DeepCollectionEquality().hash(hints),
      solution,
      explanation,
      geogebra,
      hasGeoGebraVisualization);

  @override
  String toString() {
    return 'Question(id: $id, type: $type, difficulty: $difficulty, topic: $topic, subtopic: $subtopic, question: $question, options: $options, hints: $hints, solution: $solution, explanation: $explanation, geogebra: $geogebra, hasGeoGebraVisualization: $hasGeoGebraVisualization)';
  }
}

/// @nodoc
abstract mixin class $QuestionCopyWith<$Res> {
  factory $QuestionCopyWith(Question value, $Res Function(Question) _then) =
      _$QuestionCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      QuestionType type,
      int difficulty,
      String topic,
      String subtopic,
      String question,
      List<QuestionOption>? options,
      List<QuestionHint> hints,
      String solution,
      String explanation,
      GeoGebraData? geogebra,
      bool hasGeoGebraVisualization});

  $GeoGebraDataCopyWith<$Res>? get geogebra;
}

/// @nodoc
class _$QuestionCopyWithImpl<$Res> implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._self, this._then);

  final Question _self;
  final $Res Function(Question) _then;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? difficulty = null,
    Object? topic = null,
    Object? subtopic = null,
    Object? question = null,
    Object? options = freezed,
    Object? hints = null,
    Object? solution = null,
    Object? explanation = null,
    Object? geogebra = freezed,
    Object? hasGeoGebraVisualization = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as QuestionType,
      difficulty: null == difficulty
          ? _self.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
      topic: null == topic
          ? _self.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      subtopic: null == subtopic
          ? _self.subtopic
          : subtopic // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _self.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      options: freezed == options
          ? _self.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<QuestionOption>?,
      hints: null == hints
          ? _self.hints
          : hints // ignore: cast_nullable_to_non_nullable
              as List<QuestionHint>,
      solution: null == solution
          ? _self.solution
          : solution // ignore: cast_nullable_to_non_nullable
              as String,
      explanation: null == explanation
          ? _self.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
      geogebra: freezed == geogebra
          ? _self.geogebra
          : geogebra // ignore: cast_nullable_to_non_nullable
              as GeoGebraData?,
      hasGeoGebraVisualization: null == hasGeoGebraVisualization
          ? _self.hasGeoGebraVisualization
          : hasGeoGebraVisualization // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeoGebraDataCopyWith<$Res>? get geogebra {
    if (_self.geogebra == null) {
      return null;
    }

    return $GeoGebraDataCopyWith<$Res>(_self.geogebra!, (value) {
      return _then(_self.copyWith(geogebra: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _Question implements Question {
  const _Question(
      {required this.id,
      required this.type,
      required this.difficulty,
      required this.topic,
      required this.subtopic,
      required this.question,
      final List<QuestionOption>? options,
      final List<QuestionHint> hints = const [],
      required this.solution,
      required this.explanation,
      this.geogebra,
      this.hasGeoGebraVisualization = false})
      : _options = options,
        _hints = hints;
  factory _Question.fromJson(Map<String, dynamic> json) =>
      _$QuestionFromJson(json);

  @override
  final String id;
  @override
  final QuestionType type;
  @override
  final int difficulty;
// 1-10
  @override
  final String topic;
  @override
  final String subtopic;
  @override
  final String question;
// LaTeX formatted
  final List<QuestionOption>? _options;
// LaTeX formatted
  @override
  List<QuestionOption>? get options {
    final value = _options;
    if (value == null) return null;
    if (_options is EqualUnmodifiableListView) return _options;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

// For multiple-choice
  final List<QuestionHint> _hints;
// For multiple-choice
  @override
  @JsonKey()
  List<QuestionHint> get hints {
    if (_hints is EqualUnmodifiableListView) return _hints;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hints);
  }

  @override
  final String solution;
  @override
  final String explanation;
  @override
  final GeoGebraData? geogebra;
  @override
  @JsonKey()
  final bool hasGeoGebraVisualization;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$QuestionCopyWith<_Question> get copyWith =>
      __$QuestionCopyWithImpl<_Question>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$QuestionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _Question &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.subtopic, subtopic) ||
                other.subtopic == subtopic) &&
            (identical(other.question, question) ||
                other.question == question) &&
            const DeepCollectionEquality().equals(other._options, _options) &&
            const DeepCollectionEquality().equals(other._hints, _hints) &&
            (identical(other.solution, solution) ||
                other.solution == solution) &&
            (identical(other.explanation, explanation) ||
                other.explanation == explanation) &&
            (identical(other.geogebra, geogebra) ||
                other.geogebra == geogebra) &&
            (identical(
                    other.hasGeoGebraVisualization, hasGeoGebraVisualization) ||
                other.hasGeoGebraVisualization == hasGeoGebraVisualization));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      type,
      difficulty,
      topic,
      subtopic,
      question,
      const DeepCollectionEquality().hash(_options),
      const DeepCollectionEquality().hash(_hints),
      solution,
      explanation,
      geogebra,
      hasGeoGebraVisualization);

  @override
  String toString() {
    return 'Question(id: $id, type: $type, difficulty: $difficulty, topic: $topic, subtopic: $subtopic, question: $question, options: $options, hints: $hints, solution: $solution, explanation: $explanation, geogebra: $geogebra, hasGeoGebraVisualization: $hasGeoGebraVisualization)';
  }
}

/// @nodoc
abstract mixin class _$QuestionCopyWith<$Res>
    implements $QuestionCopyWith<$Res> {
  factory _$QuestionCopyWith(_Question value, $Res Function(_Question) _then) =
      __$QuestionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      QuestionType type,
      int difficulty,
      String topic,
      String subtopic,
      String question,
      List<QuestionOption>? options,
      List<QuestionHint> hints,
      String solution,
      String explanation,
      GeoGebraData? geogebra,
      bool hasGeoGebraVisualization});

  @override
  $GeoGebraDataCopyWith<$Res>? get geogebra;
}

/// @nodoc
class __$QuestionCopyWithImpl<$Res> implements _$QuestionCopyWith<$Res> {
  __$QuestionCopyWithImpl(this._self, this._then);

  final _Question _self;
  final $Res Function(_Question) _then;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? type = null,
    Object? difficulty = null,
    Object? topic = null,
    Object? subtopic = null,
    Object? question = null,
    Object? options = freezed,
    Object? hints = null,
    Object? solution = null,
    Object? explanation = null,
    Object? geogebra = freezed,
    Object? hasGeoGebraVisualization = null,
  }) {
    return _then(_Question(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _self.type
          : type // ignore: cast_nullable_to_non_nullable
              as QuestionType,
      difficulty: null == difficulty
          ? _self.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
      topic: null == topic
          ? _self.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      subtopic: null == subtopic
          ? _self.subtopic
          : subtopic // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _self.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      options: freezed == options
          ? _self._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<QuestionOption>?,
      hints: null == hints
          ? _self._hints
          : hints // ignore: cast_nullable_to_non_nullable
              as List<QuestionHint>,
      solution: null == solution
          ? _self.solution
          : solution // ignore: cast_nullable_to_non_nullable
              as String,
      explanation: null == explanation
          ? _self.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
      geogebra: freezed == geogebra
          ? _self.geogebra
          : geogebra // ignore: cast_nullable_to_non_nullable
              as GeoGebraData?,
      hasGeoGebraVisualization: null == hasGeoGebraVisualization
          ? _self.hasGeoGebraVisualization
          : hasGeoGebraVisualization // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeoGebraDataCopyWith<$Res>? get geogebra {
    if (_self.geogebra == null) {
      return null;
    }

    return $GeoGebraDataCopyWith<$Res>(_self.geogebra!, (value) {
      return _then(_self.copyWith(geogebra: value));
    });
  }
}

/// @nodoc
mixin _$QuestionOption {
  String get id; // A, B, C, D
  String get text;
  bool get isCorrect;

  /// Create a copy of QuestionOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QuestionOptionCopyWith<QuestionOption> get copyWith =>
      _$QuestionOptionCopyWithImpl<QuestionOption>(
          this as QuestionOption, _$identity);

  /// Serializes this QuestionOption to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QuestionOption &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text, isCorrect);

  @override
  String toString() {
    return 'QuestionOption(id: $id, text: $text, isCorrect: $isCorrect)';
  }
}

/// @nodoc
abstract mixin class $QuestionOptionCopyWith<$Res> {
  factory $QuestionOptionCopyWith(
          QuestionOption value, $Res Function(QuestionOption) _then) =
      _$QuestionOptionCopyWithImpl;
  @useResult
  $Res call({String id, String text, bool isCorrect});
}

/// @nodoc
class _$QuestionOptionCopyWithImpl<$Res>
    implements $QuestionOptionCopyWith<$Res> {
  _$QuestionOptionCopyWithImpl(this._self, this._then);

  final QuestionOption _self;
  final $Res Function(QuestionOption) _then;

  /// Create a copy of QuestionOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? isCorrect = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isCorrect: null == isCorrect
          ? _self.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _QuestionOption implements QuestionOption {
  const _QuestionOption(
      {required this.id, required this.text, this.isCorrect = false});
  factory _QuestionOption.fromJson(Map<String, dynamic> json) =>
      _$QuestionOptionFromJson(json);

  @override
  final String id;
// A, B, C, D
  @override
  final String text;
  @override
  @JsonKey()
  final bool isCorrect;

  /// Create a copy of QuestionOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$QuestionOptionCopyWith<_QuestionOption> get copyWith =>
      __$QuestionOptionCopyWithImpl<_QuestionOption>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$QuestionOptionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _QuestionOption &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text, isCorrect);

  @override
  String toString() {
    return 'QuestionOption(id: $id, text: $text, isCorrect: $isCorrect)';
  }
}

/// @nodoc
abstract mixin class _$QuestionOptionCopyWith<$Res>
    implements $QuestionOptionCopyWith<$Res> {
  factory _$QuestionOptionCopyWith(
          _QuestionOption value, $Res Function(_QuestionOption) _then) =
      __$QuestionOptionCopyWithImpl;
  @override
  @useResult
  $Res call({String id, String text, bool isCorrect});
}

/// @nodoc
class __$QuestionOptionCopyWithImpl<$Res>
    implements _$QuestionOptionCopyWith<$Res> {
  __$QuestionOptionCopyWithImpl(this._self, this._then);

  final _QuestionOption _self;
  final $Res Function(_QuestionOption) _then;

  /// Create a copy of QuestionOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? isCorrect = null,
  }) {
    return _then(_QuestionOption(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isCorrect: null == isCorrect
          ? _self.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
mixin _$QuestionHint {
  int get level; // 1, 2, 3
  String get text;

  /// Create a copy of QuestionHint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QuestionHintCopyWith<QuestionHint> get copyWith =>
      _$QuestionHintCopyWithImpl<QuestionHint>(
          this as QuestionHint, _$identity);

  /// Serializes this QuestionHint to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QuestionHint &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, level, text);

  @override
  String toString() {
    return 'QuestionHint(level: $level, text: $text)';
  }
}

/// @nodoc
abstract mixin class $QuestionHintCopyWith<$Res> {
  factory $QuestionHintCopyWith(
          QuestionHint value, $Res Function(QuestionHint) _then) =
      _$QuestionHintCopyWithImpl;
  @useResult
  $Res call({int level, String text});
}

/// @nodoc
class _$QuestionHintCopyWithImpl<$Res> implements $QuestionHintCopyWith<$Res> {
  _$QuestionHintCopyWithImpl(this._self, this._then);

  final QuestionHint _self;
  final $Res Function(QuestionHint) _then;

  /// Create a copy of QuestionHint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? text = null,
  }) {
    return _then(_self.copyWith(
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _QuestionHint implements QuestionHint {
  const _QuestionHint({required this.level, required this.text});
  factory _QuestionHint.fromJson(Map<String, dynamic> json) =>
      _$QuestionHintFromJson(json);

  @override
  final int level;
// 1, 2, 3
  @override
  final String text;

  /// Create a copy of QuestionHint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$QuestionHintCopyWith<_QuestionHint> get copyWith =>
      __$QuestionHintCopyWithImpl<_QuestionHint>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$QuestionHintToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _QuestionHint &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, level, text);

  @override
  String toString() {
    return 'QuestionHint(level: $level, text: $text)';
  }
}

/// @nodoc
abstract mixin class _$QuestionHintCopyWith<$Res>
    implements $QuestionHintCopyWith<$Res> {
  factory _$QuestionHintCopyWith(
          _QuestionHint value, $Res Function(_QuestionHint) _then) =
      __$QuestionHintCopyWithImpl;
  @override
  @useResult
  $Res call({int level, String text});
}

/// @nodoc
class __$QuestionHintCopyWithImpl<$Res>
    implements _$QuestionHintCopyWith<$Res> {
  __$QuestionHintCopyWithImpl(this._self, this._then);

  final _QuestionHint _self;
  final $Res Function(_QuestionHint) _then;

  /// Create a copy of QuestionHint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? level = null,
    Object? text = null,
  }) {
    return _then(_QuestionHint(
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _self.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$GeoGebraData {
  String? get appletId;
  List<String> get commands;
  String get description;

  /// Create a copy of GeoGebraData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $GeoGebraDataCopyWith<GeoGebraData> get copyWith =>
      _$GeoGebraDataCopyWithImpl<GeoGebraData>(
          this as GeoGebraData, _$identity);

  /// Serializes this GeoGebraData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is GeoGebraData &&
            (identical(other.appletId, appletId) ||
                other.appletId == appletId) &&
            const DeepCollectionEquality().equals(other.commands, commands) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, appletId,
      const DeepCollectionEquality().hash(commands), description);

  @override
  String toString() {
    return 'GeoGebraData(appletId: $appletId, commands: $commands, description: $description)';
  }
}

/// @nodoc
abstract mixin class $GeoGebraDataCopyWith<$Res> {
  factory $GeoGebraDataCopyWith(
          GeoGebraData value, $Res Function(GeoGebraData) _then) =
      _$GeoGebraDataCopyWithImpl;
  @useResult
  $Res call({String? appletId, List<String> commands, String description});
}

/// @nodoc
class _$GeoGebraDataCopyWithImpl<$Res> implements $GeoGebraDataCopyWith<$Res> {
  _$GeoGebraDataCopyWithImpl(this._self, this._then);

  final GeoGebraData _self;
  final $Res Function(GeoGebraData) _then;

  /// Create a copy of GeoGebraData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appletId = freezed,
    Object? commands = null,
    Object? description = null,
  }) {
    return _then(_self.copyWith(
      appletId: freezed == appletId
          ? _self.appletId
          : appletId // ignore: cast_nullable_to_non_nullable
              as String?,
      commands: null == commands
          ? _self.commands
          : commands // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _GeoGebraData implements GeoGebraData {
  const _GeoGebraData(
      {this.appletId,
      final List<String> commands = const [],
      this.description = ''})
      : _commands = commands;
  factory _GeoGebraData.fromJson(Map<String, dynamic> json) =>
      _$GeoGebraDataFromJson(json);

  @override
  final String? appletId;
  final List<String> _commands;
  @override
  @JsonKey()
  List<String> get commands {
    if (_commands is EqualUnmodifiableListView) return _commands;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_commands);
  }

  @override
  @JsonKey()
  final String description;

  /// Create a copy of GeoGebraData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$GeoGebraDataCopyWith<_GeoGebraData> get copyWith =>
      __$GeoGebraDataCopyWithImpl<_GeoGebraData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$GeoGebraDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _GeoGebraData &&
            (identical(other.appletId, appletId) ||
                other.appletId == appletId) &&
            const DeepCollectionEquality().equals(other._commands, _commands) &&
            (identical(other.description, description) ||
                other.description == description));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, appletId,
      const DeepCollectionEquality().hash(_commands), description);

  @override
  String toString() {
    return 'GeoGebraData(appletId: $appletId, commands: $commands, description: $description)';
  }
}

/// @nodoc
abstract mixin class _$GeoGebraDataCopyWith<$Res>
    implements $GeoGebraDataCopyWith<$Res> {
  factory _$GeoGebraDataCopyWith(
          _GeoGebraData value, $Res Function(_GeoGebraData) _then) =
      __$GeoGebraDataCopyWithImpl;
  @override
  @useResult
  $Res call({String? appletId, List<String> commands, String description});
}

/// @nodoc
class __$GeoGebraDataCopyWithImpl<$Res>
    implements _$GeoGebraDataCopyWith<$Res> {
  __$GeoGebraDataCopyWithImpl(this._self, this._then);

  final _GeoGebraData _self;
  final $Res Function(_GeoGebraData) _then;

  /// Create a copy of GeoGebraData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? appletId = freezed,
    Object? commands = null,
    Object? description = null,
  }) {
    return _then(_GeoGebraData(
      appletId: freezed == appletId
          ? _self.appletId
          : appletId // ignore: cast_nullable_to_non_nullable
              as String?,
      commands: null == commands
          ? _self._commands
          : commands // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: null == description
          ? _self.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$QuestionSession {
  String get sessionId;
  int get learningPlanItemId;
  List<TopicData> get topics;
  UserContext get userContext;
  List<Question> get questions;
  int get totalQuestions;
  DateTime get createdAt;

  /// Create a copy of QuestionSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QuestionSessionCopyWith<QuestionSession> get copyWith =>
      _$QuestionSessionCopyWithImpl<QuestionSession>(
          this as QuestionSession, _$identity);

  /// Serializes this QuestionSession to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QuestionSession &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.learningPlanItemId, learningPlanItemId) ||
                other.learningPlanItemId == learningPlanItemId) &&
            const DeepCollectionEquality().equals(other.topics, topics) &&
            (identical(other.userContext, userContext) ||
                other.userContext == userContext) &&
            const DeepCollectionEquality().equals(other.questions, questions) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sessionId,
      learningPlanItemId,
      const DeepCollectionEquality().hash(topics),
      userContext,
      const DeepCollectionEquality().hash(questions),
      totalQuestions,
      createdAt);

  @override
  String toString() {
    return 'QuestionSession(sessionId: $sessionId, learningPlanItemId: $learningPlanItemId, topics: $topics, userContext: $userContext, questions: $questions, totalQuestions: $totalQuestions, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class $QuestionSessionCopyWith<$Res> {
  factory $QuestionSessionCopyWith(
          QuestionSession value, $Res Function(QuestionSession) _then) =
      _$QuestionSessionCopyWithImpl;
  @useResult
  $Res call(
      {String sessionId,
      int learningPlanItemId,
      List<TopicData> topics,
      UserContext userContext,
      List<Question> questions,
      int totalQuestions,
      DateTime createdAt});

  $UserContextCopyWith<$Res> get userContext;
}

/// @nodoc
class _$QuestionSessionCopyWithImpl<$Res>
    implements $QuestionSessionCopyWith<$Res> {
  _$QuestionSessionCopyWithImpl(this._self, this._then);

  final QuestionSession _self;
  final $Res Function(QuestionSession) _then;

  /// Create a copy of QuestionSession
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? sessionId = null,
    Object? learningPlanItemId = null,
    Object? topics = null,
    Object? userContext = null,
    Object? questions = null,
    Object? totalQuestions = null,
    Object? createdAt = null,
  }) {
    return _then(_self.copyWith(
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      learningPlanItemId: null == learningPlanItemId
          ? _self.learningPlanItemId
          : learningPlanItemId // ignore: cast_nullable_to_non_nullable
              as int,
      topics: null == topics
          ? _self.topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<TopicData>,
      userContext: null == userContext
          ? _self.userContext
          : userContext // ignore: cast_nullable_to_non_nullable
              as UserContext,
      questions: null == questions
          ? _self.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<Question>,
      totalQuestions: null == totalQuestions
          ? _self.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of QuestionSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserContextCopyWith<$Res> get userContext {
    return $UserContextCopyWith<$Res>(_self.userContext, (value) {
      return _then(_self.copyWith(userContext: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _QuestionSession implements QuestionSession {
  const _QuestionSession(
      {required this.sessionId,
      required this.learningPlanItemId,
      required final List<TopicData> topics,
      required this.userContext,
      required final List<Question> questions,
      required this.totalQuestions,
      required this.createdAt})
      : _topics = topics,
        _questions = questions;
  factory _QuestionSession.fromJson(Map<String, dynamic> json) =>
      _$QuestionSessionFromJson(json);

  @override
  final String sessionId;
  @override
  final int learningPlanItemId;
  final List<TopicData> _topics;
  @override
  List<TopicData> get topics {
    if (_topics is EqualUnmodifiableListView) return _topics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topics);
  }

  @override
  final UserContext userContext;
  final List<Question> _questions;
  @override
  List<Question> get questions {
    if (_questions is EqualUnmodifiableListView) return _questions;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  final int totalQuestions;
  @override
  final DateTime createdAt;

  /// Create a copy of QuestionSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$QuestionSessionCopyWith<_QuestionSession> get copyWith =>
      __$QuestionSessionCopyWithImpl<_QuestionSession>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$QuestionSessionToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _QuestionSession &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.learningPlanItemId, learningPlanItemId) ||
                other.learningPlanItemId == learningPlanItemId) &&
            const DeepCollectionEquality().equals(other._topics, _topics) &&
            (identical(other.userContext, userContext) ||
                other.userContext == userContext) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions) &&
            (identical(other.totalQuestions, totalQuestions) ||
                other.totalQuestions == totalQuestions) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      sessionId,
      learningPlanItemId,
      const DeepCollectionEquality().hash(_topics),
      userContext,
      const DeepCollectionEquality().hash(_questions),
      totalQuestions,
      createdAt);

  @override
  String toString() {
    return 'QuestionSession(sessionId: $sessionId, learningPlanItemId: $learningPlanItemId, topics: $topics, userContext: $userContext, questions: $questions, totalQuestions: $totalQuestions, createdAt: $createdAt)';
  }
}

/// @nodoc
abstract mixin class _$QuestionSessionCopyWith<$Res>
    implements $QuestionSessionCopyWith<$Res> {
  factory _$QuestionSessionCopyWith(
          _QuestionSession value, $Res Function(_QuestionSession) _then) =
      __$QuestionSessionCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String sessionId,
      int learningPlanItemId,
      List<TopicData> topics,
      UserContext userContext,
      List<Question> questions,
      int totalQuestions,
      DateTime createdAt});

  @override
  $UserContextCopyWith<$Res> get userContext;
}

/// @nodoc
class __$QuestionSessionCopyWithImpl<$Res>
    implements _$QuestionSessionCopyWith<$Res> {
  __$QuestionSessionCopyWithImpl(this._self, this._then);

  final _QuestionSession _self;
  final $Res Function(_QuestionSession) _then;

  /// Create a copy of QuestionSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? sessionId = null,
    Object? learningPlanItemId = null,
    Object? topics = null,
    Object? userContext = null,
    Object? questions = null,
    Object? totalQuestions = null,
    Object? createdAt = null,
  }) {
    return _then(_QuestionSession(
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      learningPlanItemId: null == learningPlanItemId
          ? _self.learningPlanItemId
          : learningPlanItemId // ignore: cast_nullable_to_non_nullable
              as int,
      topics: null == topics
          ? _self._topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<TopicData>,
      userContext: null == userContext
          ? _self.userContext
          : userContext // ignore: cast_nullable_to_non_nullable
              as UserContext,
      questions: null == questions
          ? _self._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<Question>,
      totalQuestions: null == totalQuestions
          ? _self.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: null == createdAt
          ? _self.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }

  /// Create a copy of QuestionSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserContextCopyWith<$Res> get userContext {
    return $UserContextCopyWith<$Res>(_self.userContext, (value) {
      return _then(_self.copyWith(userContext: value));
    });
  }
}

/// @nodoc
mixin _$TopicData {
  String get leitidee;
  String get thema;
  String get unterthema;

  /// Create a copy of TopicData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $TopicDataCopyWith<TopicData> get copyWith =>
      _$TopicDataCopyWithImpl<TopicData>(this as TopicData, _$identity);

  /// Serializes this TopicData to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is TopicData &&
            (identical(other.leitidee, leitidee) ||
                other.leitidee == leitidee) &&
            (identical(other.thema, thema) || other.thema == thema) &&
            (identical(other.unterthema, unterthema) ||
                other.unterthema == unterthema));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, leitidee, thema, unterthema);

  @override
  String toString() {
    return 'TopicData(leitidee: $leitidee, thema: $thema, unterthema: $unterthema)';
  }
}

/// @nodoc
abstract mixin class $TopicDataCopyWith<$Res> {
  factory $TopicDataCopyWith(TopicData value, $Res Function(TopicData) _then) =
      _$TopicDataCopyWithImpl;
  @useResult
  $Res call({String leitidee, String thema, String unterthema});
}

/// @nodoc
class _$TopicDataCopyWithImpl<$Res> implements $TopicDataCopyWith<$Res> {
  _$TopicDataCopyWithImpl(this._self, this._then);

  final TopicData _self;
  final $Res Function(TopicData) _then;

  /// Create a copy of TopicData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leitidee = null,
    Object? thema = null,
    Object? unterthema = null,
  }) {
    return _then(_self.copyWith(
      leitidee: null == leitidee
          ? _self.leitidee
          : leitidee // ignore: cast_nullable_to_non_nullable
              as String,
      thema: null == thema
          ? _self.thema
          : thema // ignore: cast_nullable_to_non_nullable
              as String,
      unterthema: null == unterthema
          ? _self.unterthema
          : unterthema // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _TopicData implements TopicData {
  const _TopicData(
      {required this.leitidee, required this.thema, required this.unterthema});
  factory _TopicData.fromJson(Map<String, dynamic> json) =>
      _$TopicDataFromJson(json);

  @override
  final String leitidee;
  @override
  final String thema;
  @override
  final String unterthema;

  /// Create a copy of TopicData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$TopicDataCopyWith<_TopicData> get copyWith =>
      __$TopicDataCopyWithImpl<_TopicData>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$TopicDataToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _TopicData &&
            (identical(other.leitidee, leitidee) ||
                other.leitidee == leitidee) &&
            (identical(other.thema, thema) || other.thema == thema) &&
            (identical(other.unterthema, unterthema) ||
                other.unterthema == unterthema));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, leitidee, thema, unterthema);

  @override
  String toString() {
    return 'TopicData(leitidee: $leitidee, thema: $thema, unterthema: $unterthema)';
  }
}

/// @nodoc
abstract mixin class _$TopicDataCopyWith<$Res>
    implements $TopicDataCopyWith<$Res> {
  factory _$TopicDataCopyWith(
          _TopicData value, $Res Function(_TopicData) _then) =
      __$TopicDataCopyWithImpl;
  @override
  @useResult
  $Res call({String leitidee, String thema, String unterthema});
}

/// @nodoc
class __$TopicDataCopyWithImpl<$Res> implements _$TopicDataCopyWith<$Res> {
  __$TopicDataCopyWithImpl(this._self, this._then);

  final _TopicData _self;
  final $Res Function(_TopicData) _then;

  /// Create a copy of TopicData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? leitidee = null,
    Object? thema = null,
    Object? unterthema = null,
  }) {
    return _then(_TopicData(
      leitidee: null == leitidee
          ? _self.leitidee
          : leitidee // ignore: cast_nullable_to_non_nullable
              as String,
      thema: null == thema
          ? _self.thema
          : thema // ignore: cast_nullable_to_non_nullable
              as String,
      unterthema: null == unterthema
          ? _self.unterthema
          : unterthema // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$UserContext {
  String get gradeLevel;
  String get courseType;

  /// Create a copy of UserContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserContextCopyWith<UserContext> get copyWith =>
      _$UserContextCopyWithImpl<UserContext>(this as UserContext, _$identity);

  /// Serializes this UserContext to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserContext &&
            (identical(other.gradeLevel, gradeLevel) ||
                other.gradeLevel == gradeLevel) &&
            (identical(other.courseType, courseType) ||
                other.courseType == courseType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, gradeLevel, courseType);

  @override
  String toString() {
    return 'UserContext(gradeLevel: $gradeLevel, courseType: $courseType)';
  }
}

/// @nodoc
abstract mixin class $UserContextCopyWith<$Res> {
  factory $UserContextCopyWith(
          UserContext value, $Res Function(UserContext) _then) =
      _$UserContextCopyWithImpl;
  @useResult
  $Res call({String gradeLevel, String courseType});
}

/// @nodoc
class _$UserContextCopyWithImpl<$Res> implements $UserContextCopyWith<$Res> {
  _$UserContextCopyWithImpl(this._self, this._then);

  final UserContext _self;
  final $Res Function(UserContext) _then;

  /// Create a copy of UserContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gradeLevel = null,
    Object? courseType = null,
  }) {
    return _then(_self.copyWith(
      gradeLevel: null == gradeLevel
          ? _self.gradeLevel
          : gradeLevel // ignore: cast_nullable_to_non_nullable
              as String,
      courseType: null == courseType
          ? _self.courseType
          : courseType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _UserContext implements UserContext {
  const _UserContext({required this.gradeLevel, required this.courseType});
  factory _UserContext.fromJson(Map<String, dynamic> json) =>
      _$UserContextFromJson(json);

  @override
  final String gradeLevel;
  @override
  final String courseType;

  /// Create a copy of UserContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserContextCopyWith<_UserContext> get copyWith =>
      __$UserContextCopyWithImpl<_UserContext>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserContextToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserContext &&
            (identical(other.gradeLevel, gradeLevel) ||
                other.gradeLevel == gradeLevel) &&
            (identical(other.courseType, courseType) ||
                other.courseType == courseType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, gradeLevel, courseType);

  @override
  String toString() {
    return 'UserContext(gradeLevel: $gradeLevel, courseType: $courseType)';
  }
}

/// @nodoc
abstract mixin class _$UserContextCopyWith<$Res>
    implements $UserContextCopyWith<$Res> {
  factory _$UserContextCopyWith(
          _UserContext value, $Res Function(_UserContext) _then) =
      __$UserContextCopyWithImpl;
  @override
  @useResult
  $Res call({String gradeLevel, String courseType});
}

/// @nodoc
class __$UserContextCopyWithImpl<$Res> implements _$UserContextCopyWith<$Res> {
  __$UserContextCopyWithImpl(this._self, this._then);

  final _UserContext _self;
  final $Res Function(_UserContext) _then;

  /// Create a copy of UserContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? gradeLevel = null,
    Object? courseType = null,
  }) {
    return _then(_UserContext(
      gradeLevel: null == gradeLevel
          ? _self.gradeLevel
          : gradeLevel // ignore: cast_nullable_to_non_nullable
              as String,
      courseType: null == courseType
          ? _self.courseType
          : courseType // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$QuestionProgress {
  String get questionId;
  String get sessionId;
  DateTime get startedAt;
  DateTime? get completedAt;
  QuestionStatus get status;
  int get hintsUsed;
  List<HintUsageDetail> get hintsUsedDetails;
  bool get isCorrect;
  String? get userAnswer;
  int get timeSpent; // seconds
  int get xpEarned;
  XPBreakdown? get xpBreakdown;
  String get topic;
  int get difficulty;

  /// Create a copy of QuestionProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $QuestionProgressCopyWith<QuestionProgress> get copyWith =>
      _$QuestionProgressCopyWithImpl<QuestionProgress>(
          this as QuestionProgress, _$identity);

  /// Serializes this QuestionProgress to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is QuestionProgress &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.hintsUsed, hintsUsed) ||
                other.hintsUsed == hintsUsed) &&
            const DeepCollectionEquality()
                .equals(other.hintsUsedDetails, hintsUsedDetails) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.userAnswer, userAnswer) ||
                other.userAnswer == userAnswer) &&
            (identical(other.timeSpent, timeSpent) ||
                other.timeSpent == timeSpent) &&
            (identical(other.xpEarned, xpEarned) ||
                other.xpEarned == xpEarned) &&
            (identical(other.xpBreakdown, xpBreakdown) ||
                other.xpBreakdown == xpBreakdown) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      questionId,
      sessionId,
      startedAt,
      completedAt,
      status,
      hintsUsed,
      const DeepCollectionEquality().hash(hintsUsedDetails),
      isCorrect,
      userAnswer,
      timeSpent,
      xpEarned,
      xpBreakdown,
      topic,
      difficulty);

  @override
  String toString() {
    return 'QuestionProgress(questionId: $questionId, sessionId: $sessionId, startedAt: $startedAt, completedAt: $completedAt, status: $status, hintsUsed: $hintsUsed, hintsUsedDetails: $hintsUsedDetails, isCorrect: $isCorrect, userAnswer: $userAnswer, timeSpent: $timeSpent, xpEarned: $xpEarned, xpBreakdown: $xpBreakdown, topic: $topic, difficulty: $difficulty)';
  }
}

/// @nodoc
abstract mixin class $QuestionProgressCopyWith<$Res> {
  factory $QuestionProgressCopyWith(
          QuestionProgress value, $Res Function(QuestionProgress) _then) =
      _$QuestionProgressCopyWithImpl;
  @useResult
  $Res call(
      {String questionId,
      String sessionId,
      DateTime startedAt,
      DateTime? completedAt,
      QuestionStatus status,
      int hintsUsed,
      List<HintUsageDetail> hintsUsedDetails,
      bool isCorrect,
      String? userAnswer,
      int timeSpent,
      int xpEarned,
      XPBreakdown? xpBreakdown,
      String topic,
      int difficulty});

  $XPBreakdownCopyWith<$Res>? get xpBreakdown;
}

/// @nodoc
class _$QuestionProgressCopyWithImpl<$Res>
    implements $QuestionProgressCopyWith<$Res> {
  _$QuestionProgressCopyWithImpl(this._self, this._then);

  final QuestionProgress _self;
  final $Res Function(QuestionProgress) _then;

  /// Create a copy of QuestionProgress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? questionId = null,
    Object? sessionId = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? status = null,
    Object? hintsUsed = null,
    Object? hintsUsedDetails = null,
    Object? isCorrect = null,
    Object? userAnswer = freezed,
    Object? timeSpent = null,
    Object? xpEarned = null,
    Object? xpBreakdown = freezed,
    Object? topic = null,
    Object? difficulty = null,
  }) {
    return _then(_self.copyWith(
      questionId: null == questionId
          ? _self.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _self.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuestionStatus,
      hintsUsed: null == hintsUsed
          ? _self.hintsUsed
          : hintsUsed // ignore: cast_nullable_to_non_nullable
              as int,
      hintsUsedDetails: null == hintsUsedDetails
          ? _self.hintsUsedDetails
          : hintsUsedDetails // ignore: cast_nullable_to_non_nullable
              as List<HintUsageDetail>,
      isCorrect: null == isCorrect
          ? _self.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      userAnswer: freezed == userAnswer
          ? _self.userAnswer
          : userAnswer // ignore: cast_nullable_to_non_nullable
              as String?,
      timeSpent: null == timeSpent
          ? _self.timeSpent
          : timeSpent // ignore: cast_nullable_to_non_nullable
              as int,
      xpEarned: null == xpEarned
          ? _self.xpEarned
          : xpEarned // ignore: cast_nullable_to_non_nullable
              as int,
      xpBreakdown: freezed == xpBreakdown
          ? _self.xpBreakdown
          : xpBreakdown // ignore: cast_nullable_to_non_nullable
              as XPBreakdown?,
      topic: null == topic
          ? _self.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _self.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of QuestionProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $XPBreakdownCopyWith<$Res>? get xpBreakdown {
    if (_self.xpBreakdown == null) {
      return null;
    }

    return $XPBreakdownCopyWith<$Res>(_self.xpBreakdown!, (value) {
      return _then(_self.copyWith(xpBreakdown: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _QuestionProgress implements QuestionProgress {
  const _QuestionProgress(
      {required this.questionId,
      required this.sessionId,
      required this.startedAt,
      this.completedAt,
      required this.status,
      this.hintsUsed = 0,
      final List<HintUsageDetail> hintsUsedDetails = const [],
      this.isCorrect = false,
      this.userAnswer,
      this.timeSpent = 0,
      this.xpEarned = 0,
      this.xpBreakdown,
      required this.topic,
      required this.difficulty})
      : _hintsUsedDetails = hintsUsedDetails;
  factory _QuestionProgress.fromJson(Map<String, dynamic> json) =>
      _$QuestionProgressFromJson(json);

  @override
  final String questionId;
  @override
  final String sessionId;
  @override
  final DateTime startedAt;
  @override
  final DateTime? completedAt;
  @override
  final QuestionStatus status;
  @override
  @JsonKey()
  final int hintsUsed;
  final List<HintUsageDetail> _hintsUsedDetails;
  @override
  @JsonKey()
  List<HintUsageDetail> get hintsUsedDetails {
    if (_hintsUsedDetails is EqualUnmodifiableListView)
      return _hintsUsedDetails;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_hintsUsedDetails);
  }

  @override
  @JsonKey()
  final bool isCorrect;
  @override
  final String? userAnswer;
  @override
  @JsonKey()
  final int timeSpent;
// seconds
  @override
  @JsonKey()
  final int xpEarned;
  @override
  final XPBreakdown? xpBreakdown;
  @override
  final String topic;
  @override
  final int difficulty;

  /// Create a copy of QuestionProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$QuestionProgressCopyWith<_QuestionProgress> get copyWith =>
      __$QuestionProgressCopyWithImpl<_QuestionProgress>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$QuestionProgressToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _QuestionProgress &&
            (identical(other.questionId, questionId) ||
                other.questionId == questionId) &&
            (identical(other.sessionId, sessionId) ||
                other.sessionId == sessionId) &&
            (identical(other.startedAt, startedAt) ||
                other.startedAt == startedAt) &&
            (identical(other.completedAt, completedAt) ||
                other.completedAt == completedAt) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.hintsUsed, hintsUsed) ||
                other.hintsUsed == hintsUsed) &&
            const DeepCollectionEquality()
                .equals(other._hintsUsedDetails, _hintsUsedDetails) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect) &&
            (identical(other.userAnswer, userAnswer) ||
                other.userAnswer == userAnswer) &&
            (identical(other.timeSpent, timeSpent) ||
                other.timeSpent == timeSpent) &&
            (identical(other.xpEarned, xpEarned) ||
                other.xpEarned == xpEarned) &&
            (identical(other.xpBreakdown, xpBreakdown) ||
                other.xpBreakdown == xpBreakdown) &&
            (identical(other.topic, topic) || other.topic == topic) &&
            (identical(other.difficulty, difficulty) ||
                other.difficulty == difficulty));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      questionId,
      sessionId,
      startedAt,
      completedAt,
      status,
      hintsUsed,
      const DeepCollectionEquality().hash(_hintsUsedDetails),
      isCorrect,
      userAnswer,
      timeSpent,
      xpEarned,
      xpBreakdown,
      topic,
      difficulty);

  @override
  String toString() {
    return 'QuestionProgress(questionId: $questionId, sessionId: $sessionId, startedAt: $startedAt, completedAt: $completedAt, status: $status, hintsUsed: $hintsUsed, hintsUsedDetails: $hintsUsedDetails, isCorrect: $isCorrect, userAnswer: $userAnswer, timeSpent: $timeSpent, xpEarned: $xpEarned, xpBreakdown: $xpBreakdown, topic: $topic, difficulty: $difficulty)';
  }
}

/// @nodoc
abstract mixin class _$QuestionProgressCopyWith<$Res>
    implements $QuestionProgressCopyWith<$Res> {
  factory _$QuestionProgressCopyWith(
          _QuestionProgress value, $Res Function(_QuestionProgress) _then) =
      __$QuestionProgressCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String questionId,
      String sessionId,
      DateTime startedAt,
      DateTime? completedAt,
      QuestionStatus status,
      int hintsUsed,
      List<HintUsageDetail> hintsUsedDetails,
      bool isCorrect,
      String? userAnswer,
      int timeSpent,
      int xpEarned,
      XPBreakdown? xpBreakdown,
      String topic,
      int difficulty});

  @override
  $XPBreakdownCopyWith<$Res>? get xpBreakdown;
}

/// @nodoc
class __$QuestionProgressCopyWithImpl<$Res>
    implements _$QuestionProgressCopyWith<$Res> {
  __$QuestionProgressCopyWithImpl(this._self, this._then);

  final _QuestionProgress _self;
  final $Res Function(_QuestionProgress) _then;

  /// Create a copy of QuestionProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? questionId = null,
    Object? sessionId = null,
    Object? startedAt = null,
    Object? completedAt = freezed,
    Object? status = null,
    Object? hintsUsed = null,
    Object? hintsUsedDetails = null,
    Object? isCorrect = null,
    Object? userAnswer = freezed,
    Object? timeSpent = null,
    Object? xpEarned = null,
    Object? xpBreakdown = freezed,
    Object? topic = null,
    Object? difficulty = null,
  }) {
    return _then(_QuestionProgress(
      questionId: null == questionId
          ? _self.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _self.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _self.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _self.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _self.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuestionStatus,
      hintsUsed: null == hintsUsed
          ? _self.hintsUsed
          : hintsUsed // ignore: cast_nullable_to_non_nullable
              as int,
      hintsUsedDetails: null == hintsUsedDetails
          ? _self._hintsUsedDetails
          : hintsUsedDetails // ignore: cast_nullable_to_non_nullable
              as List<HintUsageDetail>,
      isCorrect: null == isCorrect
          ? _self.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      userAnswer: freezed == userAnswer
          ? _self.userAnswer
          : userAnswer // ignore: cast_nullable_to_non_nullable
              as String?,
      timeSpent: null == timeSpent
          ? _self.timeSpent
          : timeSpent // ignore: cast_nullable_to_non_nullable
              as int,
      xpEarned: null == xpEarned
          ? _self.xpEarned
          : xpEarned // ignore: cast_nullable_to_non_nullable
              as int,
      xpBreakdown: freezed == xpBreakdown
          ? _self.xpBreakdown
          : xpBreakdown // ignore: cast_nullable_to_non_nullable
              as XPBreakdown?,
      topic: null == topic
          ? _self.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _self.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  /// Create a copy of QuestionProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $XPBreakdownCopyWith<$Res>? get xpBreakdown {
    if (_self.xpBreakdown == null) {
      return null;
    }

    return $XPBreakdownCopyWith<$Res>(_self.xpBreakdown!, (value) {
      return _then(_self.copyWith(xpBreakdown: value));
    });
  }
}

/// @nodoc
mixin _$HintUsageDetail {
  int get level; // 1-3
  DateTime get usedAt;

  /// Create a copy of HintUsageDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $HintUsageDetailCopyWith<HintUsageDetail> get copyWith =>
      _$HintUsageDetailCopyWithImpl<HintUsageDetail>(
          this as HintUsageDetail, _$identity);

  /// Serializes this HintUsageDetail to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is HintUsageDetail &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.usedAt, usedAt) || other.usedAt == usedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, level, usedAt);

  @override
  String toString() {
    return 'HintUsageDetail(level: $level, usedAt: $usedAt)';
  }
}

/// @nodoc
abstract mixin class $HintUsageDetailCopyWith<$Res> {
  factory $HintUsageDetailCopyWith(
          HintUsageDetail value, $Res Function(HintUsageDetail) _then) =
      _$HintUsageDetailCopyWithImpl;
  @useResult
  $Res call({int level, DateTime usedAt});
}

/// @nodoc
class _$HintUsageDetailCopyWithImpl<$Res>
    implements $HintUsageDetailCopyWith<$Res> {
  _$HintUsageDetailCopyWithImpl(this._self, this._then);

  final HintUsageDetail _self;
  final $Res Function(HintUsageDetail) _then;

  /// Create a copy of HintUsageDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? usedAt = null,
  }) {
    return _then(_self.copyWith(
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      usedAt: null == usedAt
          ? _self.usedAt
          : usedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _HintUsageDetail implements HintUsageDetail {
  const _HintUsageDetail({required this.level, required this.usedAt});
  factory _HintUsageDetail.fromJson(Map<String, dynamic> json) =>
      _$HintUsageDetailFromJson(json);

  @override
  final int level;
// 1-3
  @override
  final DateTime usedAt;

  /// Create a copy of HintUsageDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$HintUsageDetailCopyWith<_HintUsageDetail> get copyWith =>
      __$HintUsageDetailCopyWithImpl<_HintUsageDetail>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$HintUsageDetailToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _HintUsageDetail &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.usedAt, usedAt) || other.usedAt == usedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, level, usedAt);

  @override
  String toString() {
    return 'HintUsageDetail(level: $level, usedAt: $usedAt)';
  }
}

/// @nodoc
abstract mixin class _$HintUsageDetailCopyWith<$Res>
    implements $HintUsageDetailCopyWith<$Res> {
  factory _$HintUsageDetailCopyWith(
          _HintUsageDetail value, $Res Function(_HintUsageDetail) _then) =
      __$HintUsageDetailCopyWithImpl;
  @override
  @useResult
  $Res call({int level, DateTime usedAt});
}

/// @nodoc
class __$HintUsageDetailCopyWithImpl<$Res>
    implements _$HintUsageDetailCopyWith<$Res> {
  __$HintUsageDetailCopyWithImpl(this._self, this._then);

  final _HintUsageDetail _self;
  final $Res Function(_HintUsageDetail) _then;

  /// Create a copy of HintUsageDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? level = null,
    Object? usedAt = null,
  }) {
    return _then(_HintUsageDetail(
      level: null == level
          ? _self.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      usedAt: null == usedAt
          ? _self.usedAt
          : usedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
mixin _$XPBreakdown {
  int get base;
  int get hintPenalty;
  int get timeBonus;
  int get streakBonus;

  /// Create a copy of XPBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $XPBreakdownCopyWith<XPBreakdown> get copyWith =>
      _$XPBreakdownCopyWithImpl<XPBreakdown>(this as XPBreakdown, _$identity);

  /// Serializes this XPBreakdown to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is XPBreakdown &&
            (identical(other.base, base) || other.base == base) &&
            (identical(other.hintPenalty, hintPenalty) ||
                other.hintPenalty == hintPenalty) &&
            (identical(other.timeBonus, timeBonus) ||
                other.timeBonus == timeBonus) &&
            (identical(other.streakBonus, streakBonus) ||
                other.streakBonus == streakBonus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, base, hintPenalty, timeBonus, streakBonus);

  @override
  String toString() {
    return 'XPBreakdown(base: $base, hintPenalty: $hintPenalty, timeBonus: $timeBonus, streakBonus: $streakBonus)';
  }
}

/// @nodoc
abstract mixin class $XPBreakdownCopyWith<$Res> {
  factory $XPBreakdownCopyWith(
          XPBreakdown value, $Res Function(XPBreakdown) _then) =
      _$XPBreakdownCopyWithImpl;
  @useResult
  $Res call({int base, int hintPenalty, int timeBonus, int streakBonus});
}

/// @nodoc
class _$XPBreakdownCopyWithImpl<$Res> implements $XPBreakdownCopyWith<$Res> {
  _$XPBreakdownCopyWithImpl(this._self, this._then);

  final XPBreakdown _self;
  final $Res Function(XPBreakdown) _then;

  /// Create a copy of XPBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? base = null,
    Object? hintPenalty = null,
    Object? timeBonus = null,
    Object? streakBonus = null,
  }) {
    return _then(_self.copyWith(
      base: null == base
          ? _self.base
          : base // ignore: cast_nullable_to_non_nullable
              as int,
      hintPenalty: null == hintPenalty
          ? _self.hintPenalty
          : hintPenalty // ignore: cast_nullable_to_non_nullable
              as int,
      timeBonus: null == timeBonus
          ? _self.timeBonus
          : timeBonus // ignore: cast_nullable_to_non_nullable
              as int,
      streakBonus: null == streakBonus
          ? _self.streakBonus
          : streakBonus // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _XPBreakdown implements XPBreakdown {
  const _XPBreakdown(
      {required this.base,
      required this.hintPenalty,
      required this.timeBonus,
      required this.streakBonus});
  factory _XPBreakdown.fromJson(Map<String, dynamic> json) =>
      _$XPBreakdownFromJson(json);

  @override
  final int base;
  @override
  final int hintPenalty;
  @override
  final int timeBonus;
  @override
  final int streakBonus;

  /// Create a copy of XPBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$XPBreakdownCopyWith<_XPBreakdown> get copyWith =>
      __$XPBreakdownCopyWithImpl<_XPBreakdown>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$XPBreakdownToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _XPBreakdown &&
            (identical(other.base, base) || other.base == base) &&
            (identical(other.hintPenalty, hintPenalty) ||
                other.hintPenalty == hintPenalty) &&
            (identical(other.timeBonus, timeBonus) ||
                other.timeBonus == timeBonus) &&
            (identical(other.streakBonus, streakBonus) ||
                other.streakBonus == streakBonus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, base, hintPenalty, timeBonus, streakBonus);

  @override
  String toString() {
    return 'XPBreakdown(base: $base, hintPenalty: $hintPenalty, timeBonus: $timeBonus, streakBonus: $streakBonus)';
  }
}

/// @nodoc
abstract mixin class _$XPBreakdownCopyWith<$Res>
    implements $XPBreakdownCopyWith<$Res> {
  factory _$XPBreakdownCopyWith(
          _XPBreakdown value, $Res Function(_XPBreakdown) _then) =
      __$XPBreakdownCopyWithImpl;
  @override
  @useResult
  $Res call({int base, int hintPenalty, int timeBonus, int streakBonus});
}

/// @nodoc
class __$XPBreakdownCopyWithImpl<$Res> implements _$XPBreakdownCopyWith<$Res> {
  __$XPBreakdownCopyWithImpl(this._self, this._then);

  final _XPBreakdown _self;
  final $Res Function(_XPBreakdown) _then;

  /// Create a copy of XPBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? base = null,
    Object? hintPenalty = null,
    Object? timeBonus = null,
    Object? streakBonus = null,
  }) {
    return _then(_XPBreakdown(
      base: null == base
          ? _self.base
          : base // ignore: cast_nullable_to_non_nullable
              as int,
      hintPenalty: null == hintPenalty
          ? _self.hintPenalty
          : hintPenalty // ignore: cast_nullable_to_non_nullable
              as int,
      timeBonus: null == timeBonus
          ? _self.timeBonus
          : timeBonus // ignore: cast_nullable_to_non_nullable
              as int,
      streakBonus: null == streakBonus
          ? _self.streakBonus
          : streakBonus // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
