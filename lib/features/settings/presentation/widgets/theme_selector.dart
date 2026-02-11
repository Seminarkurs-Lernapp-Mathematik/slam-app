import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../providers/settings_providers.dart';
import '../../../../core/models/theme_unlock.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../shared/widgets/glass_panel.dart';
import '../../../gamification/presentation/screens/shop_screen.dart';

/// Theme Selector Widget - 6 theme presets with unlock enforcement
class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTheme = ref.watch(selectedThemeProvider);
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser?.uid ?? '';
    final themeUnlocksAsync = ref.watch(themeUnlocksStreamProvider(userId));

    return GlassPanel(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.palette, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Farbschema',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            themeUnlocksAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) => _buildThemeGrid(
                context,
                ref,
                selectedTheme,
                ThemeUnlocks.initial(),
              ),
              data: (unlocks) => _buildThemeGrid(
                context,
                ref,
                selectedTheme,
                unlocks,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildThemeGrid(
    BuildContext context,
    WidgetRef ref,
    AppThemePreset selectedTheme,
    ThemeUnlocks unlocks,
  ) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final chipWidth = (constraints.maxWidth - 12) / 2;
        return Wrap(
          spacing: 12,
          runSpacing: 12,
          children: AppThemePreset.values.map((theme) {
            final isSelected = selectedTheme == theme;
            final isUnlocked = unlocks.isUnlocked(theme);
            final price = ThemePricing.getPrice(theme);
            return SizedBox(
              width: chipWidth,
              child: _ThemeChip(
                theme: theme,
                isSelected: isSelected,
                isUnlocked: isUnlocked,
                price: price,
                onTap: () {
                  if (isUnlocked || price == 0) {
                    ref
                        .read(selectedThemeProvider.notifier)
                        .setTheme(theme);
                  } else {
                    _showLockedThemeDialog(context);
                  }
                },
              ),
            );
          }).toList(),
        );
      },
    );
  }

  void _showLockedThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme gesperrt'),
        content: const Text(
          'Dieses Theme muss zuerst im Shop mit Münzen freigeschaltet werden.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Abbrechen'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.of(context).pop();
              context.go('/shop');
            },
            child: const Text('Zum Shop'),
          ),
        ],
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  final AppThemePreset theme;
  final bool isSelected;
  final bool isUnlocked;
  final int price;
  final VoidCallback onTap;

  const _ThemeChip({
    required this.theme,
    required this.isSelected,
    required this.isUnlocked,
    required this.price,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getThemeColor(theme);
    final isLocked = !isUnlocked && price > 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: isLocked ? 0.1 : 0.2),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 2,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isLocked ? color.withValues(alpha: 0.4) : color,
                shape: BoxShape.circle,
              ),
              child: isLocked
                  ? const Icon(Icons.lock, size: 12, color: Colors.white70)
                  : null,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _getThemeName(theme),
                    style: TextStyle(
                      fontWeight:
                          isSelected ? FontWeight.bold : FontWeight.normal,
                      color: isLocked
                          ? Theme.of(context)
                              .colorScheme
                              .onSurfaceVariant
                          : null,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (isLocked)
                    Text(
                      '$price Münzen',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.amber,
                            fontSize: 10,
                          ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getThemeColor(AppThemePreset theme) {
    switch (theme) {
      case AppThemePreset.sunsetOrange:
        return const Color(0xFFf97316);
      case AppThemePreset.oceanBlue:
        return const Color(0xFF0ea5e9);
      case AppThemePreset.forestGreen:
        return const Color(0xFF10b981);
      case AppThemePreset.lavenderPurple:
        return const Color(0xFFa78bfa);
      case AppThemePreset.cherryRed:
        return const Color(0xFFef4444);
    }
  }

  String _getThemeName(AppThemePreset theme) {
    switch (theme) {
      case AppThemePreset.sunsetOrange:
        return 'Sunset Orange';
      case AppThemePreset.oceanBlue:
        return 'Ocean Blue';
      case AppThemePreset.forestGreen:
        return 'Forest Green';
      case AppThemePreset.lavenderPurple:
        return 'Lavender Purple';
      case AppThemePreset.cherryRed:
        return 'Cherry Red';
    }
  }
}
