// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'lernplan.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

Lernplan _$LernplanFromJson(Map<String, dynamic> json) {
  return _Lernplan.fromJson(json);
}

/// @nodoc
mixin _$Lernplan {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  List<LernplanTopic> get topics => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get createdAt => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this Lernplan to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Lernplan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LernplanCopyWith<Lernplan> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LernplanCopyWith<$Res> {
  factory $LernplanCopyWith(Lernplan value, $Res Function(Lernplan) then) =
      _$LernplanCopyWithImpl<$Res, Lernplan>;
  @useResult
  $Res call(
      {String id,
      String userId,
      List<LernplanTopic> topics,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt});
}

/// @nodoc
class _$LernplanCopyWithImpl<$Res, $Val extends Lernplan>
    implements $LernplanCopyWith<$Res> {
  _$LernplanCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Lernplan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? topics = null,
    Object? createdAt = null,
    Object? updatedAt = null,
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
      topics: null == topics
          ? _value.topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<LernplanTopic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LernplanImplCopyWith<$Res>
    implements $LernplanCopyWith<$Res> {
  factory _$$LernplanImplCopyWith(
          _$LernplanImpl value, $Res Function(_$LernplanImpl) then) =
      __$$LernplanImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      List<LernplanTopic> topics,
      @TimestampConverter() DateTime createdAt,
      @TimestampConverter() DateTime updatedAt});
}

/// @nodoc
class __$$LernplanImplCopyWithImpl<$Res>
    extends _$LernplanCopyWithImpl<$Res, _$LernplanImpl>
    implements _$$LernplanImplCopyWith<$Res> {
  __$$LernplanImplCopyWithImpl(
      _$LernplanImpl _value, $Res Function(_$LernplanImpl) _then)
      : super(_value, _then);

  /// Create a copy of Lernplan
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? topics = null,
    Object? createdAt = null,
    Object? updatedAt = null,
  }) {
    return _then(_$LernplanImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      topics: null == topics
          ? _value._topics
          : topics // ignore: cast_nullable_to_non_nullable
              as List<LernplanTopic>,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LernplanImpl extends _Lernplan with DiagnosticableTreeMixin {
  const _$LernplanImpl(
      {required this.id,
      required this.userId,
      required final List<LernplanTopic> topics,
      @TimestampConverter() required this.createdAt,
      @TimestampConverter() required this.updatedAt})
      : _topics = topics,
        super._();

  factory _$LernplanImpl.fromJson(Map<String, dynamic> json) =>
      _$$LernplanImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  final List<LernplanTopic> _topics;
  @override
  List<LernplanTopic> get topics {
    if (_topics is EqualUnmodifiableListView) return _topics;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_topics);
  }

  @override
  @TimestampConverter()
  final DateTime createdAt;
  @override
  @TimestampConverter()
  final DateTime updatedAt;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'Lernplan(id: $id, userId: $userId, topics: $topics, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'Lernplan'))
      ..add(DiagnosticsProperty('id', id))
      ..add(DiagnosticsProperty('userId', userId))
      ..add(DiagnosticsProperty('topics', topics))
      ..add(DiagnosticsProperty('createdAt', createdAt))
      ..add(DiagnosticsProperty('updatedAt', updatedAt));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LernplanImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            const DeepCollectionEquality().equals(other._topics, _topics) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId,
      const DeepCollectionEquality().hash(_topics), createdAt, updatedAt);

  /// Create a copy of Lernplan
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LernplanImplCopyWith<_$LernplanImpl> get copyWith =>
      __$$LernplanImplCopyWithImpl<_$LernplanImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LernplanImplToJson(
      this,
    );
  }
}

abstract class _Lernplan extends Lernplan {
  const factory _Lernplan(
          {required final String id,
          required final String userId,
          required final List<LernplanTopic> topics,
          @TimestampConverter() required final DateTime createdAt,
          @TimestampConverter() required final DateTime updatedAt}) =
      _$LernplanImpl;
  const _Lernplan._() : super._();

  factory _Lernplan.fromJson(Map<String, dynamic> json) =
      _$LernplanImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  List<LernplanTopic> get topics;
  @override
  @TimestampConverter()
  DateTime get createdAt;
  @override
  @TimestampConverter()
  DateTime get updatedAt;

