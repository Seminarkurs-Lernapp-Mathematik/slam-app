import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lottie/lottie.dart';

// ─── Asset paths ─────────────────────────────────────────────────────────────

abstract final class AppAnim {
  static const success      = 'assets/animations/success.json';
  static const loadingDots  = 'assets/animations/loading_dots.json';
  static const confetti     = 'assets/animations/confetti.json';
  static const fireStreak   = 'assets/animations/fire_streak.json';
  static const levelUp      = 'assets/animations/level_up.json';
  static const emptyState   = 'assets/animations/empty_state.json';
  static const wrongX       = 'assets/animations/wrong_x.json';
  static const xpStar       = 'assets/animations/xp_star.json';
  static const coinPop      = 'assets/animations/coin_pop.json';
  static const sparkleBurst = 'assets/animations/sparkle_burst.json';
}

// ─── Motion constants ─────────────────────────────────────────────────────────

abstract final class AppCurves {
  static const emphasized  = Cubic(0.05, 0.7, 0.1, 1.0);
  static const standard    = Cubic(0.2, 0.0, 0.0, 1.0);
  static const accelerate  = Cubic(0.3, 0.0, 1.0, 1.0);
  static const spring      = Cubic(0.175, 0.885, 0.32, 1.275);
  static const ambient     = Cubic(0.4, 0.0, 0.2, 1.0);
  static const snappy      = Cubic(0.2, 0.0, 0.0, 1.0);
  static const elastic     = Cubic(0.68, -0.55, 0.27, 1.55);
}

abstract final class AppDurations {
  static const micro    = Duration(milliseconds: 80);
  static const quick    = Duration(milliseconds: 150);
  static const standard = Duration(milliseconds: 280);
  static const medium   = Duration(milliseconds: 400);
  static const slow     = Duration(milliseconds: 600);
  static const dramatic = Duration(milliseconds: 900);
}

// ─── Lottie players ──────────────────────────────────────────────────────────

class LottieOnce extends StatefulWidget {
  const LottieOnce({super.key, required this.asset, this.size, this.width,
      this.height, this.onComplete, this.fit = BoxFit.contain, this.repeat = false});
  final String asset; final double? size, width, height;
  final VoidCallback? onComplete; final BoxFit fit; final bool repeat;
  @override State<LottieOnce> createState() => _LottieOnceState();
}
class _LottieOnceState extends State<LottieOnce> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override void initState() { super.initState(); _ctrl = AnimationController(vsync: this); }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Lottie.asset(widget.asset,
      controller: _ctrl, width: widget.size ?? widget.width,
      height: widget.size ?? widget.height, fit: widget.fit, repeat: widget.repeat,
      onLoaded: (c) { _ctrl.duration = c.duration;
        if (widget.repeat) _ctrl.repeat();
        else _ctrl.forward().whenComplete(() => widget.onComplete?.call()); });
}

class LottieLoop extends StatefulWidget {
  const LottieLoop({super.key, required this.asset, this.size, this.width,
      this.height, this.fit = BoxFit.contain, this.speed = 1.0});
  final String asset; final double? size, width, height; final BoxFit fit; final double speed;
  @override State<LottieLoop> createState() => _LottieLoopState();
}
class _LottieLoopState extends State<LottieLoop> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override void initState() { super.initState(); _ctrl = AnimationController(vsync: this); }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Lottie.asset(widget.asset,
      controller: _ctrl, width: widget.size ?? widget.width,
      height: widget.size ?? widget.height, fit: widget.fit,
      onLoaded: (c) { _ctrl.duration = Duration(
          milliseconds: (c.duration.inMilliseconds / widget.speed).round()); _ctrl.repeat(); });
}

// ─── Entrance animations ──────────────────────────────────────────────────────

class SlideInUp extends StatefulWidget {
  const SlideInUp({super.key, required this.child,
      this.delay = Duration.zero, this.duration = const Duration(milliseconds: 380),
      this.offset = 24.0, this.curve = AppCurves.emphasized});
  final Widget child; final Duration delay, duration; final double offset; final Curve curve;
  @override State<SlideInUp> createState() => _SlideInUpState();
}
class _SlideInUpState extends State<SlideInUp> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _opacity; late final Animation<Offset> _slide;
  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _opacity = Tween<double>(begin: 0, end: 1).animate(CurvedAnimation(parent: _ctrl, curve: widget.curve));
    _slide = Tween<Offset>(begin: Offset(0, widget.offset / 100), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: widget.curve));
    Future.delayed(widget.delay, () { if (mounted) _ctrl.forward(); });
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => FadeTransition(opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child));
}

