// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'theme_unlock.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ThemeUnlocksImpl _$$ThemeUnlocksImplFromJson(Map<String, dynamic> json) =>
    _$ThemeUnlocksImpl(
      unlockedThemes: (json['unlockedThemes'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
    );

Map<String, dynamic> _$$ThemeUnlocksImplToJson(_$ThemeUnlocksImpl instance) =>
    <String, dynamic>{
      'unlockedThemes': instance.unlockedThemes,
    };
