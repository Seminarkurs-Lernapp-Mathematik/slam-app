import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/design_tokens.dart';

/// Primary CTA button (DESIGN.md §6.1) — pill shape, primary bg, primaryOn text,
/// with shadow `0 10px 30px -8px primaryAA`.
///
/// The `gradient` and `borderRadius` parameters are retained for backward
/// compatibility but have no visual effect in the new design.
class GradientButton extends StatelessWidget {
  const GradientButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.gradient,       // retained for compat — ignored
    this.height = 52,
    this.width,
    this.borderRadius,   // retained for compat — ignored
    this.textStyle,
    this.icon,
    this.disabled = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final Gradient? gradient;
  final double height;
  final double? width;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final IconData? icon;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final isOff = disabled || isLoading || onPressed == null;

    return SizedBox(
      height: height,
      width: width,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: isOff
              ? SlamTokens.surfaceHi
              : SlamTokens.primary,
          borderRadius: BorderRadius.circular(SlamTokens.rCircle),
          boxShadow: isOff ? null : [SlamTokens.primaryShadow],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: isOff ? null : onPressed,
            borderRadius: BorderRadius.circular(SlamTokens.rCircle),
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(SlamTokens.primaryOn),
                        strokeWidth: 2.5,
                      ),
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (icon != null) ...[
                          Icon(icon, color: SlamTokens.primaryOn, size: 20),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          text,
                          style: textStyle ??
                              GoogleFonts.dmSans(
                                fontSize: 15,
                                fontWeight: FontWeight.w800,
                                color: isOff
                                    ? SlamTokens.textMute
                                    : SlamTokens.primaryOn,
                                letterSpacing: 0.1,
                              ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Secondary button (DESIGN.md §6.1) — surface bg, line border, text fg.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isLoading = false,
    this.height = 52,
    this.width,
    this.borderRadius,
    this.textStyle,
    this.icon,
    this.disabled = false,
  });

  final String text;
  final VoidCallback? onPressed;
  final bool isLoading;
  final double height;
  final double? width;
  final BorderRadius? borderRadius;
  final TextStyle? textStyle;
  final IconData? icon;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final isOff = disabled || isLoading || onPressed == null;

    return SizedBox(
      height: height,
      width: width,
      child: OutlinedButton(
        onPressed: isOff ? null : onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: isOff ? SlamTokens.textMute : SlamTokens.text,
          backgroundColor: SlamTokens.surface,
          side: BorderSide(
            color: isOff ? SlamTokens.textMute : SlamTokens.line,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(SlamTokens.rInput),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  valueColor:
                      AlwaysStoppedAnimation<Color>(SlamTokens.textDim),
                  strokeWidth: 2.5,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                  ],
                  Text(
                    text,
                    style: textStyle ??
                        GoogleFonts.dmSans(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isOff
                              ? SlamTokens.textMute
                              : SlamTokens.text,
                        ),
                  ),
                ],
              ),
      ),
    );
  }
}
