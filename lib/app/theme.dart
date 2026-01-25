import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App Theme - Material 3 Expressive Design mit Sunset Orange Theme
///
/// Repliziert das Tailwind CSS Orange Theme aus der React App
/// mit Material 3 Expressive Design Principles:
/// - Pronounced rounded corners (24-28px)
/// - Expressive typography with dynamic scaling
/// - Rich surface tints and elevation
/// - Enhanced motion and interaction
class AppTheme {
  // Sunset Theme Colors (aus React App: #f97316)
  static const Color primaryOrange = Color(0xFFf97316);
  static const Color primaryOrangeDark = Color(0xFFea580c);
  static const Color primaryOrangeLight = Color(0xFFfb923c);

  // Tonal Palette for Material 3 Expressive
  static const Color primary10 = Color(0xFF3d0e00);
  static const Color primary20 = Color(0xFF651d00);
  static const Color primary30 = Color(0xFF8e2a00);
  static const Color primary40 = Color(0xFFea580c);
  static const Color primary50 = Color(0xFFf97316);
  static const Color primary60 = Color(0xFFfb923c);
  static const Color primary80 = Color(0xFFfdba74);
  static const Color primary90 = Color(0xFFfed7aa);

  // Dark Theme Background Colors
  static const Color backgroundDark = Color(0xFF1a1a1f);
  static const Color surfaceDark = Color(0xFF27272a);
  static const Color surfaceDarkHighest = Color(0xFF3f3f46);
  static const Color surfaceContainer = Color(0xFF2d2d32);
  static const Color surfaceContainerLow = Color(0xFF232328);
  static const Color surfaceContainerHigh = Color(0xFF36363c);

  // Text Colors
  static const Color textPrimary = Color(0xFFfafafa);
  static const Color textSecondary = Color(0xFFa1a1aa);
  static const Color textTertiary = Color(0xFF71717a);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,

      // Material 3 Expressive Color Scheme with Tonal Palette
      colorScheme: ColorScheme.dark(
        primary: primaryOrange,
        onPrimary: Colors.white,
        primaryContainer: primary30,
        onPrimaryContainer: primary90,
        secondary: primaryOrangeDark,
        onSecondary: Colors.white,
        secondaryContainer: primary20,
        onSecondaryContainer: primary80,
        tertiary: primaryOrangeLight,
        onTertiary: Colors.black,
        surface: surfaceDark,
        onSurface: textPrimary,
        surfaceContainerHighest: surfaceDarkHighest,
        surfaceContainer: surfaceContainer,
        surfaceContainerLow: surfaceContainerLow,
        surfaceContainerHigh: surfaceContainerHigh,
        error: const Color(0xFFef4444),
        onError: Colors.white,
        outline: Colors.white.withValues(alpha: 0.12),
        outlineVariant: Colors.white.withValues(alpha: 0.08),
      ),

