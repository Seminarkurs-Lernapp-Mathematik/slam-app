import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/widgets/widgets.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../../core/models/user_stats.dart';
import '../../../../core/models/theme_unlock.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../widgets/purchase_success_animation.dart';

/// Shop Screen
///
/// Allows users to purchase themes and streak freezes with coins.
class ShopScreen extends ConsumerStatefulWidget {
  const ShopScreen({super.key});

  @override
  ConsumerState<ShopScreen> createState() => _ShopScreenState();
}

class _ShopScreenState extends ConsumerState<ShopScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser?.uid ?? '';

    final userStatsAsync = ref.watch(userStatsStreamProvider(userId));
    final themeUnlocksAsync = ref.watch(themeUnlocksStreamProvider(userId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.palette), text: 'Themes'),
            Tab(icon: Icon(Icons.ac_unit), text: 'Items'),
          ],
        ),
        actions: [
          // Coin Balance
          userStatsAsync.when(
            data: (stats) => _CoinBalanceChip(coins: stats.coins),
            loading: () => const _CoinBalanceChip(coins: 0),
            error: (_, __) => const _CoinBalanceChip(coins: 0),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: userStatsAsync.when(
        data: (stats) => themeUnlocksAsync.when(
          data: (unlocks) => TabBarView(
            controller: _tabController,
            children: [
              _ThemesTab(
                stats: stats,
                unlocks: unlocks,
                userId: userId,
              ),
              _ItemsTab(
                stats: stats,
                userId: userId,
              ),
            ],
          ),
          loading: () => const Center(child: LoadingIndicator()),
          error: (e, _) => Center(child: ErrorMessage(message: e.toString())),
        ),
        loading: () => const Center(
          child: LoadingIndicator(message: 'Lade Shop...'),
        ),
        error: (error, _) => Center(
          child: ErrorMessage(message: error.toString()),
        ),
      ),
    );
  }
}

/// Coin Balance Chip Widget
class _CoinBalanceChip extends StatelessWidget {
  final int coins;

  const _CoinBalanceChip({required this.coins});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.amber.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.amber.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.monetization_on, color: Colors.amber, size: 20),
          const SizedBox(width: 6),
          Text(
            coins.toString(),
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}

/// Themes Tab
class _ThemesTab extends ConsumerWidget {
  final UserStats stats;
  final ThemeUnlocks unlocks;
  final String userId;

