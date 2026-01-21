// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stats.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserStats _$UserStatsFromJson(Map<String, dynamic> json) => _UserStats(
      level: (json['level'] as num?)?.toInt() ?? 1,
      xp: (json['xp'] as num?)?.toInt() ?? 0,
      xpToNextLevel: (json['xpToNextLevel'] as num?)?.toInt() ?? 100,
      streak: (json['streak'] as num?)?.toInt() ?? 0,
      totalXp: (json['totalXp'] as num?)?.toInt() ?? 0,
      lastActiveDate: json['lastActiveDate'] as String?,
    );

Map<String, dynamic> _$UserStatsToJson(_UserStats instance) =>
    <String, dynamic>{
      'level': instance.level,
      'xp': instance.xp,
      'xpToNextLevel': instance.xpToNextLevel,
      'streak': instance.streak,
      'totalXp': instance.totalXp,
      'lastActiveDate': instance.lastActiveDate,
    };
