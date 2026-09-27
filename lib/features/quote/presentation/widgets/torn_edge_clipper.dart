import 'package:flutter/rendering.dart';
import 'package:kuwot/features/quote/presentation/widgets/calendar_pad.dart';

/// Clips a page to a rectangle at rest, and to a jagged top edge as it tears
/// away from the binding. `jag` is 0 (resting) to 1 (fully torn). The top is
/// square, since the real page starts glued flat to the binding — but the
/// bottom-left and bottom-right corners are always rounded by
/// [PadFrame.cornerRadius], at rest and throughout the tear, matching the
/// pad frame's rounded corners (contract G5, D6).
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
    const r = PadFrame.cornerRadius;
    if (t <= 0.001) {
      return Path()..addRRect(
        RRect.fromRectAndCorners(
          Rect.fromLTWH(0, 0, w, h),
          bottomLeft: const Radius.circular(r),
          bottomRight: const Radius.circular(r),
        ),
      );
    }

    final bite = _maxBite * t;
    final segW = w / teeth.length;

    final path = Path()..moveTo(0, bite * teeth.first);
    for (var i = 1; i < teeth.length; i++) {
      path.lineTo(segW * i, bite * teeth[i]);
    }
    path.lineTo(w, bite * teeth.last);
    path.lineTo(w, h - r);
    path.arcToPoint(Offset(w - r, h), radius: const Radius.circular(r));
    path.lineTo(r, h);
    path.arcToPoint(Offset(0, h - r), radius: const Radius.circular(r));
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant TornEdgeClipper oldClipper) =>
      oldClipper.jag != jag || oldClipper.teeth != teeth;
}