  const _ThemesTab({
    required this.stats,
    required this.unlocks,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Info Card
        GlassPanel(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: theme.colorScheme.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Schalte neue Themes mit Münzen frei und personalisiere dein Lernerlebnis!',
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Theme Grid
        ...AppThemePreset.values.map((preset) {
          final isUnlocked = unlocks.isUnlocked(preset);
          final price = ThemePricing.getPrice(preset);
          final canAfford = stats.coins >= price;

          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: _ThemeCard(
              preset: preset,
              isUnlocked: isUnlocked,
              price: price,
              canAfford: canAfford,
              onPurchase: () => _purchaseTheme(context, ref, preset),
              onSelect: () => _selectTheme(context, ref, preset),
            ),
          );
        }),
      ],
    );
  }

  Future<void> _purchaseTheme(
    BuildContext context,
    WidgetRef ref,
    AppThemePreset preset,
  ) async {
    final price = ThemePricing.getPrice(preset);

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${ThemePricing.getName(preset)} kaufen?'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ThemePricing.getDescription(preset)),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.monetization_on, color: Colors.amber),
                const SizedBox(width: 8),
                Text(
                  '$price Münzen',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Kaufen'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      try {
        final aiService = ref.read(aiServiceProvider);
        final response = await aiService.purchaseItem(
          userId: userId,
          itemType: 'theme',
          itemId: preset.name,
          cost: price,
        );

        if (response['success'] == true) {
          if (context.mounted) {
            PurchaseSuccessAnimation.show(
              context,
              itemName: ThemePricing.getName(preset),
              icon: Icons.palette,
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Fehler beim Kauf: ${response['message'] ?? 'Unbekannter Fehler'}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fehler: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  void _selectTheme(BuildContext context, WidgetRef ref, AppThemePreset preset) {
    ref.read(selectedThemeProvider.notifier).setTheme(preset);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${ThemePricing.getName(preset)} aktiviert!'),
        backgroundColor: Colors.green,
      ),
    );
  }
}

/// Theme Card Widget
class _ThemeCard extends StatelessWidget {
  final AppThemePreset preset;
  final bool isUnlocked;
  final int price;
  final bool canAfford;
  final VoidCallback onPurchase;
  final VoidCallback onSelect;

  const _ThemeCard({
    required this.preset,
    required this.isUnlocked,
    required this.price,
    required this.canAfford,
    required this.onPurchase,
    required this.onSelect,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final presetColor = _getPresetColor(preset);

    return GlassPanel(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          // Color Preview
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [presetColor, presetColor.withValues(alpha: 0.7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: presetColor.withValues(alpha: 0.4),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: isUnlocked
                ? const Icon(Icons.check, color: Colors.white, size: 28)
                : const Icon(Icons.lock_outline, color: Colors.white54, size: 24),
          ),
          const SizedBox(width: 16),

          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  ThemePricing.getName(preset),
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  ThemePricing.getDescription(preset),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),

          // Action Button
          if (isUnlocked)
            FilledButton(
              onPressed: onSelect,
              child: const Text('Auswählen'),
            )
          else if (price == 0)
            FilledButton(
              onPressed: onSelect,
              child: const Text('Gratis'),
            )
          else
            FilledButton.tonal(
              onPressed: canAfford ? onPurchase : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.monetization_on, size: 16),
                  const SizedBox(width: 4),
                  Text('$price'),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Color _getPresetColor(AppThemePreset preset) {
    switch (preset) {
      case AppThemePreset.sunsetOrange:
        return const Color(0xFFF97316);
      case AppThemePreset.oceanBlue:
        return const Color(0xFF3B82F6);
      case AppThemePreset.forestGreen:
        return const Color(0xFF22C55E);
      case AppThemePreset.lavenderPurple:
        return const Color(0xFFA855F7);
      case AppThemePreset.cherryRed:
        return const Color(0xFFEF4444);
    }
  }
}

/// Items Tab (Streak Freezes, etc.)
class _ItemsTab extends ConsumerWidget {
  final UserStats stats;
  final String userId;

  const _ItemsTab({
    required this.stats,
    required this.userId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Streak Freeze Card
        GlassPanel(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.ac_unit,
                      color: Colors.blue,
                      size: 32,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Streak Freeze',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${stats.streakFreezes} im Inventar',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Schütze deine Streak, wenn du mal einen Tag verpasst. '
                'Der Streak Freeze wird automatisch aktiviert.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  // Buy with Coins
                  Expanded(
                    child: _PurchaseButton(
                      icon: Icons.monetization_on,
                      iconColor: Colors.amber,
                      label: '50 Münzen',
                      enabled: stats.coins >= 50,
                      onPressed: () =>
                          _purchaseStreakFreezeWithCoins(context, ref),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Buy with XP
                  Expanded(
                    child: _PurchaseButton(
                      icon: Icons.star,
                      iconColor: theme.colorScheme.primary,
                      label: '100 XP',
                      enabled: stats.totalXp >= 100,
                      onPressed: () =>
                          _purchaseStreakFreezeWithXP(context, ref),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // How to earn coins info
        GlassPanel.accent(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.lightbulb, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Wie verdiene ich Münzen?',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _InfoRow(
                icon: Icons.check_circle,
                text: 'Richtige Antworten geben',
              ),
              _InfoRow(
                icon: Icons.speed,
                text: 'Schnell & ohne Hinweise antworten (+25%)',
              ),
              _InfoRow(
                icon: Icons.local_fire_department,
                text: '5+ Tage Streak halten (+50%)',
              ),
              _InfoRow(
                icon: Icons.wb_sunny,
                text: 'Erste Frage des Tages (x2)',
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _purchaseStreakFreezeWithCoins(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await _showPurchaseDialog(
      context,
      title: 'Streak Freeze kaufen?',
      cost: '50 Münzen',
      icon: Icons.monetization_on,
      iconColor: Colors.amber,
    );

    if (confirmed == true && context.mounted) {
      try {
        final aiService = ref.read(aiServiceProvider);
        final response = await aiService.purchaseItem(
          userId: userId,
          itemType: 'streakFreeze',
          itemId: 'streakFreeze', // Generic ID for streak freeze
          cost: 50,
        );

        if (response['success'] == true) {
          if (context.mounted) {
            PurchaseSuccessAnimation.show(
              context,
              itemName: 'Streak Freeze',
              icon: Icons.ac_unit,
            );
          }
        } else {
          if (context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                    'Fehler beim Kauf: ${response['message'] ?? 'Unbekannter Fehler'}'),
                backgroundColor: Colors.red,
              ),
            );
          }
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fehler: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<void> _purchaseStreakFreezeWithXP(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await _showPurchaseDialog(
      context,
      title: 'Streak Freeze kaufen?',
      cost: '100 XP',
      icon: Icons.star,
      iconColor: Theme.of(context).colorScheme.primary,
      warning: 'Achtung: Du verlierst 100 XP!',
    );

    if (confirmed == true && context.mounted) {
      try {
        final updatedStats = stats.purchaseStreakFreeze();
        await ref
            .read(firestoreServiceProvider)
            .updateUserStats(userId, updatedStats);

        if (context.mounted) {
          PurchaseSuccessAnimation.show(
            context,
            itemName: 'Streak Freeze',
            icon: Icons.ac_unit,
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fehler: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<bool?> _showPurchaseDialog(
    BuildContext context, {
    required String title,
    required String cost,
    required IconData icon,
    required Color iconColor,
    String? warning,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 8),
                Text(
                  cost,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (warning != null) ...[
              const SizedBox(height: 12),
              Text(
                warning,
                style: TextStyle(color: Colors.orange.shade700),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Kaufen'),
          ),
        ],
      ),
    );
  }
}

/// Purchase Button Widget
class _PurchaseButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  const _PurchaseButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: enabled ? onPressed : null,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: enabled ? iconColor : null),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

/// Info Row Widget
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: theme.textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

/// Provider for Theme Unlocks Stream
final themeUnlocksStreamProvider =
    StreamProvider.autoDispose.family((ref, String userId) {
  if (userId.isEmpty) {
    return Stream.value(ThemeUnlocks.initial());
  }

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.themeUnlocksStream(userId).map((data) {
    final unlockedThemes = (data['unlockedThemes'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        ['sunsetOrange'];
    return ThemeUnlocks(unlockedThemes: unlockedThemes);
  });
});

/// Provider for User Stats Stream (reuse from progress_screen)
final userStatsStreamProvider =
    StreamProvider.autoDispose.family((ref, String userId) {
  if (userId.isEmpty) {
    return Stream.value(UserStats.initial());
  }

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.userStatsStream(userId);
});


  Future<void> _purchaseStreakFreezeWithXP(
    BuildContext context,
    WidgetRef ref,
  ) async {
    final confirmed = await _showPurchaseDialog(
      context,
      title: 'Streak Freeze kaufen?',
      cost: '100 XP',
      icon: Icons.star,
      iconColor: Theme.of(context).colorScheme.primary,
      warning: 'Achtung: Du verlierst 100 XP!',
    );

    if (confirmed == true && context.mounted) {
      try {
        final updatedStats = stats.purchaseStreakFreeze();
        await ref
            .read(firestoreServiceProvider)
            .updateUserStats(userId, updatedStats);

        if (context.mounted) {
          PurchaseSuccessAnimation.show(
            context,
            itemName: 'Streak Freeze',
            icon: Icons.ac_unit,
          );
        }
      } catch (e) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Fehler: ${e.toString()}'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }

  Future<bool?> _showPurchaseDialog(
    BuildContext context, {
    required String title,
    required String cost,
    required IconData icon,
    required Color iconColor,
    String? warning,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: iconColor),
                const SizedBox(width: 8),
                Text(
                  cost,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            if (warning != null) ...[
              const SizedBox(height: 12),
              Text(
                warning,
                style: TextStyle(color: Colors.orange.shade700),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Kaufen'),
          ),
        ],
      ),
    );
  }
}

/// Purchase Button Widget
class _PurchaseButton extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String label;
  final bool enabled;
  final VoidCallback onPressed;

  const _PurchaseButton({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.enabled,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: enabled ? onPressed : null,
      style: FilledButton.styleFrom(
        padding: const EdgeInsets.symmetric(vertical: 12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: enabled ? iconColor : null),
          const SizedBox(width: 8),
          Text(label),
        ],
      ),
    );
  }
}

/// Info Row Widget
class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const _InfoRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          Icon(icon, size: 18, color: theme.colorScheme.primary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(text, style: theme.textTheme.bodySmall),
          ),
        ],
      ),
    );
  }
}

/// Provider for Theme Unlocks Stream
final themeUnlocksStreamProvider =
    StreamProvider.autoDispose.family((ref, String userId) {
  if (userId.isEmpty) {
    return Stream.value(ThemeUnlocks.initial());
  }

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.themeUnlocksStream(userId).map((data) {
    final unlockedThemes = (data['unlockedThemes'] as List<dynamic>?)
            ?.map((e) => e.toString())
            .toList() ??
        ['sunsetOrange'];
    return ThemeUnlocks(unlockedThemes: unlockedThemes);
  });
});

/// Provider for User Stats Stream (reuse from progress_screen)
final userStatsStreamProvider =
    StreamProvider.autoDispose.family((ref, String userId) {
  if (userId.isEmpty) {
    return Stream.value(UserStats.initial());
  }

  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.userStatsStream(userId);
});
