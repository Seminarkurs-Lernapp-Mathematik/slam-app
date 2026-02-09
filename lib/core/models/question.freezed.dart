// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'question.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Question _$QuestionFromJson(Map<String, dynamic> json) {
  return _Question.fromJson(json);
}

/// @nodoc
mixin _$Question {
  String get id => throw _privateConstructorUsedError;
  QuestionType get type => throw _privateConstructorUsedError;
  int get difficulty => throw _privateConstructorUsedError; // 1-10
  String get topic => throw _privateConstructorUsedError;
  String get subtopic => throw _privateConstructorUsedError;
  String get question => throw _privateConstructorUsedError; // LaTeX formatted
  List<QuestionOption>? get options =>
      throw _privateConstructorUsedError; // For multiple-choice
  List<QuestionHint> get hints => throw _privateConstructorUsedError;
  String get solution => throw _privateConstructorUsedError;
  String get explanation => throw _privateConstructorUsedError;
  GeoGebraData? get geogebra => throw _privateConstructorUsedError;
  bool get hasGeoGebraVisualization => throw _privateConstructorUsedError;

  /// Serializes this Question to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionCopyWith<Question> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionCopyWith<$Res> {
  factory $QuestionCopyWith(Question value, $Res Function(Question) then) =
      _$QuestionCopyWithImpl<$Res, Question>;
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
class _$QuestionCopyWithImpl<$Res, $Val extends Question>
    implements $QuestionCopyWith<$Res> {
  _$QuestionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as QuestionType,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      subtopic: null == subtopic
          ? _value.subtopic
          : subtopic // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      options: freezed == options
          ? _value.options
          : options // ignore: cast_nullable_to_non_nullable
              as List<QuestionOption>?,
      hints: null == hints
          ? _value.hints
          : hints // ignore: cast_nullable_to_non_nullable
              as List<QuestionHint>,
      solution: null == solution
          ? _value.solution
          : solution // ignore: cast_nullable_to_non_nullable
              as String,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
      geogebra: freezed == geogebra
          ? _value.geogebra
          : geogebra // ignore: cast_nullable_to_non_nullable
              as GeoGebraData?,
      hasGeoGebraVisualization: null == hasGeoGebraVisualization
          ? _value.hasGeoGebraVisualization
          : hasGeoGebraVisualization // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $GeoGebraDataCopyWith<$Res>? get geogebra {
    if (_value.geogebra == null) {
      return null;
    }

    return $GeoGebraDataCopyWith<$Res>(_value.geogebra!, (value) {
      return _then(_value.copyWith(geogebra: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuestionImplCopyWith<$Res>
    implements $QuestionCopyWith<$Res> {
  factory _$$QuestionImplCopyWith(
          _$QuestionImpl value, $Res Function(_$QuestionImpl) then) =
      __$$QuestionImplCopyWithImpl<$Res>;
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
class __$$QuestionImplCopyWithImpl<$Res>
    extends _$QuestionCopyWithImpl<$Res, _$QuestionImpl>
    implements _$$QuestionImplCopyWith<$Res> {
  __$$QuestionImplCopyWithImpl(
      _$QuestionImpl _value, $Res Function(_$QuestionImpl) _then)
      : super(_value, _then);

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
    return _then(_$QuestionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as QuestionType,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      subtopic: null == subtopic
          ? _value.subtopic
          : subtopic // ignore: cast_nullable_to_non_nullable
              as String,
      question: null == question
          ? _value.question
          : question // ignore: cast_nullable_to_non_nullable
              as String,
      options: freezed == options
          ? _value._options
          : options // ignore: cast_nullable_to_non_nullable
              as List<QuestionOption>?,
      hints: null == hints
          ? _value._hints
          : hints // ignore: cast_nullable_to_non_nullable
              as List<QuestionHint>,
      solution: null == solution
          ? _value.solution
          : solution // ignore: cast_nullable_to_non_nullable
              as String,
      explanation: null == explanation
          ? _value.explanation
          : explanation // ignore: cast_nullable_to_non_nullable
              as String,
      geogebra: freezed == geogebra
          ? _value.geogebra
          : geogebra // ignore: cast_nullable_to_non_nullable
              as GeoGebraData?,
      hasGeoGebraVisualization: null == hasGeoGebraVisualization
          ? _value.hasGeoGebraVisualization
          : hasGeoGebraVisualization // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionImpl extends _Question {
  const _$QuestionImpl(
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
        _hints = hints,
        super._();

  factory _$QuestionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionImplFromJson(json);

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

  @override
  String toString() {
    return 'Question(id: $id, type: $type, difficulty: $difficulty, topic: $topic, subtopic: $subtopic, question: $question, options: $options, hints: $hints, solution: $solution, explanation: $explanation, geogebra: $geogebra, hasGeoGebraVisualization: $hasGeoGebraVisualization)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionImpl &&
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

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionImplCopyWith<_$QuestionImpl> get copyWith =>
      __$$QuestionImplCopyWithImpl<_$QuestionImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionImplToJson(
      this,
    );
  }
}

abstract class _Question extends Question {
  const factory _Question(
      {required final String id,
      required final QuestionType type,
      required final int difficulty,
      required final String topic,
      required final String subtopic,
      required final String question,
      final List<QuestionOption>? options,
      final List<QuestionHint> hints,
      required final String solution,
      required final String explanation,
      final GeoGebraData? geogebra,
      final bool hasGeoGebraVisualization}) = _$QuestionImpl;
  const _Question._() : super._();

  factory _Question.fromJson(Map<String, dynamic> json) =
      _$QuestionImpl.fromJson;

  @override
  String get id;
  @override
  QuestionType get type;
  @override
  int get difficulty; // 1-10
  @override
  String get topic;
  @override
  String get subtopic;
  @override
  String get question; // LaTeX formatted
  @override
  List<QuestionOption>? get options; // For multiple-choice
  @override
  List<QuestionHint> get hints;
  @override
  String get solution;
  @override
  String get explanation;
  @override
  GeoGebraData? get geogebra;
  @override
  bool get hasGeoGebraVisualization;

  /// Create a copy of Question
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionImplCopyWith<_$QuestionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuestionOption _$QuestionOptionFromJson(Map<String, dynamic> json) {
  return _QuestionOption.fromJson(json);
}

/// @nodoc
mixin _$QuestionOption {
  String get id => throw _privateConstructorUsedError; // A, B, C, D
  String get text => throw _privateConstructorUsedError;
  bool get isCorrect => throw _privateConstructorUsedError;

  /// Serializes this QuestionOption to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestionOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionOptionCopyWith<QuestionOption> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionOptionCopyWith<$Res> {
  factory $QuestionOptionCopyWith(
          QuestionOption value, $Res Function(QuestionOption) then) =
      _$QuestionOptionCopyWithImpl<$Res, QuestionOption>;
  @useResult
  $Res call({String id, String text, bool isCorrect});
}

/// @nodoc
class _$QuestionOptionCopyWithImpl<$Res, $Val extends QuestionOption>
    implements $QuestionOptionCopyWith<$Res> {
  _$QuestionOptionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? isCorrect = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionOptionImplCopyWith<$Res>
    implements $QuestionOptionCopyWith<$Res> {
  factory _$$QuestionOptionImplCopyWith(_$QuestionOptionImpl value,
          $Res Function(_$QuestionOptionImpl) then) =
      __$$QuestionOptionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String text, bool isCorrect});
}

/// @nodoc
class __$$QuestionOptionImplCopyWithImpl<$Res>
    extends _$QuestionOptionCopyWithImpl<$Res, _$QuestionOptionImpl>
    implements _$$QuestionOptionImplCopyWith<$Res> {
  __$$QuestionOptionImplCopyWithImpl(
      _$QuestionOptionImpl _value, $Res Function(_$QuestionOptionImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuestionOption
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? text = null,
    Object? isCorrect = null,
  }) {
    return _then(_$QuestionOptionImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionOptionImpl extends _QuestionOption {
  const _$QuestionOptionImpl(
      {required this.id, required this.text, this.isCorrect = false})
      : super._();

  factory _$QuestionOptionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionOptionImplFromJson(json);

  @override
  final String id;
// A, B, C, D
  @override
  final String text;
  @override
  @JsonKey()
  final bool isCorrect;

  @override
  String toString() {
    return 'QuestionOption(id: $id, text: $text, isCorrect: $isCorrect)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionOptionImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.text, text) || other.text == text) &&
            (identical(other.isCorrect, isCorrect) ||
                other.isCorrect == isCorrect));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, text, isCorrect);

  /// Create a copy of QuestionOption
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionOptionImplCopyWith<_$QuestionOptionImpl> get copyWith =>
      __$$QuestionOptionImplCopyWithImpl<_$QuestionOptionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionOptionImplToJson(
      this,
    );
  }
}

abstract class _QuestionOption extends QuestionOption {
  const factory _QuestionOption(
      {required final String id,
      required final String text,
      final bool isCorrect}) = _$QuestionOptionImpl;
  const _QuestionOption._() : super._();

  factory _QuestionOption.fromJson(Map<String, dynamic> json) =
      _$QuestionOptionImpl.fromJson;

  @override
  String get id; // A, B, C, D
  @override
  String get text;
  @override
  bool get isCorrect;

  /// Create a copy of QuestionOption
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionOptionImplCopyWith<_$QuestionOptionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuestionHint _$QuestionHintFromJson(Map<String, dynamic> json) {
  return _QuestionHint.fromJson(json);
}

/// @nodoc
mixin _$QuestionHint {
  int get level => throw _privateConstructorUsedError; // 1, 2, 3
  String get text => throw _privateConstructorUsedError;

  /// Serializes this QuestionHint to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestionHint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionHintCopyWith<QuestionHint> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionHintCopyWith<$Res> {
  factory $QuestionHintCopyWith(
          QuestionHint value, $Res Function(QuestionHint) then) =
      _$QuestionHintCopyWithImpl<$Res, QuestionHint>;
  @useResult
  $Res call({int level, String text});
}

/// @nodoc
class _$QuestionHintCopyWithImpl<$Res, $Val extends QuestionHint>
    implements $QuestionHintCopyWith<$Res> {
  _$QuestionHintCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of QuestionHint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? text = null,
  }) {
    return _then(_value.copyWith(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$QuestionHintImplCopyWith<$Res>
    implements $QuestionHintCopyWith<$Res> {
  factory _$$QuestionHintImplCopyWith(
          _$QuestionHintImpl value, $Res Function(_$QuestionHintImpl) then) =
      __$$QuestionHintImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int level, String text});
}

/// @nodoc
class __$$QuestionHintImplCopyWithImpl<$Res>
    extends _$QuestionHintCopyWithImpl<$Res, _$QuestionHintImpl>
    implements _$$QuestionHintImplCopyWith<$Res> {
  __$$QuestionHintImplCopyWithImpl(
      _$QuestionHintImpl _value, $Res Function(_$QuestionHintImpl) _then)
      : super(_value, _then);

  /// Create a copy of QuestionHint
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? text = null,
  }) {
    return _then(_$QuestionHintImpl(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      text: null == text
          ? _value.text
          : text // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionHintImpl extends _QuestionHint {
  const _$QuestionHintImpl({required this.level, required this.text})
      : super._();

  factory _$QuestionHintImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionHintImplFromJson(json);

  @override
  final int level;
// 1, 2, 3
  @override
  final String text;

  @override
  String toString() {
    return 'QuestionHint(level: $level, text: $text)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionHintImpl &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.text, text) || other.text == text));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, level, text);

  /// Create a copy of QuestionHint
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionHintImplCopyWith<_$QuestionHintImpl> get copyWith =>
      __$$QuestionHintImplCopyWithImpl<_$QuestionHintImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionHintImplToJson(
      this,
    );
  }
}

abstract class _QuestionHint extends QuestionHint {
  const factory _QuestionHint(
      {required final int level,
      required final String text}) = _$QuestionHintImpl;
  const _QuestionHint._() : super._();

  factory _QuestionHint.fromJson(Map<String, dynamic> json) =
      _$QuestionHintImpl.fromJson;

  @override
  int get level; // 1, 2, 3
  @override
  String get text;

  /// Create a copy of QuestionHint
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionHintImplCopyWith<_$QuestionHintImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

GeoGebraData _$GeoGebraDataFromJson(Map<String, dynamic> json) {
  return _GeoGebraData.fromJson(json);
}

/// @nodoc
mixin _$GeoGebraData {
  String? get appletId => throw _privateConstructorUsedError;
  List<String> get commands => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;

  /// Serializes this GeoGebraData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of GeoGebraData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $GeoGebraDataCopyWith<GeoGebraData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $GeoGebraDataCopyWith<$Res> {
  factory $GeoGebraDataCopyWith(
          GeoGebraData value, $Res Function(GeoGebraData) then) =
      _$GeoGebraDataCopyWithImpl<$Res, GeoGebraData>;
  @useResult
  $Res call({String? appletId, List<String> commands, String description});
}

/// @nodoc
class _$GeoGebraDataCopyWithImpl<$Res, $Val extends GeoGebraData>
    implements $GeoGebraDataCopyWith<$Res> {
  _$GeoGebraDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of GeoGebraData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appletId = freezed,
    Object? commands = null,
    Object? description = null,
  }) {
    return _then(_value.copyWith(
      appletId: freezed == appletId
          ? _value.appletId
          : appletId // ignore: cast_nullable_to_non_nullable
              as String?,
      commands: null == commands
          ? _value.commands
          : commands // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$GeoGebraDataImplCopyWith<$Res>
    implements $GeoGebraDataCopyWith<$Res> {
  factory _$$GeoGebraDataImplCopyWith(
          _$GeoGebraDataImpl value, $Res Function(_$GeoGebraDataImpl) then) =
      __$$GeoGebraDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String? appletId, List<String> commands, String description});
}

/// @nodoc
class __$$GeoGebraDataImplCopyWithImpl<$Res>
    extends _$GeoGebraDataCopyWithImpl<$Res, _$GeoGebraDataImpl>
    implements _$$GeoGebraDataImplCopyWith<$Res> {
  __$$GeoGebraDataImplCopyWithImpl(
      _$GeoGebraDataImpl _value, $Res Function(_$GeoGebraDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of GeoGebraData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? appletId = freezed,
    Object? commands = null,
    Object? description = null,
  }) {
    return _then(_$GeoGebraDataImpl(
      appletId: freezed == appletId
          ? _value.appletId
          : appletId // ignore: cast_nullable_to_non_nullable
              as String?,
      commands: null == commands
          ? _value._commands
          : commands // ignore: cast_nullable_to_non_nullable
              as List<String>,
      description: null == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$GeoGebraDataImpl extends _GeoGebraData {
  const _$GeoGebraDataImpl(
      {this.appletId,
      final List<String> commands = const [],
      this.description = ''})
      : _commands = commands,
        super._();

  factory _$GeoGebraDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$GeoGebraDataImplFromJson(json);

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

  @override
  String toString() {
    return 'GeoGebraData(appletId: $appletId, commands: $commands, description: $description)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$GeoGebraDataImpl &&
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

  /// Create a copy of GeoGebraData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$GeoGebraDataImplCopyWith<_$GeoGebraDataImpl> get copyWith =>
      __$$GeoGebraDataImplCopyWithImpl<_$GeoGebraDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$GeoGebraDataImplToJson(
      this,
    );
  }
}

abstract class _GeoGebraData extends GeoGebraData {
  const factory _GeoGebraData(
      {final String? appletId,
      final List<String> commands,
      final String description}) = _$GeoGebraDataImpl;
  const _GeoGebraData._() : super._();

  factory _GeoGebraData.fromJson(Map<String, dynamic> json) =
      _$GeoGebraDataImpl.fromJson;

  @override
  String? get appletId;
  @override
  List<String> get commands;
  @override
  String get description;

  /// Create a copy of GeoGebraData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$GeoGebraDataImplCopyWith<_$GeoGebraDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuestionSession _$QuestionSessionFromJson(Map<String, dynamic> json) {
  return _QuestionSession.fromJson(json);
}

/// @nodoc
mixin _$QuestionSession {
  String get sessionId => throw _privateConstructorUsedError;
  int get learningPlanItemId => throw _privateConstructorUsedError;
  List<TopicData> get topics => throw _privateConstructorUsedError;
  UserContext get userContext => throw _privateConstructorUsedError;
  List<Question> get questions => throw _privateConstructorUsedError;
  int get totalQuestions => throw _privateConstructorUsedError;
  DateTime? get createdAt =>
      throw _privateConstructorUsedError; // Made optional - backend doesn't always return it
  bool? get fromCache => throw _privateConstructorUsedError;
  String? get cacheKey => throw _privateConstructorUsedError;
  String? get modelUsed => throw _privateConstructorUsedError;
  String? get providerUsed => throw _privateConstructorUsedError;

  /// Serializes this QuestionSession to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestionSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionSessionCopyWith<QuestionSession> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionSessionCopyWith<$Res> {
  factory $QuestionSessionCopyWith(
          QuestionSession value, $Res Function(QuestionSession) then) =
      _$QuestionSessionCopyWithImpl<$Res, QuestionSession>;
  @useResult
  $Res call(
      {String sessionId,
      int learningPlanItemId,
      List<TopicData> topics,
      UserContext userContext,
      List<Question> questions,
      int totalQuestions,
      DateTime? createdAt,
      bool? fromCache,
      String? cacheKey,
      String? modelUsed,
      String? providerUsed});

  $UserContextCopyWith<$Res> get userContext;
}

/// @nodoc
class _$QuestionSessionCopyWithImpl<$Res, $Val extends QuestionSession>
    implements $QuestionSessionCopyWith<$Res> {
  _$QuestionSessionCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    Object? createdAt = freezed,
    Object? fromCache = freezed,
    Object? cacheKey = freezed,
    Object? modelUsed = freezed,
    Object? providerUsed = freezed,
  }) {
    return _then(_value.copyWith(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      learningPlanItemId: null == learningPlanItemId
          ? _value.learningPlanItemId
          : learningPlanItemId // ignore: cast_nullable_to_non_nullable
              as int,
      topics: null == topics
          ? _value.topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<TopicData>,
      userContext: null == userContext
          ? _value.userContext
          : userContext // ignore: cast_nullable_to_non_nullable
              as UserContext,
      questions: null == questions
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<Question>,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      fromCache: freezed == fromCache
          ? _value.fromCache
          : fromCache // ignore: cast_nullable_to_non_nullable
              as bool?,
      cacheKey: freezed == cacheKey
          ? _value.cacheKey
          : cacheKey // ignore: cast_nullable_to_non_nullable
              as String?,
      modelUsed: freezed == modelUsed
          ? _value.modelUsed
          : modelUsed // ignore: cast_nullable_to_non_nullable
              as String?,
      providerUsed: freezed == providerUsed
          ? _value.providerUsed
          : providerUsed // ignore: cast_nullable_to_non_nullable
              as String?,
    ) as $Val);
  }

  /// Create a copy of QuestionSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $UserContextCopyWith<$Res> get userContext {
    return $UserContextCopyWith<$Res>(_value.userContext, (value) {
      return _then(_value.copyWith(userContext: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuestionSessionImplCopyWith<$Res>
    implements $QuestionSessionCopyWith<$Res> {
  factory _$$QuestionSessionImplCopyWith(_$QuestionSessionImpl value,
          $Res Function(_$QuestionSessionImpl) then) =
      __$$QuestionSessionImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String sessionId,
      int learningPlanItemId,
      List<TopicData> topics,
      UserContext userContext,
      List<Question> questions,
      int totalQuestions,
      DateTime? createdAt,
      bool? fromCache,
      String? cacheKey,
      String? modelUsed,
      String? providerUsed});

  @override
  $UserContextCopyWith<$Res> get userContext;
}

/// @nodoc
class __$$QuestionSessionImplCopyWithImpl<$Res>
    extends _$QuestionSessionCopyWithImpl<$Res, _$QuestionSessionImpl>
    implements _$$QuestionSessionImplCopyWith<$Res> {
  __$$QuestionSessionImplCopyWithImpl(
      _$QuestionSessionImpl _value, $Res Function(_$QuestionSessionImpl) _then)
      : super(_value, _then);

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
    Object? createdAt = freezed,
    Object? fromCache = freezed,
    Object? cacheKey = freezed,
    Object? modelUsed = freezed,
    Object? providerUsed = freezed,
  }) {
    return _then(_$QuestionSessionImpl(
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      learningPlanItemId: null == learningPlanItemId
          ? _value.learningPlanItemId
          : learningPlanItemId // ignore: cast_nullable_to_non_nullable
              as int,
      topics: null == topics
          ? _value._topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<TopicData>,
      userContext: null == userContext
          ? _value.userContext
          : userContext // ignore: cast_nullable_to_non_nullable
              as UserContext,
      questions: null == questions
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<Question>,
      totalQuestions: null == totalQuestions
          ? _value.totalQuestions
          : totalQuestions // ignore: cast_nullable_to_non_nullable
              as int,
      createdAt: freezed == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      fromCache: freezed == fromCache
          ? _value.fromCache
          : fromCache // ignore: cast_nullable_to_non_nullable
              as bool?,
      cacheKey: freezed == cacheKey
          ? _value.cacheKey
          : cacheKey // ignore: cast_nullable_to_non_nullable
              as String?,
      modelUsed: freezed == modelUsed
          ? _value.modelUsed
          : modelUsed // ignore: cast_nullable_to_non_nullable
              as String?,
      providerUsed: freezed == providerUsed
          ? _value.providerUsed
          : providerUsed // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionSessionImpl extends _QuestionSession {
  const _$QuestionSessionImpl(
      {required this.sessionId,
      required this.learningPlanItemId,
      required final List<TopicData> topics,
      required this.userContext,
      required final List<Question> questions,
      required this.totalQuestions,
      this.createdAt,
      this.fromCache,
      this.cacheKey,
      this.modelUsed,
      this.providerUsed})
      : _topics = topics,
        _questions = questions,
        super._();

  factory _$QuestionSessionImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionSessionImplFromJson(json);

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
  final DateTime? createdAt;
// Made optional - backend doesn't always return it
  @override
  final bool? fromCache;
  @override
  final String? cacheKey;
  @override
  final String? modelUsed;
  @override
  final String? providerUsed;

  @override
  String toString() {
    return 'QuestionSession(sessionId: $sessionId, learningPlanItemId: $learningPlanItemId, topics: $topics, userContext: $userContext, questions: $questions, totalQuestions: $totalQuestions, createdAt: $createdAt, fromCache: $fromCache, cacheKey: $cacheKey, modelUsed: $modelUsed, providerUsed: $providerUsed)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionSessionImpl &&
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
                other.createdAt == createdAt) &&
            (identical(other.fromCache, fromCache) ||
                other.fromCache == fromCache) &&
            (identical(other.cacheKey, cacheKey) ||
                other.cacheKey == cacheKey) &&
            (identical(other.modelUsed, modelUsed) ||
                other.modelUsed == modelUsed) &&
            (identical(other.providerUsed, providerUsed) ||
                other.providerUsed == providerUsed));
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
      createdAt,
      fromCache,
      cacheKey,
      modelUsed,
      providerUsed);

  /// Create a copy of QuestionSession
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionSessionImplCopyWith<_$QuestionSessionImpl> get copyWith =>
      __$$QuestionSessionImplCopyWithImpl<_$QuestionSessionImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionSessionImplToJson(
      this,
    );
  }
}

abstract class _QuestionSession extends QuestionSession {
  const factory _QuestionSession(
      {required final String sessionId,
      required final int learningPlanItemId,
      required final List<TopicData> topics,
      required final UserContext userContext,
      required final List<Question> questions,
      required final int totalQuestions,
      final DateTime? createdAt,
      final bool? fromCache,
      final String? cacheKey,
      final String? modelUsed,
      final String? providerUsed}) = _$QuestionSessionImpl;
  const _QuestionSession._() : super._();

  factory _QuestionSession.fromJson(Map<String, dynamic> json) =
      _$QuestionSessionImpl.fromJson;

  @override
  String get sessionId;
  @override
  int get learningPlanItemId;
  @override
  List<TopicData> get topics;
  @override
  UserContext get userContext;
  @override
  List<Question> get questions;
  @override
  int get totalQuestions;
  @override
  DateTime? get createdAt; // Made optional - backend doesn't always return it
  @override
  bool? get fromCache;
  @override
  String? get cacheKey;
  @override
  String? get modelUsed;
  @override
  String? get providerUsed;

  /// Create a copy of QuestionSession
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionSessionImplCopyWith<_$QuestionSessionImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

TopicData _$TopicDataFromJson(Map<String, dynamic> json) {
  return _TopicData.fromJson(json);
}

/// @nodoc
mixin _$TopicData {
  String get leitidee => throw _privateConstructorUsedError;
  String get thema => throw _privateConstructorUsedError;
  String get unterthema => throw _privateConstructorUsedError;

  /// Serializes this TopicData to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TopicData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TopicDataCopyWith<TopicData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TopicDataCopyWith<$Res> {
  factory $TopicDataCopyWith(TopicData value, $Res Function(TopicData) then) =
      _$TopicDataCopyWithImpl<$Res, TopicData>;
  @useResult
  $Res call({String leitidee, String thema, String unterthema});
}

/// @nodoc
class _$TopicDataCopyWithImpl<$Res, $Val extends TopicData>
    implements $TopicDataCopyWith<$Res> {
  _$TopicDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TopicData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leitidee = null,
    Object? thema = null,
    Object? unterthema = null,
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
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$TopicDataImplCopyWith<$Res>
    implements $TopicDataCopyWith<$Res> {
  factory _$$TopicDataImplCopyWith(
          _$TopicDataImpl value, $Res Function(_$TopicDataImpl) then) =
      __$$TopicDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String leitidee, String thema, String unterthema});
}

/// @nodoc
class __$$TopicDataImplCopyWithImpl<$Res>
    extends _$TopicDataCopyWithImpl<$Res, _$TopicDataImpl>
    implements _$$TopicDataImplCopyWith<$Res> {
  __$$TopicDataImplCopyWithImpl(
      _$TopicDataImpl _value, $Res Function(_$TopicDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of TopicData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leitidee = null,
    Object? thema = null,
    Object? unterthema = null,
  }) {
    return _then(_$TopicDataImpl(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$TopicDataImpl extends _TopicData {
  const _$TopicDataImpl(
      {required this.leitidee, required this.thema, required this.unterthema})
      : super._();

  factory _$TopicDataImpl.fromJson(Map<String, dynamic> json) =>
      _$$TopicDataImplFromJson(json);

  @override
  final String leitidee;
  @override
  final String thema;
  @override
  final String unterthema;

  @override
  String toString() {
    return 'TopicData(leitidee: $leitidee, thema: $thema, unterthema: $unterthema)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TopicDataImpl &&
            (identical(other.leitidee, leitidee) ||
                other.leitidee == leitidee) &&
            (identical(other.thema, thema) || other.thema == thema) &&
            (identical(other.unterthema, unterthema) ||
                other.unterthema == unterthema));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, leitidee, thema, unterthema);

  /// Create a copy of TopicData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TopicDataImplCopyWith<_$TopicDataImpl> get copyWith =>
      __$$TopicDataImplCopyWithImpl<_$TopicDataImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TopicDataImplToJson(
      this,
    );
  }
}

abstract class _TopicData extends TopicData {
  const factory _TopicData(
      {required final String leitidee,
      required final String thema,
      required final String unterthema}) = _$TopicDataImpl;
  const _TopicData._() : super._();

  factory _TopicData.fromJson(Map<String, dynamic> json) =
      _$TopicDataImpl.fromJson;

  @override
  String get leitidee;
  @override
  String get thema;
  @override
  String get unterthema;

  /// Create a copy of TopicData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TopicDataImplCopyWith<_$TopicDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

UserContext _$UserContextFromJson(Map<String, dynamic> json) {
  return _UserContext.fromJson(json);
}

/// @nodoc
mixin _$UserContext {
  String get gradeLevel => throw _privateConstructorUsedError;
  String get courseType => throw _privateConstructorUsedError;

  /// Serializes this UserContext to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserContextCopyWith<UserContext> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserContextCopyWith<$Res> {
  factory $UserContextCopyWith(
          UserContext value, $Res Function(UserContext) then) =
      _$UserContextCopyWithImpl<$Res, UserContext>;
  @useResult
  $Res call({String gradeLevel, String courseType});
}

/// @nodoc
class _$UserContextCopyWithImpl<$Res, $Val extends UserContext>
    implements $UserContextCopyWith<$Res> {
  _$UserContextCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserContext
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
abstract class _$$UserContextImplCopyWith<$Res>
    implements $UserContextCopyWith<$Res> {
  factory _$$UserContextImplCopyWith(
          _$UserContextImpl value, $Res Function(_$UserContextImpl) then) =
      __$$UserContextImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String gradeLevel, String courseType});
}

/// @nodoc
class __$$UserContextImplCopyWithImpl<$Res>
    extends _$UserContextCopyWithImpl<$Res, _$UserContextImpl>
    implements _$$UserContextImplCopyWith<$Res> {
  __$$UserContextImplCopyWithImpl(
      _$UserContextImpl _value, $Res Function(_$UserContextImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserContext
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? gradeLevel = null,
    Object? courseType = null,
  }) {
    return _then(_$UserContextImpl(
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
class _$UserContextImpl extends _UserContext {
  const _$UserContextImpl({required this.gradeLevel, required this.courseType})
      : super._();

  factory _$UserContextImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserContextImplFromJson(json);

  @override
  final String gradeLevel;
  @override
  final String courseType;

  @override
  String toString() {
    return 'UserContext(gradeLevel: $gradeLevel, courseType: $courseType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserContextImpl &&
            (identical(other.gradeLevel, gradeLevel) ||
                other.gradeLevel == gradeLevel) &&
            (identical(other.courseType, courseType) ||
                other.courseType == courseType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, gradeLevel, courseType);

  /// Create a copy of UserContext
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserContextImplCopyWith<_$UserContextImpl> get copyWith =>
      __$$UserContextImplCopyWithImpl<_$UserContextImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserContextImplToJson(
      this,
    );
  }
}

abstract class _UserContext extends UserContext {
  const factory _UserContext(
      {required final String gradeLevel,
      required final String courseType}) = _$UserContextImpl;
  const _UserContext._() : super._();

  factory _UserContext.fromJson(Map<String, dynamic> json) =
      _$UserContextImpl.fromJson;

  @override
  String get gradeLevel;
  @override
  String get courseType;

  /// Create a copy of UserContext
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserContextImplCopyWith<_$UserContextImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

QuestionProgress _$QuestionProgressFromJson(Map<String, dynamic> json) {
  return _QuestionProgress.fromJson(json);
}

/// @nodoc
mixin _$QuestionProgress {
  String get questionId => throw _privateConstructorUsedError;
  String get sessionId => throw _privateConstructorUsedError;
  DateTime get startedAt => throw _privateConstructorUsedError;
  DateTime? get completedAt => throw _privateConstructorUsedError;
  QuestionStatus get status => throw _privateConstructorUsedError;
  int get hintsUsed => throw _privateConstructorUsedError;
  List<HintUsageDetail> get hintsUsedDetails =>
      throw _privateConstructorUsedError;
  bool get isCorrect => throw _privateConstructorUsedError;
  String? get userAnswer => throw _privateConstructorUsedError;
  int get timeSpent => throw _privateConstructorUsedError; // seconds
  int get xpEarned => throw _privateConstructorUsedError;
  XPBreakdown? get xpBreakdown => throw _privateConstructorUsedError;
  String get topic => throw _privateConstructorUsedError;
  int get difficulty => throw _privateConstructorUsedError;

  /// Serializes this QuestionProgress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of QuestionProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $QuestionProgressCopyWith<QuestionProgress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestionProgressCopyWith<$Res> {
  factory $QuestionProgressCopyWith(
          QuestionProgress value, $Res Function(QuestionProgress) then) =
      _$QuestionProgressCopyWithImpl<$Res, QuestionProgress>;
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
class _$QuestionProgressCopyWithImpl<$Res, $Val extends QuestionProgress>
    implements $QuestionProgressCopyWith<$Res> {
  _$QuestionProgressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuestionStatus,
      hintsUsed: null == hintsUsed
          ? _value.hintsUsed
          : hintsUsed // ignore: cast_nullable_to_non_nullable
              as int,
      hintsUsedDetails: null == hintsUsedDetails
          ? _value.hintsUsedDetails
          : hintsUsedDetails // ignore: cast_nullable_to_non_nullable
              as List<HintUsageDetail>,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      userAnswer: freezed == userAnswer
          ? _value.userAnswer
          : userAnswer // ignore: cast_nullable_to_non_nullable
              as String?,
      timeSpent: null == timeSpent
          ? _value.timeSpent
          : timeSpent // ignore: cast_nullable_to_non_nullable
              as int,
      xpEarned: null == xpEarned
          ? _value.xpEarned
          : xpEarned // ignore: cast_nullable_to_non_nullable
              as int,
      xpBreakdown: freezed == xpBreakdown
          ? _value.xpBreakdown
          : xpBreakdown // ignore: cast_nullable_to_non_nullable
              as XPBreakdown?,
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }

  /// Create a copy of QuestionProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $XPBreakdownCopyWith<$Res>? get xpBreakdown {
    if (_value.xpBreakdown == null) {
      return null;
    }

    return $XPBreakdownCopyWith<$Res>(_value.xpBreakdown!, (value) {
      return _then(_value.copyWith(xpBreakdown: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$QuestionProgressImplCopyWith<$Res>
    implements $QuestionProgressCopyWith<$Res> {
  factory _$$QuestionProgressImplCopyWith(_$QuestionProgressImpl value,
          $Res Function(_$QuestionProgressImpl) then) =
      __$$QuestionProgressImplCopyWithImpl<$Res>;
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
class __$$QuestionProgressImplCopyWithImpl<$Res>
    extends _$QuestionProgressCopyWithImpl<$Res, _$QuestionProgressImpl>
    implements _$$QuestionProgressImplCopyWith<$Res> {
  __$$QuestionProgressImplCopyWithImpl(_$QuestionProgressImpl _value,
      $Res Function(_$QuestionProgressImpl) _then)
      : super(_value, _then);

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
    return _then(_$QuestionProgressImpl(
      questionId: null == questionId
          ? _value.questionId
          : questionId // ignore: cast_nullable_to_non_nullable
              as String,
      sessionId: null == sessionId
          ? _value.sessionId
          : sessionId // ignore: cast_nullable_to_non_nullable
              as String,
      startedAt: null == startedAt
          ? _value.startedAt
          : startedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      completedAt: freezed == completedAt
          ? _value.completedAt
          : completedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      status: null == status
          ? _value.status
          : status // ignore: cast_nullable_to_non_nullable
              as QuestionStatus,
      hintsUsed: null == hintsUsed
          ? _value.hintsUsed
          : hintsUsed // ignore: cast_nullable_to_non_nullable
              as int,
      hintsUsedDetails: null == hintsUsedDetails
          ? _value._hintsUsedDetails
          : hintsUsedDetails // ignore: cast_nullable_to_non_nullable
              as List<HintUsageDetail>,
      isCorrect: null == isCorrect
          ? _value.isCorrect
          : isCorrect // ignore: cast_nullable_to_non_nullable
              as bool,
      userAnswer: freezed == userAnswer
          ? _value.userAnswer
          : userAnswer // ignore: cast_nullable_to_non_nullable
              as String?,
      timeSpent: null == timeSpent
          ? _value.timeSpent
          : timeSpent // ignore: cast_nullable_to_non_nullable
              as int,
      xpEarned: null == xpEarned
          ? _value.xpEarned
          : xpEarned // ignore: cast_nullable_to_non_nullable
              as int,
      xpBreakdown: freezed == xpBreakdown
          ? _value.xpBreakdown
          : xpBreakdown // ignore: cast_nullable_to_non_nullable
              as XPBreakdown?,
      topic: null == topic
          ? _value.topic
          : topic // ignore: cast_nullable_to_non_nullable
              as String,
      difficulty: null == difficulty
          ? _value.difficulty
          : difficulty // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$QuestionProgressImpl extends _QuestionProgress {
  const _$QuestionProgressImpl(
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
      : _hintsUsedDetails = hintsUsedDetails,
        super._();

  factory _$QuestionProgressImpl.fromJson(Map<String, dynamic> json) =>
      _$$QuestionProgressImplFromJson(json);

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

  @override
  String toString() {
    return 'QuestionProgress(questionId: $questionId, sessionId: $sessionId, startedAt: $startedAt, completedAt: $completedAt, status: $status, hintsUsed: $hintsUsed, hintsUsedDetails: $hintsUsedDetails, isCorrect: $isCorrect, userAnswer: $userAnswer, timeSpent: $timeSpent, xpEarned: $xpEarned, xpBreakdown: $xpBreakdown, topic: $topic, difficulty: $difficulty)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$QuestionProgressImpl &&
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

  /// Create a copy of QuestionProgress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$QuestionProgressImplCopyWith<_$QuestionProgressImpl> get copyWith =>
      __$$QuestionProgressImplCopyWithImpl<_$QuestionProgressImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$QuestionProgressImplToJson(
      this,
    );
  }
}

abstract class _QuestionProgress extends QuestionProgress {
  const factory _QuestionProgress(
      {required final String questionId,
      required final String sessionId,
      required final DateTime startedAt,
      final DateTime? completedAt,
      required final QuestionStatus status,
      final int hintsUsed,
      final List<HintUsageDetail> hintsUsedDetails,
      final bool isCorrect,
      final String? userAnswer,
      final int timeSpent,
      final int xpEarned,
      final XPBreakdown? xpBreakdown,
      required final String topic,
      required final int difficulty}) = _$QuestionProgressImpl;
  const _QuestionProgress._() : super._();

  factory _QuestionProgress.fromJson(Map<String, dynamic> json) =
      _$QuestionProgressImpl.fromJson;

  @override
  String get questionId;
  @override
  String get sessionId;
  @override
  DateTime get startedAt;
  @override
  DateTime? get completedAt;
  @override
  QuestionStatus get status;
  @override
  int get hintsUsed;
  @override
  List<HintUsageDetail> get hintsUsedDetails;
  @override
  bool get isCorrect;
  @override
  String? get userAnswer;
  @override
  int get timeSpent; // seconds
  @override
  int get xpEarned;
  @override
  XPBreakdown? get xpBreakdown;
  @override
  String get topic;
  @override
  int get difficulty;

  /// Create a copy of QuestionProgress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$QuestionProgressImplCopyWith<_$QuestionProgressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

HintUsageDetail _$HintUsageDetailFromJson(Map<String, dynamic> json) {
  return _HintUsageDetail.fromJson(json);
}

/// @nodoc
mixin _$HintUsageDetail {
  int get level => throw _privateConstructorUsedError; // 1-3
  DateTime get usedAt => throw _privateConstructorUsedError;

  /// Serializes this HintUsageDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of HintUsageDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HintUsageDetailCopyWith<HintUsageDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HintUsageDetailCopyWith<$Res> {
  factory $HintUsageDetailCopyWith(
          HintUsageDetail value, $Res Function(HintUsageDetail) then) =
      _$HintUsageDetailCopyWithImpl<$Res, HintUsageDetail>;
  @useResult
  $Res call({int level, DateTime usedAt});
}

/// @nodoc
class _$HintUsageDetailCopyWithImpl<$Res, $Val extends HintUsageDetail>
    implements $HintUsageDetailCopyWith<$Res> {
  _$HintUsageDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HintUsageDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? usedAt = null,
  }) {
    return _then(_value.copyWith(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      usedAt: null == usedAt
          ? _value.usedAt
          : usedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HintUsageDetailImplCopyWith<$Res>
    implements $HintUsageDetailCopyWith<$Res> {
  factory _$$HintUsageDetailImplCopyWith(_$HintUsageDetailImpl value,
          $Res Function(_$HintUsageDetailImpl) then) =
      __$$HintUsageDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int level, DateTime usedAt});
}

/// @nodoc
class __$$HintUsageDetailImplCopyWithImpl<$Res>
    extends _$HintUsageDetailCopyWithImpl<$Res, _$HintUsageDetailImpl>
    implements _$$HintUsageDetailImplCopyWith<$Res> {
  __$$HintUsageDetailImplCopyWithImpl(
      _$HintUsageDetailImpl _value, $Res Function(_$HintUsageDetailImpl) _then)
      : super(_value, _then);

  /// Create a copy of HintUsageDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? level = null,
    Object? usedAt = null,
  }) {
    return _then(_$HintUsageDetailImpl(
      level: null == level
          ? _value.level
          : level // ignore: cast_nullable_to_non_nullable
              as int,
      usedAt: null == usedAt
          ? _value.usedAt
          : usedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$HintUsageDetailImpl extends _HintUsageDetail {
  const _$HintUsageDetailImpl({required this.level, required this.usedAt})
      : super._();

  factory _$HintUsageDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$HintUsageDetailImplFromJson(json);

  @override
  final int level;
// 1-3
  @override
  final DateTime usedAt;

  @override
  String toString() {
    return 'HintUsageDetail(level: $level, usedAt: $usedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HintUsageDetailImpl &&
            (identical(other.level, level) || other.level == level) &&
            (identical(other.usedAt, usedAt) || other.usedAt == usedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, level, usedAt);

  /// Create a copy of HintUsageDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HintUsageDetailImplCopyWith<_$HintUsageDetailImpl> get copyWith =>
      __$$HintUsageDetailImplCopyWithImpl<_$HintUsageDetailImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$HintUsageDetailImplToJson(
      this,
    );
  }
}

abstract class _HintUsageDetail extends HintUsageDetail {
  const factory _HintUsageDetail(
      {required final int level,
      required final DateTime usedAt}) = _$HintUsageDetailImpl;
  const _HintUsageDetail._() : super._();

  factory _HintUsageDetail.fromJson(Map<String, dynamic> json) =
      _$HintUsageDetailImpl.fromJson;

  @override
  int get level; // 1-3
  @override
  DateTime get usedAt;

  /// Create a copy of HintUsageDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HintUsageDetailImplCopyWith<_$HintUsageDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

XPBreakdown _$XPBreakdownFromJson(Map<String, dynamic> json) {
  return _XPBreakdown.fromJson(json);
}

/// @nodoc
mixin _$XPBreakdown {
  int get base => throw _privateConstructorUsedError;
  int get hintPenalty => throw _privateConstructorUsedError;
  int get timeBonus => throw _privateConstructorUsedError;
  int get streakBonus => throw _privateConstructorUsedError;

  /// Serializes this XPBreakdown to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of XPBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $XPBreakdownCopyWith<XPBreakdown> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $XPBreakdownCopyWith<$Res> {
  factory $XPBreakdownCopyWith(
          XPBreakdown value, $Res Function(XPBreakdown) then) =
      _$XPBreakdownCopyWithImpl<$Res, XPBreakdown>;
  @useResult
  $Res call({int base, int hintPenalty, int timeBonus, int streakBonus});
}

/// @nodoc
class _$XPBreakdownCopyWithImpl<$Res, $Val extends XPBreakdown>
    implements $XPBreakdownCopyWith<$Res> {
  _$XPBreakdownCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

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
    return _then(_value.copyWith(
      base: null == base
          ? _value.base
          : base // ignore: cast_nullable_to_non_nullable
              as int,
      hintPenalty: null == hintPenalty
          ? _value.hintPenalty
          : hintPenalty // ignore: cast_nullable_to_non_nullable
              as int,
      timeBonus: null == timeBonus
          ? _value.timeBonus
          : timeBonus // ignore: cast_nullable_to_non_nullable
              as int,
      streakBonus: null == streakBonus
          ? _value.streakBonus
          : streakBonus // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$XPBreakdownImplCopyWith<$Res>
    implements $XPBreakdownCopyWith<$Res> {
  factory _$$XPBreakdownImplCopyWith(
          _$XPBreakdownImpl value, $Res Function(_$XPBreakdownImpl) then) =
      __$$XPBreakdownImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int base, int hintPenalty, int timeBonus, int streakBonus});
}

/// @nodoc
class __$$XPBreakdownImplCopyWithImpl<$Res>
    extends _$XPBreakdownCopyWithImpl<$Res, _$XPBreakdownImpl>
    implements _$$XPBreakdownImplCopyWith<$Res> {
  __$$XPBreakdownImplCopyWithImpl(
      _$XPBreakdownImpl _value, $Res Function(_$XPBreakdownImpl) _then)
      : super(_value, _then);

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
    return _then(_$XPBreakdownImpl(
      base: null == base
          ? _value.base
          : base // ignore: cast_nullable_to_non_nullable
              as int,
      hintPenalty: null == hintPenalty
          ? _value.hintPenalty
          : hintPenalty // ignore: cast_nullable_to_non_nullable
              as int,
      timeBonus: null == timeBonus
          ? _value.timeBonus
          : timeBonus // ignore: cast_nullable_to_non_nullable
              as int,
      streakBonus: null == streakBonus
          ? _value.streakBonus
          : streakBonus // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$XPBreakdownImpl extends _XPBreakdown {
  const _$XPBreakdownImpl(
      {required this.base,
      required this.hintPenalty,
      required this.timeBonus,
      required this.streakBonus})
      : super._();

  factory _$XPBreakdownImpl.fromJson(Map<String, dynamic> json) =>
      _$$XPBreakdownImplFromJson(json);

  @override
  final int base;
  @override
  final int hintPenalty;
  @override
  final int timeBonus;
  @override
  final int streakBonus;

  @override
  String toString() {
    return 'XPBreakdown(base: $base, hintPenalty: $hintPenalty, timeBonus: $timeBonus, streakBonus: $streakBonus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$XPBreakdownImpl &&
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

  /// Create a copy of XPBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$XPBreakdownImplCopyWith<_$XPBreakdownImpl> get copyWith =>
      __$$XPBreakdownImplCopyWithImpl<_$XPBreakdownImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$XPBreakdownImplToJson(
      this,
    );
  }
}

abstract class _XPBreakdown extends XPBreakdown {
  const factory _XPBreakdown(
      {required final int base,
      required final int hintPenalty,
      required final int timeBonus,
      required final int streakBonus}) = _$XPBreakdownImpl;
  const _XPBreakdown._() : super._();

  factory _XPBreakdown.fromJson(Map<String, dynamic> json) =
      _$XPBreakdownImpl.fromJson;

  @override
  int get base;
  @override
  int get hintPenalty;
  @override
  int get timeBonus;
  @override
  int get streakBonus;

  /// Create a copy of XPBreakdown
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$XPBreakdownImplCopyWith<_$XPBreakdownImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
