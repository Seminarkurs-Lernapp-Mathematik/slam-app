// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'saved_content.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

SavedContent _$SavedContentFromJson(Map<String, dynamic> json) {
  return _SavedContent.fromJson(json);
}

/// @nodoc
mixin _$SavedContent {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  ContentType get type => throw _privateConstructorUsedError;
  String get htmlContent => throw _privateConstructorUsedError;
  String? get cssContent => throw _privateConstructorUsedError;
  String? get javascriptContent => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  List<String> get tags => throw _privateConstructorUsedError;

  /// Serializes this SavedContent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SavedContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SavedContentCopyWith<SavedContent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SavedContentCopyWith<$Res> {
  factory $SavedContentCopyWith(
          SavedContent value, $Res Function(SavedContent) then) =
      _$SavedContentCopyWithImpl<$Res, SavedContent>;
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      ContentType type,
      String htmlContent,
      String? cssContent,
      String? javascriptContent,
      String? description,
      DateTime createdAt,
      DateTime? updatedAt,
      List<String> tags});
}

/// @nodoc
class _$SavedContentCopyWithImpl<$Res, $Val extends SavedContent>
    implements $SavedContentCopyWith<$Res> {
  _$SavedContentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SavedContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? type = null,
    Object? htmlContent = null,
    Object? cssContent = freezed,
    Object? javascriptContent = freezed,
    Object? description = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? tags = null,
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
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ContentType,
      htmlContent: null == htmlContent
          ? _value.htmlContent
          : htmlContent // ignore: cast_nullable_to_non_nullable
              as String,
      cssContent: freezed == cssContent
          ? _value.cssContent
          : cssContent // ignore: cast_nullable_to_non_nullable
              as String?,
      javascriptContent: freezed == javascriptContent
          ? _value.javascriptContent
          : javascriptContent // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tags: null == tags
          ? _value.tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$SavedContentImplCopyWith<$Res>
    implements $SavedContentCopyWith<$Res> {
  factory _$$SavedContentImplCopyWith(
          _$SavedContentImpl value, $Res Function(_$SavedContentImpl) then) =
      __$$SavedContentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String title,
      ContentType type,
      String htmlContent,
      String? cssContent,
      String? javascriptContent,
      String? description,
      DateTime createdAt,
      DateTime? updatedAt,
      List<String> tags});
}

/// @nodoc
class __$$SavedContentImplCopyWithImpl<$Res>
    extends _$SavedContentCopyWithImpl<$Res, _$SavedContentImpl>
    implements _$$SavedContentImplCopyWith<$Res> {
  __$$SavedContentImplCopyWithImpl(
      _$SavedContentImpl _value, $Res Function(_$SavedContentImpl) _then)
      : super(_value, _then);

  /// Create a copy of SavedContent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? title = null,
    Object? type = null,
    Object? htmlContent = null,
    Object? cssContent = freezed,
    Object? javascriptContent = freezed,
    Object? description = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? tags = null,
  }) {
    return _then(_$SavedContentImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _value.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      title: null == title
          ? _value.title
          : title // ignore: cast_nullable_to_non_nullable
              as String,
      type: null == type
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as ContentType,
      htmlContent: null == htmlContent
          ? _value.htmlContent
          : htmlContent // ignore: cast_nullable_to_non_nullable
              as String,
      cssContent: freezed == cssContent
          ? _value.cssContent
          : cssContent // ignore: cast_nullable_to_non_nullable
              as String?,
      javascriptContent: freezed == javascriptContent
          ? _value.javascriptContent
          : javascriptContent // ignore: cast_nullable_to_non_nullable
              as String?,
      description: freezed == description
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String?,
      createdAt: null == createdAt
          ? _value.createdAt
          : createdAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
      updatedAt: freezed == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime?,
      tags: null == tags
          ? _value._tags
          : tags // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$SavedContentImpl extends _SavedContent {
  const _$SavedContentImpl(
      {required this.id,
      required this.userId,
      required this.title,
      required this.type,
      required this.htmlContent,
      this.cssContent,
      this.javascriptContent,
      this.description,
      required this.createdAt,
      this.updatedAt,
      final List<String> tags = const []})
      : _tags = tags,
        super._();

  factory _$SavedContentImpl.fromJson(Map<String, dynamic> json) =>
      _$$SavedContentImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String title;
  @override
  final ContentType type;
  @override
  final String htmlContent;
  @override
  final String? cssContent;
  @override
  final String? javascriptContent;
  @override
  final String? description;
  @override
  final DateTime createdAt;
  @override
  final DateTime? updatedAt;
  final List<String> _tags;
  @override
  @JsonKey()
  List<String> get tags {
    if (_tags is EqualUnmodifiableListView) return _tags;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_tags);
  }

  @override
  String toString() {
    return 'SavedContent(id: $id, userId: $userId, title: $title, type: $type, htmlContent: $htmlContent, cssContent: $cssContent, javascriptContent: $javascriptContent, description: $description, createdAt: $createdAt, updatedAt: $updatedAt, tags: $tags)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SavedContentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.type, type) || other.type == type) &&
            (identical(other.htmlContent, htmlContent) ||
                other.htmlContent == htmlContent) &&
            (identical(other.cssContent, cssContent) ||
                other.cssContent == cssContent) &&
            (identical(other.javascriptContent, javascriptContent) ||
                other.javascriptContent == javascriptContent) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._tags, _tags));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      userId,
      title,
      type,
      htmlContent,
      cssContent,
      javascriptContent,
      description,
      createdAt,
      updatedAt,
      const DeepCollectionEquality().hash(_tags));

  /// Create a copy of SavedContent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SavedContentImplCopyWith<_$SavedContentImpl> get copyWith =>
      __$$SavedContentImplCopyWithImpl<_$SavedContentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SavedContentImplToJson(
      this,
    );
  }
}

abstract class _SavedContent extends SavedContent {
  const factory _SavedContent(
      {required final String id,
      required final String userId,
      required final String title,
      required final ContentType type,
      required final String htmlContent,
      final String? cssContent,
      final String? javascriptContent,
      final String? description,
      required final DateTime createdAt,
      final DateTime? updatedAt,
      final List<String> tags}) = _$SavedContentImpl;
  const _SavedContent._() : super._();

  factory _SavedContent.fromJson(Map<String, dynamic> json) =
      _$SavedContentImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String get title;
  @override
  ContentType get type;
  @override
  String get htmlContent;
  @override
  String? get cssContent;
  @override
  String? get javascriptContent;
  @override
  String? get description;
  @override
  DateTime get createdAt;
  @override
  DateTime? get updatedAt;
  @override
  List<String> get tags;

  /// Create a copy of SavedContent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SavedContentImplCopyWith<_$SavedContentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
