import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
          data: (unlocks) =>
              _ShopBody(stats: stats, unlocks: unlocks, userId: userId),
          loading: () => Center(
              child: CircularProgressIndicator(color: SlamTokens.primary)),
          error: (e, _) => Center(
              child: Text('Fehler: $e',
                  style: const TextStyle(color: SlamTokens.danger))),
        ),
        loading: () =>
            Center(child: CircularProgressIndicator(color: SlamTokens.primary)),
        error: (e, _) => Center(
            child: Text('Fehler: $e',
                style: const TextStyle(color: SlamTokens.danger))),
      ),
    );
  }
}

class _ShopBody extends ConsumerWidget {
  const _ShopBody(
      {required this.stats, required this.unlocks, required this.userId});
  final UserStats stats;
  final ThemeUnlocks unlocks;
  final String userId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        SliverToBoxAdapter(child: _ShopHeader(coins: stats.coins)),
        SliverToBoxAdapter(child: _AnimatedSectionLabel('THEMES', delay: 100)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
              SlamTokens.gutter, 0, SlamTokens.gutter, 18),
          sliver: SliverGrid(
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 190,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.88,
            ),
            delegate: SliverChildBuilderDelegate(
              (_, i) {
                final preset = AppThemePreset.values[i];
                final isUnlocked = unlocks.isUnlocked(preset);
                final price = ThemePricing.getPrice(preset);
                return _AnimatedThemeCard(
                  index: i,
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
        SliverToBoxAdapter(
            child: _AnimatedSectionLabel('POWER-UPS', delay: 300)),
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(
              SlamTokens.gutter, 0, SlamTokens.gutter, 32),
          sliver: SliverList(
            delegate: SliverChildListDelegate([
              _AnimatedPowerUpRow(
                index: 0,
                icon: Icons.ac_unit,
                iconColor: SlamTokens.success,
                title: 'Streak-Freeze',
                subtitle: 'Power-Up',
                cost: 80,
                onBuy: () =>
                    _purchaseStreakFreezeWithCoins(context, ref, userId, stats),
              ),
              const SizedBox(height: 8),
              _AnimatedPowerUpRow(
                index: 1,
                icon: Icons.star,
                iconColor: SlamTokens.primary,
                title: 'Streak-Freeze (XP)',
                subtitle: '100 XP Kosten',
                cost: 0,
                costLabel: '100 XP',
                onBuy: () =>
                    _purchaseStreakFreezeWithXP(context, ref, userId, stats),
              ),
            ]),
          ),
        ),
      ],
    );
  }

  Future<void> _purchaseTheme(BuildContext context, WidgetRef ref,
      AppThemePreset preset, int price) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: SlamTokens.surface,
        title: Text('${ThemePricing.getName(preset)} kaufen?',
            style: GoogleFonts.fraunces(
                color: SlamTokens.text, fontWeight: FontWeight.w700)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ThemePricing.getDescription(preset),
                style: GoogleFonts.dmSans(color: SlamTokens.textDim)),
            const SizedBox(height: 16),
            Row(children: [
              const Icon(Icons.monetization_on,
                  color: SlamTokens.warn, size: 18),
              const SizedBox(width: 8),
              Text('$price Münzen',
                  style: GoogleFonts.dmSans(
                      fontWeight: FontWeight.w700, color: SlamTokens.text)),
            ]),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Abbrechen')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Kaufen')),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => const Center(child: CircularProgressIndicator()));

    try {
      final resp = await ref.read(firestoreServiceProvider).purchaseTheme(
            userId: userId,
            themeName: preset.name,
            cost: price,
          );
      if (context.mounted) Navigator.pop(context);
      if (resp['success'] == true && context.mounted) {
        PurchaseSuccessAnimation.show(context,
            itemName: ThemePricing.getName(preset), icon: Icons.palette);
      } else if (context.mounted) {
        _showError(context, resp['message']?.toString() ?? 'Fehler');
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        _showError(context, e.toString());
      }
    }
  }

  void _selectTheme(
      BuildContext context, WidgetRef ref, AppThemePreset preset) {
    HapticFeedback.selectionClick();
    ref.read(selectedThemeProvider.notifier).setTheme(preset);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text('${ThemePricing.getName(preset)} aktiviert!'),
          backgroundColor: SlamTokens.success,
          duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _purchaseStreakFreezeWithCoins(BuildContext context,
      WidgetRef ref, String userId, UserStats stats) async {
    if (stats.coins < 80) {
      _showError(context, 'Nicht genug Münzen (80 benötigt)');
      return;
    }
    final confirmed =
        await _confirmDialog(context, 'Streak Freeze kaufen?', '80 Münzen');
    if (confirmed != true || !context.mounted) return;
    try {
      final resp = await ref
          .read(firestoreServiceProvider)
          .purchaseStreakFreezeWithCoins(userId: userId, cost: 80);
      if (resp['success'] == true && context.mounted) {
        PurchaseSuccessAnimation.show(context,
            itemName: 'Streak Freeze', icon: Icons.ac_unit);
      } else if (context.mounted) {
        _showError(context, resp['message']?.toString() ?? 'Fehler');
      }
    } catch (e) {
      if (context.mounted) _showError(context, e.toString());
    }
  }

  Future<void> _purchaseStreakFreezeWithXP(BuildContext context, WidgetRef ref,
      String userId, UserStats stats) async {
    if (stats.totalXp < 100) {
      _showError(context, 'Nicht genug XP (100 benötigt)');
      return;
    }
    final confirmed =
        await _confirmDialog(context, 'Streak Freeze kaufen?', '100 XP');
    if (confirmed != true || !context.mounted) return;
    try {
      final resp = await ref
          .read(firestoreServiceProvider)
          .purchaseStreakFreezeWithXP(userId: userId, xpCost: 100);
      if (resp['success'] == true && context.mounted) {
        PurchaseSuccessAnimation.show(context,
            itemName: 'Streak Freeze', icon: Icons.ac_unit);
      } else if (context.mounted) {
        _showError(context, resp['message']?.toString() ?? 'Fehler');
      }
    } catch (e) {
      if (context.mounted) _showError(context, e.toString());
    }
  }

  Future<bool?> _confirmDialog(
      BuildContext context, String title, String cost) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: SlamTokens.surface,
        title: Text(title,
            style: GoogleFonts.fraunces(
                color: SlamTokens.text, fontWeight: FontWeight.w700)),
        content:
            Text(cost, style: GoogleFonts.dmSans(color: SlamTokens.textDim)),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text('Abbrechen')),
          FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Kaufen')),
        ],
      ),
    );
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
          content: Text(msg),
          backgroundColor: SlamTokens.danger,
          duration: const Duration(seconds: 4)),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Shop Header with pulsing coin badge
