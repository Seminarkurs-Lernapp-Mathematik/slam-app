import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'design_tokens.dart';
import '../features/settings/presentation/providers/settings_providers.dart';

// Primary colours per preset (mirrors ThemeConfig.fromPreset)
const Map<AppThemePreset, Color> _kPrimary = {
  AppThemePreset.sunsetOrange:    Color(0xFFFF7A3B),
  AppThemePreset.oceanBlue:       Color(0xFF3BA8FF),
  AppThemePreset.forestGreen:     Color(0xFF3BD490),
  AppThemePreset.lavenderPurple:  Color(0xFFA07CFF),
  AppThemePreset.cherryRed:       Color(0xFFFF5566),
};

// "On primary" text colours — dark tint of the primary for legibility
const Map<AppThemePreset, Color> _kPrimaryOn = {
  AppThemePreset.sunsetOrange:    Color(0xFF23100A),
  AppThemePreset.oceanBlue:       Color(0xFF0A1A2E),
  AppThemePreset.forestGreen:     Color(0xFF071A10),
  AppThemePreset.lavenderPurple:  Color(0xFF100A20),
  AppThemePreset.cherryRed:       Color(0xFF1A0A0A),
};

/// App Theme — Sunset Glow / Liquid UI (DESIGN.md v2)
///
/// Typography:
///   Fraunces  → emotional / hero content  (Display, Headings, large numbers)
///   DM Sans   → action / structure        (Buttons, Labels, Body)
///   JB Mono   → meta / timer / code tags  (via SlamTokens.jbMono() directly)
class AppTheme {
  // Legacy color constants — kept for any screens not yet migrated.
  // New code should use SlamTokens directly.
  static Color get primaryOrange => SlamTokens.primary;
  static const Color primaryOrangeDark  = Color(0xFFE85F20);
  static const Color primaryOrangeLight = Color(0xFFFF9B67);

  /// Sync SlamTokens primary colours with [preset] and return the ThemeData.
  /// Call this in SLAMApp.build() BEFORE building MaterialApp so every widget
  /// reads the correct colour in the same frame.
  static ThemeData themeForPreset(AppThemePreset preset) {
    final primary   = _kPrimary[preset]!;
    final primaryOn = _kPrimaryOn[preset]!;
    SlamTokens.applyTheme(primary: primary, primaryOn: primaryOn);
    return _buildThemeWithPrimaryColor(primary);
  }

  static const Color backgroundDark    = SlamTokens.bg;
  static const Color surfaceDark       = SlamTokens.surface;
  static const Color surfaceContainer  = SlamTokens.bgElev;
  static const Color textPrimary       = SlamTokens.text;
  static const Color textSecondary     = SlamTokens.textDim;

  // Primary glow (used by existing GlassPanel.accent)
  static BoxShadow get primaryGlow => BoxShadow(
    color: SlamTokens.primary.withValues(alpha: 0.35),
    blurRadius: 24,
    spreadRadius: 0,
  );

  static ThemeData get darkTheme => _buildThemeWithPrimaryColor(SlamTokens.primary);

  static ThemeData getThemeForPreset(AppThemePreset preset) {
    final Color primaryColor;
    switch (preset) {
      case AppThemePreset.sunsetOrange:
        primaryColor = SlamTokens.primary;
      case AppThemePreset.oceanBlue:
        primaryColor = const Color(0xFF3BA8FF);
      case AppThemePreset.forestGreen:
        primaryColor = const Color(0xFF3BD490);
      case AppThemePreset.lavenderPurple:
        primaryColor = const Color(0xFFA07CFF);
      case AppThemePreset.cherryRed:
        primaryColor = const Color(0xFFFF5566);
    }
    return _buildThemeWithPrimaryColor(primaryColor);
  }

