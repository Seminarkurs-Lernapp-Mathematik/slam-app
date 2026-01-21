import 'package:freezed_annotation/freezed_annotation.dart';
import '../constants/level_thresholds.dart';

part 'user_stats.freezed.dart';
part 'user_stats.g.dart';

/// User Statistics Model
///
/// Kompatibel mit React App Firestore Structure:
/// users/{userId}/stats
@freezed
class UserStats with _$UserStats {
  const UserStats._();

  const factory UserStats({
    @Default(1) int level,
    @Default(0) int xp,
    @Default(100) int xpToNextLevel,
    @Default(0) int streak,
    @Default(0) int totalXp,
    String? lastActiveDate, // ISO date string "2024-01-21"
  }) = _UserStats;

  factory UserStats.fromJson(Map<String, dynamic> json) =>
      _$UserStatsFromJson(json);

  /// Calculate current level from totalXp
  int get calculatedLevel => LevelSystem.levelFromXp(totalXp);

  /// Get progress to next level (0.0 - 1.0)
  double get progressToNextLevel {
    final progress = LevelSystem.progressToNextLevel(totalXp);
    return progress['progress'] as double;
  }

  /// Get XP in current level
  int get currentLevelXp {
    final progress = LevelSystem.progressToNextLevel(totalXp);
    return progress['currentXp'] as int;
  }

  /// Get XP needed for next level
  int get xpNeededForNextLevel {
    final progress = LevelSystem.progressToNextLevel(totalXp);
    return progress['xpNeeded'] as int;
  }

  /// Check if max level reached
  bool get isMaxLevel => calculatedLevel >= LevelSystem.maxLevel;

  /// Get level title (German)
  String get levelTitle => LevelSystem.getLevelTitle(calculatedLevel);

  /// Create default stats for new user
  factory UserStats.initial() {
    return const UserStats(
      level: 1,
      xp: 0,
      xpToNextLevel: 100,
      streak: 0,
      totalXp: 0,
      lastActiveDate: null,
    );
  }

  /// Update stats after earning XP
  UserStats addXp(int earnedXp) {
    final newTotalXp = totalXp + earnedXp;
    final newLevel = LevelSystem.levelFromXp(newTotalXp);
    final progress = LevelSystem.progressToNextLevel(newTotalXp);

    return copyWith(
      level: newLevel,
      xp: progress['currentXp'] as int,
      xpToNextLevel: progress['xpNeeded'] as int,
      totalXp: newTotalXp,
    );
  }

  /// Update streak (call daily)
  UserStats updateStreak(String todayDate) {
    if (lastActiveDate == null) {
      return copyWith(streak: 1, lastActiveDate: todayDate);
    }

    final lastDate = DateTime.parse(lastActiveDate!);
    final today = DateTime.parse(todayDate);
    final difference = today.difference(lastDate).inDays;

    if (difference == 0) {
      // Same day - no change
      return this;
    } else if (difference == 1) {
      // Consecutive day - increment streak
      return copyWith(streak: streak + 1, lastActiveDate: todayDate);
    } else {
      // Streak broken - reset to 1
      return copyWith(streak: 1, lastActiveDate: todayDate);
    }
  }

  /// Check if streak is at risk (no activity today)
  bool isStreakAtRisk(String todayDate) {
    if (lastActiveDate == null) return false;

    final lastDate = DateTime.parse(lastActiveDate!);
    final today = DateTime.parse(todayDate);
    final difference = today.difference(lastDate).inDays;

    return difference >= 1;
  }
}
