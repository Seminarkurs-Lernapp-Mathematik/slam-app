import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:phosphor_flutter/phosphor_flutter.dart';

/// XP Animation Widget
///
/// Displays an animated XP gain notification with particles
class XPAnimation extends StatefulWidget {
  final int xpAmount;
  final VoidCallback? onComplete;

  const XPAnimation({
    super.key,
    required this.xpAmount,
    this.onComplete,
  });

  /// Show XP Animation as Overlay
  static void show(
    BuildContext context, {
    required int xpAmount,
    VoidCallback? onComplete,
  }) {
    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => XPAnimation(
        xpAmount: xpAmount,
        onComplete: () {
          overlayEntry.remove();
          onComplete?.call();
        },
      ),
    );

    overlay.insert(overlayEntry);
  }

  @override
  State<XPAnimation> createState() => _XPAnimationState();
}

class _XPAnimationState extends State<XPAnimation>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _particleController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();

    // Scale Animation
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _scaleController,
        curve: Curves.elasticOut,
      ),
    );

    // Fade Animation
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _fadeController,
        curve: Curves.easeInCubic,
      ),
    );

    // Slide Animation
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _slideController,
        curve: Curves.easeOutCubic,
      ),
    );

    // Particle Animation
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Generate Particles
    _generateParticles();

    // Start Animations
    _scaleController.forward();
    _slideController.forward();

    // Wait 1.5s then fade out
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        _fadeController.forward().then((_) {
          widget.onComplete?.call();
        });
      }
    });

    _particleController.forward();
  }

  void _generateParticles() {
    final random = math.Random();
    for (int i = 0; i < 20; i++) {
      _particles.add(_Particle(
        angle: random.nextDouble() * 2 * math.pi,
        speed: 50 + random.nextDouble() * 100,
        size: 4 + random.nextDouble() * 6,
        color: i % 3 == 0
            ? Colors.orange.shade400
            : i % 3 == 1
                ? Colors.yellow.shade400
                : Colors.orange.shade600,
      ));
    }
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Particles Layer
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _particleController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _ParticlePainter(
                    particles: _particles,
                    progress: _particleController.value,
                    center: Offset(size.width / 2, size.height / 2.5),
                  ),
                );
              },
            ),
          ),

          // XP Display
          Positioned(
            top: size.height / 3,
            left: 0,
            right: 0,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SlideTransition(
                position: _slideAnimation,
                child: ScaleTransition(
                  scale: _scaleAnimation,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 20,
                      ),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            theme.colorScheme.primary,
                            theme.colorScheme.secondary,
                          ],
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: [
                          BoxShadow(
                            color: theme.colorScheme.primary
                                .withValues(alpha: 0.5),
                            blurRadius: 20,
                            spreadRadius: 4,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            PhosphorIconsRegular.sparkle,
                            color: Colors.white,
                            size: 32,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '+${widget.xpAmount} XP',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Particle Data Class
class _Particle {
  final double angle;
  final double speed;
  final double size;
  final Color color;

  _Particle({
    required this.angle,
    required this.speed,
    required this.size,
    required this.color,
  });
}

/// Particle Painter
class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;
  final Offset center;

  _ParticlePainter({
    required this.particles,
    required this.progress,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final particle in particles) {
      final distance = particle.speed * progress;
      final x = center.dx + distance * math.cos(particle.angle);
      final y = center.dy + distance * math.sin(particle.angle);

      // Fade out as particles move away
      final opacity = 1.0 - progress;

      final paint = Paint()
        ..color = particle.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(
        Offset(x, y),
        particle.size * (1.0 - progress * 0.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_ParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