      // AppBar Theme
      appBarTheme: const AppBarTheme(
        backgroundColor: backgroundDark,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: textPrimary,
          fontSize: 20,
          fontWeight: FontWeight.w600,
        ),
        iconTheme: IconThemeData(color: textPrimary),
      ),

      // Card Theme (GlassPanel equivalent) - Material 3 Expressive
      cardTheme: CardThemeData(
        color: surfaceDark.withValues(alpha:0.8),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28), // Expressive: larger corners
          side: BorderSide(
            color: Colors.white.withValues(alpha:0.12),
            width: 1,
          ),
        ),
      ),

      // Button Themes - Material 3 Expressive with pronounced corners
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: Colors.white,
          elevation: 0,
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Expressive: larger corners
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),

      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryOrange,
          foregroundColor: Colors.white,
          elevation: 2,
          shadowColor: primaryOrange.withValues(alpha: 0.4),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Expressive: larger corners
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),

      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: primaryOrange,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16), // Expressive
          ),
        ),
      ),

      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: primaryOrange,
          side: const BorderSide(color: primaryOrange, width: 1.5),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Expressive: larger corners
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.1,
          ),
        ),
      ),

      // Input Decoration Theme - Material 3 Expressive
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20), // Expressive: larger corners
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha:0.12),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: BorderSide(
            color: Colors.white.withValues(alpha:0.12),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: primaryOrange,
            width: 2.5, // Slightly thicker for emphasis
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color(0xFFef4444),
            width: 1.5,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
          borderSide: const BorderSide(
            color: Color(0xFFef4444),
            width: 2.5,
          ),
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        hintStyle: TextStyle(
          color: textTertiary,
          fontSize: 16,
        ),
      ),

      // Text Theme - Material 3 Expressive Typography with Google Sans
      // More dramatic scale with enhanced contrast
      // Using Google Sans for smooth, modern typography
      textTheme: GoogleFonts.interTextTheme(
        const TextTheme(
          displayLarge: TextStyle(
            fontSize: 64, // Expressive: larger displays
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: -0.5,
            height: 1.1,
          ),
          displayMedium: TextStyle(
            fontSize: 52, // Expressive
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: -0.25,
            height: 1.15,
          ),
          displaySmall: TextStyle(
            fontSize: 40, // Expressive
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.2,
          ),
          headlineLarge: TextStyle(
            fontSize: 36, // Expressive: larger headlines
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.25,
          ),
          headlineMedium: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.25,
          ),
          headlineSmall: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: textPrimary,
            letterSpacing: 0,
            height: 1.3,
          ),
          titleLarge: TextStyle(
            fontSize: 22, // Slightly larger
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0.15,
            height: 1.4,
          ),
          titleMedium: TextStyle(
            fontSize: 18, // Slightly larger
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0.15,
            height: 1.4,
          ),
          titleSmall: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0.1,
            height: 1.4,
          ),
          bodyLarge: TextStyle(
            fontSize: 17, // Slightly larger for better readability
            fontWeight: FontWeight.w400,
            color: textPrimary,
            letterSpacing: 0.25,
            height: 1.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 15, // Slightly larger
            fontWeight: FontWeight.w400,
            color: textPrimary,
            letterSpacing: 0.25,
            height: 1.5,
          ),
          bodySmall: TextStyle(
            fontSize: 13, // Slightly larger
            fontWeight: FontWeight.w400,
            color: textSecondary,
            letterSpacing: 0.4,
            height: 1.4,
          ),
          labelLarge: TextStyle(
            fontSize: 15, // Slightly larger
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0.1,
            height: 1.4,
          ),
          labelMedium: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: textPrimary,
            letterSpacing: 0.5,
            height: 1.3,
          ),
          labelSmall: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: textSecondary,
            letterSpacing: 0.5,
            height: 1.3,
          ),
        ),
      ),

      // IconTheme - Material 3 Expressive
      iconTheme: const IconThemeData(
        color: textPrimary,
        size: 24,
      ),

      // FloatingActionButton Theme - Material 3 Expressive
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: primaryOrange,
        foregroundColor: Colors.white,
        elevation: 3,
        focusElevation: 4,
        hoverElevation: 4,
        highlightElevation: 6,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(28), // Expressive: large corners
        ),
        sizeConstraints: const BoxConstraints.tightFor(
          width: 64, // Slightly larger
          height: 64,
        ),
      ),

      // NavigationBar Theme - Material 3 Expressive
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: surfaceContainer,
        elevation: 0,
        height: 80,
        indicatorColor: primary30,
        labelTextStyle: WidgetStateProperty.all(
          const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ),

      // Divider Theme
      dividerTheme: DividerThemeData(
        color: Colors.white.withValues(alpha:0.12),
        thickness: 1,
        space: 1,
      ),

      // Progress Indicator Theme
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: primaryOrange,
        linearTrackColor: surfaceDark,
      ),

      // Scaffold Background
      scaffoldBackgroundColor: backgroundDark,

      // Page Transitions - Material 3 Expressive uses emphasized easing
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: PredictiveBackPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
    );
  }

  // Gradient für Buttons und spezielle UI-Elemente
  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [
      primaryOrange,
      primaryOrangeDark,
    ],
  );

  // Glow Effect für spezielle Elemente
  static BoxShadow get primaryGlow {
    return BoxShadow(
      color: primaryOrange.withValues(alpha:0.4),
      blurRadius: 20,
      spreadRadius: 2,
    );
  }
}
