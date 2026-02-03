import 'dart:math';

/// Level System & XP Constants
///
/// Basiert auf dem Gamification-System aus der React-App.
/// Exponentielles Level-System mit 20 Levels.
class LevelSystem {
  LevelSystem._(); // Private constructor

  // Max Level
  static const int maxLevel = 20;

  // Base XP for Level 2
  static const int baseXP = 100;

  // Exponential multiplier
  static const double multiplier = 1.5;

  /// Calculate XP needed for a specific level
  ///
  /// Formula: 100 * (1.5 ^ (level - 1))
  ///
  /// Examples:
  /// - Level 1: 0 XP (starting)
  /// - Level 2: 100 XP
  /// - Level 3: 150 XP (total: 250)
  /// - Level 4: 225 XP (total: 475)
  /// - Level 5: 338 XP (total: 813)
  static int xpForLevel(int level) {
    if (level <= 1) return 0;
    return (baseXP * pow(multiplier, level - 2)).round();
  }

  /// Calculate total XP needed to reach a level
  ///
  /// Sum of all XP from level 1 to target level
  static int totalXpForLevel(int level) {
    int total = 0;
    for (int i = 2; i <= level; i++) {
      total += xpForLevel(i);
    }
    return total;
  }

  /// Calculate level from total XP
  ///
  /// Returns the current level based on total XP earned
  static int levelFromXp(int totalXp) {
    for (int level = maxLevel; level >= 1; level--) {
      if (totalXp >= totalXpForLevel(level)) {
        return level;
      }
    }
    return 1;
  }

  /// Calculate progress to next level
  ///
  /// Returns:
  /// - currentXp: XP in current level
  /// - xpNeeded: Total XP needed for next level
  /// - progress: Progress as percentage (0.0 - 1.0)
  static Map<String, dynamic> progressToNextLevel(int totalXp) {
    final currentLevel = levelFromXp(totalXp);

    if (currentLevel >= maxLevel) {
      return {
        'currentXp': 0,
        'xpNeeded': 0,
        'progress': 1.0,
        'isMaxLevel': true,
      };
    }

    final xpForCurrentLevel = totalXpForLevel(currentLevel);
    final xpForNextLevel = totalXpForLevel(currentLevel + 1);

    final currentXp = totalXp - xpForCurrentLevel;
    final xpNeeded = xpForNextLevel - xpForCurrentLevel;
    final progress = currentXp / xpNeeded;

    return {
      'currentXp': currentXp,
      'xpNeeded': xpNeeded,
      'progress': progress,
      'isMaxLevel': false,
    };
  }

  /// Level titles (German)
  static const Map<int, String> levelTitles = {
    1: 'Anfänger',
    2: 'Lernender',
    3: 'Fortgeschritten',
    4: 'Experte',
    5: 'Meister',
    6: 'Großmeister',
    7: 'Champion',
    8: 'Legende',
    9: 'Mythisch',
    10: 'Göttlich',
    11: 'Transzendent',
    12: 'Unsterblich',
    13: 'Allwissend',
    14: 'Universell',
    15: 'Kosmisch',
    16: 'Zeitlos',
    17: 'Unendlich',
    18: 'Absolut',
    19: 'Uranfänglich',
    20: 'Singularität',
  };

  /// Get level title
  static String getLevelTitle(int level) {
    return levelTitles[level.clamp(1, maxLevel)] ?? 'Unbekannt';
  }
}

/// XP Calculation Constants
class XPSystem {
  XPSystem._(); // Private constructor

  // Base XP by difficulty (1-10)
  static const Map<int, int> baseXP = {
    1: 10,
    2: 15,
    3: 20,
    4: 30,
    5: 50,
    6: 60,
    7: 75,
    8: 90,
    9: 110,
    10: 130,
  };

  // Hint penalties (multipliers)
  static const Map<int, double> hintMultipliers = {
    0: 1.0, // 100% - No hints
    1: 0.85, // 85% - 1 hint used
    2: 0.65, // 65% - 2 hints used
    3: 0.40, // 40% - 3 hints used
  };

