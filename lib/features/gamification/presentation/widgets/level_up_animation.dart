import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../core/constants/level_thresholds.dart';

/// Level Up Animation
///
/// Displays an epic level up celebration with particles, glow effects,
/// and the new level title. Maximum dopamine feedback!
class LevelUpAnimation extends StatefulWidget {
  final int newLevel;
  final VoidCallback? onComplete;

  const LevelUpAnimation({
    super.key,
    required this.newLevel,
    this.onComplete,
  });

  /// Show Level Up Animation as Overlay
  static void show(
    BuildContext context, {
    required int newLevel,
    VoidCallback? onComplete,
  }) {
    // Strong haptic for level up
    HapticFeedback.heavyImpact();

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => LevelUpAnimation(
        newLevel: newLevel,
        onComplete: () {
          overlayEntry.remove();
          onComplete?.call();
        },
      ),
    );

    overlay.insert(overlayEntry);
  }

  @override
  State<LevelUpAnimation> createState() => _LevelUpAnimationState();
}

class _LevelUpAnimationState extends State<LevelUpAnimation>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _pulseController;
  late AnimationController _particleController;
  late AnimationController _numberController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _glowAnimation;
  late Animation<double> _numberAnimation;

  final List<_LevelParticle> _particles = [];

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 3500),
      vsync: this,
    );

    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 10),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 75),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 15),
    ]).animate(_mainController);

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.5)
            .chain(CurveTween(curve: Curves.easeOutExpo)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.5, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 30,
      ),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 35),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.8), weight: 15),
    ]).animate(_mainController);

    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _particleController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _numberController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _numberAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _numberController, curve: Curves.elasticOut),
    );

    // Generate particles
    _generateParticles();

    // Start animations
    _mainController.forward().then((_) {
      widget.onComplete?.call();
    });
    _particleController.forward();

    // Delayed number reveal
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        _numberController.forward();
        HapticFeedback.mediumImpact();
      }
    });
  }

  void _generateParticles() {
    final random = math.Random();

    // Burst particles
    for (int i = 0; i < 40; i++) {
      _particles.add(_LevelParticle(
        type: _ParticleType.burst,
        angle: (i / 40) * 2 * math.pi,
        speed: 100 + random.nextDouble() * 150,
        size: 4 + random.nextDouble() * 8,
        color: HSLColor.fromAHSL(
          1.0,
          (i / 40) * 360,
          0.8,
          0.6,
        ).toColor(),
      ));
    }

    // Rising particles
    for (int i = 0; i < 20; i++) {
      _particles.add(_LevelParticle(
        type: _ParticleType.rising,
        angle: -math.pi / 2 + (random.nextDouble() - 0.5) * 0.5,
        speed: 50 + random.nextDouble() * 100,
        size: 3 + random.nextDouble() * 5,
        color: Colors.amber.withValues(alpha: 0.8),
        startX: random.nextDouble(),
      ));
    }

    // Sparkles
    for (int i = 0; i < 30; i++) {
      _particles.add(_LevelParticle(
        type: _ParticleType.sparkle,
        angle: random.nextDouble() * 2 * math.pi,
        speed: 0,
        size: 2 + random.nextDouble() * 4,
        color: Colors.white,
        startX: random.nextDouble(),
        startY: random.nextDouble(),
      ));
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _pulseController.dispose();
    _particleController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final levelTitle = LevelSystem.getLevelTitle(widget.newLevel);

    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: _mainController,
        builder: (context, child) {
          return Stack(
            children: [
              // Dark overlay
              Container(
                color: Colors.black.withValues(alpha: 0.6 * _fadeAnimation.value),
              ),

              // Particle layer
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _particleController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _LevelParticlePainter(
                        particles: _particles,
                        progress: _particleController.value,
                        center: Offset(size.width / 2, size.height / 2),
                        screenSize: size,
                      ),
                    );
                  },
                ),
              ),

              // Main content
              Center(
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // "LEVEL UP" text
                        ShaderMask(
                          shaderCallback: (bounds) {
                            return const LinearGradient(
                              colors: [
                                Color(0xFFFFD700),
                                Color(0xFFFFA500),
                                Color(0xFFFF6B00),
                              ],
                            ).createShader(bounds);
                          },
                          child: Text(
                            'LEVEL UP!',
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 4,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Level number with glow
                        AnimatedBuilder(
                          animation: Listenable.merge([_glowAnimation, _numberAnimation]),
                          builder: (context, child) {
                            return Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: RadialGradient(
                                  colors: [
                                    theme.colorScheme.primary,
                                    theme.colorScheme.primary.withValues(alpha: 0.5),
                                    Colors.transparent,
                                  ],
                                  stops: const [0.3, 0.6, 1.0],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: theme.colorScheme.primary
                                        .withValues(alpha: _glowAnimation.value * 0.8),
                                    blurRadius: 40 + _glowAnimation.value * 20,
                                    spreadRadius: 10 + _glowAnimation.value * 10,
                                  ),
                                ],
                              ),
                              child: Transform.scale(
                                scale: _numberAnimation.value,
                                child: Text(
                                  '${widget.newLevel}',
                                  style: theme.textTheme.displayLarge?.copyWith(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 72,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 24),

                        // Level title
                        AnimatedBuilder(
                          animation: _numberAnimation,
                          builder: (context, child) {
                            return Opacity(
                              opacity: _numberAnimation.value,
                              child: Transform.translate(
                                offset: Offset(0, 20 * (1 - _numberAnimation.value)),
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 24,
                                    vertical: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.colorScheme.surface.withValues(alpha: 0.9),
                                    borderRadius: BorderRadius.circular(30),
                                    border: Border.all(
                                      color: theme.colorScheme.primary.withValues(alpha: 0.5),
                                      width: 2,
                                    ),
                                  ),
                                  child: Text(
                                    levelTitle,
                                    style: theme.textTheme.headlineSmall?.copyWith(
                                      color: theme.colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

enum _ParticleType { burst, rising, sparkle }

class _LevelParticle {
  final _ParticleType type;
  final double angle;
  final double speed;
  final double size;
  final Color color;
  final double startX;
  final double startY;

  _LevelParticle({
    required this.type,
    required this.angle,
    required this.speed,
    required this.size,
    required this.color,
    this.startX = 0.5,
    this.startY = 0.5,
  });
}

class _LevelParticlePainter extends CustomPainter {
  final List<_LevelParticle> particles;
  final double progress;
  final Offset center;
  final Size screenSize;

  _LevelParticlePainter({
    required this.particles,
    required this.progress,
    required this.center,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      switch (p.type) {
        case _ParticleType.burst:
          _drawBurstParticle(canvas, p);
          break;
        case _ParticleType.rising:
          _drawRisingParticle(canvas, p);
          break;
        case _ParticleType.sparkle:
          _drawSparkle(canvas, p);
          break;
      }
    }
  }

  void _drawBurstParticle(Canvas canvas, _LevelParticle p) {
    final t = progress;
    final distance = p.speed * t * 3;
    final x = center.dx + distance * math.cos(p.angle);
    final y = center.dy + distance * math.sin(p.angle);

    final opacity = (1.0 - t).clamp(0.0, 1.0);
    final paint = Paint()
      ..color = p.color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(x, y), p.size * (1 - t * 0.5), paint);
  }

  void _drawRisingParticle(Canvas canvas, _LevelParticle p) {
    final t = progress;
    final x = p.startX * screenSize.width;
    final y = screenSize.height - (t * screenSize.height * 1.2);

    final opacity = (1.0 - t).clamp(0.0, 1.0) * 0.8;
    final paint = Paint()
      ..color = p.color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(Offset(x, y), p.size, paint);
  }

  void _drawSparkle(Canvas canvas, _LevelParticle p) {
    // Sparkles appear and disappear
    final phaseOffset = (p.startX + p.startY) * 2 * math.pi;
    final sparkleProgress = (math.sin(progress * math.pi * 4 + phaseOffset) + 1) / 2;

    if (sparkleProgress < 0.3) return;

    final x = p.startX * screenSize.width;
    final y = p.startY * screenSize.height;

    final opacity = sparkleProgress * 0.8;
    final paint = Paint()
      ..color = p.color.withValues(alpha: opacity)
      ..style = PaintingStyle.fill;

    // Draw star shape
    final starSize = p.size * sparkleProgress;
    canvas.drawCircle(Offset(x, y), starSize, paint);

    // Cross lines for sparkle effect
    final linePaint = Paint()
      ..color = p.color.withValues(alpha: opacity * 0.5)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    canvas.drawLine(
      Offset(x - starSize * 2, y),
      Offset(x + starSize * 2, y),
      linePaint,
    );
    canvas.drawLine(
      Offset(x, y - starSize * 2),
      Offset(x, y + starSize * 2),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(_LevelParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
