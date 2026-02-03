import 'package:freezed_annotation/freezed_annotation.dart';
import '../../features/settings/presentation/providers/settings_providers.dart';

part 'theme_unlock.freezed.dart';
part 'theme_unlock.g.dart';

/// Theme Unlocks Model
///
/// Tracks which themes the user has unlocked with coins.
/// Stored in Firestore: users/{userId}/themeUnlocks
@freezed
class ThemeUnlocks with _$ThemeUnlocks {
  const ThemeUnlocks._();

  const factory ThemeUnlocks({
    @Default([]) List<String> unlockedThemes, // List of theme enum names
  }) = _ThemeUnlocks;

  factory ThemeUnlocks.fromJson(Map<String, dynamic> json) =>
      _$ThemeUnlocksFromJson(json);

  /// Create default unlocks for new user (only sunset orange)
  factory ThemeUnlocks.initial() {
    return const ThemeUnlocks(
      unlockedThemes: ['sunsetOrange'], // Default theme is unlocked
    );
  }

  /// Check if a theme is unlocked
  bool isUnlocked(AppThemePreset theme) {
    return unlockedThemes.contains(theme.name);
  }

  /// Unlock a new theme
  ThemeUnlocks unlock(AppThemePreset theme) {
    if (isUnlocked(theme)) {
      return this; // Already unlocked
    }

    return copyWith(
      unlockedThemes: [...unlockedThemes, theme.name],
    );
  }

  /// Get list of locked themes
  List<AppThemePreset> getLockedThemes() {
    return AppThemePreset.values
        .where((theme) => !isUnlocked(theme))
        .toList();
  }

  /// Get list of unlocked themes as enums
  List<AppThemePreset> getUnlockedThemes() {
    return AppThemePreset.values
        .where((theme) => isUnlocked(theme))
        .toList();
  }
}

/// Theme Pricing Information
class ThemePricing {
  ThemePricing._(); // Private constructor

  /// Get coin price for a theme
  static int getPrice(AppThemePreset theme) {
    switch (theme) {
      case AppThemePreset.sunsetOrange:
        return 0; // Default theme is free
      case AppThemePreset.oceanBlue:
        return 100;
      case AppThemePreset.forestGreen:
        return 100;
      case AppThemePreset.lavenderPurple:
        return 150;
      case AppThemePreset.cherryRed:
        return 150;
    }
  }

  /// Get theme name (German)
  static String getName(AppThemePreset theme) {
    switch (theme) {
      case AppThemePreset.sunsetOrange:
        return 'Sonnenuntergang Orange';
      case AppThemePreset.oceanBlue:
        return 'Ozean Blau';
      case AppThemePreset.forestGreen:
        return 'Wald Grün';
      case AppThemePreset.lavenderPurple:
        return 'Lavendel Lila';
      case AppThemePreset.cherryRed:
        return 'Kirsch Rot';
    }
  }

  /// Get theme description (German)
  static String getDescription(AppThemePreset theme) {
    switch (theme) {
      case AppThemePreset.sunsetOrange:
        return 'Das klassische SLAM-Theme mit warmen Sonnenuntergang-Tönen';
      case AppThemePreset.oceanBlue:
        return 'Ruhige blaue Töne inspiriert vom Ozean';
      case AppThemePreset.forestGreen:
        return 'Erfrischende grüne Farben des Waldes';
      case AppThemePreset.lavenderPurple:
        return 'Elegante violette Töne mit Lavendel-Akzenten';
      case AppThemePreset.cherryRed:
        return 'Kraftvolles Rot mit energiegeladenen Akzenten';
    }
  }
}
