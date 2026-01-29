import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/settings_providers.dart';
import '../../../../shared/widgets/glass_panel.dart';

/// Theme Selector Widget - 6 theme presets
class ThemeSelector extends ConsumerWidget {
  const ThemeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedTheme = ref.watch(selectedThemeProvider);

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
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: AppThemePreset.values.map((theme) {
                final isSelected = selectedTheme == theme;
                return _ThemeChip(
                  theme: theme,
                  isSelected: isSelected,
                  onTap: () => ref.read(selectedThemeProvider.notifier).setTheme(theme),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

class _ThemeChip extends StatelessWidget {
  final AppThemePreset theme;
  final bool isSelected;
  final VoidCallback onTap;

  const _ThemeChip({
    required this.theme,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getThemeColor(theme);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
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
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              _getThemeName(theme),
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
            if (isSelected) ...[
              const SizedBox(width: 4),
              Icon(Icons.check_circle, size: 16, color: color),
            ],
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
      case AppThemePreset.midnightDark:
        return const Color(0xFF1e293b);
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
      case AppThemePreset.midnightDark:
        return 'Midnight Dark';
      case AppThemePreset.cherryRed:
        return 'Cherry Red';
    }
  }
}
