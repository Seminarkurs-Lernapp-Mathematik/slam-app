// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserSettings {
  ThemeSettings get theme;
  AIModelSettings get aiModel;
  String get gradeLevel;
  String get courseType;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserSettingsCopyWith<UserSettings> get copyWith =>
      _$UserSettingsCopyWithImpl<UserSettings>(
          this as UserSettings, _$identity);

  /// Serializes this UserSettings to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserSettings &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.aiModel, aiModel) || other.aiModel == aiModel) &&
            (identical(other.gradeLevel, gradeLevel) ||
                other.gradeLevel == gradeLevel) &&
            (identical(other.courseType, courseType) ||
                other.courseType == courseType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, theme, aiModel, gradeLevel, courseType);

  @override
  String toString() {
    return 'UserSettings(theme: $theme, aiModel: $aiModel, gradeLevel: $gradeLevel, courseType: $courseType)';
  }
}

/// @nodoc
abstract mixin class $UserSettingsCopyWith<$Res> {
  factory $UserSettingsCopyWith(
          UserSettings value, $Res Function(UserSettings) _then) =
      _$UserSettingsCopyWithImpl;
  @useResult
  $Res call(
      {ThemeSettings theme,
      AIModelSettings aiModel,
      String gradeLevel,
      String courseType});

  $ThemeSettingsCopyWith<$Res> get theme;
  $AIModelSettingsCopyWith<$Res> get aiModel;
}

/// @nodoc
class _$UserSettingsCopyWithImpl<$Res> implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._self, this._then);

  final UserSettings _self;
  final $Res Function(UserSettings) _then;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? theme = null,
    Object? aiModel = null,
    Object? gradeLevel = null,
    Object? courseType = null,
  }) {
    return _then(_self.copyWith(
      theme: null == theme
          ? _self.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as ThemeSettings,
      aiModel: null == aiModel
          ? _self.aiModel
          : aiModel // ignore: cast_nullable_to_non_nullable
              as AIModelSettings,
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

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ThemeSettingsCopyWith<$Res> get theme {
    return $ThemeSettingsCopyWith<$Res>(_self.theme, (value) {
      return _then(_self.copyWith(theme: value));
    });
  }

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AIModelSettingsCopyWith<$Res> get aiModel {
    return $AIModelSettingsCopyWith<$Res>(_self.aiModel, (value) {
      return _then(_self.copyWith(aiModel: value));
    });
  }
}

/// @nodoc
@JsonSerializable()
class _UserSettings implements UserSettings {
  const _UserSettings(
      {required this.theme,
      required this.aiModel,
      this.gradeLevel = 'Klasse_11',
      this.courseType = 'Leistungsfach'});
  factory _UserSettings.fromJson(Map<String, dynamic> json) =>
      _$UserSettingsFromJson(json);

  @override
  final ThemeSettings theme;
  @override
  final AIModelSettings aiModel;
  @override
  @JsonKey()
  final String gradeLevel;
  @override
  @JsonKey()
  final String courseType;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserSettingsCopyWith<_UserSettings> get copyWith =>
      __$UserSettingsCopyWithImpl<_UserSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserSettingsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserSettings &&
            (identical(other.theme, theme) || other.theme == theme) &&
            (identical(other.aiModel, aiModel) || other.aiModel == aiModel) &&
            (identical(other.gradeLevel, gradeLevel) ||
                other.gradeLevel == gradeLevel) &&
            (identical(other.courseType, courseType) ||
                other.courseType == courseType));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, theme, aiModel, gradeLevel, courseType);

  @override
  String toString() {
    return 'UserSettings(theme: $theme, aiModel: $aiModel, gradeLevel: $gradeLevel, courseType: $courseType)';
  }
}

/// @nodoc
abstract mixin class _$UserSettingsCopyWith<$Res>
    implements $UserSettingsCopyWith<$Res> {
  factory _$UserSettingsCopyWith(
          _UserSettings value, $Res Function(_UserSettings) _then) =
      __$UserSettingsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {ThemeSettings theme,
      AIModelSettings aiModel,
      String gradeLevel,
      String courseType});

  @override
  $ThemeSettingsCopyWith<$Res> get theme;
  @override
  $AIModelSettingsCopyWith<$Res> get aiModel;
}