class ScaleIn extends StatefulWidget {
  const ScaleIn({super.key, required this.child, this.delay = Duration.zero,
      this.duration = const Duration(milliseconds: 350),
      this.curve = AppCurves.spring, this.beginScale = 0.6});
  final Widget child; final Duration delay, duration; final Curve curve; final double beginScale;
  @override State<ScaleIn> createState() => _ScaleInState();
}
class _ScaleInState extends State<ScaleIn> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale, _opacity;
  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _scale = Tween<double>(begin: widget.beginScale, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: widget.curve));
    _opacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.6, curve: Curves.easeOut)));
    Future.delayed(widget.delay, () { if (mounted) _ctrl.forward(); });
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => FadeTransition(opacity: _opacity,
      child: ScaleTransition(scale: _scale, child: widget.child));
}

class BounceIn extends StatefulWidget {
  const BounceIn({super.key, required this.child, this.delay = Duration.zero,
      this.duration = const Duration(milliseconds: 550)});
  final Widget child; final Duration delay, duration;
  @override State<BounceIn> createState() => _BounceInState();
}
class _BounceInState extends State<BounceIn> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<Offset> _slide; late final Animation<double> _opacity;
  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _slide = Tween<Offset>(begin: const Offset(0, 0.5), end: Offset.zero)
        .animate(CurvedAnimation(parent: _ctrl, curve: AppCurves.spring));
    _opacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _ctrl, curve: const Interval(0, 0.4, curve: Curves.easeOut)));
    Future.delayed(widget.delay, () { if (mounted) _ctrl.forward(); });
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => FadeTransition(opacity: _opacity,
      child: SlideTransition(position: _slide, child: widget.child));
}

class StaggeredList extends StatelessWidget {
  const StaggeredList({super.key, required this.children, this.staggerMs = 60,
      this.initialDelayMs = 0, this.itemDuration = const Duration(milliseconds: 380),
      this.offset = 28.0});
  final List<Widget> children; final int staggerMs, initialDelayMs;
  final Duration itemDuration; final double offset;
  @override Widget build(BuildContext context) => Column(mainAxisSize: MainAxisSize.min,
      children: [for (int i = 0; i < children.length; i++)
        SlideInUp(delay: Duration(milliseconds: initialDelayMs + i * staggerMs),
            duration: itemDuration, offset: offset, child: children[i])]);
}

// ─── Press & interaction animations ──────────────────────────────────────────

/// Press-scale + color flash + haptic — the universal tap handler
class TapRipple extends StatefulWidget {
  const TapRipple({super.key, required this.child, this.onTap,
      this.color, this.pressedScale = 0.92,
      this.pressDuration = const Duration(milliseconds: 100),
      this.haptic = HapticStrength.light, this.borderRadius = 16.0});
  final Widget child; final VoidCallback? onTap; final Color? color;
  final double pressedScale, borderRadius; final Duration pressDuration;
  final HapticStrength haptic;
  @override State<TapRipple> createState() => _TapRippleState();
}
enum HapticStrength { none, light, medium, heavy }

class _TapRippleState extends State<TapRipple> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  bool _flashing = false;

  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.pressDuration,
        reverseDuration: const Duration(milliseconds: 250));
    _scale = Tween<double>(begin: 1.0, end: widget.pressedScale)
        .animate(CurvedAnimation(parent: _ctrl,
            curve: Curves.easeOut, reverseCurve: AppCurves.spring));
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  void _triggerHaptic() {
    switch (widget.haptic) {
      case HapticStrength.light:  HapticFeedback.selectionClick(); break;
      case HapticStrength.medium: HapticFeedback.mediumImpact(); break;
      case HapticStrength.heavy:  HapticFeedback.heavyImpact(); break;
      case HapticStrength.none:   break;
    }
  }

  @override Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) { _ctrl.forward(); setState(() => _flashing = true); },
      onTapUp: (_) {
        _ctrl.reverse();
        setState(() => _flashing = false);
        _triggerHaptic();
        widget.onTap?.call();
      },
      onTapCancel: () { _ctrl.reverse(); setState(() => _flashing = false); },
      child: ScaleTransition(
        scale: _scale,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 80),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(widget.borderRadius),
            color: _flashing && widget.color != null
                ? widget.color!.withValues(alpha: 0.15)
                : Colors.transparent,
          ),
          child: widget.child,
        ),
      ),
    );
  }
}

