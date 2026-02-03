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
      detailLevel: (json['detailLevel'] as num?)?.toInt() ?? 5,
      temperature: (json['temperature'] as num?)?.toDouble() ?? 0.7,
      helpfulness: (json['helpfulness'] as num?)?.toInt() ?? 7,
      autoMode: json['autoMode'] as bool? ?? true,
      aiProvider: json['aiProvider'] as String? ?? 'gemini',
      claudeApiKey: json['claudeApiKey'] as String?,
      geminiApiKey: json['geminiApiKey'] as String?,
      geminiFastModel:
          json['geminiFastModel'] as String? ?? 'gemini-2.0-flash-lite',
      geminiModel: json['geminiModel'] as String? ?? 'gemini-2.0-flash',
      geminiSmartModel:
          json['geminiSmartModel'] as String? ?? 'gemini-2.5-pro-preview-05-06',
      modelMode: json['modelMode'] as String? ?? 'fast',
      selectedModel: json['selectedModel'] as String?,
      showAiAssessments: json['showAiAssessments'] as bool? ?? false,
    );

Map<String, dynamic> _$$AIModelSettingsImplToJson(
        _$AIModelSettingsImpl instance) =>
    <String, dynamic>{
      'detailLevel': instance.detailLevel,
      'temperature': instance.temperature,
      'helpfulness': instance.helpfulness,
      'autoMode': instance.autoMode,
      'aiProvider': instance.aiProvider,
      'claudeApiKey': instance.claudeApiKey,
      'geminiApiKey': instance.geminiApiKey,
      'geminiFastModel': instance.geminiFastModel,
      'geminiModel': instance.geminiModel,
      'geminiSmartModel': instance.geminiSmartModel,
      'modelMode': instance.modelMode,
      'selectedModel': instance.selectedModel,
      'showAiAssessments': instance.showAiAssessments,
    };
