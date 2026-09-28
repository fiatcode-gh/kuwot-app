import 'package:flutter/material.dart';
import 'package:kuwot/core/presentation/theme/app_fonts.dart';

/// The quote body, sized to fill (not overflow) whatever space it is given.
/// Source quotes are at most 74 characters, but the fit search still guards
/// any box size and any text scale factor.
///
/// Finds the largest quote font size (within [minFontSize]..[maxFontSize])
/// whose measured height fits the available box, via a bounded binary
/// search over real [TextPainter] layout (not [FittedBox], which would
/// squash line breaks). Scrolling is the last-resort fallback if even the
/// minimum doesn't fit.
class QuoteTypeBlock extends StatelessWidget {
  const QuoteTypeBlock({
    super.key,
    required this.body,
    required this.ink,
    this.minFontSize = 14,
    this.maxFontSize = 30,
  });

  final String body;
  final Color ink;
  final double minFontSize;
  final double maxFontSize;

  /// The exact height [Text] will render [text] at, in [context], with
  /// [style] and [textScaler], wrapped to [maxWidth]. Replicates the merge
  /// `Text.build` performs against the ambient `DefaultTextStyle` — a plain
  /// [TextPainter] laid out with the bare, un-merged [style] under-measures
  /// whenever a field [style] leaves unset (notably `height`) differs from
  /// the ambient default, which is exactly what let the longest quote
  /// fixture overflow past this widget's own fit search. Exposed (not
  /// private) so a test can pin that this stays exact; also the single
  /// source of truth [heightAt] below searches against.
  static double measuredTextHeight({
    required BuildContext context,
    required String text,
    required TextStyle style,
    required double maxWidth,
    required TextScaler textScaler,
  }) {
    final effectiveStyle = DefaultTextStyle.of(context).style.merge(style);
    final painter = TextPainter(
      text: TextSpan(text: text, style: effectiveStyle),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      textScaler: textScaler,
    )..layout(maxWidth: maxWidth);
    return painter.height;
  }

  @override
  Widget build(BuildContext context) {
    final textScaler = MediaQuery.textScalerOf(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxWidth = constraints.maxWidth;
        final maxHeight = constraints.maxHeight;

        double heightAt(double fontSize) {
          return measuredTextHeight(
            context: context,
            text: body,
            style: AppFonts.quoteBody(size: fontSize, color: ink),
            maxWidth: maxWidth,
            textScaler: textScaler,
          );
        }

        // On a wide page (tablet) the fixed 30pt cap left a short quote
        // looking small and lost inside a much bigger box; let the cap grow
        // with the available width. On phone widths this stays clamped to
        // maxFontSize, so it changes nothing there.
        final widthScaledMax = (maxWidth / 11).clamp(maxFontSize, 44.0);
        // `heightAt` now measures the exact style `Text` paints (including
        // the `DefaultTextStyle` merge), so this only needs to absorb
        // floating-point layout rounding, not a real metrics gap.
        final searchHeight = maxHeight - 2.0;
        var lo = minFontSize;
        var hi = widthScaledMax;
        if (heightAt(lo) <= searchHeight) {
          for (var i = 0; i < 12; i++) {
            final mid = (lo + hi) / 2;
            if (heightAt(mid) <= searchHeight) {
              lo = mid;
            } else {
              hi = mid;
            }
          }
        } else {
          hi = lo; // even the minimum overflows; fall back to scrolling below.
        }

        final fontSize = lo;
        final content = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              body,
              textAlign: TextAlign.center,
              style: AppFonts.quoteBody(size: fontSize, color: ink),
            ),
          ],
        );

        // Compare against the same safety-margined budget the search used —
        // not the raw box height — so this edge case (the minimum font size
        // still doesn't truly fit on a real device) reliably falls through
        // to scrolling instead of risking a hairline overflow.
        final fits = heightAt(fontSize) <= searchHeight;
        if (fits) return content;
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: maxHeight),
            child: content,
          ),
        );
      },
    );
  }
}
