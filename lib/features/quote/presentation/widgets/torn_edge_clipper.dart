import 'package:flutter/rendering.dart';

/// Clips a page to a full rectangle at rest, and to a jagged top edge as it
/// tears away from the binding. `jag` is 0 (resting) to 1 (fully torn). The
/// bottom and side corners are always square — a real pad page is cut flat
/// everywhere except the top, where the page is glued to the pad.
class TornEdgeClipper extends CustomClipper<Path> {
  const TornEdgeClipper({required this.jag, required this.teeth});

  /// 0 (rest) .. 1 (fully torn). Values are not clamped here so callers can
  /// hold the shape at its fully-torn silhouette while the page continues
  /// translating off-screen.
  final double jag;

  /// Per-page, stable jitter (0..1 each) describing how deep the tear bites
  /// at each point along the top edge. Regenerated per page so no two pages
  /// tear identically.
  final List<double> teeth;

  static const double _maxBite = 26;

  @override
  Path getClip(Size size) {
    final t = jag <= 0 ? 0.0 : (jag > 1 ? 1.0 : jag);
    final w = size.width;
    final h = size.height;
    if (t <= 0.001) {
      return Path()..addRect(Rect.fromLTWH(0, 0, w, h));
    }

    final bite = _maxBite * t;
    final segW = w / teeth.length;

    final path = Path()..moveTo(0, bite * teeth.first);
    for (var i = 1; i < teeth.length; i++) {
      path.lineTo(segW * i, bite * teeth[i]);
    }
    path.lineTo(w, bite * teeth.last);
    path.lineTo(w, h);
    path.lineTo(0, h);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant TornEdgeClipper oldClipper) =>
      oldClipper.jag != jag || oldClipper.teeth != teeth;
}
