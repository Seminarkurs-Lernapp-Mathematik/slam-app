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
          SliverToBoxAdapter(child: _AnimatedHeroCard(onTap: () => setState(() => _subScreen = 1))),
          SliverToBoxAdapter(child: _buildGrid()),
          const SliverToBoxAdapter(child: SizedBox(height: 32)),
        ],
      ),
    );
  }

  String _subScreenTitle(int index) {
    switch (index) {
      case 0: return 'GeoGebra';
      case 1: return 'KI-Labor';
      case 2: return 'Meine Inhalte';
      default: return '';
    }
  }

  Widget _subScreenWidget(int index) {
    switch (index) {
      case 0: return const GeogebraScreen();
      case 1: return const GenerativeAppsScreen();
      case 2: return const ContentLibraryScreen();
      default: return const SizedBox();
    }
  }

  Widget _buildHeader() {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(SlamTokens.gutter, 24, SlamTokens.gutter, 16),
        child: TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeOutCubic,
          builder: (_, v, child) => Opacity(
            opacity: v,
            child: Transform.translate(offset: Offset(0, (1 - v) * 16), child: child),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('WERKZEUGE', style: GoogleFonts.dmSans(
                  fontSize: 11, fontWeight: FontWeight.w800,
                  letterSpacing: 1.2, color: SlamTokens.textDim)),
              const SizedBox(height: 6),
              Text('Spiel mit Mathe.', style: GoogleFonts.fraunces(
                  fontSize: 34, fontWeight: FontWeight.w700,
                  color: SlamTokens.text, letterSpacing: -0.8, height: 1.05)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    final apps = [
      _AppTile(title: 'GeoGebra', subtitle: 'Visualisiere Funktionen & Geometrie',
          icon: Icons.architecture, color: const Color(0xFFFFB35C),
          onTap: () => setState(() => _subScreen = 0)),
      _AppTile(title: 'KI-Labor', subtitle: 'Generiere Mini-Apps per Prompt',
          icon: Icons.science, color: const Color(0xFFC88CFF),
          onTap: () => setState(() => _subScreen = 1)),
      _AppTile(title: 'Meine Inhalte', subtitle: 'Gespeicherte Apps & Visualisierungen',
          icon: Icons.folder_open, color: const Color(0xFFFFC94D),
          onTap: () => setState(() => _subScreen = 2)),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SlamTokens.gutter),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 190,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.88,
        ),
        itemCount: apps.length,
        itemBuilder: (_, i) => _AnimatedAppCard(index: i, app: apps[i]),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Animated hero card — shifting gradient + NEU badge pulse + entrance
// ─────────────────────────────────────────────────────────────────────────────

class _AnimatedHeroCard extends StatefulWidget {
  const _AnimatedHeroCard({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_AnimatedHeroCard> createState() => _AnimatedHeroCardState();
}

class _AnimatedHeroCardState extends State<_AnimatedHeroCard>
    with TickerProviderStateMixin {
  late AnimationController _gradCtrl;
  late AnimationController _badgeCtrl;
  late Animation<double> _badgeScale;

  // 3D tilt
  double _rotX = 0, _rotY = 0;
  double _fromX = 0, _fromY = 0;
  late AnimationController _springCtrl;
  late Animation<double> _springX;
  late Animation<double> _springY;
  double _pressScale = 1.0;

  @override
  void initState() {
    super.initState();
    _gradCtrl = AnimationController(vsync: this,
        duration: const Duration(seconds: 4))..repeat(reverse: true);

    _badgeCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 900))..repeat(reverse: true);
    _badgeScale = Tween(begin: 1.0, end: 1.08).animate(
        CurvedAnimation(parent: _badgeCtrl, curve: Curves.easeInOut));

    _springCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 500));
    _springX = const AlwaysStoppedAnimation(0);
    _springY = const AlwaysStoppedAnimation(0);
    _springCtrl.addListener(() {
      if (mounted) setState(() { _rotX = _springX.value; _rotY = _springY.value; });
    });
  }

  @override
  void dispose() {
    _gradCtrl.dispose();
    _badgeCtrl.dispose();
    _springCtrl.dispose();
    super.dispose();
  }

  void _onMouseMove(Offset pos, Size size) {
    _springCtrl.stop();
    setState(() {
      _rotY = (pos.dx / size.width - 0.5) * 2 * 0.12;
      _rotX = -(pos.dy / size.height - 0.5) * 2 * 0.09;
    });
  }

  void _springBack() {
    _fromX = _rotX; _fromY = _rotY;
    _springX = Tween(begin: _fromX, end: 0.0).animate(
        CurvedAnimation(parent: _springCtrl, curve: Curves.elasticOut));
    _springY = Tween(begin: _fromY, end: 0.0).animate(
        CurvedAnimation(parent: _springCtrl, curve: Curves.elasticOut));
    _springCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeOutCubic,
      builder: (_, v, child) => Opacity(
        opacity: v,
        child: Transform.translate(offset: Offset(0, (1 - v) * 24), child: child),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(SlamTokens.gutter, 0, SlamTokens.gutter, 14),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, 200);
            return MouseRegion(
              onHover: (e) => _onMouseMove(e.localPosition, size),
              onExit: (_) => _springBack(),
              child: GestureDetector(
                onTapDown: (_) => setState(() => _pressScale = 0.97),
                onTapUp: (_) { setState(() => _pressScale = 1.0); widget.onTap(); },
                onTapCancel: () => setState(() => _pressScale = 1.0),
                child: AnimatedScale(
                  scale: _pressScale,
                  duration: const Duration(milliseconds: 140),
                  curve: Curves.easeOutBack,
                  child: Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()
                      ..setEntry(3, 2, 0.0015)
                      ..rotateX(_rotX)
                      ..rotateY(_rotY),
                    child: _buildCardContent(),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return AnimatedBuilder(
      animation: _gradCtrl,
      builder: (_, __) {
        final t = _gradCtrl.value;
        final c1 = Color.lerp(const Color(0xFFFF9A4A), const Color(0xFFFF6020), t)!;
        final c2 = Color.lerp(const Color(0xFFFF6FA0), const Color(0xFFFF4080), t)!;

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
              // Animated blob
              Positioned(
                right: -30 + t * 12, top: -20 + t * 8,
                child: Container(
                  width: 140, height: 140,
                  decoration: const BoxDecoration(
                    color: Color(0x22FFFFFF), shape: BoxShape.circle,
                  ),
                ),
              ),
              // Second smaller blob
              Positioned(
                right: 40, bottom: -10,
                child: Opacity(
                  opacity: 0.15 + t * 0.1,
                  child: Container(
                    width: 80, height: 80,
                    decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NEU badge with pulse
                  AnimatedBuilder(
                    animation: _badgeScale,
                    builder: (_, child) => Transform.scale(
                      scale: _badgeScale.value, alignment: Alignment.centerLeft, child: child,
                    ),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      decoration: BoxDecoration(
                        color: const Color(0x38000000),
                        borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_awesome, size: 12, color: Colors.white),
                          const SizedBox(width: 6),
                          Text('NEU', style: GoogleFonts.dmSans(
                              fontSize: 10, fontWeight: FontWeight.w800,
                              color: Colors.white, letterSpacing: 0.8)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text('Bau deine\nMini-App.', style: GoogleFonts.fraunces(
                      fontSize: 26, fontWeight: FontWeight.w800,
                      color: SlamTokens.primaryOn, letterSpacing: -0.6, height: 1.1)),
                  const SizedBox(height: 8),
                  Text(
                    'Beschreibe was du brauchst — die KI generiert Rechner, Graphen, Simulatoren.',
                    style: GoogleFonts.dmSans(
                        fontSize: 13, color: SlamTokens.primaryOn.withValues(alpha: 0.8), height: 1.4),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: SlamTokens.primaryOn,
                      borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                    ),
                    child: Row(mainAxisSize: MainAxisSize.min, children: [
                      Text('KI-Labor öffnen', style: GoogleFonts.dmSans(
                          fontSize: 13, fontWeight: FontWeight.w800, color: SlamTokens.primary)),
                      const SizedBox(width: 6),
                      Icon(Icons.arrow_forward, size: 14, color: SlamTokens.primary),
                    ]),
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

// ─────────────────────────────────────────────────────────────────────────────
// Animated app card — staggered entrance + floating icon + 3D tilt + press
// ─────────────────────────────────────────────────────────────────────────────

class _AnimatedAppCard extends StatefulWidget {
  const _AnimatedAppCard({required this.index, required this.app});
  final int index;
  final _AppTile app;

  @override
  State<_AnimatedAppCard> createState() => _AnimatedAppCardState();
}

class _AnimatedAppCardState extends State<_AnimatedAppCard>
    with TickerProviderStateMixin {
  // Entrance
  late AnimationController _entranceCtrl;
  late Animation<double> _fade;
  late Animation<double> _scale;
  late Animation<Offset> _slide;

  // Icon float
  late AnimationController _floatCtrl;
  late Animation<double> _floatY;

  // 3D tilt
  double _rotX = 0, _rotY = 0;
  double _fromX = 0, _fromY = 0;
  late AnimationController _springCtrl;
  late Animation<double> _springX;
  late Animation<double> _springY;
  double _pressScale = 1.0;

  @override
  void initState() {
    super.initState();

    _entranceCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 650));
    _fade = CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOut);
    _scale = Tween(begin: 0.78, end: 1.0).animate(
        CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutBack));
    _slide = Tween(begin: const Offset(0, 0.2), end: Offset.zero).animate(
        CurvedAnimation(parent: _entranceCtrl, curve: Curves.easeOutCubic));
    Future.delayed(Duration(milliseconds: 200 + widget.index * 120), () {
      if (mounted) _entranceCtrl.forward();
    });

    _floatCtrl = AnimationController(vsync: this,
        duration: Duration(milliseconds: 2200 + widget.index * 300))
      ..repeat(reverse: true);
    _floatY = Tween(begin: 0.0, end: -5.0).animate(
        CurvedAnimation(parent: _floatCtrl, curve: Curves.easeInOut));

    _springCtrl = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 500));
    _springX = const AlwaysStoppedAnimation(0);
    _springY = const AlwaysStoppedAnimation(0);
    _springCtrl.addListener(() {
      if (mounted) setState(() { _rotX = _springX.value; _rotY = _springY.value; });
    });
  }

  @override
  void dispose() {
    _entranceCtrl.dispose();
    _floatCtrl.dispose();
    _springCtrl.dispose();
    super.dispose();
  }

  void _onMouseMove(Offset pos, Size size) {
    _springCtrl.stop();
    setState(() {
      _rotY = (pos.dx / size.width - 0.5) * 2 * 0.16;
      _rotX = -(pos.dy / size.height - 0.5) * 2 * 0.12;
    });
  }

  void _springBack() {
    _fromX = _rotX; _fromY = _rotY;
    _springX = Tween(begin: _fromX, end: 0.0).animate(
        CurvedAnimation(parent: _springCtrl, curve: Curves.elasticOut));
    _springY = Tween(begin: _fromY, end: 0.0).animate(
        CurvedAnimation(parent: _springCtrl, curve: Curves.elasticOut));
    _springCtrl.forward(from: 0);
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _fade,
      child: ScaleTransition(
        scale: _scale,
        child: SlideTransition(
          position: _slide,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final size = Size(constraints.maxWidth, constraints.maxHeight);
              return MouseRegion(
                onHover: (e) => _onMouseMove(e.localPosition, size),
                onExit: (_) => _springBack(),
                child: GestureDetector(
                  onTapDown: (_) => setState(() => _pressScale = 0.93),
                  onTapUp: (_) { setState(() => _pressScale = 1.0); widget.app.onTap(); },
                  onTapCancel: () => setState(() => _pressScale = 1.0),
                  child: AnimatedScale(
                    scale: _pressScale,
                    duration: const Duration(milliseconds: 140),
                    curve: Curves.easeOutBack,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..setEntry(3, 2, 0.002)
                        ..rotateX(_rotX)
                        ..rotateY(_rotY),
                      child: _buildCardContent(),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildCardContent() {
    return Container(
      decoration: BoxDecoration(
        color: SlamTokens.surface,
        borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
        border: Border.all(color: SlamTokens.line),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Floating icon with glow
          AnimatedBuilder(
            animation: _floatY,
            builder: (_, child) => Transform.translate(
              offset: Offset(0, _floatY.value), child: child,
            ),
            child: Container(
              width: 48, height: 48,
              decoration: BoxDecoration(
                color: widget.app.color,
                borderRadius: BorderRadius.circular(14),
                boxShadow: [BoxShadow(
                  color: widget.app.color.withValues(alpha: 0.55),
                  blurRadius: 18,
                  offset: const Offset(0, 6),
                  spreadRadius: -4,
                )],
              ),
              alignment: Alignment.center,
              child: Icon(widget.app.icon, size: 22, color: SlamTokens.primaryOn),
            ),
          ),
          const SizedBox(height: 14),
          Text(widget.app.title, style: GoogleFonts.fraunces(
              fontSize: 15, fontWeight: FontWeight.w700,
              color: SlamTokens.text, letterSpacing: -0.3)),
          const SizedBox(height: 4),
          Text(widget.app.subtitle, style: GoogleFonts.dmSans(
              fontSize: 11, color: SlamTokens.textDim, height: 1.4)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Data + helpers
// ─────────────────────────────────────────────────────────────────────────────

class _AppTile {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AppTile({
    required this.title, required this.subtitle,
    required this.icon, required this.color, required this.onTap,
  });
}

class _SubScreenShell extends StatelessWidget {
  const _SubScreenShell({
    required this.title, required this.onBack, required this.child,
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
        title: Text(title, style: GoogleFonts.fraunces(
            fontSize: 18, fontWeight: FontWeight.w700, color: SlamTokens.text)),
      ),
      body: child,
    );
  }
}