  // Bonus multipliers
  static const double timeBonusMultiplier = 0.2; // +20% if very fast
  static const double streakBonusSmall = 0.25; // +25% for 3+ streak
  static const double streakBonusLarge = 0.5; // +50% for 5+ streak
  static const double algebraicBonus = 0.1; // +10% for algebraic answers

  /// Calculate XP for a correct answer
  ///
  /// Formula:
  /// baseXP * hintPenalty + timeBonus + streakBonus + algebraicBonus
  ///
  /// Example:
  /// - Difficulty 5: 50 base XP
  /// - 1 hint used: * 0.85 = 42.5 XP
  /// - 5+ streak: + 21.25 XP bonus
  /// - Fast answer: + 10 XP bonus
  /// - Total: ~74 XP
  static int calculateXP({
    required int difficulty,
    required int hintsUsed,
    required int timeSpentSeconds,
    required int correctStreak,
    bool usedAlgebraicMethod = false,
  }) {
    // Get base XP
    final base = baseXP[difficulty.clamp(1, 10)] ?? 10;

    // Apply hint penalty
    final hintPenalty = hintMultipliers[hintsUsed.clamp(0, 3)] ?? 0.4;
    double xp = base * hintPenalty;

    // Time bonus (if completed very quickly)
    final expectedTime = difficulty * 60; // difficulty * 60 seconds
    if (timeSpentSeconds < expectedTime * 0.5) {
      xp += base * timeBonusMultiplier;
    }

    // Streak bonus
    if (correctStreak >= 5) {
      xp += xp * streakBonusLarge;
    } else if (correctStreak >= 3) {
      xp += xp * streakBonusSmall;
    }

    // Algebraic method bonus
    if (usedAlgebraicMethod) {
      xp += base * algebraicBonus;
    }

    return xp.round();
  }

  /// Get base XP for difficulty
  static int getBaseXP(int difficulty) {
    return baseXP[difficulty.clamp(1, 10)] ?? 10;
  }
}

/// Coin System Constants
///
/// Coins are a separate currency from XP used for cosmetic purchases
/// (themes) and streak freezes.
class CoinSystem {
  CoinSystem._(); // Private constructor

  // Base coins by question difficulty level
  static const Map<int, int> baseCoins = {
    1: 1, // Level 1-2
    2: 1,
    3: 2, // Level 3-4
    4: 2,
    5: 3, // Level 5-6
    6: 3,
    7: 4, // Level 7-8
    8: 4,
    9: 5, // Level 9-10
    10: 5,
  };

  // Multipliers
  static const double firstQuestionBonus = 2.0; // 2x coins for first question
  static const double streakBonus = 0.5; // +50% for 5+ streak
  static const double perfectAnswerBonus = 0.25; // +25% for perfect answer

  /// Calculate coins earned for answering a question
  ///
  /// Formula:
  /// baseCoins * firstQuestionMultiplier + streakBonus + perfectBonus
  ///
  /// Example:
  /// - Difficulty 5: 3 base coins
  /// - First question: * 2.0 = 6 coins
  /// - 5+ streak: + 1.5 coins
  /// - Perfect answer (no hints, fast): + 0.75 coins
  /// - Total: ~8 coins
  static int calculateCoins({
    required int difficulty,
    required bool isFirstQuestionToday,
    required int currentStreak,
    required bool isPerfectAnswer, // No hints used, answered quickly
  }) {
    // Get base coins
    final base = baseCoins[difficulty.clamp(1, 10)] ?? 1;
    double coins = base.toDouble();

    // First question bonus
    if (isFirstQuestionToday) {
      coins *= firstQuestionBonus;
    }

    // Streak bonus (5+ days)
    if (currentStreak >= 5) {
      coins += coins * streakBonus;
    }

    // Perfect answer bonus
    if (isPerfectAnswer) {
      coins += coins * perfectAnswerBonus;
    }

    return coins.round();
  }

  /// Get base coins for difficulty
  static int getBaseCoins(int difficulty) {
    return baseCoins[difficulty.clamp(1, 10)] ?? 1;
  }
}
