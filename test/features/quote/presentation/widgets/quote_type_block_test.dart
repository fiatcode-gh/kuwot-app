import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/core/presentation/theme/app_fonts.dart';
import 'package:kuwot/features/quote/presentation/widgets/quote_type_block.dart';

const _body =
    'A quote long enough that even the smallest allowed font size barely '
    'fits inside a box sized to match it almost exactly.';
const _width = 320.0;
const _minFontSize = 14.0;

/// Mirrors `QuoteTypeBlock`'s own `heightAt` measurement at [_minFontSize],
/// so the test can construct a box exactly on the fitting boundary rather
/// than an arbitrarily tiny one — the regression only manifests when the
/// available height is a hair short, not wildly short.
double _measureMinHeight() {
  final bodyPainter = TextPainter(
    text: const TextSpan(
      text: _body,
      style: TextStyle(
        fontFamily: AppFonts.frauncesFamily,
        fontStyle: FontStyle.italic,
        fontSize: _minFontSize,
        height: 1.28,
      ),
    ),
    textAlign: TextAlign.center,
    textDirection: TextDirection.ltr,
  )..layout(maxWidth: _width);
  return bodyPainter.height;
}

void main() {
  Future<Object?> pumpInBox(
    WidgetTester tester, {
    required double height,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Align(
          alignment: Alignment.topLeft,
          child: SizedBox(
            width: _width,
            height: height,
            child: const QuoteTypeBlock(
              body: _body,
              ink: Colors.black,
              minFontSize: _minFontSize,
            ),
          ),
        ),
      ),
    );
    await tester.pump();
    return tester.takeException();
  }

  testWidgets('fits a generously sized box without scrolling or overflowing', (
    tester,
  ) async {
    final generousHeight = _measureMinHeight() + 200;
    final exception = await pumpInBox(tester, height: generousHeight);

    expect(exception, isNull);
    expect(find.byType(SingleChildScrollView), findsNothing);
  });

  testWidgets(
    'falls back to scrolling instead of overflowing when the minimum font '
    'size is a hair short of the available height',
    (tester) async {
      // Just under the height the minimum font size needs — a hairline
      // shortfall, not an arbitrarily tiny box. A lenient fits-check that
      // tolerates a small fudge factor against the raw box height would
      // wrongly accept this and let the Column overflow for real.
      final hairlineHeight = _measureMinHeight() - 0.2;
      final exception = await pumpInBox(tester, height: hairlineHeight);

      expect(
        exception,
        isNull,
        reason: 'quote overflowed instead of scrolling',
      );
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    },
  );
}
