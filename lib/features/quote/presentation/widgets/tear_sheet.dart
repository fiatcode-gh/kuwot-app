import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kuwot/features/quote/presentation/widgets/torn_edge_clipper.dart';

/// A rectangular sheet that can be dragged and torn away, following the
/// finger, tearing along a jagged edge, then flying off past a threshold;
/// springing back before it. With reduced motion the drag itself does not
/// move the sheet, and a completed tear (or the on-screen control) plays a
/// short fade instead (contract G8). Shared by the whole-page tear and the
/// same-day quote-only tear.
///
/// While the sheet is not at rest — dragging, flying away, springing back
/// or fading — it renders through an [OverlayPortal] into the nearest
/// [Overlay] instead of in place, so it paints above every pad layer
/// (including the binding and, for a quote tear, the header) and is never
/// clipped by an ancestor (contract D8). The in-place [GestureDetector]
/// never moves: it keeps tracking the gesture already in progress and stays
/// ready to arm a new one once the sheet is at rest again. Only the visual
/// content — built once from the shared animation state and reused for
/// both the in-place and the overlay render — switches sides.
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
  final LayerLink _link = LayerLink();
  final OverlayPortalController _overlay = OverlayPortalController();

  _Phase _phase = _Phase.resting;
  bool _animating = false;
  double _progress = 0;
  double _dx = 0;
  double _height = 0;
  double _rawDy = 0;
  double _opacity = 1;
  Size _size = Size.zero;

  bool get _reducedMotion => MediaQuery.disableAnimationsOf(context);

  /// False while dragging, flying away, springing back or fading — the
  /// overlay should be showing the moving sheet during all of those.
  /// [_animating] alone tells springing-back apart from true rest, since a
  /// spring-back sets [_phase] back to [_Phase.resting] immediately and
  /// only the animation marks it as still moving (contract D8).
  bool get _settled => _phase == _Phase.resting && !_animating;

  void _syncOverlay() {
    if (!mounted) return;
    if (_settled) {
      if (_overlay.isShowing) _overlay.hide();
    } else {
      if (!_overlay.isShowing) _overlay.show();
    }
  }

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
    _syncOverlay();
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
    if (_phase != _Phase.dragging) return;
    final vy = details.velocity.pixelsPerSecond.dy;
    if (_reducedMotion) {
      final torn = _rawDy >= _threshold || vy > _flingVelocity;
      setState(() {
        _phase = _Phase.resting;
        _rawDy = 0;
      });
      _syncOverlay();
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
    _animating = true;
    _syncOverlay();
    _controller
      ..duration = duration
      ..value = 0;
    void listener() =>
        setState(() => onTick(curve.transform(_controller.value)));
    _controller.addListener(listener);
    await _controller.forward();
    _controller.removeListener(listener);
    _animating = false;
    _syncOverlay();
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
    _syncOverlay();
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
    _syncOverlay();
    await _animate(
      duration: _fadeDuration,
      curve: Curves.linear,
      onTick: (t) => _opacity = 1 - t,
    );
    _finish();
  }

  void _finish() {
    if (!mounted) return;
    _overlay.hide();
    setState(() => _phase = _Phase.gone);
    widget.onTornAway();
  }

  /// Gives [child] its rest-sized box ([_size]) without imposing an
  /// ancestor-style hit-test/paint bound: [OverflowBox] hands its own child
  /// loose constraints regardless of the incoming ones (the overlay's
  /// theatre is otherwise full-screen), and `Alignment.topLeft` keeps it
  /// flush with the origin either way. Placed *inside* the transform chain
  /// in [_buildVisual], after the translate/rotate/scale have already
  /// unwound the incoming hit-test position, so a plain sized box here
  /// never re-gates the escape the transforms just enabled.
  Widget _sizedOverflow(Widget child) => OverflowBox(
    alignment: Alignment.topLeft,
    minWidth: 0,
    maxWidth: double.infinity,
    minHeight: 0,
    maxHeight: double.infinity,
    child: SizedBox.fromSize(size: _size, child: child),
  );

  Widget _buildVisual() {
    if (_reducedMotion) {
      return _sizedOverflow(
        Opacity(
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
    return Transform.translate(
      offset: Offset(_dx, translateY),
      child: Transform.rotate(
        angle: rotation,
        child: Transform.scale(
          scale: scale,
          child: Opacity(
            opacity: opacity,
            child: _sizedOverflow(
              DecoratedBox(
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
  }

  @override
  Widget build(BuildContext context) {
    if (_phase == _Phase.gone) {
      return const SizedBox.expand();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        _height = constraints.maxHeight;
        _size = constraints.biggest;
        final settled = !_overlay.isShowing;
        return CompositedTransformTarget(
          link: _link,
          child: OverlayPortal(
            controller: _overlay,
            overlayChildBuilder: (context) => IgnorePointer(
              child: CompositedTransformFollower(
                link: _link,
                showWhenUnlinked: false,
                child: _buildVisual(),
              ),
            ),
            child: GestureDetector(
              onPanStart: _onPanStart,
              onPanUpdate: _onPanUpdate,
              onPanEnd: _onPanEnd,
              child: settled ? _buildVisual() : SizedBox.fromSize(size: _size),
            ),
          ),
        );
      },
    );
  }
}
