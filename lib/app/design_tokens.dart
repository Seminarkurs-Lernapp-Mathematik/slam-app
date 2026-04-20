import 'package:flutter/material.dart';

/// Sunset Glow — Liquid UI design tokens. Source of truth: DESIGN.md §2–5.
abstract final class SlamTokens {
  // ── Background stack (§2.1) ───────────────────────────────────────────────
  static const Color bg        = Color(0xFF0F0A0D);
  static const Color bgElev    = Color(0xFF1A1116);
  static const Color surface   = Color(0xFF22161C);
  static const Color surfaceHi = Color(0xFF2E1D25);
  static const Color line      = Color(0x1AFFB496); // rgba(255,180,150,0.10)

  // ── Text (§2.1) ──────────────────────────────────────────────────────────
  static const Color text     = Color(0xFFFFF4EC);
  static const Color textDim  = Color(0x94FFF4EC); // 0.58 α
  static const Color textMute = Color(0x52FFF4EC); // 0.32 α

  // ── Primary (§2.1) — runtime-mutable so theme switches take effect ────────
  // Defaults are the Sunset Orange palette; call applyTheme() on theme change.
  static Color primary     = const Color(0xFFFF7A3B);
  static Color primaryOn   = const Color(0xFF23100A);
  static Color primarySoft = const Color(0x24FF7A3B); // 0.14 α

  /// Update all primary colour tokens at once.
  /// Call this before (re)building ThemeData so every widget that reads
  /// SlamTokens.primary sees the new colour in the same frame.
  static void applyTheme({required Color primary, required Color primaryOn}) {
    SlamTokens.primary     = primary;
    SlamTokens.primaryOn   = primaryOn;
    SlamTokens.primarySoft = primary.withValues(alpha: 36 / 255); // 0.14 α
  }

  // ── Subject hues (§2.2) ──────────────────────────────────────────────────
  static const Color algebra       = Color(0xFFFFB35C);
  static const Color algebraSoft   = Color(0x24FFB35C);
  static const Color analysis      = Color(0xFF7CC4FF);
  static const Color analysisSoft  = Color(0x247CC4FF);
  static const Color geometrie      = Color(0xFFC88CFF);
  static const Color geometrieSoft  = Color(0x24C88CFF);
  static const Color stochastik     = Color(0xFF7FE3C4);
  static const Color stochastikSoft = Color(0x247FE3C4);

  // ── Status (§2.3) ────────────────────────────────────────────────────────
  static const Color success     = Color(0xFF4DD490);
  static const Color successSoft = Color(0x244DD490);
  static const Color danger      = Color(0xFFFF6B7A);
  static const Color dangerSoft  = Color(0x24FF6B7A);
  static const Color warn        = Color(0xFFFFC94D);
  static const Color warnSoft    = Color(0x24FFC94D);

  // ── Corner radius scale (§4.1) ────────────────────────────────────────────
  static const double rCircle  = 999;
  static const double rCardSm  = 22;
  static const double rCardMd  = 24;
  static const double rCardLg  = 28;
  static const double rInput   = 18;
  static const double rOption  = 18;

  // ── Spacing 4-px grid (§4.2) ─────────────────────────────────────────────
  static const double sp4      = 4;
  static const double sp6      = 6;
  static const double sp8      = 8;
  static const double sp10     = 10;
  static const double sp14     = 14;
  static const double sp18     = 18;
  static const double sp20     = 20;
  static const double sp22     = 22;
  static const double sp24     = 24;
  static const double sp32     = 32;
  static const double sp40     = 40;
  static const double gutter   = 20;

  // ── Motion curves (§5.1) ─────────────────────────────────────────────────
  static const Curve curveStandard = Cubic(0.32, 0.72, 0, 1);
  static const Curve curveFeedback = Curves.easeOut;

  // ── Motion durations (§5.2) ──────────────────────────────────────────────
  static const Duration dHover    = Duration(milliseconds: 200);
  static const Duration dState    = Duration(milliseconds: 300);
  static const Duration dScreen   = Duration(milliseconds: 500);
  static const Duration dSwoosh   = Duration(milliseconds: 680);
  static const Duration dConfetti = Duration(milliseconds: 1200);

  // ── Elevation shadows ────────────────────────────────────────────────────
  static BoxShadow get primaryShadow => BoxShadow(
    color: primary.withValues(alpha: 0.67),
    blurRadius: 30,
    offset: const Offset(0, 10),
    spreadRadius: -8,
  );
}