  static ThemeData _buildThemeWithPrimaryColor(Color primary) {
    // Derive tonal shades for ColorScheme
    final primaryContainer = Color.lerp(primary, Colors.black, 0.72)!;
    final onPrimaryContainer = Color.lerp(primary, Colors.white, 0.75)!;

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      colorScheme: ColorScheme.dark(
        primary: primary,
        onPrimary: SlamTokens.primaryOn,
        primaryContainer: primaryContainer,
        onPrimaryContainer: onPrimaryContainer,
        secondary: Color.lerp(primary, Colors.black, 0.2)!,
        onSecondary: SlamTokens.text,
        surface: SlamTokens.surface,
        onSurface: SlamTokens.text,
        surfaceContainerHighest: SlamTokens.surfaceHi,
        surfaceContainer: SlamTokens.bgElev,
        surfaceContainerLow: SlamTokens.bg,
        surfaceContainerHigh: SlamTokens.surfaceHi,
        error: SlamTokens.danger,
        onError: SlamTokens.text,
        outline: SlamTokens.line,
        outlineVariant: SlamTokens.line,
        // Exposed for legacy widgets that use colorScheme.secondary etc.
        tertiary: Color.lerp(primary, Colors.white, 0.3)!,
        onTertiary: SlamTokens.primaryOn,
      ),

      scaffoldBackgroundColor: SlamTokens.bg,

      // AppBar — minimal; screens supply their own headers in the new design.
      appBarTheme: AppBarTheme(
        backgroundColor: SlamTokens.bg,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.fraunces(
          textStyle: const TextStyle(
            color: SlamTokens.text,
            fontSize: 28,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.6,
          ),
        ),
        iconTheme: const IconThemeData(color: SlamTokens.text),
      ),

      // Card — §6.2
      cardTheme: CardThemeData(
        color: SlamTokens.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
          side: const BorderSide(color: SlamTokens.line),
        ),
      ),

      // Filled button — Primary CTA §6.1: pill, primary bg, primaryOn text
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: SlamTokens.primaryOn,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.dmSans(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // Elevated button — also pill, with shadow
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primary,
          foregroundColor: SlamTokens.primaryOn,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
          shape: const StadiumBorder(),
          textStyle: GoogleFonts.dmSans(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // Outlined — Secondary §6.1
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: SlamTokens.text,
          side: const BorderSide(color: SlamTokens.line),
          backgroundColor: SlamTokens.surface,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SlamTokens.rInput),
          ),
          textStyle: GoogleFonts.dmSans(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),

