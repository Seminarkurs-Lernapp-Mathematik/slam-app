import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/design_tokens.dart';
import '../animations/app_animations.dart';

class SlamEmptyState extends StatelessWidget {
  const SlamEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
    this.actionLabel,
    this.iconColor,
    this.useLottie = true,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? action;
  final String? actionLabel;
  final Color? iconColor;
  final bool useLottie;

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? SlamTokens.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleIn(
              duration: const Duration(milliseconds: 500),
              curve: AppCurves.spring,
              child: useLottie
                  ? SizedBox(
                      width: 100,
                      height: 100,
                      child: LottieLoop(
                        asset: AppAnim.emptyState,
                        size: 100,
                      ),
                    )
                  : Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: color.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Icon(icon,
                          size: 40, color: color.withValues(alpha: 0.8)),
                    ),
            ),
            const SizedBox(height: 20),
            SlideInUp(
              delay: const Duration(milliseconds: 120),
              child: Text(
                title,
                style: GoogleFonts.fraunces(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: SlamTokens.text,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 8),
            SlideInUp(
              delay: const Duration(milliseconds: 180),
              child: Text(
                subtitle,
                style: GoogleFonts.dmSans(
                  fontSize: 14,
                  color: SlamTokens.textDim,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            if (action != null && actionLabel != null) ...[
              const SizedBox(height: 28),
              SlideInUp(
                delay: const Duration(milliseconds: 240),
                child: PressScale(
                  onTap: action,
                  child: FilledButton(
                    onPressed: action,
                    style: FilledButton.styleFrom(
                      backgroundColor: color,
                      foregroundColor: SlamTokens.primaryOn,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 28, vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(SlamTokens.rOption),
                      ),
                    ),
                    child: Text(
                      actionLabel!,
                      style: GoogleFonts.dmSans(
                          fontWeight: FontWeight.w600, fontSize: 15),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