class PressScale extends StatefulWidget {
  const PressScale({super.key, required this.child, this.onTap,
      this.pressedScale = 0.94, this.duration = const Duration(milliseconds: 120)});
  final Widget child; final VoidCallback? onTap;
  final double pressedScale; final Duration duration;
  @override State<PressScale> createState() => _PressScaleState();
}
class _PressScaleState extends State<PressScale> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration,
        reverseDuration: const Duration(milliseconds: 220));
    _scale = Tween<double>(begin: 1.0, end: widget.pressedScale).animate(
        CurvedAnimation(parent: _ctrl, curve: Curves.easeOut, reverseCurve: AppCurves.spring));
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) { _ctrl.reverse(); widget.onTap?.call(); },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(scale: _scale, child: widget.child));
}

// ─── Shake (wrong answer) ─────────────────────────────────────────────────────

class ShakeWidget extends StatefulWidget {
  const ShakeWidget({super.key, required this.child, this.shake = false,
      this.color = Colors.red});
  final Widget child; final bool shake; final Color color;
  @override State<ShakeWidget> createState() => _ShakeWidgetState();
}
class _ShakeWidgetState extends State<ShakeWidget> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _shake, _redFlash;

  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 520));
    _shake = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 12.0), weight: 10),
      TweenSequenceItem(tween: Tween(begin: 12.0, end: -14.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -14.0, end: 10.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 10.0, end: -8.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: -8.0, end: 4.0), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 4.0, end: 0.0), weight: 10),
    ]).animate(_ctrl);
    _redFlash = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 0.22), weight: 20),
      TweenSequenceItem(tween: Tween(begin: 0.22, end: 0.0), weight: 80),
    ]).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override void didUpdateWidget(ShakeWidget old) {
    super.didUpdateWidget(old);
    if (widget.shake && !old.shake) { HapticFeedback.heavyImpact(); _ctrl.forward(from: 0); }
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) => AnimatedBuilder(
      animation: _ctrl,
      builder: (_, child) => Transform.translate(
          offset: Offset(_shake.value, 0),
          child: Container(
            decoration: BoxDecoration(
              color: widget.color.withValues(alpha: _redFlash.value),
              borderRadius: BorderRadius.circular(16),
            ),
            child: child,
          )),
      child: widget.child);
}

// ─── Animated gradient background ─────────────────────────────────────────────

class AnimatedGradientBg extends StatefulWidget {
  const AnimatedGradientBg({super.key, required this.child,
      required this.colors, this.duration = const Duration(seconds: 5)});
  final Widget child; final List<List<Color>> colors; final Duration duration;
  @override State<AnimatedGradientBg> createState() => _AnimatedGradientBgState();
}
class _AnimatedGradientBgState extends State<AnimatedGradientBg>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  int _idx = 0;
  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration)
      ..addStatusListener((s) { if (s == AnimationStatus.completed) {
          setState(() => _idx = (_idx + 1) % widget.colors.length);
          _ctrl.forward(from: 0);
        }})
      ..forward();
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    final a = widget.colors[_idx]; final b = widget.colors[(_idx + 1) % widget.colors.length];
    return AnimatedBuilder(
        animation: _ctrl,
        builder: (_, child) {
          final t = Curves.easeInOut.transform(_ctrl.value);
          final blended = List.generate(
              math.min(a.length, b.length),
              (i) => Color.lerp(a[i], b[i], t)!);
          return Container(decoration: BoxDecoration(gradient: LinearGradient(
              begin: Alignment.topLeft, end: Alignment.bottomRight, colors: blended)),
              child: child);
        },
        child: widget.child);
  }
}

// ─── Floating particles (ambient background) ──────────────────────────────────

