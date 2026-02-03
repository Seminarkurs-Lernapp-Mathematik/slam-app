import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Purchase Success Animation
///
/// Displays a celebratory animation when a purchase is completed.
/// Includes confetti, item icon, and success message.
class PurchaseSuccessAnimation extends StatefulWidget {
  final String itemName;
  final IconData icon;
  final VoidCallback? onComplete;

  const PurchaseSuccessAnimation({
    super.key,
    required this.itemName,
    required this.icon,
    this.onComplete,
  });

  /// Show Purchase Success Animation as Overlay
  static void show(
    BuildContext context, {
    required String itemName,
    required IconData icon,
    VoidCallback? onComplete,
  }) {
    // Success haptic
    HapticFeedback.heavyImpact();

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => PurchaseSuccessAnimation(
        itemName: itemName,
        icon: icon,
        onComplete: () {
          overlayEntry.remove();
          onComplete?.call();
        },
      ),
    );

    overlay.insert(overlayEntry);
  }

  @override
  State<PurchaseSuccessAnimation> createState() =>
      _PurchaseSuccessAnimationState();
}

class _PurchaseSuccessAnimationState extends State<PurchaseSuccessAnimation>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _confettiController;
  late AnimationController _checkController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _checkAnimation;

  final List<_Confetti> _confetti = [];

  @override
  void initState() {
    super.initState();

    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.3)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.3, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 25,
      ),
      TweenSequenceItem(
        tween: ConstantTween(1.0),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.0, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInCubic)),
        weight: 20,
      ),
    ]).animate(_mainController);

    _fadeAnimation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 15),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 65),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_mainController);

    _confettiController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _checkController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _checkAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _checkController,
        curve: Curves.easeOutBack,
      ),
    );

    // Generate confetti
    _generateConfetti();

    // Start animations
    _mainController.forward().then((_) {
      widget.onComplete?.call();
    });
    _confettiController.forward();

    // Delay check animation
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _checkController.forward();
      }
    });
  }

  void _generateConfetti() {
    final random = math.Random();
    final colors = [
      Colors.red,
      Colors.blue,
      Colors.green,
      Colors.yellow,
      Colors.purple,
      Colors.orange,
      Colors.pink,
      Colors.cyan,
    ];

    for (int i = 0; i < 50; i++) {
      _confetti.add(_Confetti(
        x: random.nextDouble(),
        speed: 200 + random.nextDouble() * 300,
        angle: -math.pi / 2 + (random.nextDouble() - 0.5) * math.pi,
        rotationSpeed: (random.nextDouble() - 0.5) * 10,
        size: 6 + random.nextDouble() * 8,
        color: colors[random.nextInt(colors.length)],
        shape: random.nextInt(3), // 0: circle, 1: rectangle, 2: star
      ));
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _confettiController.dispose();
    _checkController.dispose();
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
          // Semi-transparent background
          AnimatedBuilder(
            animation: _fadeAnimation,
            builder: (context, child) {
              return Container(
                color: Colors.black.withValues(alpha: 0.3 * _fadeAnimation.value),
              );
            },
          ),

          // Confetti layer
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _confettiController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _ConfettiPainter(
                    confetti: _confetti,
                    progress: _confettiController.value,
                    screenSize: size,
                  ),
                );
              },
            ),
          ),

          // Main content
          Center(
            child: AnimatedBuilder(
              animation: _mainController,
              builder: (context, child) {
                return Opacity(
                  opacity: _fadeAnimation.value,
                  child: Transform.scale(
                    scale: _scaleAnimation.value,
                    child: child,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.all(32),
                margin: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
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
                    // Icon with check overlay
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color:
                                theme.colorScheme.primary.withValues(alpha: 0.1),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            widget.icon,
                            size: 64,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        // Animated check mark
                        Positioned(
                          right: 0,
                          bottom: 0,
                          child: AnimatedBuilder(
                            animation: _checkAnimation,
                            builder: (context, child) {
                              return Transform.scale(
                                scale: _checkAnimation.value,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: const BoxDecoration(
                                    color: Colors.green,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Success text
                    Text(
                      'Erfolgreich!',
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Item name
                    Text(
                      widget.itemName,
                      style: theme.textTheme.titleMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'wurde freigeschaltet!',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Confetti Data
class _Confetti {
  final double x;
  final double speed;
  final double angle;
  final double rotationSpeed;
  final double size;
  final Color color;
  final int shape;

  _Confetti({
    required this.x,
    required this.speed,
    required this.angle,
    required this.rotationSpeed,
    required this.size,
    required this.color,
    required this.shape,
  });
}

/// Confetti Painter
class _ConfettiPainter extends CustomPainter {
  final List<_Confetti> confetti;
  final double progress;
  final Size screenSize;

  _ConfettiPainter({
    required this.confetti,
    required this.progress,
    required this.screenSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final c in confetti) {
      // Calculate position
      final startX = c.x * screenSize.width;
      final startY = screenSize.height / 3;

      final t = progress;
      final gravity = 400 * t * t;
      final distance = c.speed * t;

      final x = startX + distance * math.cos(c.angle);
      final y = startY + distance * math.sin(c.angle) + gravity;

      // Skip if off screen
      if (y > screenSize.height + 50) continue;

      final opacity = (1.0 - progress * 0.5).clamp(0.0, 1.0);
      final paint = Paint()
        ..color = c.color.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(c.rotationSpeed * progress);

      switch (c.shape) {
        case 0: // Circle
          canvas.drawCircle(Offset.zero, c.size / 2, paint);
          break;
        case 1: // Rectangle
          canvas.drawRect(
            Rect.fromCenter(center: Offset.zero, width: c.size, height: c.size / 2),
            paint,
          );
          break;
        case 2: // Star shape (simplified)
          final path = Path();
          for (int i = 0; i < 5; i++) {
            final angle = (i * 4 * math.pi / 5) - math.pi / 2;
            final point = Offset(
              c.size / 2 * math.cos(angle),
              c.size / 2 * math.sin(angle),
            );
            if (i == 0) {
              path.moveTo(point.dx, point.dy);
            } else {
              path.lineTo(point.dx, point.dy);
            }
          }
          path.close();
          canvas.drawPath(path, paint);
          break;
      }

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
