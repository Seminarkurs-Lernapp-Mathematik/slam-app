import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../app/design_tokens.dart';
import 'geogebra_screen.dart';
import 'generative_apps_screen.dart';
import 'content_library_screen.dart';

class AppsHubScreen extends ConsumerStatefulWidget {
  const AppsHubScreen({super.key});

  @override
  ConsumerState<AppsHubScreen> createState() => _AppsHubScreenState();
}

class _AppsHubScreenState extends ConsumerState<AppsHubScreen> {
  int? _subScreen;

  @override
  Widget build(BuildContext context) {
    if (_subScreen != null) {
      return _SubScreenShell(
        title: _subScreenTitle(_subScreen!),
        onBack: () => setState(() => _subScreen = null),
        child: _subScreenWidget(_subScreen!),
      );
    }

    return Scaffold(
      backgroundColor: SlamTokens.bg,
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverToBoxAdapter(child: _buildHeader()),
          SliverToBoxAdapter(
              child: _AnimatedHeroCard(
            index: 0,
            onTap: () => setState(() => _subScreen = 1),
          )),
          SliverToBoxAdapter(
              child: _AnimatedHeroCard(
            index: 1,
            onTap: () => setState(() => _subScreen = 0),
          )),
          SliverToBoxAdapter(
              child: _AnimatedHeroCard(
            index: 2,
            onTap: () => setState(() => _subScreen = 2),
          )),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  String _subScreenTitle(int index) {
    switch (index) {
      case 0:
        return 'GeoGebra';
      case 1:
        return 'KI-Labor';
      case 2:
        return 'Meine Inhalte';
      default:
        return '';
    }
  }

  Widget _subScreenWidget(int index) {
    switch (index) {
      case 0:
        return const GeogebraScreen();
      case 1:
        return const GenerativeAppsScreen();
      case 2:
        return const ContentLibraryScreen();
      default:
        return const SizedBox();
    }
  }

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            SlamTokens.gutter, 24, SlamTokens.gutter, 16),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          builder: (_, v, child) => Opacity(
            opacity: v,
            child: Transform.translate(
                offset: Offset(0, (1 - v) * 16), child: child),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('WERKZEUGE',
                  style: GoogleFonts.dmSans(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1.2,
                      color: SlamTokens.textDim)),
              const SizedBox(height: 6),
              Text('Spiel mit Mathe.',
                  style: GoogleFonts.fraunces(
                      fontSize: 34,
                      fontWeight: FontWeight.w700,
                      color: SlamTokens.text,
                      letterSpacing: -0.8,
                      height: 1.05)),
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Hero card data
// ─────────────────────────────────────────────────────────────────────────────

class _HeroData {
  final String badge;
  final IconData badgeIcon;
  final String headline;
  final String body;
  final String cta;
  final Color colorA;
  final Color colorB;
  final Color colorC;
  final Color colorD;

  const _HeroData({
    required this.badge,
    required this.badgeIcon,
    required this.headline,
    required this.body,
    required this.cta,
    required this.colorA,
    required this.colorB,
    required this.colorC,
    required this.colorD,
  });
}

const _heroData = [
  _HeroData(
    badge: 'NEU',
    badgeIcon: Icons.auto_awesome,
    headline: 'Bau deine\nMini-App.',
    body:
        'Beschreibe was du brauchst — die KI generiert Rechner, Graphen, Simulatoren.',
    cta: 'KI-Labor öffnen',
    colorA: Color(0xFFFF9A4A),
    colorB: Color(0xFFFF6020),
    colorC: Color(0xFFFF6FA0),
    colorD: Color(0xFFFF4080),
  ),
  _HeroData(
    badge: 'VISUALISIEREN',
    badgeIcon: Icons.architecture,
    headline: 'Entdecke\nGeoGebra.',
    body:
        'Zeichne Funktionen, konstruiere Geometrie und verstehe Mathe visuell.',
    cta: 'GeoGebra öffnen',
    colorA: Color(0xFF3B82F6),
    colorB: Color(0xFF6366F1),
    colorC: Color(0xFF8B5CF6),
    colorD: Color(0xFF4F46E5),
  ),
  _HeroData(
    badge: 'BIBLIOTHEK',
    badgeIcon: Icons.folder_open,
    headline: 'Meine\nInhalte.',
    body:
        'Deine gespeicherten Mini-Apps, GeoGebra-Konstruktionen und Visualisierungen.',
    cta: 'Inhalte öffnen',
    colorA: Color(0xFFD97706),
    colorB: Color(0xFFF59E0B),
    colorC: Color(0xFFFBBF24),
    colorD: Color(0xFFEA580C),
  ),
];

// ─────────────────────────────────────────────────────────────────────────────
// Animated hero card — shifting gradient + badge pulse + entrance
// ─────────────────────────────────────────────────────────────────────────────

class _AnimatedHeroCard extends StatefulWidget {
  const _AnimatedHeroCard({required this.index, required this.onTap});
  final int index;
  final VoidCallback onTap;

  @override
  State<_AnimatedHeroCard> createState() => _AnimatedHeroCardState();
}

class _AnimatedHeroCardState extends State<_AnimatedHeroCard>
    with TickerProviderStateMixin {
  late AnimationController _gradCtrl;
  late AnimationController _badgeCtrl;
  late Animation<double> _badgeScale;
  double _pressScale = 1.0;

  @override
  void initState() {
    super.initState();
    _gradCtrl =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat(reverse: true);

    _badgeCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 900))
      ..repeat(reverse: true);
    _badgeScale = Tween(begin: 1.0, end: 1.08)
        .animate(CurvedAnimation(parent: _badgeCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _gradCtrl.dispose();
    _badgeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: Duration(milliseconds: 600 + widget.index * 120),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child:
            Transform.translate(offset: Offset(0, (1 - v) * 24), child: child),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(
            SlamTokens.gutter, 0, SlamTokens.gutter, 14),
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressScale = 0.97),
          onTapUp: (_) {
            setState(() => _pressScale = 1.0);
            widget.onTap();
          },
          onTapCancel: () => setState(() => _pressScale = 1.0),
          child: AnimatedScale(
            scale: _pressScale,
            duration: const Duration(milliseconds: 140),
            curve: Curves.easeOutBack,
            child: _buildCardContent(),
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    final data = _heroData[widget.index];
    return AnimatedBuilder(
      animation: _gradCtrl,
      builder: (_, __) {
        final t = _gradCtrl.value;
        final c1 = Color.lerp(data.colorA, data.colorB, t)!;
        final c2 = Color.lerp(data.colorC, data.colorD, t)!;

        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(-1 + t * 0.4, -1),
              end: Alignment(1, 1 - t * 0.4),
              colors: [c1, c2],
            ),
            borderRadius: BorderRadius.circular(SlamTokens.rCardLg),
          ),
          padding: const EdgeInsets.all(22),
          child: Stack(
            children: [
              Positioned(
                right: -30 + t * 12,
                top: -20 + t * 8,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    color: SlamTokens.overlayWhite13,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Positioned(
                right: 40,
                bottom: -10,
                child: Opacity(
                  opacity: 0.15 + t * 0.1,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AnimatedBuilder(
                    animation: _badgeScale,
                    builder: (_, child) => Transform.scale(
                      scale: _badgeScale.value,
                      alignment: Alignment.centerLeft,
                      child: child,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: SlamTokens.overlayBlack33,
                        borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(data.badgeIcon, size: 12, color: Colors.white),
                          const SizedBox(width: 6),
                          Text(
                            data.badge,
                            style: GoogleFonts.dmSans(
                                fontSize: 10,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                letterSpacing: 0.8),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    data.headline,
                    style: GoogleFonts.fraunces(
                        fontSize: 26,
                        fontWeight: FontWeight.w800,
                        color: SlamTokens.primaryOn,
                        letterSpacing: -0.6,
                        height: 1.1),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    data.body,
                    style: GoogleFonts.dmSans(
                        fontSize: 13,
                        color: SlamTokens.primaryOn.withValues(alpha: 0.8),
                        height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: SlamTokens.primaryOn,
                      borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          data.cta,
                          style: GoogleFonts.dmSans(
                              fontSize: 13,
                              fontWeight: FontWeight.w800,
                              color: c1),
                        ),
                        const SizedBox(width: 6),
                        Icon(Icons.arrow_forward, size: 14, color: c1),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SubScreenShell extends StatelessWidget {
  const _SubScreenShell({
    required this.title,
    required this.onBack,
    required this.child,
  });
  final String title;
  final VoidCallback onBack;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SlamTokens.bg,
      appBar: AppBar(
        backgroundColor: SlamTokens.bg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: SlamTokens.text),
          onPressed: onBack,
        ),
        title: Text(title,
            style: GoogleFonts.fraunces(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: SlamTokens.text)),
      ),
      body: child,
    );
  }
}
