import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/design_tokens.dart';
import '../providers/usage_providers.dart';

/// Subtle usage indicator shown in the Profil tab after 5+ tasks.
/// Shows day/week AI call counts as thin progress bars.
class UsageIndicator extends ConsumerWidget {
  const UsageIndicator({super.key});

  static const int _weekSoftLimit = 100;
  static const int _daySoftLimit = 20;
  static const int _visibilityThreshold = 5;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usageAsync = ref.watch(usageStatsProvider);

    return usageAsync.when(
      data: (stats) {
        if (stats.sessionCount < _visibilityThreshold) {
          return const SizedBox.shrink();
        }
        return _UsageContent(stats: stats);
      },
      loading: () => const SizedBox.shrink(),
      error: (_, __) => const SizedBox.shrink(),
    );
  }
}

class _UsageContent extends StatelessWidget {
  final UsageStats stats;

  const _UsageContent({required this.stats});

  static const int _weekSoftLimit = UsageIndicator._weekSoftLimit;
  static const int _daySoftLimit = UsageIndicator._daySoftLimit;

  @override
  Widget build(BuildContext context) {
    final weekFraction = (stats.weekCount / _weekSoftLimit).clamp(0.0, 1.0);
    final dayFraction = (stats.dayCount / _daySoftLimit).clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.bolt_outlined,
                  size: 13, color: SlamTokens.textDim),
              const SizedBox(width: 4),
              Text(
                'KI-Nutzung',
                style: GoogleFonts.dmSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: SlamTokens.textDim,
                  letterSpacing: 0.2,
                ),
              ),
              const Spacer(),
              Text(
                '${stats.weekCount}/$_weekSoftLimit diese Woche',
                style: GoogleFonts.dmSans(
                  fontSize: 11,
                  color: SlamTokens.textMute,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _ThinProgressBar(fraction: weekFraction, label: 'Woche'),
          const SizedBox(height: 4),
          _ThinProgressBar(fraction: dayFraction, label: 'Heute'),
        ],
      ),
    );
  }
}

class _ThinProgressBar extends StatelessWidget {
  final double fraction;
  final String label;

  const _ThinProgressBar({required this.fraction, required this.label});

  @override
  Widget build(BuildContext context) {
    final color = fraction > 0.8
        ? SlamTokens.warn
        : SlamTokens.primary.withValues(alpha: 0.7);

    return Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(
            label,
            style: GoogleFonts.dmSans(
              fontSize: 10,
              color: SlamTokens.textMute,
            ),
          ),
        ),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(2),
            child: LinearProgressIndicator(
              value: fraction,
              minHeight: 3,
              backgroundColor: SlamTokens.line,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
        ),
      ],
    );
  }
}
