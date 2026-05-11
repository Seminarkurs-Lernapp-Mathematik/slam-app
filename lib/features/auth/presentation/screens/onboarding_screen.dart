import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../app/design_tokens.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final _controller = PageController();
  int _page = 0;
  bool _consented = false;

  static const _pages = [
    _OnboardingPage(
      icon: Icons.bolt,
      title: 'Willkommen bei SLAM!',
      body:
          'Deine smarte Lern-App für Mathematik am Gymnasium. Fragen, Feedback und KI-Unterstützung – alles an einem Ort.',
    ),
    _OnboardingPage(
      icon: Icons.dynamic_feed,
      title: 'Adaptiver Fragen-Feed',
      body:
          'Der Feed passt sich deinem Niveau an. Beantworte Fragen und SLAM steigert den Schwierigkeitsgrad automatisch.',
    ),
    _OnboardingPage(
      icon: Icons.map,
      title: 'Dein Lernplan',
      body:
          'Wähle Themen aus, zu denen du Fragen erhalten möchtest. Du kannst deinen Lernplan jederzeit anpassen.',
    ),
    _OnboardingPage(
      icon: Icons.emoji_events,
      title: 'XP, Coins & Streaks',
      body:
          'Sammle Erfahrungspunkte, verdiene Coins und halte deinen Streak aufrecht. Schalte neue Themes im Shop frei.',
    ),
    _OnboardingPage(
      icon: Icons.science,
      title: 'KI-Labor & GeoGebra',
      body:
          'Erstelle interaktive Lern-Apps und mathematische Visualisierungen mit nur einem Klick – powered by KI.',
    ),
  ];

  // Total page count includes the DSGVO consent page at the end
  int get _totalPages => _pages.length + 1;
  bool get _isConsentPage => _page == _pages.length;
  bool get _isLast => _page == _totalPages - 1;

  Future<void> _finish() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    await prefs.setBool('dsgvo_consented', true);
    await prefs.setString(
        'dsgvo_consent_date', DateTime.now().toIso8601String());
    if (mounted) context.go('/diagnostic');
  }

  Future<void> _skip() async {
    // Skip still goes directly to the consent page, not past it
    _controller.animateToPage(
      _pages.length,
      duration: const Duration(milliseconds: 350),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cs = theme.colorScheme;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Skip button — hidden on consent page
            if (!_isConsentPage)
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.only(right: 16, top: 8),
                  child: TextButton(
                    onPressed: _skip,
                    child: const Text('Überspringen'),
                  ),
                ),
              )
            else
              const SizedBox(height: 48),

            // Pages
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _totalPages,
                onPageChanged: (i) => setState(() => _page = i),
                itemBuilder: (_, i) {
                  if (i == _pages.length) {
                    return _buildConsentPage(theme, cs);
                  }
                  return _buildPage(_pages[i], theme, cs);
                },
              ),
            ),

            // Dots + Next/Finish
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Dots
                  Row(
                    children: List.generate(_totalPages, (i) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: i == _page ? 20 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: i == _page
                              ? cs.primary
                              : cs.outlineVariant,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  // Action button
                  FilledButton.icon(
                    onPressed: _isLast
                        ? (_consented ? _finish : null)
                        : () => _controller.nextPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            ),
                    icon: Icon(
                        _isLast ? Icons.check : Icons.arrow_forward, size: 18),
                    label: Text(_isLast ? 'Los geht\'s!' : 'Weiter'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPage(_OnboardingPage page, ThemeData theme, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: cs.primary.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(page.icon, size: 56, color: cs.primary),
          ),
          const SizedBox(height: 40),
          Text(
            page.title,
            style: theme.textTheme.headlineSmall
                ?.copyWith(fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            page.body,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: cs.onSurfaceVariant,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildConsentPage(ThemeData theme, ColorScheme cs) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: SlamTokens.primarySoft,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(Icons.privacy_tip_outlined,
                size: 44, color: SlamTokens.primary),
          ),
          const SizedBox(height: 28),
          Text(
            'Datenschutz & Einwilligung',
            style: GoogleFonts.fraunces(
              fontSize: 22,
              fontWeight: FontWeight.w700,
              color: SlamTokens.text,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: SlamTokens.surface,
              borderRadius: BorderRadius.circular(SlamTokens.rCardMd),
              border: Border.all(color: SlamTokens.line),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _bulletPoint('Deine Antworten und Fortschritte werden in Firebase gespeichert, um die App personalisieren zu können.'),
                const SizedBox(height: 8),
                _bulletPoint('Deine Texteingaben können von KI-Diensten (Claude, Gemini) verarbeitet werden, um Fragen und Feedback zu generieren.'),
                const SizedBox(height: 8),
                _bulletPoint('E-Mail-Adresse und Name werden ausschließlich für die Authentifizierung verwendet und nicht an KI-Dienste weitergegeben.'),
                const SizedBox(height: 8),
                _bulletPoint('Du kannst deine Daten jederzeit in den Einstellungen löschen.'),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Consent checkbox
          GestureDetector(
            onTap: () => setState(() => _consented = !_consented),
            behavior: HitTestBehavior.opaque,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    color: _consented ? SlamTokens.primary : Colors.transparent,
                    border: Border.all(
                      color: _consented
                          ? SlamTokens.primary
                          : SlamTokens.textDim,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: _consented
                      ? const Icon(Icons.check,
                          size: 16, color: Colors.white)
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.dmSans(
                          fontSize: 13, color: SlamTokens.textDim),
                      children: [
                        const TextSpan(
                            text: 'Ich stimme der '),
                        TextSpan(
                          text: 'Datenschutzerklärung',
                          style: TextStyle(
                            color: SlamTokens.primary,
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () => launchUrl(
                                  Uri.parse(
                                      'https://learn-smart.app/datenschutz'),
                                  mode: LaunchMode.externalApplication,
                                ),
                        ),
                        const TextSpan(
                            text:
                                ' zu und bin einverstanden, dass meine Lerndaten wie beschrieben verarbeitet werden.'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _bulletPoint(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: SlamTokens.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.dmSans(
                fontSize: 13, color: SlamTokens.textDim, height: 1.4),
          ),
        ),
      ],
    );
  }
}

class _OnboardingPage {
  final IconData icon;
  final String title;
  final String body;

  const _OnboardingPage({
    required this.icon,
    required this.title,
    required this.body,
  });
}
