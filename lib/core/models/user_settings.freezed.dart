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
  AIModelSettings get aiModel => throw _privateConstructorUsedError;
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
  $Res call(
      {ThemeSettings theme,
      AIModelSettings aiModel,
      String gradeLevel,
      String courseType});

  $ThemeSettingsCopyWith<$Res> get theme;
  $AIModelSettingsCopyWith<$Res> get aiModel;
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
    Object? aiModel = null,
    Object? gradeLevel = null,
    Object? courseType = null,
  }) {
    return _then(_value.copyWith(
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as ThemeSettings,
      aiModel: null == aiModel
          ? _value.aiModel
          : aiModel // ignore: cast_nullable_to_non_nullable
              as AIModelSettings,
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

  /// Create a copy of UserSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $AIModelSettingsCopyWith<$Res> get aiModel {
    return $AIModelSettingsCopyWith<$Res>(_value.aiModel, (value) {
      return _then(_value.copyWith(aiModel: value) as $Val);
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
    Object? aiModel = null,
    Object? gradeLevel = null,
    Object? courseType = null,
  }) {
    return _then(_$UserSettingsImpl(
      theme: null == theme
          ? _value.theme
          : theme // ignore: cast_nullable_to_non_nullable
              as ThemeSettings,
      aiModel: null == aiModel
          ? _value.aiModel
          : aiModel // ignore: cast_nullable_to_non_nullable
              as AIModelSettings,
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
      required this.aiModel,
      this.gradeLevel = 'Klasse_11',
      this.courseType = 'Leistungsfach'})
      : super._();

  factory _$UserSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$UserSettingsImplFromJson(json);

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

  @override
  String toString() {
    return 'UserSettings(theme: $theme, aiModel: $aiModel, gradeLevel: $gradeLevel, courseType: $courseType)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$UserSettingsImpl &&
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
      required final AIModelSettings aiModel,
      final String gradeLevel,
      final String courseType}) = _$UserSettingsImpl;
  const _UserSettings._() : super._();

  factory _UserSettings.fromJson(Map<String, dynamic> json) =
      _$UserSettingsImpl.fromJson;

  @override
  ThemeSettings get theme;
  @override
  AIModelSettings get aiModel;
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

AIModelSettings _$AIModelSettingsFromJson(Map<String, dynamic> json) {
  return _AIModelSettings.fromJson(json);
}

/// @nodoc
mixin _$AIModelSettings {
  int get detailLevel => throw _privateConstructorUsedError; // 1-10
  double get temperature => throw _privateConstructorUsedError; // 0-1
  int get helpfulness => throw _privateConstructorUsedError; // 1-10
  bool get autoMode => throw _privateConstructorUsedError;
  String get aiProvider =>
      throw _privateConstructorUsedError; // 'claude' or 'gemini'
  String? get claudeApiKey => throw _privateConstructorUsedError;
  String? get geminiApiKey => throw _privateConstructorUsedError;
  String get geminiFastModel => throw _privateConstructorUsedError;
  String get geminiModel => throw _privateConstructorUsedError;
  String get geminiSmartModel => throw _privateConstructorUsedError;
  String get modelMode =>
      throw _privateConstructorUsedError; // 'fast', 'standard', 'smart'
  String? get selectedModel =>
      throw _privateConstructorUsedError; // Current active model (derived from provider + mode)
  bool get showAiAssessments => throw _privateConstructorUsedError;

  /// Serializes this AIModelSettings to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AIModelSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AIModelSettingsCopyWith<AIModelSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AIModelSettingsCopyWith<$Res> {
  factory $AIModelSettingsCopyWith(
          AIModelSettings value, $Res Function(AIModelSettings) then) =
      _$AIModelSettingsCopyWithImpl<$Res, AIModelSettings>;
  @useResult
  $Res call(
      {int detailLevel,
      double temperature,
      int helpfulness,
      bool autoMode,
      String aiProvider,
      String? claudeApiKey,
      String? geminiApiKey,
      String geminiFastModel,
      String geminiModel,
      String geminiSmartModel,
      String modelMode,
      String? selectedModel,
      bool showAiAssessments});
}

/// @nodoc
class _$AIModelSettingsCopyWithImpl<$Res, $Val extends AIModelSettings>
    implements $AIModelSettingsCopyWith<$Res> {
  _$AIModelSettingsCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AIModelSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? detailLevel = null,
    Object? temperature = null,
    Object? helpfulness = null,
    Object? autoMode = null,
    Object? aiProvider = null,
    Object? claudeApiKey = freezed,
    Object? geminiApiKey = freezed,
    Object? geminiFastModel = null,
    Object? geminiModel = null,
    Object? geminiSmartModel = null,
    Object? modelMode = null,
    Object? selectedModel = freezed,
    Object? showAiAssessments = null,
  }) {
    return _then(_value.copyWith(
      detailLevel: null == detailLevel
          ? _value.detailLevel
          : detailLevel // ignore: cast_nullable_to_non_nullable
              as int,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      helpfulness: null == helpfulness
          ? _value.helpfulness
          : helpfulness // ignore: cast_nullable_to_non_nullable
              as int,
      autoMode: null == autoMode
          ? _value.autoMode
          : autoMode // ignore: cast_nullable_to_non_nullable
              as bool,
      aiProvider: null == aiProvider
          ? _value.aiProvider
          : aiProvider // ignore: cast_nullable_to_non_nullable
              as String,
      claudeApiKey: freezed == claudeApiKey
          ? _value.claudeApiKey
          : claudeApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      geminiApiKey: freezed == geminiApiKey
          ? _value.geminiApiKey
          : geminiApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      geminiFastModel: null == geminiFastModel
          ? _value.geminiFastModel
          : geminiFastModel // ignore: cast_nullable_to_non_nullable
              as String,
      geminiModel: null == geminiModel
          ? _value.geminiModel
          : geminiModel // ignore: cast_nullable_to_non_nullable
              as String,
      geminiSmartModel: null == geminiSmartModel
          ? _value.geminiSmartModel
          : geminiSmartModel // ignore: cast_nullable_to_non_nullable
              as String,
      modelMode: null == modelMode
          ? _value.modelMode
          : modelMode // ignore: cast_nullable_to_non_nullable
              as String,
      selectedModel: freezed == selectedModel
          ? _value.selectedModel
          : selectedModel // ignore: cast_nullable_to_non_nullable
              as String?,
      showAiAssessments: null == showAiAssessments
          ? _value.showAiAssessments
          : showAiAssessments // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AIModelSettingsImplCopyWith<$Res>
    implements $AIModelSettingsCopyWith<$Res> {
  factory _$$AIModelSettingsImplCopyWith(_$AIModelSettingsImpl value,
          $Res Function(_$AIModelSettingsImpl) then) =
      __$$AIModelSettingsImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int detailLevel,
      double temperature,
      int helpfulness,
      bool autoMode,
      String aiProvider,
      String? claudeApiKey,
      String? geminiApiKey,
      String geminiFastModel,
      String geminiModel,
      String geminiSmartModel,
      String modelMode,
      String? selectedModel,
      bool showAiAssessments});
}

/// @nodoc
class __$$AIModelSettingsImplCopyWithImpl<$Res>
    extends _$AIModelSettingsCopyWithImpl<$Res, _$AIModelSettingsImpl>
    implements _$$AIModelSettingsImplCopyWith<$Res> {
  __$$AIModelSettingsImplCopyWithImpl(
      _$AIModelSettingsImpl _value, $Res Function(_$AIModelSettingsImpl) _then)
      : super(_value, _then);

  /// Create a copy of AIModelSettings
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? detailLevel = null,
    Object? temperature = null,
    Object? helpfulness = null,
    Object? autoMode = null,
    Object? aiProvider = null,
    Object? claudeApiKey = freezed,
    Object? geminiApiKey = freezed,
    Object? geminiFastModel = null,
    Object? geminiModel = null,
    Object? geminiSmartModel = null,
    Object? modelMode = null,
    Object? selectedModel = freezed,
    Object? showAiAssessments = null,
  }) {
    return _then(_$AIModelSettingsImpl(
      detailLevel: null == detailLevel
          ? _value.detailLevel
          : detailLevel // ignore: cast_nullable_to_non_nullable
              as int,
      temperature: null == temperature
          ? _value.temperature
          : temperature // ignore: cast_nullable_to_non_nullable
              as double,
      helpfulness: null == helpfulness
          ? _value.helpfulness
          : helpfulness // ignore: cast_nullable_to_non_nullable
              as int,
      autoMode: null == autoMode
          ? _value.autoMode
          : autoMode // ignore: cast_nullable_to_non_nullable
              as bool,
      aiProvider: null == aiProvider
          ? _value.aiProvider
          : aiProvider // ignore: cast_nullable_to_non_nullable
              as String,
      claudeApiKey: freezed == claudeApiKey
          ? _value.claudeApiKey
          : claudeApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      geminiApiKey: freezed == geminiApiKey
          ? _value.geminiApiKey
          : geminiApiKey // ignore: cast_nullable_to_non_nullable
              as String?,
      geminiFastModel: null == geminiFastModel
          ? _value.geminiFastModel
          : geminiFastModel // ignore: cast_nullable_to_non_nullable
              as String,
      geminiModel: null == geminiModel
          ? _value.geminiModel
          : geminiModel // ignore: cast_nullable_to_non_nullable
              as String,
      geminiSmartModel: null == geminiSmartModel
          ? _value.geminiSmartModel
          : geminiSmartModel // ignore: cast_nullable_to_non_nullable
              as String,
      modelMode: null == modelMode
          ? _value.modelMode
          : modelMode // ignore: cast_nullable_to_non_nullable
              as String,
      selectedModel: freezed == selectedModel
          ? _value.selectedModel
          : selectedModel // ignore: cast_nullable_to_non_nullable
              as String?,
      showAiAssessments: null == showAiAssessments
          ? _value.showAiAssessments
          : showAiAssessments // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AIModelSettingsImpl extends _AIModelSettings {
  const _$AIModelSettingsImpl(
      {this.detailLevel = 5,
      this.temperature = 0.7,
      this.helpfulness = 7,
      this.autoMode = true,
      this.aiProvider = 'gemini',
      this.claudeApiKey,
      this.geminiApiKey,
      this.geminiFastModel = 'gemini-2.0-flash-lite',
      this.geminiModel = 'gemini-2.0-flash',
      this.geminiSmartModel = 'gemini-2.5-pro-preview-05-06',
      this.modelMode = 'fast',
      this.selectedModel,
      this.showAiAssessments = false})
      : super._();

  factory _$AIModelSettingsImpl.fromJson(Map<String, dynamic> json) =>
      _$$AIModelSettingsImplFromJson(json);

  @override
  @JsonKey()
  final int detailLevel;
// 1-10
  @override
  @JsonKey()
  final double temperature;
// 0-1
  @override
  @JsonKey()
  final int helpfulness;
// 1-10
  @override
  @JsonKey()
  final bool autoMode;
  @override
  @JsonKey()
  final String aiProvider;
// 'claude' or 'gemini'
  @override
  final String? claudeApiKey;
  @override
  final String? geminiApiKey;
  @override
  @JsonKey()
  final String geminiFastModel;
  @override
  @JsonKey()
  final String geminiModel;
  @override
  @JsonKey()
  final String geminiSmartModel;
  @override
  @JsonKey()
  final String modelMode;
// 'fast', 'standard', 'smart'
  @override
  final String? selectedModel;
// Current active model (derived from provider + mode)
  @override
  @JsonKey()
  final bool showAiAssessments;

  @override
  String toString() {
    return 'AIModelSettings(detailLevel: $detailLevel, temperature: $temperature, helpfulness: $helpfulness, autoMode: $autoMode, aiProvider: $aiProvider, claudeApiKey: $claudeApiKey, geminiApiKey: $geminiApiKey, geminiFastModel: $geminiFastModel, geminiModel: $geminiModel, geminiSmartModel: $geminiSmartModel, modelMode: $modelMode, selectedModel: $selectedModel, showAiAssessments: $showAiAssessments)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AIModelSettingsImpl &&
            (identical(other.detailLevel, detailLevel) ||
                other.detailLevel == detailLevel) &&
            (identical(other.temperature, temperature) ||
                other.temperature == temperature) &&
            (identical(other.helpfulness, helpfulness) ||
                other.helpfulness == helpfulness) &&
            (identical(other.autoMode, autoMode) ||
                other.autoMode == autoMode) &&
            (identical(other.aiProvider, aiProvider) ||
                other.aiProvider == aiProvider) &&
            (identical(other.claudeApiKey, claudeApiKey) ||
                other.claudeApiKey == claudeApiKey) &&
            (identical(other.geminiApiKey, geminiApiKey) ||
                other.geminiApiKey == geminiApiKey) &&
            (identical(other.geminiFastModel, geminiFastModel) ||
                other.geminiFastModel == geminiFastModel) &&
            (identical(other.geminiModel, geminiModel) ||
                other.geminiModel == geminiModel) &&
            (identical(other.geminiSmartModel, geminiSmartModel) ||
                other.geminiSmartModel == geminiSmartModel) &&
            (identical(other.modelMode, modelMode) ||
                other.modelMode == modelMode) &&
            (identical(other.selectedModel, selectedModel) ||
                other.selectedModel == selectedModel) &&
            (identical(other.showAiAssessments, showAiAssessments) ||
                other.showAiAssessments == showAiAssessments));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      detailLevel,
      temperature,
      helpfulness,
      autoMode,
      aiProvider,
      claudeApiKey,
      geminiApiKey,
      geminiFastModel,
      geminiModel,
      geminiSmartModel,
      modelMode,
      selectedModel,
      showAiAssessments);

  /// Create a copy of AIModelSettings
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AIModelSettingsImplCopyWith<_$AIModelSettingsImpl> get copyWith =>
      __$$AIModelSettingsImplCopyWithImpl<_$AIModelSettingsImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AIModelSettingsImplToJson(
      this,
    );
  }
}

abstract class _AIModelSettings extends AIModelSettings {
  const factory _AIModelSettings(
      {final int detailLevel,
      final double temperature,
      final int helpfulness,
      final bool autoMode,
      final String aiProvider,
      final String? claudeApiKey,
      final String? geminiApiKey,
      final String geminiFastModel,
      final String geminiModel,
      final String geminiSmartModel,
      final String modelMode,
      final String? selectedModel,
      final bool showAiAssessments}) = _$AIModelSettingsImpl;
  const _AIModelSettings._() : super._();

  factory _AIModelSettings.fromJson(Map<String, dynamic> json) =
      _$AIModelSettingsImpl.fromJson;

  @override
  int get detailLevel; // 1-10
  @override
  double get temperature; // 0-1
  @override
  int get helpfulness; // 1-10
  @override
  bool get autoMode;
  @override
  String get aiProvider; // 'claude' or 'gemini'
  @override
  String? get claudeApiKey;
  @override
  String? get geminiApiKey;
  @override
  String get geminiFastModel;
  @override
  String get geminiModel;
  @override
  String get geminiSmartModel;
  @override
  String get modelMode; // 'fast', 'standard', 'smart'
  @override
  String?
      get selectedModel; // Current active model (derived from provider + mode)
  @override
  bool get showAiAssessments;

  /// Create a copy of AIModelSettings
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AIModelSettingsImplCopyWith<_$AIModelSettingsImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