class FloatingParticles extends StatefulWidget {
  const FloatingParticles({super.key, required this.child,
      this.colors, this.count = 14, this.maxSize = 6.0});
  final Widget child; final List<Color>? colors; final int count; final double maxSize;
  @override State<FloatingParticles> createState() => _FloatingParticlesState();
}
class _FloatingParticlesState extends State<FloatingParticles>
    with TickerProviderStateMixin {
  final List<_Particle> _particles = [];
  late final AnimationController _ctrl;
  final _rng = math.Random();

  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(seconds: 8))..repeat();
    for (int i = 0; i < widget.count; i++) { _particles.add(_Particle(_rng)); }
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Stack(children: [
      widget.child,
      Positioned.fill(child: IgnorePointer(child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => CustomPaint(
              painter: _ParticlePainter(_particles, _ctrl.value,
                  widget.colors ?? [Colors.white.withValues(alpha: 0.12),
                      Colors.white.withValues(alpha: 0.06)],
                  widget.maxSize)))))]);
}

class _Particle {
  final double x, y0, speed, size, phase;
  _Particle(math.Random r)
      : x = r.nextDouble(), y0 = r.nextDouble(),
        speed = 0.03 + r.nextDouble() * 0.06,
        size = 1.5 + r.nextDouble() * 4,
        phase = r.nextDouble() * math.pi * 2;
}

class _ParticlePainter extends CustomPainter {
  final List<_Particle> particles; final double t;
  final List<Color> colors; final double maxSize;
  _ParticlePainter(this.particles, this.t, this.colors, this.maxSize);

  @override void paint(Canvas canvas, Size size) {
    for (int i = 0; i < particles.length; i++) {
      final p = particles[i];
      final y = (p.y0 - t * p.speed) % 1.0;
      final wobble = math.sin(t * math.pi * 2 + p.phase) * 0.015;
      final dx = (p.x + wobble).clamp(0.0, 1.0) * size.width;
      final dy = (y < 0 ? y + 1.0 : y) * size.height;
      final opacity = (math.sin(t * math.pi * 4 + p.phase) + 1) / 2;
      final paint = Paint()
        ..color = colors[i % colors.length].withValues(alpha: opacity * 0.7)
        ..style = PaintingStyle.fill;
      canvas.drawCircle(Offset(dx, dy), p.size * opacity, paint);
    }
  }
  @override bool shouldRepaint(_ParticlePainter o) => o.t != t;
}

// ─── Glow border ──────────────────────────────────────────────────────────────

class GlowBorder extends StatefulWidget {
  const GlowBorder({super.key, required this.child, required this.color,
      this.borderRadius = 16.0, this.glowRadius = 12.0, this.animate = true});
  final Widget child; final Color color; final double borderRadius, glowRadius; final bool animate;
  @override State<GlowBorder> createState() => _GlowBorderState();
}
class _GlowBorderState extends State<GlowBorder> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _glow;
  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1600));
    _glow = Tween<double>(begin: 0.4, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: AppCurves.ambient));
    if (widget.animate) _ctrl.repeat(reverse: true);
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(
      animation: _glow,
      builder: (_, child) => Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: [BoxShadow(
                  color: widget.color.withValues(alpha: _glow.value * 0.6),
                  blurRadius: widget.glowRadius * _glow.value,
                  spreadRadius: widget.glowRadius * 0.15 * _glow.value)]),
          child: child),
      child: widget.child);
}

// ─── Sparkle overlay (sprinkle on any widget) ─────────────────────────────────

class SparkleOverlay extends StatefulWidget {
  const SparkleOverlay({super.key, required this.child, this.active = false,
      this.color = Colors.amber});
  final Widget child; final bool active; final Color color;
  @override State<SparkleOverlay> createState() => _SparkleOverlayState();
}
class _SparkleOverlayState extends State<SparkleOverlay> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    if (widget.active) _ctrl.repeat();
  }
  @override void didUpdateWidget(SparkleOverlay old) {
    super.didUpdateWidget(old);
    if (widget.active && !old.active) _ctrl.repeat();
    else if (!widget.active && old.active) { _ctrl.stop(); _ctrl.reset(); }
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => Stack(children: [
      widget.child,
      if (widget.active) Positioned.fill(child: IgnorePointer(child: AnimatedBuilder(
          animation: _ctrl,
          builder: (_, __) => CustomPaint(
              painter: _SparklePainter(_ctrl.value, widget.color)))))]);
}
class _SparklePainter extends CustomPainter {
  final double t; final Color color;
  _SparklePainter(this.t, this.color);
  static final _rng = math.Random(42);
  static final _pts = List.generate(8, (i) => Offset(
      _rng.nextDouble(), _rng.nextDouble()));
  @override void paint(Canvas canvas, Size size) {
    for (int i = 0; i < _pts.length; i++) {
      final phase = (t + i / _pts.length) % 1.0;
      final opacity = (math.sin(phase * math.pi) ).clamp(0.0, 1.0);
      final radius = 2.0 + phase * 3.0;
      final paint = Paint()..color = color.withValues(alpha: opacity * 0.8);
      canvas.drawCircle(Offset(_pts[i].dx * size.width, _pts[i].dy * size.height), radius, paint);
    }
  }
  @override bool shouldRepaint(_SparklePainter o) => o.t != t;
}

