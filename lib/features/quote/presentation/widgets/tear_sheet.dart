import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kuwot/features/quote/presentation/widgets/torn_edge_clipper.dart';

/// A rectangular sheet that can be dragged and torn away, following the
/// finger, tearing along a jagged edge, then flying off past a threshold;
/// springing back before it. With reduced motion the drag itself does not
/// move the sheet, and a completed tear (or the on-screen control) plays a
/// short fade instead (contract G8). Shared by the whole-page tear and the
/// same-day quote-only tear.
class TearSheet extends StatefulWidget {
  const TearSheet({
    super.key,
    required this.child,
    required this.teethSeed,
    required this.onTornAway,
  });

  final Widget child;
  final int teethSeed;
  final VoidCallback onTornAway;

  @override
  State<TearSheet> createState() => TearSheetState();
}

enum _Phase { resting, dragging, flying, gone }

class TearSheetState extends State<TearSheet>
    with SingleTickerProviderStateMixin {
  static const _threshold = 130.0;
  static const _flingVelocity = 900.0;
  static const _flyDuration = Duration(milliseconds: 260);
  static const _springDuration = Duration(milliseconds: 380);
  static const _fadeDuration = Duration(milliseconds: 150);
  static const _teethCount = 22;

  late final AnimationController _controller;
  late final List<double> _teeth;

  _Phase _phase = _Phase.resting;
  double _progress = 0;
  double _dx = 0;
  double _height = 0;
  double _rawDy = 0;
  double _opacity = 1;

  bool get _reducedMotion => MediaQuery.disableAnimationsOf(context);

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this);
    final rng = Random(widget.teethSeed);
    _teeth = List.generate(_teethCount, (_) => rng.nextDouble());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Runs the same tear-away animation as a completed drag, for an
  /// on-screen control. A no-op unless the sheet is currently resting.
  Future<void> tearAway() async {
    if (_phase != _Phase.resting) return;
    if (_reducedMotion) {
      await _fadeOut();
    } else {
      await _flyAway();
    }
  }

  void _onPanStart(DragStartDetails details) {
    if (_phase != _Phase.resting || _controller.isAnimating) return;
    setState(() => _phase = _Phase.dragging);
  }

  void _onPanUpdate(DragUpdateDetails details) {
    if (_phase != _Phase.dragging) return;
    setState(() {
      if (_reducedMotion) {
        _rawDy += details.delta.dy;
      } else {
        _progress = (_progress + details.delta.dy / _threshold).clamp(
          -0.08,
          1.3,
        );
        _dx = (_dx + details.delta.dx * 0.25).clamp(-32.0, 32.0);
      }
    });
  }

  void _onPanEnd(DragEndDetails details) {
    final vy = details.velocity.pixelsPerSecond.dy;
    if (_reducedMotion) {
      final torn = _rawDy >= _threshold || vy > _flingVelocity;
      setState(() {
        _phase = _Phase.resting;
        _rawDy = 0;
      });
      if (torn) _fadeOut();
      return;
    }
    if (_progress >= 1.0 || vy > _flingVelocity) {
      _flyAway();
    } else {
      setState(() => _phase = _Phase.resting);
      _springBack();
    }
  }

  Future<void> _animate({
    required Duration duration,
    required Curve curve,
    required void Function(double t) onTick,
  }) async {
    _controller
      ..duration = duration
      ..value = 0;
    void listener() =>
        setState(() => onTick(curve.transform(_controller.value)));
    _controller.addListener(listener);
    await _controller.forward();
    _controller.removeListener(listener);
  }

  Future<void> _springBack() {
    final startP = _progress;
    final startDx = _dx;
    return _animate(
      duration: _springDuration,
      curve: Curves.elasticOut,
      onTick: (t) {
        _progress = startP * (1 - t);
        _dx = startDx * (1 - t);
      },
    );
  }

  Future<void> _flyAway() async {
    setState(() => _phase = _Phase.flying);
    final startP = _progress;
    final flyTarget = 1.0 + (_height * 1.3) / _threshold;
    await _animate(
      duration: _flyDuration,
      curve: Curves.easeIn,
      onTick: (t) => _progress = startP + (flyTarget - startP) * t,
    );
    _finish();
  }

  Future<void> _fadeOut() async {
    setState(() => _phase = _Phase.flying);
    await _animate(
      duration: _fadeDuration,
      curve: Curves.linear,
      onTick: (t) => _opacity = 1 - t,
    );
    _finish();
  }

  void _finish() {
    if (!mounted) return;
    setState(() => _phase = _Phase.gone);
    widget.onTornAway();
  }

  @override
  Widget build(BuildContext context) {
    if (_phase == _Phase.gone) {
      return const SizedBox.expand();
    }
    return LayoutBuilder(
      builder: (context, constraints) {
        _height = constraints.maxHeight;
        if (_reducedMotion) {
          return GestureDetector(
            onPanStart: _onPanStart,
            onPanUpdate: _onPanUpdate,
            onPanEnd: _onPanEnd,
            child: Opacity(
              opacity: _opacity,
              child: RepaintBoundary(child: widget.child),
            ),
          );
        }

        final jag = _progress.clamp(0.0, 1.0);
        final flightT = ((_progress - 1.0) / 0.6).clamp(0.0, 1.0);
        final translateY = _progress * _threshold;
        final rotation = _dx / 600 + _progress * 0.05;
        final scale = 1 - flightT * 0.05;
        final opacity = 1 - flightT;
        return GestureDetector(
          onPanStart: _onPanStart,
          onPanUpdate: _onPanUpdate,
          onPanEnd: _onPanEnd,
          child: Transform.translate(
            offset: Offset(_dx, translateY),
            child: Transform.rotate(
              angle: rotation,
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      boxShadow: _progress > 0.02
                          ? [
                              BoxShadow(
                                color: Colors.black.withValues(
                                  alpha: 0.28 * (_progress * 3).clamp(0.0, 1.0),
                                ),
                                blurRadius: 18,
                                offset: const Offset(0, 8),
                              ),
                            ]
                          : const [],
                    ),
                    child: ClipPath(
                      clipper: TornEdgeClipper(jag: jag, teeth: _teeth),
                      clipBehavior: Clip.antiAlias,
                      child: RepaintBoundary(child: widget.child),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
