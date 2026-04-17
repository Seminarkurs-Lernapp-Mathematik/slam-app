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
  // null = hub, 0 = GeoGebra, 1 = KI-Labor, 2 = Content Library
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
          SliverToBoxAdapter(child: _buildHeroCard()),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WERKZEUGE',
              style: GoogleFonts.dmSans(
                fontSize: 11, fontWeight: FontWeight.w800,
                letterSpacing: 1.2, color: SlamTokens.textDim,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Spiel mit Mathe.',
              style: GoogleFonts.fraunces(
                fontSize: 34, fontWeight: FontWeight.w700,
                color: SlamTokens.text, letterSpacing: -0.8, height: 1.05,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroCard() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(SlamTokens.gutter, 0, SlamTokens.gutter, 14),
      child: GestureDetector(
        onTap: () => setState(() => _subScreen = 1),
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFFF9A4A), Color(0xFFFF6FA0)],
            ),
            borderRadius: BorderRadius.circular(SlamTokens.rCardLg),
          ),
          padding: const EdgeInsets.all(22),
          child: Stack(
            children: [
              // Background blob
              Positioned(
                right: -30, top: -20,
                child: Container(
                  width: 140, height: 140,
                  decoration: const BoxDecoration(
                    color: Color(0x33FFFFFF),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // NEU badge
                  Container(
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
                  const SizedBox(height: 12),
                  Text(
                    'Bau deine\nMini-App.',
                    style: GoogleFonts.fraunces(
                      fontSize: 26, fontWeight: FontWeight.w800,
                      color: SlamTokens.primaryOn, letterSpacing: -0.6, height: 1.1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Beschreibe was du brauchst — die KI generiert Rechner, Graphen, Simulatoren.',
                    style: GoogleFonts.dmSans(
                      fontSize: 13, color: SlamTokens.primaryOn.withValues(alpha: 0.8), height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
                    decoration: BoxDecoration(
                      color: SlamTokens.primaryOn,
                      borderRadius: BorderRadius.circular(SlamTokens.rCircle),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('KI-Labor öffnen', style: GoogleFonts.dmSans(
                            fontSize: 13, fontWeight: FontWeight.w800,
                            color: SlamTokens.primary)),
                        const SizedBox(width: 6),
                        Icon(Icons.arrow_forward, size: 14, color: SlamTokens.primary),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrid() {
    final apps = [
      _AppTile(
        title: 'GeoGebra',
        subtitle: 'Visualisiere Funktionen & Geometrie',
        icon: Icons.architecture,
        color: const Color(0xFFFFB35C), // algebra warm
        onTap: () => setState(() => _subScreen = 0),
      ),
      _AppTile(
        title: 'KI-Labor',
        subtitle: 'Generiere Mini-Apps per Prompt',
        icon: Icons.science,
        color: const Color(0xFFC88CFF), // geometrie purple
        onTap: () => setState(() => _subScreen = 1),
      ),
      _AppTile(
        title: 'Meine Inhalte',
        subtitle: 'Gespeicherte Apps & Visualisierungen',
        icon: Icons.folder_open,
        color: const Color(0xFFFFC94D), // warn yellow
        onTap: () => setState(() => _subScreen = 2),
      ),
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: SlamTokens.gutter),
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          childAspectRatio: 0.82,
        ),
        itemCount: apps.length,
        itemBuilder: (_, i) => _buildAppCard(apps[i]),
      ),
    );
  }

  Widget _buildAppCard(_AppTile app) {
    return GestureDetector(
      onTap: app.onTap,
      child: Container(
        decoration: BoxDecoration(
          color: SlamTokens.surface,
          borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
          border: Border.all(color: SlamTokens.line),
        ),
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 52, height: 52,
              decoration: BoxDecoration(
                color: app.color,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [BoxShadow(color: app.color.withValues(alpha: 0.5), blurRadius: 20, offset: const Offset(0, 8), spreadRadius: -6)],
              ),
              alignment: Alignment.center,
              child: Icon(app.icon, size: 24, color: SlamTokens.primaryOn),
            ),
            const SizedBox(height: 16),
            Text(
              app.title,
              style: GoogleFonts.fraunces(
                fontSize: 16, fontWeight: FontWeight.w700,
                color: SlamTokens.text, letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              app.subtitle,
              style: GoogleFonts.dmSans(
                fontSize: 12, color: SlamTokens.textDim, height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppTile {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  const _AppTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.onTap,
  });
}

// Sub-screen shell with back button
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
        title: Text(title, style: GoogleFonts.fraunces(
          fontSize: 18, fontWeight: FontWeight.w700, color: SlamTokens.text,
        )),
      ),
      body: child,
    );
  }
}
