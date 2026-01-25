// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_content.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SavedContentImpl _$$SavedContentImplFromJson(Map<String, dynamic> json) =>
    _$SavedContentImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      type: $enumDecode(_$ContentTypeEnumMap, json['type']),
      htmlContent: json['htmlContent'] as String,
      cssContent: json['cssContent'] as String?,
      javascriptContent: json['javascriptContent'] as String?,
      description: json['description'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      tags:
          (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList() ??
              const [],
    );

Map<String, dynamic> _$$SavedContentImplToJson(_$SavedContentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'title': instance.title,
      'type': _$ContentTypeEnumMap[instance.type]!,
      'htmlContent': instance.htmlContent,
      'cssContent': instance.cssContent,
      'javascriptContent': instance.javascriptContent,
      'description': instance.description,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'tags': instance.tags,
    };

const _$ContentTypeEnumMap = {
  ContentType.miniApp: 'mini-app',
  ContentType.geogebra: 'geogebra',
  ContentType.simulation: 'simulation',
};
