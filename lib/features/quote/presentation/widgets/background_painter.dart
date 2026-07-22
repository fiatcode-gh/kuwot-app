import 'dart:math';

import 'package:flutter/material.dart';
import 'package:kuwot/features/quote/domain/entities/background_style.dart';

class BackgroundPainter extends CustomPainter {
  BackgroundPainter(this.style);

  final BackgroundStyle style;

  @override
  void paint(Canvas canvas, Size size) {
    final rng = Random(style.seed);
    final rect = Offset.zero & size;
    final colors = style.palette.colors;

    // Confine all drawing to the canvas — overlay shapes (blobs, low-poly,
    // waves) can extend past the bounds, and CustomPainter does not clip by
    // default, so they would otherwise bleed onto sibling widgets.
    canvas.clipRect(rect);

    // base gradient fill
    final Gradient gradient;
    switch (style.kind) {
      case BackgroundKind.radialGradient:
        gradient = RadialGradient(colors: colors, radius: 1.0);
      case BackgroundKind.sweepGradient:
        gradient = SweepGradient(colors: _loop(colors));
      case BackgroundKind.linearGradient:
      case BackgroundKind.blobs:
      case BackgroundKind.waves:
      case BackgroundKind.lowPoly:
      case BackgroundKind.stripes:
        gradient = LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors,
        );
    }
    canvas.drawRect(rect, Paint()..shader = gradient.createShader(rect));

    // seeded overlay
    switch (style.kind) {
      case BackgroundKind.blobs:
        _paintBlobs(canvas, size, rng, colors);
      case BackgroundKind.waves:
        _paintWaves(canvas, size, rng, colors);
      case BackgroundKind.lowPoly:
        _paintLowPoly(canvas, size, rng, colors);
      case BackgroundKind.stripes:
        _paintStripes(canvas, size, rng, colors);
      case BackgroundKind.linearGradient:
      case BackgroundKind.radialGradient:
      case BackgroundKind.sweepGradient:
        break;
    }
  }

  List<Color> _loop(List<Color> c) => [...c, c.first];

  Color _overlay(List<Color> colors, Random rng, double alpha) {
    return colors[rng.nextInt(colors.length)].withValues(alpha: alpha);
  }

  void _paintBlobs(Canvas canvas, Size size, Random rng, List<Color> colors) {
    for (var i = 0; i < 5; i++) {
      final paint = Paint()..color = _overlay(colors, rng, 0.25);
      final center = Offset(
        rng.nextDouble() * size.width,
        rng.nextDouble() * size.height,
      );
      final radius = size.shortestSide * (0.15 + rng.nextDouble() * 0.35);
      canvas.drawCircle(center, radius, paint);
    }
  }

  void _paintWaves(Canvas canvas, Size size, Random rng, List<Color> colors) {
    for (var w = 0; w < 3; w++) {
      final paint = Paint()..color = _overlay(colors, rng, 0.2);
      final path = Path();
      final baseY = size.height * (0.3 + w * 0.25);
      final amp = 20 + rng.nextDouble() * 40;
      path.moveTo(0, baseY);
      for (double x = 0; x <= size.width; x += 20) {
        path.lineTo(x, baseY + sin((x / size.width) * pi * 4) * amp);
      }
      path.lineTo(size.width, size.height);
      path.lineTo(0, size.height);
      path.close();
      canvas.drawPath(path, paint);
    }
  }

  void _paintLowPoly(Canvas canvas, Size size, Random rng, List<Color> colors) {
    for (var i = 0; i < 14; i++) {
      final paint = Paint()..color = _overlay(colors, rng, 0.18);
      final p1 = Offset(
        rng.nextDouble() * size.width,
        rng.nextDouble() * size.height,
      );
      final p2 =
          p1 +
          Offset(
            (rng.nextDouble() - 0.5) * 200,
            (rng.nextDouble() - 0.5) * 200,
          );
      final p3 =
          p1 +
          Offset(
            (rng.nextDouble() - 0.5) * 200,
            (rng.nextDouble() - 0.5) * 200,
          );
      canvas.drawPath(
        Path()
          ..moveTo(p1.dx, p1.dy)
          ..lineTo(p2.dx, p2.dy)
          ..lineTo(p3.dx, p3.dy)
          ..close(),
        paint,
      );
    }
  }

  void _paintStripes(Canvas canvas, Size size, Random rng, List<Color> colors) {
    final gap = size.width / (6 + rng.nextInt(6));
    for (double x = -size.height; x < size.width; x += gap) {
      final paint = Paint()
        ..color = _overlay(colors, rng, 0.12)
        ..strokeWidth = gap * 0.4
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(x, 0),
        Offset(x + size.height, size.height),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BackgroundPainter oldDelegate) =>
      oldDelegate.style != style;
}