// ─────────────────────────────────────────────────────────────────────────────

class _ShopHeader extends StatelessWidget {
  const _ShopHeader({required this.coins});
  final int coins;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            SlamTokens.gutter, 24, SlamTokens.gutter, 8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('SHOP',
                      style: GoogleFonts.dmSans(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: SlamTokens.textDim)),
                  const SizedBox(height: 6),
                  Text('Belohnungen',
                      style: GoogleFonts.fraunces(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: SlamTokens.text,
                          letterSpacing: -0.8)),
                ],
              ),
            ),
            _PulsingCoinBadge(coins: coins),
          ],
        ),
      ),
    );
  }
}

class _PulsingCoinBadge extends StatefulWidget {
  const _PulsingCoinBadge({required this.coins});
  final int coins;

  @override
  State<_PulsingCoinBadge> createState() => _PulsingCoinBadgeState();
}

class _PulsingCoinBadgeState extends State<_PulsingCoinBadge>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _glow;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1800))
      ..repeat(reverse: true);
    _glow = Tween(begin: 8.0, end: 22.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _glow,
      builder: (_, __) => TweenAnimationBuilder<int>(
        tween: IntTween(begin: 0, end: widget.coins),
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeOutCubic,
        builder: (_, value, __) => Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
          decoration: BoxDecoration(
            color: SlamTokens.warn,
            borderRadius: BorderRadius.circular(SlamTokens.rCircle),
            boxShadow: [
              BoxShadow(
                color: SlamTokens.warn.withValues(alpha: 0.55),
                blurRadius: _glow.value,
                offset: const Offset(0, 4),
                spreadRadius: -2,
              )
            ],
          ),
          child: Row(children: [
            Icon(Icons.monetization_on, size: 16, color: SlamTokens.primaryOn),
            const SizedBox(width: 6),
            Text('$value',
                style: GoogleFonts.fraunces(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: SlamTokens.primaryOn)),
          ]),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated section label
// ─────────────────────────────────────────────────────────────────────────────

class _AnimatedSectionLabel extends StatefulWidget {
  const _AnimatedSectionLabel(this.text, {required this.delay});
  final String text;
  final int delay;

  @override
  State<_AnimatedSectionLabel> createState() => _AnimatedSectionLabelState();
}

class _AnimatedSectionLabelState extends State<_AnimatedSectionLabel>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slide = Tween(begin: const Offset(-0.06, 0), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    Future.delayed(Duration(milliseconds: widget.delay), () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              SlamTokens.gutter, 6, SlamTokens.gutter, 10),
          child: Text(widget.text,
              style: GoogleFonts.dmSans(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1.2,
                  color: SlamTokens.textDim)),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated theme card — stagger + 3D tilt + shimmer gradient + press physics
// ─────────────────────────────────────────────────────────────────────────────

class _AnimatedThemeCard extends StatefulWidget {
  const _AnimatedThemeCard({
    required this.index,
    required this.preset,
    required this.isUnlocked,
    required this.price,
    required this.canAfford,
    required this.onPurchase,
    required this.onSelect,
  });
  final int index;
  final AppThemePreset preset;
  final bool isUnlocked;
  final int price;
  final bool canAfford;
  final VoidCallback onPurchase;
  final VoidCallback onSelect;

  @override
  State<_AnimatedThemeCard> createState() => _AnimatedThemeCardState();
}

class _AnimatedThemeCardState extends State<_AnimatedThemeCard>
    with TickerProviderStateMixin {
  late AnimationController _entranceCtrl;
  late Animation<double> _entranceFade;
  late Animation<double> _entranceScale;
  late Animation<Offset> _entranceSlide;

  double _pressScale = 1.0;

  late AnimationController _shimmerCtrl;

  late AnimationController _ownedCtrl;
  late Animation<double> _ownedGlow;

  Color get _baseColor {
    switch (widget.preset) {
      case AppThemePreset.sunsetOrange:
        return SlamTokens.primary;
      case AppThemePreset.oceanBlue:
        return SlamTokens.accentBlue;
      case AppThemePreset.forestGreen:
        return SlamTokens.accentGreen;
      case AppThemePreset.lavenderPurple:
        return const Color(0xFFA855F7);
      case AppThemePreset.cherryRed:
        return SlamTokens.accentRed;
    }
  }

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 650));
    _entranceFade =
        CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _entranceScale = Tween(begin: 0.78, end: 1.0).animate(
        CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutBack));
    _entranceSlide = Tween(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(
            CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic));

    _shimmerCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2200))
      ..repeat();

    _ownedCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat(reverse: true);
    _ownedGlow = Tween(begin: 0.0, end: 8.0)
        .animate(CurvedAnimation(parent: _ownedCtrl, curve: Curves.easeInOut));

    Future.delayed(Duration(milliseconds: 80 + widget.index * 110), () {
      if (mounted) _entranceCtrl.forward();
    });
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _shimmerCtrl.dispose();
    _ownedCtrl.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => setState(() => _pressScale = 0.93);
  void _onTapUp(TapUpDetails _) {
    setState(() => _pressScale = 1.0);
    if (widget.isUnlocked) {
      widget.onSelect();
    } else if (widget.canAfford) {
      widget.onPurchase();
    }
  }

  void _onTapCancel() => setState(() => _pressScale = 1.0);

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _entranceFade,
      child: ScaleTransition(
        scale: _entranceScale,
        child: SlideTransition(
          position: _entranceSlide,
          child: GestureDetector(
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: AnimatedScale(
              scale: _pressScale,
              duration: const Duration(milliseconds: 130),
              curve: Curves.easeOutBack,
              child: _buildCard(),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCard() {
    return AnimatedBuilder(
      animation: _ownedGlow,
      builder: (_, child) => Container(
        decoration: BoxDecoration(
          color: SlamTokens.surface,
          borderRadius: BorderRadius.circular(SlamTokens.rCardSm),
          border: Border.all(
            color: widget.isUnlocked
                ? _baseColor.withValues(alpha: 0.5 + _ownedGlow.value / 16)
                : SlamTokens.line,
            width: widget.isUnlocked ? 1.5 : 1,
          ),
          boxShadow: widget.isUnlocked
              ? [
                  BoxShadow(
                    color: _baseColor.withValues(
                        alpha: 0.22 + _ownedGlow.value / 60),
                    blurRadius: 12 + _ownedGlow.value,
                    spreadRadius: -2,
                  )
                ]
              : null,
        ),
        padding: const EdgeInsets.all(12),
        child: child,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Gradient preview with shimmer
          Expanded(child: _buildGradientPreview()),
          const SizedBox(height: 8),
          Text(ThemePricing.getName(widget.preset),
              style: GoogleFonts.fraunces(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: SlamTokens.text,
                  letterSpacing: -0.2)),
          const SizedBox(height: 6),
          Row(children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
              decoration: BoxDecoration(
                color: SlamTokens.warnSoft,
                borderRadius: BorderRadius.circular(SlamTokens.rCircle),
              ),
              child: Row(children: [
                const Icon(Icons.monetization_on,
                    size: 10, color: SlamTokens.warn),
                const SizedBox(width: 2),
                Text('${widget.price}',
                    style: GoogleFonts.dmSans(
                        fontSize: 10,
                        fontWeight: FontWeight.w800,
                        color: SlamTokens.warn)),
              ]),
            ),
            const Spacer(),
            Text(
              widget.isUnlocked ? 'BESITZT' : 'KAUFEN',
              style: GoogleFonts.dmSans(
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.6,
                color:
                    widget.isUnlocked ? SlamTokens.success : SlamTokens.textDim,
              ),
            ),
          ]),
        ],
      ),
    );
  }

  Widget _buildGradientPreview() {
    return AnimatedBuilder(
      animation: _shimmerCtrl,
      builder: (_, __) {
        final sweep = _shimmerCtrl.value;
        final gradEnd = Alignment(
          math.cos(sweep * math.pi * 2) * 0.5,
          math.sin(sweep * math.pi * 2) * 0.5 + 0.5,
        );

        return ClipRRect(
          borderRadius: BorderRadius.circular(SlamTokens.rCardSm - 4),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Base gradient
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: gradEnd,
                    colors: [_baseColor, _baseColor.withValues(alpha: 0.55)],
                  ),
                ),
              ),
              // Shimmer sweep
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment(sweep * 4 - 2.2, -1),
                    end: Alignment(sweep * 4 - 1.4, 1),
                    colors: [
                      Colors.white.withValues(alpha: 0.0),
                      Colors.white.withValues(alpha: 0.20),
                      Colors.white.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
              // Owned check badge
              if (widget.isUnlocked)
                Positioned(
                  top: 8,
                  right: 8,
                  child: TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0.0, end: 1.0),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOutBack,
                    builder: (_, v, __) => Transform.scale(
                      scale: v,
                      child: Container(
                        width: 22,
                        height: 22,
                        decoration: BoxDecoration(
                          color: SlamTokens.overlayBlack33,
                          shape: BoxShape.circle,
                        ),
                        alignment: Alignment.center,
                        child: const Icon(Icons.check,
                            size: 13, color: Colors.white),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated power-up row — entrance from right + buy button bounce
// ─────────────────────────────────────────────────────────────────────────────

class _AnimatedPowerUpRow extends StatefulWidget {
  const _AnimatedPowerUpRow({
    required this.index,
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.cost,
    this.costLabel,
    required this.onBuy,
  });
  final int index;
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;
  final int cost;
  final String? costLabel;
  final VoidCallback onBuy;

  @override
  State<_AnimatedPowerUpRow> createState() => _AnimatedPowerUpRowState();
}

class _AnimatedPowerUpRowState extends State<_AnimatedPowerUpRow>
    with TickerProviderStateMixin {
  late AnimationController _entranceCtrl;
  late Animation<double> _fade;
  late Animation<Offset> _slide;

  late AnimationController _btnCtrl;
  late Animation<double> _btnScale;

  @override
  void initState() {
    super.initState();
    _entranceCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    _fade = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _slide = Tween(begin: const Offset(0.12, 0), end: Offset.zero).animate(
        CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: 400 + widget.index * 120), () {
      if (mounted) _entranceCtrl.forward();
    });

    _btnCtrl = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 160),
        lowerBound: 0.88,
        upperBound: 1.0,
        value: 1.0);
    _btnScale = _btnCtrl;
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _btnCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: SlideTransition(
        position: _slide,
        child: Container(
          decoration: BoxDecoration(
            color: SlamTokens.surface,
            borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
            border: Border.all(color: SlamTokens.line),
          ),
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            // Animated icon container
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.0, end: 1.0),
              duration: Duration(milliseconds: 600 + widget.index * 100),
              curve: Curves.easeOutBack,
              builder: (_, v, child) => Transform.scale(scale: v, child: child),
              child: Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: widget.iconColor.withValues(alpha: 0.14),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Icon(widget.icon, size: 20, color: widget.iconColor),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.title,
                    style: GoogleFonts.fraunces(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: SlamTokens.text,
                        letterSpacing: -0.2)),
                Text(widget.subtitle,
                    style: GoogleFonts.dmSans(
                        fontSize: 12, color: SlamTokens.textDim)),
              ],
            )),
            // Buy button with scale feedback
            GestureDetector(
              onTapDown: (_) => _btnCtrl.reverse(),
              onTapUp: (_) {
                _btnCtrl.forward();
                widget.onBuy();
              },
              onTapCancel: () => _btnCtrl.forward(),
              child: AnimatedBuilder(
                animation: _btnScale,
                builder: (_, child) =>
                    Transform.scale(scale: _btnScale.value, child: child),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: SlamTokens.warnSoft,
                    borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                  ),
                  child: Row(children: [
                    if (widget.cost > 0) ...[
                      const Icon(Icons.monetization_on,
                          size: 13, color: SlamTokens.warn),
                      const SizedBox(width: 4),
                      Text('${widget.cost}',
                          style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: SlamTokens.warn)),
                    ] else
                      Text(widget.costLabel ?? '',
                          style: GoogleFonts.dmSans(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: SlamTokens.warn)),
                  ]),
                ),
              ),
            ),
          ]),
        ),
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
            ?.map((e) => e.toString())
            .toList() ??
        ['sunsetOrange'];
    return ThemeUnlocks(unlockedThemes: unlockedThemes);
  });
});