// ─── Animated counter ─────────────────────────────────────────────────────────

class AnimatedCounter extends StatefulWidget {
  const AnimatedCounter({super.key, required this.value, this.style,
      this.duration = const Duration(milliseconds: 600),
      this.curve = AppCurves.emphasized, this.prefix = '', this.suffix = ''});
  final int value; final TextStyle? style; final Duration duration;
  final Curve curve; final String prefix, suffix;
  @override State<AnimatedCounter> createState() => _AnimatedCounterState();
}
class _AnimatedCounterState extends State<AnimatedCounter> with SingleTickerProviderStateMixin {
  late AnimationController _ctrl; late Animation<double> _anim;
  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _anim = Tween<double>(begin: widget.value.toDouble(), end: widget.value.toDouble())
        .animate(CurvedAnimation(parent: _ctrl, curve: widget.curve));
  }
  @override void didUpdateWidget(AnimatedCounter old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _anim = Tween<double>(begin: old.value.toDouble(), end: widget.value.toDouble())
          .animate(CurvedAnimation(parent: _ctrl, curve: widget.curve));
      _ctrl..reset()..forward();
    }
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(
      animation: _anim,
      builder: (_, __) => Text(
          '${widget.prefix}${_anim.value.round()}${widget.suffix}',
          style: widget.style));
}

// ─── Pulse glow ───────────────────────────────────────────────────────────────

class PulseGlow extends StatefulWidget {
  const PulseGlow({super.key, required this.child, required this.color,
      this.minRadius = 0.0, this.maxRadius = 8.0,
      this.duration = const Duration(milliseconds: 1800)});
  final Widget child; final Color color; final double minRadius, maxRadius; final Duration duration;
  @override State<PulseGlow> createState() => _PulseGlowState();
}
class _PulseGlowState extends State<PulseGlow> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl; late final Animation<double> _radius;
  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _radius = Tween<double>(begin: widget.minRadius, end: widget.maxRadius)
        .animate(CurvedAnimation(parent: _ctrl, curve: AppCurves.ambient));
    _ctrl.repeat(reverse: true);
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) => AnimatedBuilder(
      animation: _radius,
      builder: (_, child) => Container(
          decoration: BoxDecoration(shape: BoxShape.circle, boxShadow: [BoxShadow(
              color: widget.color.withValues(alpha: 0.45),
              blurRadius: _radius.value, spreadRadius: _radius.value * 0.4)]),
          child: child),
      child: widget.child);
}

// ─── Shimmer ──────────────────────────────────────────────────────────────────

class ShimmerBox extends StatefulWidget {
  const ShimmerBox({super.key, required this.width, required this.height, this.borderRadius = 12.0});
  final double width, height, borderRadius;
  @override State<ShimmerBox> createState() => _ShimmerBoxState();
}
class _ShimmerBoxState extends State<ShimmerBox> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _shimmer;
  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 1200));
    _shimmer = Tween<double>(begin: -1.5, end: 2.5)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
    _ctrl.repeat();
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    final base = Theme.of(context).colorScheme.surfaceContainerHighest;
    return AnimatedBuilder(animation: _shimmer,
        builder: (_, __) => Container(width: widget.width, height: widget.height,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(widget.borderRadius),
                gradient: LinearGradient(
                    begin: Alignment.centerLeft, end: Alignment.centerRight,
                    stops: const [0.0, 0.5, 1.0],
                    colors: [base.withValues(alpha: 0.5), base.withValues(alpha: 0.9), base.withValues(alpha: 0.5)],
                    transform: _SlidingGradientTransform(_shimmer.value)))));
  }
}
class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform(this.slidePercent);
  final double slidePercent;
  @override Matrix4? transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(bounds.width * slidePercent, 0, 0);
}

