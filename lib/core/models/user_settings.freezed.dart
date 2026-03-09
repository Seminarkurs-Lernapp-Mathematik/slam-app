// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) {
  return _UserSettings.fromJson(json);
}

/// @nodoc
mixin _$UserSettings {
  ThemeSettings get theme => throw _privateConstructorUsedError;
  String get gradeLevel => throw _privateConstructorUsedError;
  String get courseType => throw _privateConstructorUsedError;

  /// Serializes this UserSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $UserSettingsCopyWith<UserSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSettingsCopyWith<$Res> {
  factory $UserSettingsCopyWith(
          UserSettings value, $Res Function(UserSettings) then) =
      _$UserSettingsCopyWithImpl<$Res, UserSettings>;
  @useResult
  $Res call({ThemeSettings theme, String gradeLevel, String courseType});

  $ThemeSettingsCopyWith<$Res> get theme;
}

/// @nodoc
class _$UserSettingsCopyWithImpl<$Res, $Val extends UserSettings>
    implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theme = null,
    Object? gradeLevel = null,
    Object? courseType = null,
  }) {
    return _then(_value.copyWith(
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as ThemeSettings,
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

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ThemeSettingsCopyWith<$Res> get theme {
    return $ThemeSettingsCopyWith<$Res>(_value.theme, (value) {
      return _then(_value.copyWith(theme: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$UserSettingsImplCopyWith<$Res>
    implements $UserSettingsCopyWith<$Res> {
  factory _$$UserSettingsImplCopyWith(
          _$UserSettingsImpl value, $Res Function(_$UserSettingsImpl) then) =
      __$$UserSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({ThemeSettings theme, String gradeLevel, String courseType});

  @override
  $ThemeSettingsCopyWith<$Res> get theme;
}

/// @nodoc
class __$$UserSettingsImplCopyWithImpl<$Res>
    extends _$UserSettingsCopyWithImpl<$Res, _$UserSettingsImpl>
    implements _$$UserSettingsImplCopyWith<$Res> {
  __$$UserSettingsImplCopyWithImpl(
      _$UserSettingsImpl _value, $Res Function(_$UserSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theme = null,
    Object? gradeLevel = null,
    Object? courseType = null,
  }) {
    return _then(_$UserSettingsImpl(
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as ThemeSettings,
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
class _$UserSettingsImpl extends _UserSettings {
  const _$UserSettingsImpl(
      {required this.theme,
      this.gradeLevel = 'Klasse_11',
      this.courseType = 'Leistungsfach'})
      : super._();

  factory _$UserSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSettingsImplFromJson(json);

  @override
  final ThemeSettings theme;
  @override
  @JsonKey()
  final String gradeLevel;
  @override
  @JsonKey()
  final String courseType;

  @override
  String toString() {
    return 'UserSettings(theme: $theme, gradeLevel: $gradeLevel, courseType: $courseType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSettingsImpl &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.gradeLevel, gradeLevel) ||
                other.gradeLevel == gradeLevel) &&
            (identical(other.courseType, courseType) ||
                other.courseType == courseType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, theme, gradeLevel, courseType);

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      __$$UserSettingsImplCopyWithImpl<_$UserSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$UserSettingsImplToJson(
      this,
    );
  }
}

abstract class _UserSettings extends UserSettings {
  const factory _UserSettings(
      {required final ThemeSettings theme,
      final String gradeLevel,
      final String courseType}) = _$UserSettingsImpl;
  const _UserSettings._() : super._();

  factory _UserSettings.fromJson(Map<String, dynamic> json) =
      _$UserSettingsImpl.fromJson;

  @override
  ThemeSettings get theme;
  @override
  String get gradeLevel;
  @override
  String get courseType;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$UserSettingsImplCopyWith<_$UserSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

ThemeSettings _$ThemeSettingsFromJson(Map<String, dynamic> json) {
  return _ThemeSettings.fromJson(json);
}

/// @nodoc
mixin _$ThemeSettings {
  String get name => throw _privateConstructorUsedError;
  String get primary => throw _privateConstructorUsedError;
  String get gradient => throw _privateConstructorUsedError;
  String get gradientFrom => throw _privateConstructorUsedError;
  String get gradientTo => throw _privateConstructorUsedError;
  String get glow => throw _privateConstructorUsedError;

  /// Serializes this ThemeSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ThemeSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ThemeSettingsCopyWith<ThemeSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ThemeSettingsCopyWith<$Res> {
  factory $ThemeSettingsCopyWith(
          ThemeSettings value, $Res Function(ThemeSettings) then) =
      _$ThemeSettingsCopyWithImpl<$Res, ThemeSettings>;
  @useResult
  $Res call(
      {String name,
      String primary,
      String gradient,
      String gradientFrom,
      String gradientTo,
      String glow});
}

/// @nodoc
class _$ThemeSettingsCopyWithImpl<$Res, $Val extends ThemeSettings>
    implements $ThemeSettingsCopyWith<$Res> {
  _$ThemeSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ThemeSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? primary = null,
    Object? gradient = null,
    Object? gradientFrom = null,
    Object? gradientTo = null,
    Object? glow = null,
  }) {
    return _then(_value.copyWith(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      primary: null == primary
          ? _value.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as String,
      gradient: null == gradient
          ? _value.gradient
          : gradient // ignore: cast_nullable_to_non_nullable
              as String,
      gradientFrom: null == gradientFrom
          ? _value.gradientFrom
          : gradientFrom // ignore: cast_nullable_to_non_nullable
              as String,
      gradientTo: null == gradientTo
          ? _value.gradientTo
          : gradientTo // ignore: cast_nullable_to_non_nullable
              as String,
      glow: null == glow
          ? _value.glow
          : glow // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ThemeSettingsImplCopyWith<$Res>
    implements $ThemeSettingsCopyWith<$Res> {
  factory _$$ThemeSettingsImplCopyWith(
          _$ThemeSettingsImpl value, $Res Function(_$ThemeSettingsImpl) then) =
      __$$ThemeSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String name,
      String primary,
      String gradient,
      String gradientFrom,
      String gradientTo,
      String glow});
}

/// @nodoc
class __$$ThemeSettingsImplCopyWithImpl<$Res>
    extends _$ThemeSettingsCopyWithImpl<$Res, _$ThemeSettingsImpl>
    implements _$$ThemeSettingsImplCopyWith<$Res> {
  __$$ThemeSettingsImplCopyWithImpl(
      _$ThemeSettingsImpl _value, $Res Function(_$ThemeSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of ThemeSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? name = null,
    Object? primary = null,
    Object? gradient = null,
    Object? gradientFrom = null,
    Object? gradientTo = null,
    Object? glow = null,
  }) {
    return _then(_$ThemeSettingsImpl(
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      primary: null == primary
          ? _value.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as String,
      gradient: null == gradient
          ? _value.gradient
          : gradient // ignore: cast_nullable_to_non_nullable
              as String,
      gradientFrom: null == gradientFrom
          ? _value.gradientFrom
          : gradientFrom // ignore: cast_nullable_to_non_nullable
              as String,
      gradientTo: null == gradientTo
          ? _value.gradientTo
          : gradientTo // ignore: cast_nullable_to_non_nullable
              as String,
      glow: null == glow
          ? _value.glow
          : glow // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ThemeSettingsImpl extends _ThemeSettings {
  const _$ThemeSettingsImpl(
      {required this.name,
      required this.primary,
      required this.gradient,
      required this.gradientFrom,
      required this.gradientTo,
      required this.glow})
      : super._();

  factory _$ThemeSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$ThemeSettingsImplFromJson(json);

  @override
  final String name;
  @override
  final String primary;
  @override
  final String gradient;
  @override
  final String gradientFrom;
  @override
  final String gradientTo;
  @override
  final String glow;

  @override
  String toString() {
    return 'ThemeSettings(name: $name, primary: $primary, gradient: $gradient, gradientFrom: $gradientFrom, gradientTo: $gradientTo, glow: $glow)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ThemeSettingsImpl &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.primary, primary) || other.primary == primary) &&
            (identical(other.gradient, gradient) ||
                other.gradient == gradient) &&
            (identical(other.gradientFrom, gradientFrom) ||
                other.gradientFrom == gradientFrom) &&
            (identical(other.gradientTo, gradientTo) ||
                other.gradientTo == gradientTo) &&
            (identical(other.glow, glow) || other.glow == glow));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, name, primary, gradient, gradientFrom, gradientTo, glow);

  /// Create a copy of ThemeSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ThemeSettingsImplCopyWith<_$ThemeSettingsImpl> get copyWith =>
      __$$ThemeSettingsImplCopyWithImpl<_$ThemeSettingsImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ThemeSettingsImplToJson(
      this,
    );
  }
}

abstract class _ThemeSettings extends ThemeSettings {
  const factory _ThemeSettings(
      {required final String name,
      required final String primary,
      required final String gradient,
      required final String gradientFrom,
      required final String gradientTo,
      required final String glow}) = _$ThemeSettingsImpl;
  const _ThemeSettings._() : super._();

  factory _ThemeSettings.fromJson(Map<String, dynamic> json) =
      _$ThemeSettingsImpl.fromJson;

  @override
  String get name;
  @override
  String get primary;
  @override
  String get gradient;
  @override
  String get gradientFrom;
  @override
  String get gradientTo;
  @override
  String get glow;

  /// Create a copy of ThemeSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ThemeSettingsImplCopyWith<_$ThemeSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
