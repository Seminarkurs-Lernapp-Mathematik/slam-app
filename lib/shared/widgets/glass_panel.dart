import 'package:flutter/material.dart';
import 'dart:ui';

/// Glass Panel Widget
///
/// Glassmorphism-style panel with backdrop blur.
/// Replicates the React app's GlassPanel component.
class GlassPanel extends StatelessWidget {
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

  const GlassPanel({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius,
    this.blur = 12.0,
    this.opacity = 0.08,
    this.showBorder = true,
    this.borderColor,
    this.glow = false,
    this.glowColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final effectiveBorderRadius = borderRadius ?? BorderRadius.circular(16);
    final effectiveBorderColor =
        borderColor ?? Colors.white.withValues(alpha: 0.12);
    final effectiveGlowColor =
        glowColor ?? theme.colorScheme.primary.withValues(alpha: 0.4);

    return Container(
      margin: margin,
      decoration: BoxDecoration(
        borderRadius: effectiveBorderRadius,
        boxShadow: glow
            ? [
                BoxShadow(
                  color: effectiveGlowColor,
                  blurRadius: 20,
                  spreadRadius: 2,
                )
              ]
            : null,
      ),
      child: ClipRRect(
        borderRadius: effectiveBorderRadius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: opacity),
              borderRadius: effectiveBorderRadius,
              border: showBorder
                  ? Border.all(
                      color: effectiveBorderColor,
                      width: 1,
                    )
                  : null,
            ),
            padding: padding,
            child: child,
          ),
        ),
      ),
    );
  }

  /// Variant: Active (more opacity)
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
      opacity: 0.12,
      borderColor: Colors.white.withValues(alpha: 0.20),
      child: child,
    );
  }

  /// Variant: Inactive (less opacity)
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
      opacity: 0.05,
      borderColor: Colors.white.withValues(alpha: 0.05),
      child: child,
    );
  }

  /// Variant: Accent (with glow)
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
      opacity: 0.12,
      glow: true,
      glowColor: glowColor,
      child: child,
    );
  }
}