  /// Create a copy of Lernplan
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LernplanImplCopyWith<_$LernplanImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

LernplanTopic _$LernplanTopicFromJson(Map<String, dynamic> json) {
  return _LernplanTopic.fromJson(json);
}

/// @nodoc
mixin _$LernplanTopic {
  String get leitidee => throw _privateConstructorUsedError;
  String get thema => throw _privateConstructorUsedError;
  String get unterthema => throw _privateConstructorUsedError;
  @TimestampConverter()
  DateTime get addedAt => throw _privateConstructorUsedError;
  String get source => throw _privateConstructorUsedError;

  /// Serializes this LernplanTopic to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of LernplanTopic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $LernplanTopicCopyWith<LernplanTopic> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $LernplanTopicCopyWith<$Res> {
  factory $LernplanTopicCopyWith(
          LernplanTopic value, $Res Function(LernplanTopic) then) =
      _$LernplanTopicCopyWithImpl<$Res, LernplanTopic>;
  @useResult
  $Res call(
      {String leitidee,
      String thema,
      String unterthema,
      @TimestampConverter() DateTime addedAt,
      String source});
}

/// @nodoc
class _$LernplanTopicCopyWithImpl<$Res, $Val extends LernplanTopic>
    implements $LernplanTopicCopyWith<$Res> {
  _$LernplanTopicCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of LernplanTopic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leitidee = null,
    Object? thema = null,
    Object? unterthema = null,
    Object? addedAt = null,
    Object? source = null,
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
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$LernplanTopicImplCopyWith<$Res>
    implements $LernplanTopicCopyWith<$Res> {
  factory _$$LernplanTopicImplCopyWith(
          _$LernplanTopicImpl value, $Res Function(_$LernplanTopicImpl) then) =
      __$$LernplanTopicImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String leitidee,
      String thema,
      String unterthema,
      @TimestampConverter() DateTime addedAt,
      String source});
}

/// @nodoc
class __$$LernplanTopicImplCopyWithImpl<$Res>
    extends _$LernplanTopicCopyWithImpl<$Res, _$LernplanTopicImpl>
    implements _$$LernplanTopicImplCopyWith<$Res> {
  __$$LernplanTopicImplCopyWithImpl(
      _$LernplanTopicImpl _value, $Res Function(_$LernplanTopicImpl) _then)
      : super(_value, _then);

  /// Create a copy of LernplanTopic
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? leitidee = null,
    Object? thema = null,
    Object? unterthema = null,
    Object? addedAt = null,
    Object? source = null,
  }) {
    return _then(_$LernplanTopicImpl(
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
      addedAt: null == addedAt
          ? _value.addedAt
          : addedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      source: null == source
          ? _value.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$LernplanTopicImpl extends _LernplanTopic with DiagnosticableTreeMixin {
  const _$LernplanTopicImpl(
      {required this.leitidee,
      required this.thema,
      required this.unterthema,
      @TimestampConverter() required this.addedAt,
      this.source = 'manual'})
      : super._();

  factory _$LernplanTopicImpl.fromJson(Map<String, dynamic> json) =>
      _$$LernplanTopicImplFromJson(json);

  @override
  final String leitidee;
  @override
  final String thema;
  @override
  final String unterthema;
  @override
  @TimestampConverter()
  final DateTime addedAt;
  @override
  @JsonKey()
  final String source;

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    return 'LernplanTopic(leitidee: $leitidee, thema: $thema, unterthema: $unterthema, addedAt: $addedAt, source: $source)';
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty('type', 'LernplanTopic'))
      ..add(DiagnosticsProperty('leitidee', leitidee))
      ..add(DiagnosticsProperty('thema', thema))
      ..add(DiagnosticsProperty('unterthema', unterthema))
      ..add(DiagnosticsProperty('addedAt', addedAt))
      ..add(DiagnosticsProperty('source', source));
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$LernplanTopicImpl &&
            (identical(other.leitidee, leitidee) ||
                other.leitidee == leitidee) &&
            (identical(other.thema, thema) || other.thema == thema) &&
            (identical(other.unterthema, unterthema) ||
                other.unterthema == unterthema) &&
            (identical(other.addedAt, addedAt) || other.addedAt == addedAt) &&
            (identical(other.source, source) || other.source == source));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, leitidee, thema, unterthema, addedAt, source);

  /// Create a copy of LernplanTopic
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$LernplanTopicImplCopyWith<_$LernplanTopicImpl> get copyWith =>
      __$$LernplanTopicImplCopyWithImpl<_$LernplanTopicImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$LernplanTopicImplToJson(
      this,
    );
  }
}

abstract class _LernplanTopic extends LernplanTopic {
  const factory _LernplanTopic(
      {required final String leitidee,
      required final String thema,
      required final String unterthema,
      @TimestampConverter() required final DateTime addedAt,
      final String source}) = _$LernplanTopicImpl;
  const _LernplanTopic._() : super._();

  factory _LernplanTopic.fromJson(Map<String, dynamic> json) =
      _$LernplanTopicImpl.fromJson;

  @override
  String get leitidee;
  @override
  String get thema;
  @override
  String get unterthema;
  @override
  @TimestampConverter()
  DateTime get addedAt;
  @override
  String get source;

  /// Create a copy of LernplanTopic
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$LernplanTopicImplCopyWith<_$LernplanTopicImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
