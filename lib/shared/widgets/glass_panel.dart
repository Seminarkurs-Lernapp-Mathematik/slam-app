import 'package:flutter/material.dart';

import '../../app/design_tokens.dart';

/// Card-style panel (DESIGN.md §6.2).
///
/// Replaces the old glassmorphism/backdrop-blur approach. Uses
/// `surface` background + `line` border + symmetric corner radii.
///
/// All constructor parameters are preserved for backward compatibility.
/// The `blur` and `opacity` parameters are kept but have no visual effect —
/// existing callers compile without changes.
class GlassPanel extends StatelessWidget {
  const GlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 0,       // deprecated; retained for compat
    this.opacity = 0,    // deprecated; retained for compat
    this.showBorder = true,
    this.borderColor,
    this.glow = false,
    this.glowColor,
    this.backgroundColor,
  });

  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final BorderRadius? borderRadius;
  final double blur;
  final double opacity;
  final bool showBorder;
  final Color? borderColor;
  final bool glow;
  final Color? glowColor;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final radius = borderRadius ?? BorderRadius.circular(SlamTokens.rCardMd);
    final bg = backgroundColor ?? SlamTokens.surface;
    final border = borderColor ?? SlamTokens.line;

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: radius,
        border: showBorder ? Border.all(color: border) : null,
        boxShadow: glow
            ? [
                BoxShadow(
                  color: (glowColor ?? SlamTokens.primary).withValues(alpha: 0.35),
                  blurRadius: 24,
                  spreadRadius: 0,
                )
              ]
            : null,
      ),
      padding: padding,
      child: child,
    );
  }

  /// Variant: interactively highlighted card.
  factory GlassPanel.active({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
  }) {
    return GlassPanel(
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      backgroundColor: SlamTokens.surfaceHi,
      borderColor: SlamTokens.primary.withValues(alpha: 0.3),
      child: child,
    );
  }

  /// Variant: dimmed / secondary card.
  factory GlassPanel.inactive({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
  }) {
    return GlassPanel(
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      backgroundColor: SlamTokens.bgElev,
      child: child,
    );
  }

  /// Variant: accent card with primary glow.
  factory GlassPanel.accent({
    required Widget child,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    BorderRadius? borderRadius,
    Color? glowColor,
  }) {
    return GlassPanel(
      padding: padding,
      margin: margin,
      borderRadius: borderRadius,
      glow: true,
      glowColor: glowColor,
      child: child,
    );
  }
}
