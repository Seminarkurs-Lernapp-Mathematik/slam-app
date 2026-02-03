import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'level_up_animation.dart';

/// Combined Reward Animation
///
/// Shows XP earned, coins earned, and triggers level up if applicable.
/// The ultimate dopamine-inducing reward feedback!
class RewardAnimation extends StatefulWidget {
  final int xpEarned;
  final int coinsEarned;
  final int? newLevel; // If set, shows level up animation after
  final int? streakDay; // Current streak day for bonus indicator
  final VoidCallback? onComplete;

  const RewardAnimation({
    super.key,
    required this.xpEarned,
    required this.coinsEarned,
    this.newLevel,
    this.streakDay,
    this.onComplete,
  });

  /// Show Reward Animation as Overlay
  static void show(
    BuildContext context, {
    required int xpEarned,
    required int coinsEarned,
    int? newLevel,
    int? streakDay,
    VoidCallback? onComplete,
  }) {
    HapticFeedback.mediumImpact();

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => RewardAnimation(
        xpEarned: xpEarned,
        coinsEarned: coinsEarned,
        newLevel: newLevel,
        streakDay: streakDay,
        onComplete: () {
          overlayEntry.remove();
          onComplete?.call();
        },
      ),
    );

    overlay.insert(overlayEntry);
  }

  @override
  State<RewardAnimation> createState() => _RewardAnimationState();
}

