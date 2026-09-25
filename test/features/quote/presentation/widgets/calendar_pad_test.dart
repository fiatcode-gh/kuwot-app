import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kuwot/features/quote/domain/entities/background_style.dart';
import 'package:kuwot/features/quote/domain/entities/pad_day.dart';
import 'package:kuwot/features/quote/domain/entities/pad_page.dart';
import 'package:kuwot/features/quote/domain/entities/palettes.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/domain/entities/tear_kind.dart';
import 'package:kuwot/features/quote/presentation/widgets/calendar_pad.dart';
import 'package:kuwot/features/quote/presentation/widgets/torn_edge_clipper.dart';

import '../../../../helpers/load_app_fonts.dart';
import '../../../../helpers/pad_test_app.dart';

// Yesterday's leftover page (page tear) and today (used for both the page
// tear's `under` and every quote-tear fixture below, since a quote tear
// always keeps the same day).
const _yesterday = PadDay(2026, 9, 24);
const _today = PadDay(2026, 9, 25);

void main() {
  setUpAll(() async {
    await loadAppFonts();
    await initializeDateFormatting();
  });

  final style = BackgroundStyle(seed: 1, palette: kPalettes.first);
  const topQuote = Quote(id: 1, body: 'Top quote', author: 'A');
  const underQuote = Quote(id: 2, body: 'Under quote', author: 'B');

  // Page tear: an older top page torn away to reveal today underneath.
  final pageTop = PadPage(day: _yesterday, quote: topQuote, header: style);
  final pageUnder = PadPage(day: _today, quote: underQuote, header: style);

  // Quote tear: same day, a fresh quote underneath, the same header.
  final quoteTop = PadPage(day: _today, quote: topQuote, header: style);
  final quoteUnder = PadPage(day: _today, quote: underQuote, header: style);

  /// Pumps a [CalendarPad] hosted by [padTestApp] and returns a counter that
  /// tracks how many times `onTornAway` has fired so far.
  Future<ValueNotifier<int>> pumpPad(
    WidgetTester tester, {
    required PadPage top,
    required PadPage under,
    required TearKind tearKind,
    int revision = 0,
    bool disableAnimations = false,
    Key? padKey,
  }) async {
    final tornCount = ValueNotifier(0);
    await tester.pumpWidget(
      padTestApp(
        CalendarPad(
          key: padKey,
          top: top,
          under: under,
          tearKind: tearKind,
          revision: revision,
          onTornAway: () => tornCount.value++,
          locale: const Locale('en', 'US'),
        ),
        disableAnimations: disableAnimations,
      ),
    );
    return tornCount;
  }

  group('PadFrame symmetry at rest (G5)', () {
    for (final kind in TearKind.values) {
      testWidgets(
        '$kind: binding, page and both edge sheets share left/right, the '
        'edges show a 4dp and 8dp step below the page, and the page starts '
        "at the binding's bottom",
        (tester) async {
          await pumpPad(
            tester,
            top: kind == TearKind.page ? pageTop : quoteTop,
            under: kind == TearKind.page ? pageUnder : quoteUnder,
            tearKind: kind,
          );

          final bindingRect = tester.getRect(find.byKey(PadFrame.bindingKey));
          final pageRect = tester.getRect(find.byKey(PadFrame.pageKey));
          final edge1Rect = tester.getRect(find.byKey(PadFrame.edgeKeys[0]));
          final edge2Rect = tester.getRect(find.byKey(PadFrame.edgeKeys[1]));

          for (final rect in [pageRect, edge1Rect, edge2Rect]) {
            expect(rect.left, bindingRect.left);
            expect(rect.right, bindingRect.right);
          }
          expect(edge1Rect.bottom, pageRect.bottom + 4);
          expect(edge2Rect.bottom, pageRect.bottom + 8);
          expect(pageRect.top, bindingRect.bottom);
        },
      );
    }
  });

  testWidgets('mid-drag on a quote tear reveals the under quote and leaves the '
      'header in place', (tester) async {
    await pumpPad(
      tester,
      top: quoteTop,
      under: quoteUnder,
      tearKind: TearKind.quote,
    );

    final restTop = tester.getTopLeft(find.text('Top quote'));
    final restNumeral = tester.getTopLeft(find.text('25'));
    final restMonth = tester.getTopLeft(find.text('SEPTEMBER'));

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Top quote')),
    );
    await gesture.moveBy(const Offset(0, 100));
    await tester.pump();

    expect(find.text('Under quote'), findsOneWidget);
    final draggedTop = tester.getTopLeft(find.text('Top quote'));
    expect(draggedTop.dy - restTop.dy, greaterThanOrEqualTo(50));
    expect(tester.getTopLeft(find.text('25')), restNumeral);
    expect(tester.getTopLeft(find.text('SEPTEMBER')), restMonth);

    await gesture.up();
    await tester.pumpAndSettle();
  });

  testWidgets(
    'a completed quote tear (past the threshold) fires onTornAway once and '
    'removes the top quote',
    (tester) async {
      final tornCount = await pumpPad(
        tester,
        top: quoteTop,
        under: quoteUnder,
        tearKind: TearKind.quote,
      );

      await tester.timedDrag(
        find.text('Top quote'),
        const Offset(0, 200),
        const Duration(milliseconds: 600),
      );
      await tester.pumpAndSettle();

      expect(tornCount.value, 1);
      expect(find.text('Top quote').hitTestable(), findsNothing);
    },
  );

  testWidgets(
    'a short quote drag (short of the threshold) springs back without '
    'tearing',
    (tester) async {
      final tornCount = await pumpPad(
        tester,
        top: quoteTop,
        under: quoteUnder,
        tearKind: TearKind.quote,
      );
      final restTop = tester.getTopLeft(find.text('Top quote'));

      await tester.timedDrag(
        find.text('Top quote'),
        const Offset(0, 60),
        const Duration(milliseconds: 600),
      );
      await tester.pumpAndSettle();

      expect(tornCount.value, 0);
      expect(tester.getTopLeft(find.text('Top quote')), restTop);
    },
  );

  testWidgets(
    'mid-drag on a page tear reveals the under page while the old page '
    'moves away, and completing it fires onTornAway once',
    (tester) async {
      final tornCount = await pumpPad(
        tester,
        top: pageTop,
        under: pageUnder,
        tearKind: TearKind.page,
      );

      final restTop = tester.getTopLeft(find.text('24'));

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('24')),
      );
      await gesture.moveBy(const Offset(0, 100));
      await tester.pump();

      expect(find.text('25'), findsOneWidget);
      final draggedTop = tester.getTopLeft(find.text('24'));
      expect(draggedTop.dy - restTop.dy, greaterThanOrEqualTo(50));

      await gesture.moveBy(const Offset(0, 100));
      await gesture.up();
      await tester.pumpAndSettle();

      expect(tornCount.value, 1);
    },
  );

  testWidgets(
    'the on-screen control tears exactly once, even if invoked twice back '
    'to back',
    (tester) async {
      final padKey = GlobalKey<CalendarPadState>();
      final tornCount = await pumpPad(
        tester,
        top: quoteTop,
        under: quoteUnder,
        tearKind: TearKind.quote,
        padKey: padKey,
      );

      unawaited(padKey.currentState!.tearAway());
      unawaited(padKey.currentState!.tearAway());
      await tester.pumpAndSettle();

      expect(tornCount.value, 1);
    },
  );

  group('reduced motion (G8 fade)', () {
    testWidgets('mid-drag does not move the sheet; a completed drag fades over '
        '150ms', (tester) async {
      final tornCount = await pumpPad(
        tester,
        top: quoteTop,
        under: quoteUnder,
        tearKind: TearKind.quote,
        disableAnimations: true,
      );
      final restTop = tester.getTopLeft(find.text('Top quote'));

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Top quote')),
      );
      await gesture.moveBy(const Offset(0, 200));
      await tester.pump();

      expect(tester.getTopLeft(find.text('Top quote')), restTop);

      await gesture.up();
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));
      expect(tornCount.value, 0);
      await tester.pump(const Duration(milliseconds: 100));
      expect(tornCount.value, 1);
    });

    testWidgets('a short drag (short of the threshold) does not tear', (
      tester,
    ) async {
      final tornCount = await pumpPad(
        tester,
        top: quoteTop,
        under: quoteUnder,
        tearKind: TearKind.quote,
        disableAnimations: true,
      );

      await tester.timedDrag(
        find.text('Top quote'),
        const Offset(0, 60),
        const Duration(milliseconds: 600),
      );
      await tester.pump(const Duration(milliseconds: 200));

      expect(tornCount.value, 0);
    });

    testWidgets('the control fades too, within 200ms', (tester) async {
      final padKey = GlobalKey<CalendarPadState>();
      final tornCount = await pumpPad(
        tester,
        top: quoteTop,
        under: quoteUnder,
        tearKind: TearKind.quote,
        disableAnimations: true,
        padKey: padKey,
      );

      unawaited(padKey.currentState!.tearAway());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      expect(tornCount.value, 1);
    });
  });

  testWidgets(
    'a revision change replaces the sheet with a fresh one at its rest '
    'position',
    (tester) async {
      final padKey = GlobalKey<CalendarPadState>();
      final tornCount = await pumpPad(
        tester,
        top: quoteTop,
        under: quoteUnder,
        tearKind: TearKind.quote,
        padKey: padKey,
      );
      final restY = tester.getTopLeft(find.text('Top quote')).dy;

      await tester.timedDrag(
        find.text('Top quote'),
        const Offset(0, 200),
        const Duration(milliseconds: 600),
      );
      await tester.pumpAndSettle();
      expect(tornCount.value, 1);

      const nextQuote = Quote(id: 3, body: 'Next quote', author: 'C');
      final nextUnder = PadPage(day: _today, quote: nextQuote, header: style);

      await tester.pumpWidget(
        padTestApp(
          CalendarPad(
            key: padKey,
            top: quoteUnder,
            under: nextUnder,
            tearKind: TearKind.quote,
            revision: 1,
            onTornAway: () => tornCount.value++,
            locale: const Locale('en', 'US'),
          ),
        ),
      );

      expect(find.text('Under quote').hitTestable(), findsOneWidget);
      expect(tester.getTopLeft(find.text('Under quote')).dy, restY);
    },
  );

  testWidgets(
    'the pad exposes a single semantics node describing only the top page: '
    'no under content, no duplicated text, no scroll actions from the pan '
    'detector',
    (tester) async {
      final semantics = tester.ensureSemantics();
      await pumpPad(
        tester,
        top: quoteTop,
        under: quoteUnder,
        tearKind: TearKind.quote,
      );

      final node = tester.getSemantics(find.byType(CalendarPad));
      final data = node.getSemanticsData();

      expect(data.label, contains('Top quote'));
      expect(data.label, isNot(contains('Under quote')));
      expect(node.childrenCount, 0);
      expect(find.bySemanticsLabel(RegExp('Under quote')), findsNothing);
      for (final action in [
        SemanticsAction.scrollUp,
        SemanticsAction.scrollDown,
        SemanticsAction.scrollLeft,
        SemanticsAction.scrollRight,
      ]) {
        expect(data.hasAction(action), isFalse);
      }

      semantics.dispose();
    },
  );

  group('rounded pad corners (D6)', () {
    const size = Size(300, 400);
    final restingTeeth = List<double>.filled(6, 0.0);

    Path pageClip(double jag) =>
        TornEdgeClipper(jag: jag, teeth: restingTeeth).getClip(size);

    test('at rest, the page clip keeps square top corners and rounds the '
        'bottom ones by PadFrame.cornerRadius', () {
      final clip = pageClip(0);

      expect(clip.contains(const Offset(1, 1)), isTrue);
      expect(clip.contains(Offset(size.width - 1, 1)), isTrue);
      expect(clip.contains(Offset(1, size.height - 1)), isFalse);
      expect(clip.contains(Offset(size.width - 1, size.height - 1)), isFalse);
    });

    test('during a tear (jag 0.5) the bottom corners are still excluded', () {
      final clip = pageClip(0.5);

      expect(clip.contains(Offset(1, size.height - 1)), isFalse);
      expect(clip.contains(Offset(size.width - 1, size.height - 1)), isFalse);
    });

    testWidgets(
      "the binding's top corners are rounded and its bottom corners are "
      'square',
      (tester) async {
        await pumpPad(
          tester,
          top: quoteTop,
          under: quoteUnder,
          tearKind: TearKind.quote,
        );

        final decoration =
            tester
                    .widget<DecoratedBox>(
                      find
                          .descendant(
                            of: find.byKey(PadFrame.bindingKey),
                            matching: find.byType(DecoratedBox),
                          )
                          .first,
                    )
                    .decoration
                as BoxDecoration;
        final rect =
            Offset.zero & tester.getSize(find.byKey(PadFrame.bindingKey));
        final clip = decoration.getClipPath(rect, TextDirection.ltr);

        expect(clip.contains(const Offset(1, 1)), isFalse);
        expect(clip.contains(Offset(rect.width - 1, 1)), isFalse);
        expect(clip.contains(Offset(1, rect.height - 1)), isTrue);
        expect(clip.contains(Offset(rect.width - 1, rect.height - 1)), isTrue);
      },
    );

    testWidgets(
      'both edge sheets use PadFrame.cornerRadius for their bottom corners',
      (tester) async {
        await pumpPad(
          tester,
          top: quoteTop,
          under: quoteUnder,
          tearKind: TearKind.quote,
        );

        const expected = BorderRadius.only(
          bottomLeft: Radius.circular(PadFrame.cornerRadius),
          bottomRight: Radius.circular(PadFrame.cornerRadius),
        );
        for (final key in PadFrame.edgeKeys) {
          final decoration =
              tester
                      .widget<DecoratedBox>(
                        find
                            .descendant(
                              of: find.byKey(key),
                              matching: find.byType(DecoratedBox),
                            )
                            .first,
                      )
                      .decoration
                  as BoxDecoration;
          expect(decoration.borderRadius, expected);
        }
      },
    );
  });
}
