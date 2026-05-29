import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

// Asset paths
abstract final class AppAnim {
  static const success = 'assets/animations/success.json';
  static const loadingDots = 'assets/animations/loading_dots.json';
  static const confetti = 'assets/animations/confetti.json';
  static const fireStreak = 'assets/animations/fire_streak.json';
  static const levelUp = 'assets/animations/level_up.json';
  static const emptyState = 'assets/animations/empty_state.json';
}

// Curves used throughout the app
abstract final class AppCurves {
  // Material 3 emphasized — for entrances
  static const emphasized = Cubic(0.05, 0.7, 0.1, 1.0);
  // Material 3 standard — for on-screen motion
  static const standard = Cubic(0.2, 0.0, 0.0, 1.0);
  // Accelerate — for exits
  static const accelerate = Cubic(0.3, 0.0, 1.0, 1.0);
  // Playful spring overshoot for icons/celebrations
  static const spring = Cubic(0.175, 0.885, 0.32, 1.275);
  // Gentle ambient for loops
  static const ambient = Cubic(0.4, 0.0, 0.2, 1.0);
}

// Durations
abstract final class AppDurations {
  static const micro = Duration(milliseconds: 100);
  static const quick = Duration(milliseconds: 180);
  static const standard = Duration(milliseconds: 300);
  static const medium = Duration(milliseconds: 400);
  static const slow = Duration(milliseconds: 600);
  static const dramatic = Duration(milliseconds: 900);
}

/// One-shot Lottie that plays once and optionally calls [onComplete].
class LottieOnce extends StatefulWidget {
  const LottieOnce({
    super.key,
    required this.asset,
    this.size,
    this.width,
    this.height,
    this.onComplete,
    this.fit = BoxFit.contain,
    this.repeat = false,
  });

  final String asset;
  final double? size;
  final double? width;
  final double? height;
  final VoidCallback? onComplete;
  final BoxFit fit;
  final bool repeat;

  @override
  State<LottieOnce> createState() => _LottieOnceState();
}

class _LottieOnceState extends State<LottieOnce>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      widget.asset,
      controller: _ctrl,
      width: widget.size ?? widget.width,
      height: widget.size ?? widget.height,
      fit: widget.fit,
      repeat: widget.repeat,
      onLoaded: (comp) {
        _ctrl.duration = comp.duration;
        if (widget.repeat) {
          _ctrl.repeat();
        } else {
          _ctrl.forward().whenComplete(() => widget.onComplete?.call());
        }
      },
    );
  }
}

/// Looping Lottie (ambient / idle).
class LottieLoop extends StatefulWidget {
  const LottieLoop({
    super.key,
    required this.asset,
    this.size,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.speed = 1.0,
  });

  final String asset;
  final double? size;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double speed;

  @override
  State<LottieLoop> createState() => _LottieLoopState();
}

class _LottieLoopState extends State<LottieLoop>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Lottie.asset(
      widget.asset,
      controller: _ctrl,
      width: widget.size ?? widget.width,
      height: widget.size ?? widget.height,
      fit: widget.fit,
      onLoaded: (comp) {
        _ctrl.duration =
            Duration(milliseconds: (comp.duration.inMilliseconds / widget.speed).round());
        _ctrl.repeat();
      },
    );
  }
}

/// Fade + slide-up entrance for a single child.
class SlideInUp extends StatefulWidget {
  const SlideInUp({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 400),
    this.offset = 24.0,
    this.curve = AppCurves.emphasized,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final double offset;
  final Curve curve;

  @override
  State<SlideInUp> createState() => _SlideInUpState();
}

class _SlideInUpState extends State<SlideInUp>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity;
  late final Animation<Offset> _slide;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _ctrl, curve: widget.curve),
    );
    _slide = Tween<Offset>(
      begin: Offset(0, widget.offset / 100),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: widget.curve));

    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child),
    );
  }
}

/// Scale + fade pop-in.
class ScaleIn extends StatefulWidget {
  const ScaleIn({
    super.key,
    required this.child,
    this.delay = Duration.zero,
    this.duration = const Duration(milliseconds: 350),
    this.curve = AppCurves.spring,
    this.beginScale = 0.6,
  });

  final Widget child;
  final Duration delay;
  final Duration duration;
  final Curve curve;
  final double beginScale;

  @override
  State<ScaleIn> createState() => _ScaleInState();
}