// ─── Morphing icon (AnimatedSwitcher wrapper) ─────────────────────────────────

class MorphIcon extends StatelessWidget {
  const MorphIcon({super.key, required this.icon, this.size = 24, this.color});
  final IconData icon; final double size; final Color? color;
  @override Widget build(BuildContext context) => AnimatedSwitcher(
      duration: AppDurations.standard,
      transitionBuilder: (child, anim) => ScaleTransition(scale: anim,
          child: FadeTransition(opacity: anim, child: child)),
      child: Icon(icon, key: ValueKey(icon), size: size, color: color));
}

// ─── Bounce count badge ───────────────────────────────────────────────────────

class BounceBadge extends StatefulWidget {
  const BounceBadge({super.key, required this.count, this.color});
  final int count; final Color? color;
  @override State<BounceBadge> createState() => _BounceBadgeState();
}
class _BounceBadgeState extends State<BounceBadge> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale;
  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 350));
    _scale = Tween<double>(begin: 1.0, end: 1.4)
        .animate(CurvedAnimation(parent: _ctrl, curve: AppCurves.spring));
  }
  @override void didUpdateWidget(BounceBadge old) {
    super.didUpdateWidget(old);
    if (old.count != widget.count) { _ctrl.forward(from: 0).then((_) => _ctrl.reverse()); }
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    return ScaleTransition(scale: _scale, child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
        child: Text('${widget.count}', style: TextStyle(color: Colors.white,
            fontSize: 11, fontWeight: FontWeight.w800))));
  }
}

// ─── Animated tab icon (bounce + rotate on select) ────────────────────────────

class AnimatedTabIcon extends StatefulWidget {
  const AnimatedTabIcon({super.key, required this.icon, required this.selectedIcon,
      required this.isActive, this.color, this.size = 22.0});
  final IconData icon, selectedIcon; final bool isActive;
  final Color? color; final double size;
  @override State<AnimatedTabIcon> createState() => _AnimatedTabIconState();
}
class _AnimatedTabIconState extends State<AnimatedTabIcon>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _bounce, _rotation;
  bool _wasActive = false;

  @override void initState() {
    super.initState();
    _wasActive = widget.isActive;
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _bounce = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 1.35).chain(CurveTween(curve: Curves.easeOut)), weight: 30),
      TweenSequenceItem(tween: Tween(begin: 1.35, end: 0.88).chain(CurveTween(curve: Curves.easeInOut)), weight: 35),
      TweenSequenceItem(tween: Tween(begin: 0.88, end: 1.0).chain(CurveTween(curve: AppCurves.spring)), weight: 35),
    ]).animate(_ctrl);
    _rotation = TweenSequence<double>([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: -0.15), weight: 30),
      TweenSequenceItem(tween: Tween(begin: -0.15, end: 0.12), weight: 40),
      TweenSequenceItem(tween: Tween(begin: 0.12, end: 0.0), weight: 30),
    ]).animate(_ctrl);
  }

  @override void didUpdateWidget(AnimatedTabIcon old) {
    super.didUpdateWidget(old);
    if (widget.isActive && !_wasActive) { _ctrl.forward(from: 0); HapticFeedback.selectionClick(); }
    _wasActive = widget.isActive;
  }

  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) => AnimatedBuilder(
      animation: _ctrl,
      builder: (_, __) => Transform.rotate(
          angle: _rotation.value,
          child: Transform.scale(
              scale: _bounce.value,
              child: Icon(widget.isActive ? widget.selectedIcon : widget.icon,
                  size: widget.size, color: widget.color))));
}

// ─── Ripple tap overlay (web-friendly) ────────────────────────────────────────

