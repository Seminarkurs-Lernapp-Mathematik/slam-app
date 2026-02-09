import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Coin Animation Widget
///
/// Displays an animated coin gain notification with flying coins and particles.
/// Creates a dopamine-inducing reward feedback.
class CoinAnimation extends StatefulWidget {
  final int coinAmount;
  final VoidCallback? onComplete;

  const CoinAnimation({
    super.key,
    required this.coinAmount,
    this.onComplete,
  });

  /// Show Coin Animation as Overlay
  static void show(
    BuildContext context, {
    required int coinAmount,
    VoidCallback? onComplete,
  }) {
    // Haptic feedback for reward
    HapticFeedback.mediumImpact();

    final overlay = Overlay.of(context);
    late OverlayEntry overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => CoinAnimation(
        coinAmount: coinAmount,
        onComplete: () {
          overlayEntry.remove();
          onComplete?.call();
        },
      ),
    );

    overlay.insert(overlayEntry);
  }

  @override
  State<CoinAnimation> createState() => _CoinAnimationState();
}

class _CoinAnimationState extends State<CoinAnimation>
    with TickerProviderStateMixin {
  late AnimationController _mainController;
  late AnimationController _coinsController;
  late AnimationController _shineController;

  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;

  final List<_FlyingCoin> _flyingCoins = [];

  @override
  void initState() {
    super.initState();

    // Main animation controller
    _mainController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 30,
      ),
      TweenSequenceItem(
        tween: Tween(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 20,
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
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 20),
      TweenSequenceItem(tween: ConstantTween(1.0), weight: 60),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 20),
    ]).animate(_mainController);

    // Flying coins controller
    _coinsController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Shine animation
    _shineController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    )..repeat();

    // Generate flying coins
    _generateFlyingCoins();

    // Start animations
    _mainController.forward().then((_) {
      widget.onComplete?.call();
    });
    _coinsController.forward();
  }

  void _generateFlyingCoins() {
    final random = math.Random();
    final coinCount = math.min(widget.coinAmount, 15);

    for (int i = 0; i < coinCount; i++) {
      _flyingCoins.add(_FlyingCoin(
        startDelay: random.nextDouble() * 0.3,
        angle: -math.pi / 2 + (random.nextDouble() - 0.5) * math.pi * 0.8,
        speed: 150 + random.nextDouble() * 100,
        rotationSpeed: (random.nextDouble() - 0.5) * 8,
        size: 24 + random.nextDouble() * 12,
      ));
    }
  }

  @override
  void dispose() {
    _mainController.dispose();
    _coinsController.dispose();
    _shineController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Material(
      color: Colors.transparent,
      child: Stack(
        children: [
          // Flying coins layer
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _coinsController,
              builder: (context, child) {
                return CustomPaint(
                  painter: _FlyingCoinsPainter(
                    coins: _flyingCoins,
                    progress: _coinsController.value,
                    center: Offset(size.width / 2, size.height / 2.5),
                  ),
                );
              },
            ),
          ),

          // Main coin display
          Positioned(
            top: size.height / 3,
            left: 0,
            right: 0,
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
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.amber.withValues(alpha: 0.6),
                        blurRadius: 30,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Animated coin icon with shine
                      AnimatedBuilder(
                        animation: _shineController,
                        builder: (context, child) {
                          return ShaderMask(
                            shaderCallback: (bounds) {
                              return LinearGradient(
                                colors: const [
                                  Colors.white54,
                                  Colors.white,
                                  Colors.white54,
                                ],
                                stops: [
                                  (_shineController.value - 0.3).clamp(0.0, 1.0),
                                  _shineController.value,
                                  (_shineController.value + 0.3).clamp(0.0, 1.0),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(bounds);
                            },
                            child: const Icon(
                              Icons.monetization_on,
                              color: Colors.white,
                              size: 36,
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '+${widget.coinAmount}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow(
                              color: Colors.black26,
                              offset: Offset(0, 2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                      ),
                    ],
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

/// Flying Coin Data
class _FlyingCoin {
  final double startDelay;
  final double angle;
  final double speed;
  final double rotationSpeed;
  final double size;

  _FlyingCoin({
    required this.startDelay,
    required this.angle,
    required this.speed,
    required this.rotationSpeed,
    required this.size,
  });
}

/// Flying Coins Painter
class _FlyingCoinsPainter extends CustomPainter {
  final List<_FlyingCoin> coins;
  final double progress;
  final Offset center;

  _FlyingCoinsPainter({
    required this.coins,
    required this.progress,
    required this.center,
  });

  @override
  void paint(Canvas canvas, Size size) {
    for (final coin in coins) {
      // Apply start delay
      final adjustedProgress =
          ((progress - coin.startDelay) / (1 - coin.startDelay)).clamp(0.0, 1.0);
      if (adjustedProgress <= 0) continue;

      // Calculate position with gravity effect
      final t = adjustedProgress;
      final gravity = 200 * t * t; // Gravity acceleration
      final distance = coin.speed * t;

      final x = center.dx + distance * math.cos(coin.angle);
      final y = center.dy + distance * math.sin(coin.angle) + gravity;

      // Fade out
      final opacity = (1.0 - adjustedProgress).clamp(0.0, 1.0);

      // Draw coin
      final paint = Paint()
        ..color = Colors.amber.withValues(alpha: opacity)
        ..style = PaintingStyle.fill;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(coin.rotationSpeed * adjustedProgress);

      // Simple coin shape
      canvas.drawCircle(Offset.zero, coin.size / 2, paint);

      // Highlight
      final highlightPaint = Paint()
        ..color = Colors.white.withValues(alpha: opacity * 0.5)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(
        Offset(-coin.size / 6, -coin.size / 6),
        coin.size / 5,
        highlightPaint,
      );

      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_FlyingCoinsPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}
