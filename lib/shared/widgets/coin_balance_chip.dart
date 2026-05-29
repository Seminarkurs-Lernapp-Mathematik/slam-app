import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../app/design_tokens.dart';
import '../../core/models/user_stats.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';
import '../animations/app_animations.dart';

/// Coin Balance Chip Widget
///
/// Displays the user's current coin balance with a gold coin icon.
/// Used in top navigation, profile screen, and settings screen.
class CoinBalanceChip extends ConsumerWidget {
  final double iconSize;
  final double fontSize;

  const CoinBalanceChip({
    super.key,
    this.iconSize = 20,
    this.fontSize = 14,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser?.uid ?? '';

    // Watch User Stats Stream
    final userStatsAsync = ref.watch(
      _userStatsStreamProvider(userId),
    );

    return userStatsAsync.when(
      data: (stats) => ScaleIn(
        curve: AppCurves.spring,
        duration: AppDurations.standard,
        child: _buildChip(context, theme, stats.coins),
      ),
      loading: () => _buildChip(context, theme, 0, isLoading: true),
      error: (_, __) => _buildChip(context, theme, 0),
    );
  }

  Widget _buildChip(
    BuildContext context,
    ThemeData theme,
    int coins, {
    bool isLoading = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: SlamTokens.warnSoft,
        borderRadius: BorderRadius.circular(SlamTokens.rCircle),
        border: Border.all(color: SlamTokens.warn.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.monetization_on, size: iconSize, color: SlamTokens.warn),
          const SizedBox(width: 6),
          if (isLoading)
            SizedBox(
              width: 24,
              height: 12,
              child: LottieLoop(asset: AppAnim.loadingDots),
            )
          else
            AnimatedCounter(
              value: coins,
              style: GoogleFonts.dmSans(
                color: SlamTokens.warn,
                fontWeight: FontWeight.w700,
                fontSize: fontSize,
              ),
            ),
        ],
      ),
    );
  }

}

/// User Stats Stream Provider (local to this widget)
final _userStatsStreamProvider =
    StreamProvider.autoDispose.family<UserStats, String>((ref, userId) {
  if (userId.isEmpty) {
    return Stream.value(UserStats.initial());
  }

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.userStatsStream(userId);
});