class RippleTap extends StatefulWidget {
  const RippleTap({super.key, required this.child, this.onTap, this.color,
      this.borderRadius = 12.0});
  final Widget child; final VoidCallback? onTap; final Color? color; final double borderRadius;
  @override State<RippleTap> createState() => _RippleTapState();
}
class _RippleTapState extends State<RippleTap> with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scale, _opacity;
  Offset _tapPos = Offset.zero;

  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    _scale = Tween<double>(begin: 0.0, end: 2.5)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
    _opacity = Tween<double>(begin: 0.3, end: 0.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }

  @override Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    return GestureDetector(
      onTapDown: (d) { setState(() => _tapPos = d.localPosition); _ctrl.forward(from: 0); },
      onTap: () { HapticFeedback.selectionClick(); widget.onTap?.call(); },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: Stack(children: [
          widget.child,
          Positioned.fill(child: AnimatedBuilder(
              animation: _ctrl,
              builder: (_, __) => CustomPaint(
                  painter: _RipplePainter(_tapPos, _scale.value, _opacity.value, color)))),
        ]),
      ),
    );
  }
}
class _RipplePainter extends CustomPainter {
  final Offset center; final double scale, opacity; final Color color;
  _RipplePainter(this.center, this.scale, this.opacity, this.color);
  @override void paint(Canvas canvas, Size size) {
    if (opacity <= 0) return;
    final maxR = math.max(size.width, size.height) * 0.8;
    canvas.drawCircle(center, maxR * scale,
        Paint()..color = color.withValues(alpha: opacity)..style = PaintingStyle.fill);
  }
  @override bool shouldRepaint(_RipplePainter o) => o.scale != scale || o.opacity != opacity;
}

// ─── Typewriter text ──────────────────────────────────────────────────────────

class TypewriterText extends StatefulWidget {
  const TypewriterText({super.key, required this.text, this.style,
      this.speed = const Duration(milliseconds: 28), this.delay = Duration.zero});
  final String text; final TextStyle? style; final Duration speed, delay;
  @override State<TypewriterText> createState() => _TypewriterTextState();
}
class _TypewriterTextState extends State<TypewriterText> {
  int _shown = 0;
  @override void initState() {
    super.initState();
    Future.delayed(widget.delay, _type);
  }
  void _type() async {
    for (int i = 0; i <= widget.text.length; i++) {
      if (!mounted) return;
      setState(() => _shown = i);
      await Future.delayed(widget.speed);
    }
  }
  @override Widget build(BuildContext context) =>
      Text(widget.text.substring(0, _shown), style: widget.style);
}

// ─── Color-matched animated progress bar ─────────────────────────────────────

class AnimatedProgressBar extends StatefulWidget {
  const AnimatedProgressBar({super.key, required this.value, required this.color,
      this.height = 10.0, this.duration = const Duration(milliseconds: 900),
      this.backgroundColor, this.borderRadius = 8.0, this.showGlow = true});
  final double value, height, borderRadius; final Color color;
  final Color? backgroundColor; final Duration duration; final bool showGlow;
  @override State<AnimatedProgressBar> createState() => _AnimatedProgressBarState();
}
class _AnimatedProgressBarState extends State<AnimatedProgressBar>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl; late Animation<double> _val;
  @override void initState() {
    super.initState();
    _ctrl = AnimationController(vsync: this, duration: widget.duration);
    _val = Tween<double>(begin: 0, end: widget.value)
        .animate(CurvedAnimation(parent: _ctrl, curve: AppCurves.emphasized));
    _ctrl.forward();
  }
  @override void didUpdateWidget(AnimatedProgressBar old) {
    super.didUpdateWidget(old);
    if (old.value != widget.value) {
      _val = Tween<double>(begin: _val.value, end: widget.value)
          .animate(CurvedAnimation(parent: _ctrl, curve: AppCurves.emphasized));
      _ctrl..reset()..forward();
    }
  }
  @override void dispose() { _ctrl.dispose(); super.dispose(); }
  @override Widget build(BuildContext context) {
    final bg = widget.backgroundColor ??
        Theme.of(context).colorScheme.surfaceContainerHighest;
    return AnimatedBuilder(
        animation: _val,
        builder: (_, __) => Container(
            height: widget.height,
            decoration: BoxDecoration(color: bg,
                borderRadius: BorderRadius.circular(widget.borderRadius)),
            child: FractionallySizedBox(
                widthFactor: _val.value.clamp(0.0, 1.0),
                alignment: Alignment.centerLeft,
                child: Container(
                    decoration: BoxDecoration(
                        color: widget.color,
                        borderRadius: BorderRadius.circular(widget.borderRadius),
                        boxShadow: widget.showGlow ? [BoxShadow(
                            color: widget.color.withValues(alpha: 0.5),
                            blurRadius: 8, offset: const Offset(0, 2))] : null)))));
  }
}
