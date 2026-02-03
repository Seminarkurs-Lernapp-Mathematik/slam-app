import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/models/user_stats.dart';
import '../../core/services/auth_service.dart';
import '../../core/services/firestore_service.dart';

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
      data: (stats) => _buildChip(context, theme, stats.coins),
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
        color: Colors.amber.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: Colors.amber.withValues(alpha: 0.3),
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.monetization_on,
            size: iconSize,
            color: Colors.amber.shade700,
          ),
          const SizedBox(width: 6),
          if (isLoading)
            SizedBox(
              width: 12,
              height: 12,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  Colors.amber.shade700,
                ),
              ),
            )
          else
            Text(
              _formatNumber(coins),
              style: TextStyle(
                color: Colors.amber.shade700,
                fontWeight: FontWeight.bold,
                fontSize: fontSize,
              ),
            ),
        ],
      ),
    );
  }

  /// Format number with K/M suffixes
  String _formatNumber(int number) {
    if (number >= 1000000) {
      return '${(number / 1000000).toStringAsFixed(1)}M';
    } else if (number >= 1000) {
      return '${(number / 1000).toStringAsFixed(1)}K';
    } else {
      return number.toString();
    }
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