class _RewardAnimationState extends State<RewardAnimation>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _xpController;
  late AnimationController _coinController;
  late AnimationController _streakController;
  late AnimationController _particleController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _xpScaleAnimation;
  late Animation<double> _coinScaleAnimation;
  late Animation<double> _streakScaleAnimation;

  final List<_RewardParticle> _particles = [];
  bool _showingLevelUp = false;

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 10),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 70),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_mainController);

    // XP animation
    _xpController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _xpScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _xpController, curve: Curves.elasticOut),
    );

    // Coin animation (delayed)
    _coinController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _coinScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _coinController, curve: Curves.elasticOut),
    );

    // Streak animation (delayed more)
    _streakController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _streakScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _streakController, curve: Curves.elasticOut),
    );

    // Particles
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _generateParticles();

    // Start animation sequence
    _startAnimations();
  }

  void _startAnimations() async {
    _mainController.forward();
    _particleController.forward();

    // Staggered reveals
    await Future.delayed(const Duration(milliseconds: 200));
    if (mounted) {
      _xpController.forward();
      HapticFeedback.lightImpact();
    }

    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted && widget.coinsEarned > 0) {
      _coinController.forward();
      HapticFeedback.lightImpact();
    }

    await Future.delayed(const Duration(milliseconds: 300));
    if (mounted && widget.streakDay != null && widget.streakDay! > 0) {
      _streakController.forward();
      HapticFeedback.lightImpact();
    }

    // Wait for main animation to nearly complete
    await Future.delayed(const Duration(milliseconds: 1500));

    // Check for level up
    if (mounted && widget.newLevel != null) {
      setState(() => _showingLevelUp = true);
      LevelUpAnimation.show(
        context,
        newLevel: widget.newLevel!,
        onComplete: widget.onComplete,
      );
    } else {
      // Wait for fade out then complete
      _mainController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          widget.onComplete?.call();
        }
      });
    }
  }

  void _generateParticles() {
    final random = math.Random();

    // XP particles (yellow/orange)
    for (int i = 0; i < 15; i++) {
      _particles.add(_RewardParticle(
        type: _RewardType.xp,
        angle: random.nextDouble() * 2 * math.pi,
        speed: 50 + random.nextDouble() * 80,
        size: 4 + random.nextDouble() * 6,
        delay: random.nextDouble() * 0.3,
      ));
    }

    // Coin particles (gold)
    for (int i = 0; i < 10; i++) {
      _particles.add(_RewardParticle(
        type: _RewardType.coin,
        angle: random.nextDouble() * 2 * math.pi,
        speed: 40 + random.nextDouble() * 60,
        size: 5 + random.nextDouble() * 7,
        delay: 0.3 + random.nextDouble() * 0.3,
      ));
    }

    // Star particles
    for (int i = 0; i < 20; i++) {
      _particles.add(_RewardParticle(
        type: _RewardType.star,
        angle: random.nextDouble() * 2 * math.pi,
        speed: 30 + random.nextDouble() * 50,
        size: 2 + random.nextDouble() * 4,
        delay: random.nextDouble() * 0.5,
      ));
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _xpController.dispose();
    _coinController.dispose();
    _streakController.dispose();
    _particleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_showingLevelUp) {
      return const SizedBox.shrink();
    }

    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: AnimatedBuilder(
        animation: _mainController,
        builder: (context, child) {
          return Stack(
            children: [
              // Particle layer
              Positioned.fill(
                child: AnimatedBuilder(
                  animation: _particleController,
                  builder: (context, child) {
                    return CustomPaint(
                      painter: _RewardParticlePainter(
                        particles: _particles,
                        progress: _particleController.value,
                        center: Offset(size.width / 2, size.height / 2.5),
                      ),
                    );
                  },
                ),
              ),

              // Main content
              Center(
                child: Opacity(
                  opacity: _fadeAnimation.value,
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 32),
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface.withValues(alpha: 0.95),
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: theme.colorScheme.primary.withValues(alpha: 0.3),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Success checkmark
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.green.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.check,
                            color: Colors.green,
                            size: 48,
                          ),
                        ),
                        const SizedBox(height: 16),

                        Text(
                          'Richtig!',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Reward rows
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // XP
                            AnimatedBuilder(
                              animation: _xpScaleAnimation,
                              builder: (context, child) {
                                return Transform.scale(
                                  scale: _xpScaleAnimation.value,
                                  child: _RewardBadge(
                                    icon: Icons.auto_awesome,
                                    value: '+${widget.xpEarned}',
                                    label: 'XP',
                                    color: theme.colorScheme.primary,
                                  ),
                                );
                              },
                            ),

                            if (widget.coinsEarned > 0) ...[
                              const SizedBox(width: 16),
                              AnimatedBuilder(
                                animation: _coinScaleAnimation,
                                builder: (context, child) {
                                  return Transform.scale(
                                    scale: _coinScaleAnimation.value,
                                    child: _RewardBadge(
                                      icon: Icons.monetization_on,
                                      value: '+${widget.coinsEarned}',
                                      label: 'Münzen',
                                      color: Colors.amber,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ],
                        ),

                        // Streak indicator
                        if (widget.streakDay != null && widget.streakDay! > 0) ...[
                          const SizedBox(height: 16),
                          AnimatedBuilder(
                            animation: _streakScaleAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _streakScaleAnimation.value,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: Colors.orange.withValues(alpha: 0.5),
                                    ),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.local_fire_department,
                                        color: Colors.orange,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        '${widget.streakDay} Tage Streak!',
                                        style: theme.textTheme.bodyMedium?.copyWith(
                                          color: Colors.orange,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ],
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

/// Reward Badge Widget
class _RewardBadge extends StatelessWidget {
  final IconData icon;
  final String value;
  final String label;
  final Color color;

  const _RewardBadge({
    required this.icon,
    required this.value,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: theme.textTheme.bodySmall?.copyWith(
              color: color.withValues(alpha: 0.8),
            ),
          ),
        ],
      ),
    );
  }
}

enum _RewardType { xp, coin, star }

class _RewardParticle {
  final _RewardType type;
  final double angle;
  final double speed;
  final double size;
  final double delay;

  _RewardParticle({
    required this.type,
    required this.angle,
    required this.speed,
    required this.size,
    required this.delay,
  });
}

class _RewardParticlePainter extends CustomPainter {
  final List<_RewardParticle> particles;
  final double progress;
  final Offset center;

  _RewardParticlePainter({
    required this.particles,
    required this.progress,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final adjustedProgress = ((progress - p.delay) / (1 - p.delay)).clamp(0.0, 1.0);
      if (adjustedProgress <= 0) continue;

      final t = adjustedProgress;
      final distance = p.speed * t;

      final x = center.dx + distance * math.cos(p.angle);
      final y = center.dy + distance * math.sin(p.angle);

      final opacity = (1.0 - t).clamp(0.0, 1.0);

      Color color;
      switch (p.type) {
        case _RewardType.xp:
          color = const Color(0xFFF97316);
          break;
        case _RewardType.coin:
          color = const Color(0xFFFFD700);
          break;
        case _RewardType.star:
          color = Colors.white;
          break;
      }

      final paint = Paint()
        ..color = color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.drawCircle(Offset(x, y), p.size * (1 - t * 0.5), paint);
    }
  }

  @override
  bool shouldRepaint(_RewardParticlePainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
