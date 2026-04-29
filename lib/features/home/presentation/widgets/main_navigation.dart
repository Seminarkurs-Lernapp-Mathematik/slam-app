import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../live_feed/presentation/screens/live_feed_screen.dart';
import '../../../learning_plan/presentation/screens/lernplan_screen.dart';
import '../../../apps/presentation/screens/apps_hub_screen.dart';
import '../../../gamification/presentation/screens/shop_screen.dart';
import '../../../home/presentation/screens/profil_screen.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/services/firestore_service.dart';
import '../../../../app/design_tokens.dart';
import '../providers/main_nav_notifier.dart';
import '../providers/nav_keys.dart';

// ─────────────────────────────────────────────────────────────────────────────
// MainNavigation
// ─────────────────────────────────────────────────────────────────────────────

/// Root shell: 4-tab indexed stack + profile swoosh-overlay.
/// Tabs: Feed(0) · Plan(1) · Apps(2) · Shop(3)
/// Profile is NOT a tab — it opens as a clip-path overlay (§6.7).
class MainNavigation extends ConsumerStatefulWidget {
  const MainNavigation({super.key});

  @override
  ConsumerState<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends ConsumerState<MainNavigation> {
  static const _screens = [
    LiveFeedScreen(),
    LernplanScreen(),
    AppsHubScreen(),
    ShopScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _updateStreakOnOpen());
  }