class _ScaleInState extends State<ScaleIn> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  late final Animation<double> _opacity;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _scale = Tween<double>(begin: widget.beginScale, end: 1.0).animate(
      CurvedAnimation(parent: _ctrl, curve: widget.curve),
    );
    _opacity = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: const Interval(0, 0.6, curve: Curves.easeOut),
      ),
    );
    Future.delayed(widget.delay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: _opacity,
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

/// Staggered list entrance — wraps a list of children and applies
/// cascading [SlideInUp] with configurable stagger gap.
class StaggeredList extends StatelessWidget {
  const StaggeredList({
    super.key,
    required this.children,
    this.staggerMs = 60,
    this.initialDelayMs = 0,
    this.itemDuration = const Duration(milliseconds: 380),
    this.offset = 28.0,
  });

  final List<Widget> children;
  final int staggerMs;
  final int initialDelayMs;
  final Duration itemDuration;
  final double offset;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        for (int i = 0; i < children.length; i++)
          SlideInUp(
            delay: Duration(milliseconds: initialDelayMs + i * staggerMs),
            duration: itemDuration,
            offset: offset,
            child: children[i],
          ),
      ],
    );
  }
}

/// Press-scale button wrapper — shrinks to [pressedScale] on down, springs back.
class PressScale extends StatefulWidget {
  const PressScale({
    super.key,
    required this.child,
    this.onTap,
    this.pressedScale = 0.94,
    this.duration = const Duration(milliseconds: 120),
  });

  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final Duration duration;

  @override
  State<PressScale> createState() => _PressScaleState();
}

class _PressScaleState extends State<PressScale>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: widget.duration,
      reverseDuration: const Duration(milliseconds: 220),
    );
    _scale = Tween<double>(begin: 1.0, end: widget.pressedScale).animate(
      CurvedAnimation(
        parent: _ctrl,
        curve: Curves.easeOut,
        reverseCurve: AppCurves.spring,
      ),
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap?.call();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child),
    );
  }
}

/// Animated counter that tweens an integer value.
class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({
    super.key,
    required this.value,
    this.style,
    this.duration = const Duration(milliseconds: 600),
    this.curve = AppCurves.emphasized,
    this.prefix = '',
    this.suffix = '',
  });

  final int value;
  final TextStyle? style;
  final Duration duration;
  final Curve curve;
  final String prefix;
  final String suffix;

  @override
  State<AnimatedCounter> createState() => _AnimatedCounterState();
}

class _AnimatedCounterState extends State<AnimatedCounter>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _anim;
  late int _from;

  @override
  void initState() {
    super.initState();
    _from = widget.value;
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = Tween<double>(begin: widget.value.toDouble(), end: widget.value.toDouble())
        .animate(CurvedAnimation(parent: _ctrl, curve: widget.curve));
  }

  @override
  void didUpdateWidget(AnimatedCounter old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _from = old.value;
      _anim = Tween<double>(
        begin: _from.toDouble(),
        end: widget.value.toDouble(),
      ).animate(CurvedAnimation(parent: _ctrl, curve: widget.curve));
      _ctrl
        ..reset()
        ..forward();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Text(
        '${widget.prefix}${_anim.value.round()}${widget.suffix}',
        style: widget.style,
      ),
    );
  }
}

/// Pulsing glow ring around any child.
class PulseGlow extends StatefulWidget {
  const PulseGlow({
    super.key,
    required this.child,
    required this.color,
    this.minRadius = 0.0,
    this.maxRadius = 8.0,
    this.duration = const Duration(milliseconds: 1800),
  });

  final Widget child;
  final Color color;
  final double minRadius;
  final double maxRadius;
  final Duration duration;

  @override
  State<PulseGlow> createState() => _PulseGlowState();
}

class _PulseGlowState extends State<PulseGlow>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _radius;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _radius = Tween<double>(begin: widget.minRadius, end: widget.maxRadius)
        .animate(CurvedAnimation(parent: _ctrl, curve: AppCurves.ambient));
    _ctrl.repeat(reverse: true);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _radius,
      builder: (_, child) => Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: widget.color.withValues(alpha: 0.45),
              blurRadius: _radius.value,
              spreadRadius: _radius.value * 0.4,
            ),
          ],
        ),
        child: child,
      ),
      child: widget.child,
    );
  }
}

/// Shimmer loading placeholder.
class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 12.0,
  });

  final double width;
  final double height;
  final double borderRadius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _shimmer;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _shimmer = Tween<double>(begin: -1.5, end: 2.5).animate(
      CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut),
    );
    _ctrl.repeat();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    return AnimatedBuilder(
      animation: _shimmer,
      builder: (_, __) => Container(
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(widget.borderRadius),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            stops: const [0.0, 0.5, 1.0],
            colors: [
              base.withValues(alpha: 0.5),
              base.withValues(alpha: 0.9),
              base.withValues(alpha: 0.5),
            ],
            transform: _SlidingGradientTransform(_shimmer.value),
          ),
        ),
      ),
    );
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.slidePercent);
  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
  }
}
