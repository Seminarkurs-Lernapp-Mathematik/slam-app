import 'dart:math' as math;
import 'package:flutter/material.dart';

import '../../../../core/models/user_stats.dart';

/// Level Progress Circle Widget
///
/// Displays a circular progress indicator showing progress to next level
class LevelProgressCircle extends StatefulWidget {
  final UserStats stats;
  final double size;

  const LevelProgressCircle({
    super.key,
    required this.stats,
    this.size = 200,
  });

  @override
  State<LevelProgressCircle> createState() => _LevelProgressCircleState();
}

class _LevelProgressCircleState extends State<LevelProgressCircle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _animation = Tween<double>(
      begin: 0.0,
      end: widget.stats.progressToNextLevel,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    _controller.forward();
  }

  @override
  void didUpdateWidget(LevelProgressCircle oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.stats.progressToNextLevel !=
        widget.stats.progressToNextLevel) {
      _animation = Tween<double>(
        begin: oldWidget.stats.progressToNextLevel,
        end: widget.stats.progressToNextLevel,
      ).animate(CurvedAnimation(
        parent: _controller,
        curve: Curves.easeOutCubic,
      ));
      _controller.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: AnimatedBuilder(
          animation: _animation,
          builder: (context, child) {
            return Stack(
              alignment: Alignment.center,
              children: [
                // Background Circle
                CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _CircleProgressPainter(
                    progress: _animation.value,
                    backgroundColor:
                        theme.colorScheme.surfaceContainerHighest,
                    progressColor: theme.colorScheme.primary,
                    secondaryColor: theme.colorScheme.secondary,
                    strokeWidth: 12,
                  ),
                ),

                // Level Info
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Level',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.stats.level.toString(),
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.stats.levelTitle,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary
                            .withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${(_animation.value * 100).toInt()}%',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

/// Custom Painter for Circular Progress
class _CircleProgressPainter extends CustomPainter {
  final double progress;
  final Color backgroundColor;
  final Color progressColor;
  final Color secondaryColor;
  final double strokeWidth;

  _CircleProgressPainter({
    required this.progress,
    required this.backgroundColor,
    required this.progressColor,
    required this.secondaryColor,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;

    // Background Circle
    final backgroundPaint = Paint()
      ..color = backgroundColor
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress Arc (Gradient)
    final rect = Rect.fromCircle(center: center, radius: radius);
    final gradient = SweepGradient(
      startAngle: -math.pi / 2,
      endAngle: -math.pi / 2 + 2 * math.pi * progress,
      colors: [
        progressColor,
        secondaryColor,
      ],
      stops: const [0.0, 1.0],
    );

    final progressPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    // Draw Progress Arc
    canvas.drawArc(
      rect,
      -math.pi / 2, // Start at top
      2 * math.pi * progress, // Sweep angle
      false,
      progressPaint,
    );

    // Glow effect at end of progress
    if (progress > 0) {
      final glowAngle = -math.pi / 2 + 2 * math.pi * progress;
      final glowX = center.dx + radius * math.cos(glowAngle);
      final glowY = center.dy + radius * math.sin(glowAngle);

      final glowPaint = Paint()
        ..color = progressColor.withValues(alpha: 0.5)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);

      canvas.drawCircle(
        Offset(glowX, glowY),
        strokeWidth / 2 + 2,
        glowPaint,
      );
    }
  }

  @override
  bool shouldRepaint(_CircleProgressPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.backgroundColor != backgroundColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}
