import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/design_tokens.dart';
import '../../../../core/models/user_stats.dart';
import '../../../../core/models/theme_unlock.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../settings/presentation/providers/settings_providers.dart';
import '../widgets/purchase_success_animation.dart';

class ShopScreen extends ConsumerWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final userId = currentUser?.uid ?? '';
    final userStatsAsync = ref.watch(_shopUserStatsProvider(userId));
    final themeUnlocksAsync = ref.watch(themeUnlocksStreamProvider(userId));

    return Scaffold(
      backgroundColor: SlamTokens.bg,
      body: userStatsAsync.when(
        data: (stats) => themeUnlocksAsync.when(
          data: (unlocks) => _ShopBody(stats: stats, unlocks: unlocks, userId: userId),
          loading: () => const Center(child: CircularProgressIndicator(color: SlamTokens.primary)),
          error: (e, _) => Center(child: Text('Fehler: $e', style: const TextStyle(color: SlamTokens.danger))),
        ),
        loading: () => const Center(child: CircularProgressIndicator(color: SlamTokens.primary)),
        error: (e, _) => Center(child: Text('Fehler: $e', style: const TextStyle(color: SlamTokens.danger))),
      ),
    );
  }
}

class _ShopBody extends ConsumerWidget {
  const _ShopBody({required this.stats, required this.unlocks, required this.userId});
  final UserStats stats;
  final ThemeUnlocks unlocks;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // ── Header ──────────────────────────────────────────────
        SliverToBoxAdapter(child: _ShopHeader(coins: stats.coins)),

        // ── THEMES label ─────────────────────────────────────────
        SliverToBoxAdapter(child: _sectionLabel('THEMES')),

        // ── Themes 2-col grid ─────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(SlamTokens.gutter, 0, SlamTokens.gutter, 18),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.78,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, i) {
                final preset = AppThemePreset.values[i];
                final isUnlocked = unlocks.isUnlocked(preset);
                final price = ThemePricing.getPrice(preset);
                return _ThemeCard(
                  preset: preset,
                  isUnlocked: isUnlocked,
                  price: price,
                  canAfford: stats.coins >= price,
                  onPurchase: () => _purchaseTheme(context, ref, preset, price),
                  onSelect: () => _selectTheme(context, ref, preset),
                );
              },
              childCount: AppThemePreset.values.length,
            ),
          ),
        ),

        // ── POWER-UPS label ───────────────────────────────────────
        SliverToBoxAdapter(child: _sectionLabel('POWER-UPS')),

        // ── Power-ups list ────────────────────────────────────────
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(SlamTokens.gutter, 0, SlamTokens.gutter, 32),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _PowerUpRow(
                icon: Icons.ac_unit,
                iconColor: SlamTokens.success,
                title: 'Streak-Freeze',
                subtitle: 'Power-Up',
                cost: 80,
                onBuy: () => _purchaseStreakFreezeWithCoins(context, ref, userId, stats),
              ),
              const SizedBox(height: 8),
              _PowerUpRow(
                icon: Icons.star,
                iconColor: SlamTokens.primary,
                title: 'Streak-Freeze (XP)',
                subtitle: '100 XP Kosten',
                cost: 0,
                costLabel: '100 XP',
                onBuy: () => _purchaseStreakFreezeWithXP(context, ref, userId, stats),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Widget _sectionLabel(String text) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(SlamTokens.gutter, 6, SlamTokens.gutter, 10),
      child: Text(
        text,
        style: GoogleFonts.dmSans(
          fontSize: 11, fontWeight: FontWeight.w800,
          letterSpacing: 1.2, color: SlamTokens.textDim,
        ),
      ),
    );
  }

  Future<void> _purchaseTheme(
    BuildContext context, WidgetRef ref, AppThemePreset preset, int price) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: SlamTokens.surface,
        title: Text('${ThemePricing.getName(preset)} kaufen?',
            style: GoogleFonts.fraunces(color: SlamTokens.text, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ThemePricing.getDescription(preset),
                style: GoogleFonts.dmSans(color: SlamTokens.textDim)),
            const SizedBox(height: 16),
            Row(children: [
              const Icon(Icons.monetization_on, color: SlamTokens.warn, size: 18),
              const SizedBox(width: 8),
              Text('$price Münzen',
                  style: GoogleFonts.dmSans(fontWeight: FontWeight.w700, color: SlamTokens.text)),
            ]),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false),
              child: const Text('Abbrechen')),
          FilledButton(onPressed: () => Navigator.pop(context, true),
              child: const Text('Kaufen')),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    showDialog(context: context, barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()));

    try {
      final resp = await ref.read(firestoreServiceProvider).purchaseTheme(
        userId: userId, themeName: preset.name, cost: price,
      );
      if (context.mounted) Navigator.pop(context);
      if (resp['success'] == true && context.mounted) {
        PurchaseSuccessAnimation.show(context, itemName: ThemePricing.getName(preset), icon: Icons.palette);
      } else if (context.mounted) {
        _showError(context, resp['message']?.toString() ?? 'Fehler');
      }
    } catch (e) {
      if (context.mounted) { Navigator.pop(context); _showError(context, e.toString()); }
    }
  }

  void _selectTheme(BuildContext context, WidgetRef ref, AppThemePreset preset) {
    ref.read(selectedThemeProvider.notifier).setTheme(preset);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${ThemePricing.getName(preset)} aktiviert!'),
          backgroundColor: SlamTokens.success, duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _purchaseStreakFreezeWithCoins(
      BuildContext context, WidgetRef ref, String userId, UserStats stats) async {
    if (stats.coins < 80) {
      _showError(context, 'Nicht genug Münzen (80 benötigt)');
      return;
    }
    final confirmed = await _confirmDialog(context, 'Streak Freeze kaufen?', '80 Münzen');
    if (confirmed != true || !context.mounted) return;

    try {
      final resp = await ref.read(firestoreServiceProvider).purchaseStreakFreezeWithCoins(userId: userId, cost: 80);
      if (resp['success'] == true && context.mounted) {
        PurchaseSuccessAnimation.show(context, itemName: 'Streak Freeze', icon: Icons.ac_unit);
      } else if (context.mounted) {
        _showError(context, resp['message']?.toString() ?? 'Fehler');
      }
    } catch (e) {
      if (context.mounted) _showError(context, e.toString());
    }
  }

  Future<void> _purchaseStreakFreezeWithXP(
      BuildContext context, WidgetRef ref, String userId, UserStats stats) async {
    if (stats.totalXp < 100) {
      _showError(context, 'Nicht genug XP (100 benötigt)');
      return;
    }
    final confirmed = await _confirmDialog(context, 'Streak Freeze kaufen?', '100 XP');
    if (confirmed != true || !context.mounted) return;

    try {
      final resp = await ref.read(firestoreServiceProvider).purchaseStreakFreezeWithXP(userId: userId, xpCost: 100);
      if (resp['success'] == true && context.mounted) {
        PurchaseSuccessAnimation.show(context, itemName: 'Streak Freeze', icon: Icons.ac_unit);
      } else if (context.mounted) {
        _showError(context, resp['message']?.toString() ?? 'Fehler');
      }
    } catch (e) {
      if (context.mounted) _showError(context, e.toString());
    }
  }

  Future<bool?> _confirmDialog(BuildContext context, String title, String cost) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: SlamTokens.surface,
        title: Text(title, style: GoogleFonts.fraunces(color: SlamTokens.text, fontWeight: FontWeight.w700)),
        content: Text(cost, style: GoogleFonts.dmSans(color: SlamTokens.textDim)),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text('Abbrechen')),
          FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Kaufen')),
        ],
      ),
    );
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: SlamTokens.danger, duration: const Duration(seconds: 4)),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shop Header
// ─────────────────────────────────────────────────────────────────────────────

