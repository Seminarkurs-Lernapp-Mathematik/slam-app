import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/design_tokens.dart';

/// Reusable empty-state widget used across list screens.
///
/// Shows an icon in a rounded container, a headline, a subtitle, and an
/// optional action button — all consistent with the SLAM design token system.
class SlamEmptyState extends StatelessWidget {
  const SlamEmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.action,
    this.actionLabel,
    this.iconColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? action;
  final String? actionLabel;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final color = iconColor ?? SlamTokens.primary;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, size: 40, color: color.withValues(alpha: 0.8)),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              style: GoogleFonts.fraunces(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: SlamTokens.text,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: GoogleFonts.dmSans(
                fontSize: 14,
                color: SlamTokens.textDim,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            if (action != null && actionLabel != null) ...[
              const SizedBox(height: 28),
              FilledButton(
                onPressed: action,
                style: FilledButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: SlamTokens.primaryOn,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(SlamTokens.rOption),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w600, fontSize: 15),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
