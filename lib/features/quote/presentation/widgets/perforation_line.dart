import 'package:flutter/material.dart';
import 'package:kuwot/core/presentation/theme/app_palette.dart';

/// A dashed line marking where the same-day quote strip tears away from the
/// fixed header above it. Purely decorative when the whole page tears as
/// one unit (an older, not-yet-caught-up page); the actual tear line for a
/// same-day quote-only tear.
class PerforationLine extends StatelessWidget {
  const PerforationLine({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return ColoredBox(
      color: palette.paper,
      child: SizedBox(
        height: 12,
        width: double.infinity,
        child: CustomPaint(painter: _DashPainter(color: palette.divider)),
      ),
    );
  }
}

class _DashPainter extends CustomPainter {
  const _DashPainter({required this.color});

  final Color color;

  static const _dashWidth = 6.0;
  static const _gapWidth = 5.0;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;
    final y = size.height / 2;
    var x = 0.0;
    while (x < size.width) {
      canvas.drawLine(Offset(x, y), Offset(x + _dashWidth, y), paint);
      x += _dashWidth + _gapWidth;
    }
  }

  @override
  bool shouldRepaint(covariant _DashPainter oldDelegate) =>
      oldDelegate.color != color;
}
