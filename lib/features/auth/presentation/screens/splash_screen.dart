import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../app/design_tokens.dart';
import '../../../../core/services/auth_service.dart';
import '../../../../core/utils/logger.dart';
import '../../../../shared/animations/app_animations.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoCtrl;
  late AnimationController _textCtrl;
  late Animation<double> _logoScale;
  late Animation<double> _logoFade;
  late Animation<double> _textFade;
  late Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _logoCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    );
    _textCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    _logoScale = Tween(begin: 0.72, end: 1.0).animate(
      CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOutBack),
    );
    _logoFade = CurvedAnimation(parent: _logoCtrl, curve: Curves.easeOut);

    _textFade = CurvedAnimation(parent: _textCtrl, curve: Curves.easeOut);
    _textSlide = Tween(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _textCtrl, curve: Curves.easeOutCubic),
    );

    // Staggered entrance: logo first, then tagline
    _logoCtrl.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _textCtrl.forward();
    });

    _checkAuthAndNavigate();
  }

  @override
  void dispose() {
    _logoCtrl.dispose();
    _textCtrl.dispose();
    super.dispose();
  }

  Future<void> _navigateHome() async {
    if (!mounted) return;
    final prefs = await SharedPreferences.getInstance();
    final onboardingDone = prefs.getBool('onboarding_done') ?? false;
    if (!onboardingDone) {
      if (mounted) context.go('/onboarding');
      return;
    }
    final diagnosticDone = prefs.getBool('diagnostic_done') ?? false;
    if (mounted) context.go(diagnosticDone ? '/home' : '/diagnostic');
  }

  Future<void> _checkAuthAndNavigate() async {
    // Minimum splash duration so the animation plays fully
    await Future.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    final authService = ref.read(authServiceProvider);
    try {
      final user = await authService.authStateChanges
          .timeout(const Duration(seconds: 10))
          .first;
      if (!mounted) return;
      if (user != null && user.emailVerified) {
        await _navigateHome();
      } else if (user != null) {
        context.go('/verify-email');
      } else {
        context.go('/login');
      }
    } on TimeoutException {
      if (!mounted) return;
      final user = authService.currentUser;
      if (user != null && user.emailVerified) {
        await _navigateHome();
      } else if (user != null) {
        context.go('/verify-email');
      } else {
        context.go('/login');
      }
    } catch (e, st) {
      Logger.error('Auth check failed, redirecting to login', tag: 'SplashScreen', error: e, stackTrace: st);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Anmeldung fehlgeschlagen. Bitte erneut versuchen.')),
        );
        context.go('/login');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SlamTokens.bg,
      body: Stack(
        children: [
          // Subtle radial glow behind the logo
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _logoCtrl,
              builder: (_, __) => Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.7,
                    colors: [
                      SlamTokens.primary
                          .withValues(alpha: _logoCtrl.value * 0.08),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
          ),

          Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Logo mark
                ScaleTransition(
                  scale: _logoScale,
                  child: FadeTransition(
                    opacity: _logoFade,
                    child: Column(
                      children: [
                        Container(
                          width: 88,
                          height: 88,
                          decoration: BoxDecoration(
                            gradient: SlamTokens.primaryGradient,
                            borderRadius: BorderRadius.circular(26),
                            boxShadow: [
                              BoxShadow(
                                color:
                                    SlamTokens.primary.withValues(alpha: 0.45),
                                blurRadius: 36,
                                offset: const Offset(0, 12),
                                spreadRadius: -4,
                              ),
                            ],
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'S',
                            style: GoogleFonts.fraunces(
                              fontSize: 52,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              height: 1,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                        Text(
                          'SLAM',
                          style: GoogleFonts.fraunces(
                            fontSize: 38,
                            fontWeight: FontWeight.w800,
                            color: SlamTokens.text,
                            letterSpacing: 4,
                            height: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                // Tagline — delayed fade + slide up
                SlideTransition(
                  position: _textSlide,
                  child: FadeTransition(
                    opacity: _textFade,
                    child: Text(
                      'Smarte Lern-App für Mathematik',
                      style: GoogleFonts.dmSans(
                        fontSize: 15,
                        color: SlamTokens.textDim,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Animated loading indicator at the bottom
          Positioned(
            bottom: 48,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _textFade,
              child: Center(
                child: LottieLoop(
                  asset: AppAnim.loadingDots,
                  width: 72,
                  height: 28,
                  speed: 0.85,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