  Future<void> _updateStreakOnOpen() async {
    final userId = ref.read(authServiceProvider).currentUser?.uid;
    if (userId == null || userId.isEmpty) return;
    try {
      await ref.read(firestoreServiceProvider).updateStreak(userId);
    } catch (e) {
      debugPrint('streak update failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final navState = ref.watch(mainNavNotifierProvider);
    final notifier = ref.read(mainNavNotifierProvider.notifier);

    return Stack(
      children: [
        Scaffold(
          backgroundColor: SlamTokens.bg,
          body: IndexedStack(
            index: navState.tabIndex,
            children: _screens,
          ),
          bottomNavigationBar: _SlamBottomNav(
            selectedIndex: navState.tabIndex,
            onTabSelected: notifier.switchToTab,
          ),
        ),

        // Profile swoosh-overlay (§6.7)
        if (navState.showProfileOverlay)
          _ProfileSwooshOverlay(
            avatarKey: avatarGlobalKey,
            onClose: notifier.closeProfile,
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// SlamBottomNav — pill nav (§6.6)
// ─────────────────────────────────────────────────────────────────────────────

class _SlamBottomNav extends StatelessWidget {
  const _SlamBottomNav({
    required this.selectedIndex,
    required this.onTabSelected,
  });

  final int selectedIndex;
  final void Function(int) onTabSelected;

  static const _tabs = [
    _NavTab(icon: Icons.rss_feed_outlined, selectedIcon: Icons.rss_feed, label: 'Feed'),
    _NavTab(icon: Icons.calendar_today_outlined, selectedIcon: Icons.calendar_today, label: 'Plan'),
    _NavTab(icon: Icons.auto_awesome_outlined, selectedIcon: Icons.auto_awesome, label: 'Apps'),
    _NavTab(icon: Icons.store_outlined, selectedIcon: Icons.store, label: 'Shop'),
  ];

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;

    return Container(
      color: SlamTokens.bg,
      padding: EdgeInsets.fromLTRB(16, 8, 16, bottom + 12),
      child: Container(
        height: 56,
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: SlamTokens.bgElev,
          borderRadius: BorderRadius.circular(SlamTokens.rCircle),
          border: Border.all(color: SlamTokens.line),
        ),
        child: LayoutBuilder(
          builder: (context, constraints) {
            // Ratio: active=2.2, inactive=1.0 → total=2.2+3=5.2
            final w = constraints.maxWidth - 8; // minus container padding
            const activeRatio = 2.2;
            const inactiveRatio = 1.0;
            const totalRatio = activeRatio + (3 * inactiveRatio);
            final activeW = w * activeRatio / totalRatio;
            final inactiveW = w * inactiveRatio / totalRatio;

            return Row(
              children: List.generate(_tabs.length, (i) {
                final isActive = i == selectedIndex;
                return _NavItem(
                  tab: _tabs[i],
                  isActive: isActive,
                  width: isActive ? activeW : inactiveW,
                  onTap: () => onTabSelected(i),
                );
              }),
            );
          },
        ),
      ),
    );
  }
}

class _NavTab {
  const _NavTab({
    required this.icon,
    required this.selectedIcon,
    required this.label,
  });

  final IconData icon;
  final IconData selectedIcon;
  final String label;
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.tab,
    required this.isActive,
    required this.width,
    required this.onTap,
  });

  final _NavTab tab;
  final bool isActive;
  final double width;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        onTap();
      },
      child: AnimatedContainer(
        duration: SlamTokens.dState,
        curve: SlamTokens.curveStandard,
        width: width,
        height: double.infinity,
        decoration: BoxDecoration(
          color: isActive ? SlamTokens.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(SlamTokens.rCircle),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedScale(
              scale: isActive ? 1.0 : 0.95,
              duration: SlamTokens.dState,
              curve: SlamTokens.curveStandard,
              child: Icon(
                isActive ? tab.selectedIcon : tab.icon,
                size: 20,
                color: isActive ? SlamTokens.primaryOn : SlamTokens.textDim,
              ),
            ),
            AnimatedSize(
              duration: SlamTokens.dState,
              curve: SlamTokens.curveStandard,
              child: isActive
                  ? Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const SizedBox(width: 6),
                        Text(
                          tab.label,
                          style: GoogleFonts.dmSans(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: SlamTokens.primaryOn,
                            letterSpacing: 0.1,
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// ProfileSwooshOverlay (§6.7)
// ─────────────────────────────────────────────────────────────────────────────

class _ProfileSwooshOverlay extends StatefulWidget {
  const _ProfileSwooshOverlay({
    required this.avatarKey,
    required this.onClose,
  });

  final GlobalKey avatarKey;
  final VoidCallback onClose;

  @override
  State<_ProfileSwooshOverlay> createState() => _ProfileSwooshOverlayState();
}

class _ProfileSwooshOverlayState extends State<_ProfileSwooshOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _clipAnim;
  late Animation<double> _contentAnim;

  /// Measured at open-time from avatarKey.currentContext.
  Offset _origin = const Offset(44, 80);

  @override
  void initState() {
    super.initState();
    _measureAvatarOrigin();

    _ctrl = AnimationController(
      vsync: this,
      duration: SlamTokens.dSwoosh,
    );

    _clipAnim = CurvedAnimation(
      parent: _ctrl,
      curve: SlamTokens.curveStandard,
    );

    // Content fades in 80 ms after clip starts expanding (§5.3)
    _contentAnim = CurvedAnimation(
      parent: _ctrl,
      curve: const Interval(0.12, 1.0, curve: Curves.easeOut),
    );

    _ctrl.forward();
  }

  void _measureAvatarOrigin() {
    final ctx = widget.avatarKey.currentContext;
    if (ctx == null) return;
    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;
    final center = Offset(box.size.width / 2, box.size.height / 2);
    _origin = box.localToGlobal(center);
  }

  Future<void> _close() async {
    await _ctrl.reverse();
    widget.onClose();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _close,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, child) {
          return Stack(
            children: [
              // Backdrop: 55% black + blur (§6.7)
              FadeTransition(
                opacity: _clipAnim,
                child: Container(color: const Color(0x8C000000)),
              ),

              // Clipped content panel
              ClipPath(
                clipper: _CircleRevealClipper(
                  origin: _origin,
                  fraction: _clipAnim.value,
                ),
                child: GestureDetector(
                  onTap: () {}, // absorb taps inside the panel
                  child: Container(
                    color: SlamTokens.bg,
                    child: FadeTransition(
                      opacity: _contentAnim,
                      child: ScaleTransition(
                        scale: Tween(begin: 0.96, end: 1.0)
                            .animate(_contentAnim),
                        alignment: Alignment.topLeft,
                        child: child,
                      ),
                    ),
                  ),
                ),
              ),

              // Close button — top-left, inside safe area
              Positioned(
                top: MediaQuery.paddingOf(context).top + 12,
                left: 16,
                child: FadeTransition(
                  opacity: _contentAnim,
                  child: GestureDetector(
                    onTap: _close,
                    child: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: SlamTokens.surfaceHi,
                        shape: BoxShape.circle,
                        border: Border.all(color: SlamTokens.line),
                      ),
                      child: const Icon(
                        Icons.close,
                        size: 20,
                        color: SlamTokens.text,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        child: const SafeArea(child: ProfilScreen()),
      ),
    );
  }
}

/// Circular clip-path that expands from [origin] as [fraction] goes 0→1.
class _CircleRevealClipper extends CustomClipper<Path> {
  const _CircleRevealClipper({
    required this.origin,
    required this.fraction,
  });

  final Offset origin;
  final double fraction;

  @override
  Path getClip(Size size) {
    // Max radius = diagonal of the screen so the circle fully covers it
    final maxRadius = math.sqrt(
      size.width * size.width + size.height * size.height,
    );
    return Path()
      ..addOval(
        Rect.fromCircle(center: origin, radius: fraction * maxRadius),
      );
  }

  @override
  bool shouldReclip(_CircleRevealClipper old) =>
      old.fraction != fraction || old.origin != origin;
}


