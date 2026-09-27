import 'package:flutter/material.dart';
import 'package:kuwot/core/presentation/theme/app_fonts.dart';

/// The quote body and author line, sized to fill (not overflow) whatever
/// space it is given. Quotes run up to 150 characters and authors up to 219
/// (some are themselves a second sentence, not a byline), so a fixed font
/// size either wastes space on short quotes or overflows on long ones.
///
/// Finds the largest quote font size (within [minFontSize]..[maxFontSize])
/// whose measured height — quote plus author, at their fixed size ratio —
/// fits the available box, via a bounded binary search over real
/// [TextPainter] layout (not [FittedBox], which would squash line breaks).
/// Scrolling is the last-resort fallback if even the minimum doesn't fit.
class QuoteTypeBlock extends StatelessWidget {
  const QuoteTypeBlock({
    super.key,
    required this.body,
    required this.author,
    required this.ink,
    required this.inkMuted,
    this.minFontSize = 14,
    this.maxFontSize = 30,
  });

  final String body;
  final String author;
  final Color ink;
  final Color inkMuted;
  final double minFontSize;
  final double maxFontSize;

  static const _authorRatio = 0.42;
  static const _gapRatio = 0.6;

  /// The exact height [Text] will render [text] at, in [context], with
  /// [style] and [textScaler], wrapped to [maxWidth]. Replicates the merge
  /// `Text.build` performs against the ambient `DefaultTextStyle` — a plain
  /// [TextPainter] laid out with the bare, un-merged [style] under-measures
  /// whenever a field [style] leaves unset (notably `height`) differs from
  /// the ambient default, which is exactly what let the longest quote and
  /// author fixtures overflow past this widget's own fit search. Exposed
  /// (not private) so a test can pin that this stays exact; also the single
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
          final bodyHeight = measuredTextHeight(
            context: context,
            text: body,
            style: AppFonts.quoteBody(size: fontSize, color: ink),
            maxWidth: maxWidth,
            textScaler: textScaler,
          );
          final authorSize = (fontSize * _authorRatio).clamp(12.0, 17.0);
          final authorHeight = measuredTextHeight(
            context: context,
            text: '— $author',
            style: AppFonts.body(
              size: authorSize,
              color: inkMuted,
              weight: 500,
            ),
            maxWidth: maxWidth,
            textScaler: textScaler,
          );
          return bodyHeight + fontSize * _gapRatio + authorHeight;
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
        final authorSize = (fontSize * _authorRatio).clamp(12.0, 17.0);
        final content = Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              body,
              textAlign: TextAlign.center,
              style: AppFonts.quoteBody(size: fontSize, color: ink),
            ),
            SizedBox(height: fontSize * _gapRatio),
            Text(
              '— $author',
              textAlign: TextAlign.center,
              style: AppFonts.body(
                size: authorSize,
                color: inkMuted,
                weight: 500,
              ),
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
