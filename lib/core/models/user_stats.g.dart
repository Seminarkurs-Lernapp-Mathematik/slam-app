// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserStatsImpl _$$UserStatsImplFromJson(Map<String, dynamic> json) =>
    _$UserStatsImpl(
      level: (json['level'] as num?)?.toInt() ?? 1,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      xpToNextLevel: (json['xpToNextLevel'] as num?)?.toInt() ?? 100,
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      totalXp: (json['totalXp'] as num?)?.toInt() ?? 0,
      lastActiveDate: json['lastActiveDate'] as String?,
    );

Map<String, dynamic> _$$UserStatsImplToJson(_$UserStatsImpl instance) =>
    <String, dynamic>{
      'level': instance.level,
      'xp': instance.xp,
      'xpToNextLevel': instance.xpToNextLevel,
      'streak': instance.streak,
      'totalXp': instance.totalXp,
      'lastActiveDate': instance.lastActiveDate,
    };
