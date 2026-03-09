// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserSettingsImpl _$$UserSettingsImplFromJson(Map<String, dynamic> json) =>
    _$UserSettingsImpl(
      theme: ThemeSettings.fromJson(json['theme'] as Map<String, dynamic>),
      gradeLevel: json['gradeLevel'] as String? ?? 'Klasse_11',
      courseType: json['courseType'] as String? ?? 'Leistungsfach',
    );

Map<String, dynamic> _$$UserSettingsImplToJson(_$UserSettingsImpl instance) =>
    <String, dynamic>{
      'theme': instance.theme,
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
