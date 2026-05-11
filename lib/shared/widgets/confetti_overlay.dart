import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../app/design_tokens.dart';

class ConfettiOverlay extends StatefulWidget {
  final Widget child;
  final bool show;
  final int xpEarned;

  const ConfettiOverlay({
    super.key,
    required this.child,
    required this.show,
    this.xpEarned = 0,
  });

  @override
  State<ConfettiOverlay> createState() => _ConfettiOverlayState();
}

class _ConfettiOverlayState extends State<ConfettiOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  final List<_Particle> _particles = [];

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
  }

  @override
  void didUpdateWidget(ConfettiOverlay old) {
    super.didUpdateWidget(old);
    if (widget.show && !old.show) {
      _generateParticles();
      _ctrl.forward(from: 0);
    }
  }

  void _generateParticles() {
    _particles.clear();
    final rng = math.Random();
    for (int i = 0; i < 40; i++) {
      _particles.add(_Particle(
        x: rng.nextDouble(),
        y: 0.4 + rng.nextDouble() * 0.1,
        vx: (rng.nextDouble() - 0.5) * 0.8,
        vy: -0.5 - rng.nextDouble() * 0.4,
        color: _randomColor(rng),
        size: 6 + rng.nextDouble() * 4,
        rotation: rng.nextDouble() * math.pi * 2,
      ));
    }
  }

  Color _randomColor(math.Random rng) {
    final colors = [
      SlamTokens.primary,
      SlamTokens.algebra,
      SlamTokens.analysis,
      SlamTokens.geometrie,
      SlamTokens.success,
      SlamTokens.warn,
    ];
    return colors[rng.nextInt(colors.length)];
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.show)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _ctrl,
                builder: (context, _) {
                  return CustomPaint(
                    painter: _ConfettiPainter(
                      particles: _particles,
                      progress: _ctrl.value,
                    ),
                  );
                },
              ),
            ),
          ),
        if (widget.show && widget.xpEarned > 0)
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: AnimatedBuilder(
                  animation: _ctrl,
                  builder: (context, _) {
                    final scale = Curves.elasticOut.transform(_ctrl.value);
                    final opacity = _ctrl.value < 0.7 ? 1.0 : (1.0 - (_ctrl.value - 0.7) / 0.3);
                    return Opacity(
                      opacity: opacity,
                      child: Transform.scale(
                        scale: scale,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: SlamTokens.success,
                            borderRadius: BorderRadius.circular(999),
                            boxShadow: [
                              BoxShadow(
                                color: SlamTokens.successSoft,
                                blurRadius: 20,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Text(
                            '+${widget.xpEarned} XP',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w800,
                              color: SlamTokens.bg,
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _Particle {
  final double x, y, vx, vy;
  final Color color;
  final double size;
  final double rotation;

  _Particle({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
    required this.color,
    required this.size,
    required this.rotation,
  });
}

class _ConfettiPainter extends CustomPainter {
  final List<_Particle> particles;
  final double progress;

  _ConfettiPainter({required this.particles, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in particles) {
      final t = progress;
      final px = (p.x + p.vx * t) * size.width;
      final py = (p.y + p.vy * t + 0.5 * t * t) * size.height;

      if (py > size.height) continue;

      final paint = Paint()..color = p.color.withValues(alpha: 1.0 - progress * 0.3);
      canvas.save();
      canvas.translate(px, py);
      canvas.rotate(p.rotation + progress * math.pi * 4);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromCenter(center: Offset.zero, width: p.size, height: p.size * 0.6),
          Radius.circular(p.size * 0.2),
        ),
        paint,
      );
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_ConfettiPainter old) => old.progress != progress;
}
