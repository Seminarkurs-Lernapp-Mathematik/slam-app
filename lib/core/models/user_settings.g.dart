// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSettingsImpl _$$UserSettingsImplFromJson(Map<String, dynamic> json) =>
    _$UserSettingsImpl(
      theme: ThemeSettings.fromJson(json['theme'] as Map<String, dynamic>),
      aiModel:
          AIModelSettings.fromJson(json['aiModel'] as Map<String, dynamic>),
      gradeLevel: json['gradeLevel'] as String? ?? 'Klasse_11',
      courseType: json['courseType'] as String? ?? 'Leistungsfach',
    );

Map<String, dynamic> _$$UserSettingsImplToJson(_$UserSettingsImpl instance) =>
    <String, dynamic>{
      'theme': instance.theme,
      'aiModel': instance.aiModel,
      'gradeLevel': instance.gradeLevel,
      'courseType': instance.courseType,
    };

_$ThemeSettingsImpl _$$ThemeSettingsImplFromJson(Map<String, dynamic> json) =>
    _$ThemeSettingsImpl(
      name: json['name'] as String,
      primary: json['primary'] as String,
      gradient: json['gradient'] as String,
      gradientFrom: json['gradientFrom'] as String,
      gradientTo: json['gradientTo'] as String,
      glow: json['glow'] as String,
    );

Map<String, dynamic> _$$ThemeSettingsImplToJson(_$ThemeSettingsImpl instance) =>
    <String, dynamic>{
      'name': instance.name,
      'primary': instance.primary,
      'gradient': instance.gradient,
      'gradientFrom': instance.gradientFrom,
      'gradientTo': instance.gradientTo,
      'glow': instance.glow,
    };

_$AIModelSettingsImpl _$$AIModelSettingsImplFromJson(
        Map<String, dynamic> json) =>
    _$AIModelSettingsImpl(
      detailLevel: (json['detailLevel'] as num?)?.toInt() ?? 50,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.5,
      helpfulness: (json['helpfulness'] as num?)?.toInt() ?? 50,
      autoMode: json['autoMode'] as bool? ?? true,
    );

Map<String, dynamic> _$$AIModelSettingsImplToJson(
        _$AIModelSettingsImpl instance) =>
    <String, dynamic>{
      'detailLevel': instance.detailLevel,
      'temperature': instance.temperature,
      'helpfulness': instance.helpfulness,
      'autoMode': instance.autoMode,
    };