class _ShopHeader extends StatelessWidget {
  const _ShopHeader({required this.coins});
  final int coins;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(SlamTokens.gutter, 24, SlamTokens.gutter, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SHOP', style: GoogleFonts.dmSans(
                      fontSize: 11, fontWeight: FontWeight.w800,
                      letterSpacing: 1.2, color: SlamTokens.textDim)),
                  const SizedBox(height: 6),
                  Text('Belohnungen', style: GoogleFonts.fraunces(
                      fontSize: 34, fontWeight: FontWeight.w700,
                      color: SlamTokens.text, letterSpacing: -0.8)),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
              decoration: BoxDecoration(
                color: SlamTokens.warn,
                borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                boxShadow: [BoxShadow(color: SlamTokens.warn.withValues(alpha: 0.5),
                    blurRadius: 18, offset: const Offset(0, 6), spreadRadius: -4)],
              ),
              child: Row(
                children: [
                  const Icon(Icons.monetization_on, size: 16, color: SlamTokens.primaryOn),
                  const SizedBox(width: 6),
                  Text('$coins', style: GoogleFonts.fraunces(
                      fontSize: 14, fontWeight: FontWeight.w800, color: SlamTokens.primaryOn)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Theme Card
// ─────────────────────────────────────────────────────────────────────────────

class _ThemeCard extends StatelessWidget {
  const _ThemeCard({
    required this.preset, required this.isUnlocked, required this.price,
    required this.canAfford, required this.onPurchase, required this.onSelect,
  });
  final AppThemePreset preset;
  final bool isUnlocked;
  final int price;
  final bool canAfford;
  final VoidCallback onPurchase;
  final VoidCallback onSelect;

  Color get _presetColor {
    switch (preset) {
      case AppThemePreset.sunsetOrange: return const Color(0xFFF97316);
      case AppThemePreset.oceanBlue: return const Color(0xFF3B82F6);
      case AppThemePreset.forestGreen: return const Color(0xFF22C55E);
      case AppThemePreset.lavenderPurple: return const Color(0xFFA855F7);
      case AppThemePreset.cherryRed: return const Color(0xFFEF4444);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isUnlocked ? onSelect : (canAfford ? onPurchase : null),
      child: Container(
        decoration: BoxDecoration(
          color: SlamTokens.surface,
          borderRadius: BorderRadius.circular(SlamTokens.rCardSm),
          border: Border.all(color: SlamTokens.line),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color preview
            Expanded(
              child: Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [_presetColor, _presetColor.withValues(alpha: 0.55)],
                  ),
                  borderRadius: BorderRadius.circular(SlamTokens.rCardSm - 4),
                ),
                child: Stack(
                  children: [
                    // Blob
                    Positioned.fill(
                      child: Container(
                        margin: const EdgeInsets.all(-4),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                        ),
                      ),
                    ),
                    if (isUnlocked)
                      Positioned(
                        top: 8, right: 8,
                        child: Container(
                          width: 24, height: 24,
                          decoration: const BoxDecoration(
                            color: Color(0x66000000), shape: BoxShape.circle,
                          ),
                          alignment: Alignment.center,
                          child: const Icon(Icons.check, size: 14, color: Colors.white),
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(ThemePricing.getName(preset), style: GoogleFonts.fraunces(
                fontSize: 14, fontWeight: FontWeight.w700,
                color: SlamTokens.text, letterSpacing: -0.2)),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: SlamTokens.warnSoft,
                    borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.monetization_on, size: 11, color: SlamTokens.warn),
                      const SizedBox(width: 3),
                      Text('$price', style: GoogleFonts.dmSans(
                          fontSize: 11, fontWeight: FontWeight.w800, color: SlamTokens.warn)),
                    ],
                  ),
                ),
                const Spacer(),
                Text(
                  isUnlocked ? 'BESITZT' : 'KAUFEN',
                  style: GoogleFonts.dmSans(
                    fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 0.6,
                    color: isUnlocked ? SlamTokens.success : SlamTokens.textDim,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Power-Up Row
// ─────────────────────────────────────────────────────────────────────────────

class _PowerUpRow extends StatelessWidget {
  const _PowerUpRow({
    required this.icon, required this.iconColor, required this.title,
    required this.subtitle, required this.cost, this.costLabel, required this.onBuy,
  });
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final int cost;
  final String? costLabel;
  final VoidCallback onBuy;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: SlamTokens.surface,
        borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
        border: Border.all(color: SlamTokens.line),
      ),
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          Container(
            width: 44, height: 44,
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.14),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 20, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: GoogleFonts.fraunces(
                    fontSize: 14, fontWeight: FontWeight.w700,
                    color: SlamTokens.text, letterSpacing: -0.2)),
                Text(subtitle, style: GoogleFonts.dmSans(
                    fontSize: 12, color: SlamTokens.textDim)),
              ],
            ),
          ),
          GestureDetector(
            onTap: onBuy,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: SlamTokens.warnSoft,
                borderRadius: BorderRadius.circular(SlamTokens.rCircle),
              ),
              child: Row(
                children: [
                  if (cost > 0) ...[
                    const Icon(Icons.monetization_on, size: 13, color: SlamTokens.warn),
                    const SizedBox(width: 4),
                    Text('$cost', style: GoogleFonts.dmSans(
                        fontSize: 13, fontWeight: FontWeight.w800, color: SlamTokens.warn)),
                  ] else
                    Text(costLabel ?? '', style: GoogleFonts.dmSans(
                        fontSize: 12, fontWeight: FontWeight.w800, color: SlamTokens.warn)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Providers
// ─────────────────────────────────────────────────────────────────────────────

final _shopUserStatsProvider =
    StreamProvider.autoDispose.family<UserStats, String>((ref, userId) {
  if (userId.isEmpty) return Stream.value(UserStats.initial());
  return ref.watch(firestoreServiceProvider).userStatsStream(userId);
});

final themeUnlocksStreamProvider =
    StreamProvider.autoDispose.family<ThemeUnlocks, String>((ref, userId) {
  if (userId.isEmpty) return Stream.value(ThemeUnlocks.initial());
  final firestoreService = ref.watch(firestoreServiceProvider);
  return firestoreService.themeUnlocksStream(userId).map((data) {
    final unlockedThemes = (data['unlockedThemes'] as List<dynamic>?)
            ?.map((e) => e.toString()).toList() ??
        ['sunsetOrange'];
    return ThemeUnlocks(unlockedThemes: unlockedThemes);
  });
});
