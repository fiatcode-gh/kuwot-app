import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:kuwot/features/quote/domain/entities/background_style.dart';
import 'package:kuwot/features/quote/domain/services/background_recipe.dart';

/// Paints a [BackgroundRecipe] with Flutter's built-in (GPU) gradients.
/// Synchronous and instant — no per-pixel work, no images, no async.
class BackgroundPainter extends CustomPainter {
  BackgroundPainter(this.style)
    : recipe = BackgroundRecipe.fromSeed(style.seed, style.palette);

  final BackgroundStyle style;
  final BackgroundRecipe recipe;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    // Confine drawing to the canvas so nothing bleeds onto sibling widgets.
    canvas.clipRect(rect);
    switch (recipe.engine) {
      case 0:
        _paintSoftBlobs(canvas, rect);
      case 1:
        _paintLinear(canvas, rect);
      case 2:
        _paintSweep(canvas, rect);
      case 3:
        _paintRadial(canvas, rect);
      case 4:
        _paintDuotone(canvas, rect);
      default:
        _paintCornerMesh(canvas, rect);
    }
  }

  void _paintSoftBlobs(Canvas canvas, Rect rect) {
    _fill(
      canvas,
      rect,
      LinearGradient(
        begin: _begin(recipe.angle),
        end: _end(recipe.angle),
        colors: [recipe.colors[0], recipe.colors[1]],
      ),
    );
    for (var i = 0; i < recipe.points.length; i++) {
      _fill(
        canvas,
        rect,
        _blob(recipe.colors[2 + i], recipe.points[i], recipe.radii[i]),
      );
    }
  }

  void _paintLinear(Canvas canvas, Rect rect) {
    _fill(
      canvas,
      rect,
      LinearGradient(
        begin: _begin(recipe.angle),
        end: _end(recipe.angle),
        colors: recipe.colors,
        stops: recipe.stops,
      ),
    );
  }

  void _paintSweep(Canvas canvas, Rect rect) {
    _fill(
      canvas,
      rect,
      SweepGradient(
        center: recipe.points.first,
        startAngle: recipe.angle,
        endAngle: recipe.angle + 2 * math.pi,
        colors: [...recipe.colors, recipe.colors.first], // loop for smooth wrap
      ),
    );
  }

  void _paintRadial(Canvas canvas, Rect rect) {
    _fill(
      canvas,
      rect,
      RadialGradient(
        center: recipe.points.first,
        radius: recipe.radii.first,
        colors: recipe.colors,
      ),
    );
  }

  void _paintDuotone(Canvas canvas, Rect rect) {
    _fill(
      canvas,
      rect,
      LinearGradient(
        begin: _begin(recipe.angle),
        end: _end(recipe.angle),
        colors: recipe.colors,
        stops: recipe.stops,
      ),
    );
  }

  void _paintCornerMesh(Canvas canvas, Rect rect) {
    canvas.drawRect(rect, Paint()..color = recipe.colors[0]);
    for (var i = 0; i < recipe.points.length; i++) {
      final color = recipe.colors[i % recipe.colors.length];
      _fill(canvas, rect, _blob(color, recipe.points[i], recipe.radii[i]));
    }
  }

  /// A soft blob: a radial gradient from an opaque palette colour to the same
  /// colour fully transparent, so it composites over the base as a soft wash.
  RadialGradient _blob(Color color, Alignment center, double radius) {
    return RadialGradient(
      center: center,
      radius: radius,
      colors: [color, color.withValues(alpha: 0)],
    );
  }

  void _fill(Canvas canvas, Rect rect, Gradient gradient) {
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));
  }

  Alignment _begin(double angle) =>
      Alignment(-math.cos(angle), -math.sin(angle));
  Alignment _end(double angle) => Alignment(math.cos(angle), math.sin(angle));

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) =>
      oldDelegate.style != style;
}