      // Text button — Ghost §6.1
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: SlamTokens.textDim,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SlamTokens.rInput),
          ),
          textStyle: GoogleFonts.dmSans(
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),

      // Input — §6.5: surfaceHi bg, pill container, no border/outline on field
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: SlamTokens.surfaceHi,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SlamTokens.rInput),
          borderSide: const BorderSide(color: SlamTokens.line),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SlamTokens.rInput),
          borderSide: const BorderSide(color: SlamTokens.line),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SlamTokens.rInput),
          borderSide: BorderSide(color: primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SlamTokens.rInput),
          borderSide: const BorderSide(color: SlamTokens.danger, width: 1.5),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(SlamTokens.rInput),
          borderSide: const BorderSide(color: SlamTokens.danger, width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        hintStyle: const TextStyle(color: SlamTokens.textMute, fontSize: 15),
      ),

      // Typography — Fraunces for display/headlines, DM Sans for body/UI
      textTheme: TextTheme(
        // ── Fraunces: Display (Hero Level, Screen titles, Question text) ──
        displayLarge: GoogleFonts.fraunces(
          textStyle: const TextStyle(
            fontSize: 70, fontWeight: FontWeight.w800,
            color: SlamTokens.text, letterSpacing: -2, height: 1.0,
          ),
        ),
        displayMedium: GoogleFonts.fraunces(
          textStyle: const TextStyle(
            fontSize: 52, fontWeight: FontWeight.w700,
            color: SlamTokens.text, letterSpacing: -1.2, height: 1.05,
          ),
        ),
        displaySmall: GoogleFonts.fraunces(
          textStyle: const TextStyle(
            fontSize: 40, fontWeight: FontWeight.w700,
            color: SlamTokens.text, letterSpacing: -0.8, height: 1.1,
          ),
        ),
        headlineLarge: GoogleFonts.fraunces(
          textStyle: const TextStyle(
            fontSize: 34, fontWeight: FontWeight.w700,
            color: SlamTokens.text, letterSpacing: -0.8, height: 1.15,
          ),
        ),
        headlineMedium: GoogleFonts.fraunces(
          textStyle: const TextStyle(
            fontSize: 30, fontWeight: FontWeight.w700,
            color: SlamTokens.text, letterSpacing: -0.6, height: 1.2,
          ),
        ),
        headlineSmall: GoogleFonts.fraunces(
          textStyle: const TextStyle(
            fontSize: 24, fontWeight: FontWeight.w600,
            color: SlamTokens.text, letterSpacing: -0.4, height: 1.25,
          ),
        ),
        // ── Fraunces: Card titles ─────────────────────────────────────────
        titleLarge: GoogleFonts.fraunces(
          textStyle: const TextStyle(
            fontSize: 17, fontWeight: FontWeight.w700,
            color: SlamTokens.text, letterSpacing: -0.3, height: 1.4,
          ),
        ),
        // ── DM Sans: UI structure ─────────────────────────────────────────
        titleMedium: GoogleFonts.dmSans(
          textStyle: const TextStyle(
            fontSize: 15, fontWeight: FontWeight.w600,
            color: SlamTokens.text, letterSpacing: 0.1, height: 1.4,
          ),
        ),
        titleSmall: GoogleFonts.dmSans(
          textStyle: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w600,
            color: SlamTokens.text, letterSpacing: 0.1, height: 1.4,
          ),
        ),
        bodyLarge: GoogleFonts.dmSans(
          textStyle: const TextStyle(
            fontSize: 16, fontWeight: FontWeight.w500,
            color: SlamTokens.text, letterSpacing: 0, height: 1.5,
          ),
        ),
        bodyMedium: GoogleFonts.dmSans(
          textStyle: const TextStyle(
            fontSize: 14, fontWeight: FontWeight.w500,
            color: SlamTokens.text, letterSpacing: 0, height: 1.5,
          ),
        ),
        bodySmall: GoogleFonts.dmSans(
          textStyle: const TextStyle(
            fontSize: 13, fontWeight: FontWeight.w400,
            color: SlamTokens.textDim, letterSpacing: 0, height: 1.4,
          ),
        ),
        labelLarge: GoogleFonts.dmSans(
          textStyle: const TextStyle(
            fontSize: 12, fontWeight: FontWeight.w800,
            color: SlamTokens.text, letterSpacing: 1.2, height: 1.3,
          ),
        ),
        labelMedium: GoogleFonts.dmSans(
          textStyle: const TextStyle(
            fontSize: 11, fontWeight: FontWeight.w700,
            color: SlamTokens.textDim, letterSpacing: 1.0, height: 1.3,
          ),
        ),
        labelSmall: GoogleFonts.dmSans(
          textStyle: const TextStyle(
            fontSize: 10, fontWeight: FontWeight.w700,
            color: SlamTokens.textMute, letterSpacing: 0.8, height: 1.3,
          ),
        ),
      ),

      iconTheme: const IconThemeData(color: SlamTokens.text, size: 24),

      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primary,
        foregroundColor: SlamTokens.primaryOn,
        elevation: 0,
        shape: const CircleBorder(),
        sizeConstraints: const BoxConstraints.tightFor(width: 56, height: 56),
      ),

      // NavigationBar kept for compat but replaced by SlamBottomNav widget.
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: SlamTokens.bgElev,
        elevation: 0,
        height: 72,
        indicatorColor: primary,
        labelTextStyle: WidgetStateProperty.all(
          GoogleFonts.dmSans(fontSize: 11, fontWeight: FontWeight.w700),
        ),
      ),

      dividerTheme: const DividerThemeData(
        color: SlamTokens.line,
        thickness: 1,
        space: 1,
      ),

      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: primary,
        linearTrackColor: SlamTokens.surfaceHi,
      ),

      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }
}