/// @nodoc
class __$UserSettingsCopyWithImpl<$Res>
    implements _$UserSettingsCopyWith<$Res> {
  __$UserSettingsCopyWithImpl(this._self, this._then);

  final _UserSettings _self;
  final $Res Function(_UserSettings) _then;

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? theme = null,
    Object? aiModel = null,
    Object? gradeLevel = null,
    Object? courseType = null,
  }) {
    return _then(_UserSettings(
      theme: null == theme
          ? _self.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as ThemeSettings,
      aiModel: null == aiModel
          ? _self.aiModel
          : aiModel // ignore: cast_nullable_to_non_nullable
              as AIModelSettings,
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

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $ThemeSettingsCopyWith<$Res> get theme {
    return $ThemeSettingsCopyWith<$Res>(_self.theme, (value) {
      return _then(_self.copyWith(theme: value));
    });
  }

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AIModelSettingsCopyWith<$Res> get aiModel {
    return $AIModelSettingsCopyWith<$Res>(_self.aiModel, (value) {
      return _then(_self.copyWith(aiModel: value));
    });
  }
}

/// @nodoc
mixin _$ThemeSettings {
  String get name;
  String get primary;
  String get gradient;
  String get gradientFrom;
  String get gradientTo;
  String get glow;

  /// Create a copy of ThemeSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ThemeSettingsCopyWith<ThemeSettings> get copyWith =>
      _$ThemeSettingsCopyWithImpl<ThemeSettings>(
          this as ThemeSettings, _$identity);

  /// Serializes this ThemeSettings to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ThemeSettings &&
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

  @override
  String toString() {
    return 'ThemeSettings(name: $name, primary: $primary, gradient: $gradient, gradientFrom: $gradientFrom, gradientTo: $gradientTo, glow: $glow)';
  }
}

/// @nodoc
abstract mixin class $ThemeSettingsCopyWith<$Res> {
  factory $ThemeSettingsCopyWith(
          ThemeSettings value, $Res Function(ThemeSettings) _then) =
      _$ThemeSettingsCopyWithImpl;
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
class _$ThemeSettingsCopyWithImpl<$Res>
    implements $ThemeSettingsCopyWith<$Res> {
  _$ThemeSettingsCopyWithImpl(this._self, this._then);

  final ThemeSettings _self;
  final $Res Function(ThemeSettings) _then;

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
    return _then(_self.copyWith(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      primary: null == primary
          ? _self.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as String,
      gradient: null == gradient
          ? _self.gradient
          : gradient // ignore: cast_nullable_to_non_nullable
              as String,
      gradientFrom: null == gradientFrom
          ? _self.gradientFrom
          : gradientFrom // ignore: cast_nullable_to_non_nullable
              as String,
      gradientTo: null == gradientTo
          ? _self.gradientTo
          : gradientTo // ignore: cast_nullable_to_non_nullable
              as String,
      glow: null == glow
          ? _self.glow
          : glow // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _ThemeSettings implements ThemeSettings {
  const _ThemeSettings(
      {required this.name,
      required this.primary,
      required this.gradient,
      required this.gradientFrom,
      required this.gradientTo,
      required this.glow});
  factory _ThemeSettings.fromJson(Map<String, dynamic> json) =>
      _$ThemeSettingsFromJson(json);

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

  /// Create a copy of ThemeSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ThemeSettingsCopyWith<_ThemeSettings> get copyWith =>
      __$ThemeSettingsCopyWithImpl<_ThemeSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ThemeSettingsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ThemeSettings &&
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

  @override
  String toString() {
    return 'ThemeSettings(name: $name, primary: $primary, gradient: $gradient, gradientFrom: $gradientFrom, gradientTo: $gradientTo, glow: $glow)';
  }
}

/// @nodoc
abstract mixin class _$ThemeSettingsCopyWith<$Res>
    implements $ThemeSettingsCopyWith<$Res> {
  factory _$ThemeSettingsCopyWith(
          _ThemeSettings value, $Res Function(_ThemeSettings) _then) =
      __$ThemeSettingsCopyWithImpl;
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
class __$ThemeSettingsCopyWithImpl<$Res>
    implements _$ThemeSettingsCopyWith<$Res> {
  __$ThemeSettingsCopyWithImpl(this._self, this._then);

  final _ThemeSettings _self;
  final $Res Function(_ThemeSettings) _then;

  /// Create a copy of ThemeSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? name = null,
    Object? primary = null,
    Object? gradient = null,
    Object? gradientFrom = null,
    Object? gradientTo = null,
    Object? glow = null,
  }) {
    return _then(_ThemeSettings(
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      primary: null == primary
          ? _self.primary
          : primary // ignore: cast_nullable_to_non_nullable
              as String,
      gradient: null == gradient
          ? _self.gradient
          : gradient // ignore: cast_nullable_to_non_nullable
              as String,
      gradientFrom: null == gradientFrom
          ? _self.gradientFrom
          : gradientFrom // ignore: cast_nullable_to_non_nullable
              as String,
      gradientTo: null == gradientTo
          ? _self.gradientTo
          : gradientTo // ignore: cast_nullable_to_non_nullable
              as String,
      glow: null == glow
          ? _self.glow
          : glow // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
mixin _$AIModelSettings {
  int get detailLevel; // 0-100
  double get temperature; // 0-1
  int get helpfulness; // 0-100
  bool get autoMode;

  /// Create a copy of AIModelSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $AIModelSettingsCopyWith<AIModelSettings> get copyWith =>
      _$AIModelSettingsCopyWithImpl<AIModelSettings>(
          this as AIModelSettings, _$identity);

  /// Serializes this AIModelSettings to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is AIModelSettings &&
            (identical(other.detailLevel, detailLevel) ||
                other.detailLevel == detailLevel) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.helpfulness, helpfulness) ||
                other.helpfulness == helpfulness) &&
            (identical(other.autoMode, autoMode) ||
                other.autoMode == autoMode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, detailLevel, temperature, helpfulness, autoMode);

  @override
  String toString() {
    return 'AIModelSettings(detailLevel: $detailLevel, temperature: $temperature, helpfulness: $helpfulness, autoMode: $autoMode)';
  }
}

/// @nodoc
abstract mixin class $AIModelSettingsCopyWith<$Res> {
  factory $AIModelSettingsCopyWith(
          AIModelSettings value, $Res Function(AIModelSettings) _then) =
      _$AIModelSettingsCopyWithImpl;
  @useResult
  $Res call(
      {int detailLevel, double temperature, int helpfulness, bool autoMode});
}

/// @nodoc
class _$AIModelSettingsCopyWithImpl<$Res>
    implements $AIModelSettingsCopyWith<$Res> {
  _$AIModelSettingsCopyWithImpl(this._self, this._then);

  final AIModelSettings _self;
  final $Res Function(AIModelSettings) _then;

  /// Create a copy of AIModelSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? detailLevel = null,
    Object? temperature = null,
    Object? helpfulness = null,
    Object? autoMode = null,
  }) {
    return _then(_self.copyWith(
      detailLevel: null == detailLevel
          ? _self.detailLevel
          : detailLevel // ignore: cast_nullable_to_non_nullable
              as int,
      temperature: null == temperature
          ? _self.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      helpfulness: null == helpfulness
          ? _self.helpfulness
          : helpfulness // ignore: cast_nullable_to_non_nullable
              as int,
      autoMode: null == autoMode
          ? _self.autoMode
          : autoMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _AIModelSettings implements AIModelSettings {
  const _AIModelSettings(
      {this.detailLevel = 50,
      this.temperature = 0.5,
      this.helpfulness = 50,
      this.autoMode = true});
  factory _AIModelSettings.fromJson(Map<String, dynamic> json) =>
      _$AIModelSettingsFromJson(json);

  @override
  @JsonKey()
  final int detailLevel;
// 0-100
  @override
  @JsonKey()
  final double temperature;
// 0-1
  @override
  @JsonKey()
  final int helpfulness;
// 0-100
  @override
  @JsonKey()
  final bool autoMode;

  /// Create a copy of AIModelSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$AIModelSettingsCopyWith<_AIModelSettings> get copyWith =>
      __$AIModelSettingsCopyWithImpl<_AIModelSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$AIModelSettingsToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _AIModelSettings &&
            (identical(other.detailLevel, detailLevel) ||
                other.detailLevel == detailLevel) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.helpfulness, helpfulness) ||
                other.helpfulness == helpfulness) &&
            (identical(other.autoMode, autoMode) ||
                other.autoMode == autoMode));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, detailLevel, temperature, helpfulness, autoMode);

  @override
  String toString() {
    return 'AIModelSettings(detailLevel: $detailLevel, temperature: $temperature, helpfulness: $helpfulness, autoMode: $autoMode)';
  }
}

/// @nodoc
abstract mixin class _$AIModelSettingsCopyWith<$Res>
    implements $AIModelSettingsCopyWith<$Res> {
  factory _$AIModelSettingsCopyWith(
          _AIModelSettings value, $Res Function(_AIModelSettings) _then) =
      __$AIModelSettingsCopyWithImpl;
  @override
  @useResult
  $Res call(
      {int detailLevel, double temperature, int helpfulness, bool autoMode});
}

/// @nodoc
class __$AIModelSettingsCopyWithImpl<$Res>
    implements _$AIModelSettingsCopyWith<$Res> {
  __$AIModelSettingsCopyWithImpl(this._self, this._then);

  final _AIModelSettings _self;
  final $Res Function(_AIModelSettings) _then;

  /// Create a copy of AIModelSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? detailLevel = null,
    Object? temperature = null,
    Object? helpfulness = null,
    Object? autoMode = null,
  }) {
    return _then(_AIModelSettings(
      detailLevel: null == detailLevel
          ? _self.detailLevel
          : detailLevel // ignore: cast_nullable_to_non_nullable
              as int,
      temperature: null == temperature
          ? _self.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      helpfulness: null == helpfulness
          ? _self.helpfulness
          : helpfulness // ignore: cast_nullable_to_non_nullable
              as int,
      autoMode: null == autoMode
          ? _self.autoMode
          : autoMode // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
