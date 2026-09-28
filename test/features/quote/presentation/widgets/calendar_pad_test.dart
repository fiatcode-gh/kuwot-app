import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kuwot/core/presentation/theme/app_theme.dart';
import 'package:kuwot/features/quote/domain/entities/background_style.dart';
import 'package:kuwot/features/quote/domain/entities/pad_day.dart';
import 'package:kuwot/features/quote/domain/entities/pad_page.dart';
import 'package:kuwot/features/quote/domain/entities/palettes.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/domain/entities/quote_group.dart';
import 'package:kuwot/features/quote/domain/entities/tear_kind.dart';
import 'package:kuwot/features/quote/presentation/widgets/calendar_pad.dart';
import 'package:kuwot/features/quote/presentation/widgets/page_header.dart';
import 'package:kuwot/features/quote/presentation/widgets/tear_sheet.dart';
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
  const topQuote = Quote(id: 1, body: 'Top quote', group: QuoteGroup.grow);
  const underQuote = Quote(id: 2, body: 'Under quote', group: QuoteGroup.rest);

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

      const nextQuote = Quote(
        id: 3,
        body: 'Next quote',
        group: QuoteGroup.rest,
      );
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
      expect(data.label, endsWith('Top quote'));
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

  group('the page slot corners nest with the edge sheets at rest, not square '
      'page paper underneath (F1)', () {
    final boundaryKey = GlobalKey();

    // Realistically wide quotes: a short fixture (as used elsewhere in
    // this file) lets `QuoteStrip`'s content size narrower than the page
    // and center, which would leave paper unpainted at the sides for a
    // reason unrelated to corner rounding and confound this probe.
    const wideTopQuote = Quote(
      id: 101,
      body:
          'The huge modern heresy is to alter the human soul to fit '
          'modern social conditions, instead of altering modern social '
          'conditions to fit the human soul.',
      group: QuoteGroup.grow,
    );
    const wideUnderQuote = Quote(
      id: 102,
      body:
          'Some men see things as they are and say why; I dream things '
          'that never were and say why not.',
      group: QuoteGroup.rest,
    );
    final widePageTop = PadPage(
      day: _yesterday,
      quote: wideTopQuote,
      header: style,
    );
    final widePageUnder = PadPage(
      day: _today,
      quote: wideUnderQuote,
      header: style,
    );
    final wideQuoteTop = PadPage(
      day: _today,
      quote: wideTopQuote,
      header: style,
    );
    final wideQuoteUnder = PadPage(
      day: _today,
      quote: wideUnderQuote,
      header: style,
    );

    const captureRatio = 4.0;

    Future<(ByteData, int)> capture(
      WidgetTester tester, {
      required PadPage top,
      required PadPage under,
      required TearKind tearKind,
      required ThemeData theme,
    }) async {
      await tester.pumpWidget(
        padTestApp(
          RepaintBoundary(
            key: boundaryKey,
            child: CalendarPad(
              top: top,
              under: under,
              tearKind: tearKind,
              revision: 0,
              onTornAway: () {},
              locale: const Locale('en', 'US'),
            ),
          ),
          theme: theme,
        ),
      );
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(boundaryKey),
      );
      final result = await tester.runAsync(() async {
        final image = await boundary.toImage(pixelRatio: captureRatio);
        final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        return (data!, image.width);
      });
      return result!;
    }

    // Reads the pixel at [point] (logical coordinates, relative to the
    // captured boundary), sampled a quarter-dp further into the corner
    // than [point] itself. `toImage`'s antialiasing softens roughly one
    // *physical* pixel around a clip edge; at `captureRatio` that band is
    // a quarter of a logical dp wide, well short of this nudge, so the
    // read lands cleanly on one side of the corner clip rather than in
    // its blend zone.
    Color colorAt(ByteData data, int imageWidth, Offset point) {
      final x = (point.dx * captureRatio).round();
      final y = (point.dy * captureRatio).round();
      final index = (y * imageWidth + x) * 4;
      return Color.fromARGB(
        data.getUint8(index + 3),
        data.getUint8(index),
        data.getUint8(index + 1),
        data.getUint8(index + 2),
      );
    }

    for (final kind in TearKind.values) {
      for (final themeEntry in {
        'light': lightTheme,
        'dark': darkTheme,
      }.entries) {
        testWidgets(
          '$kind, ${themeEntry.key} theme: 1dp inside each bottom corner '
          'shows the edge sheet, not page paper',
          (tester) async {
            final (data, imageWidth) = await capture(
              tester,
              top: kind == TearKind.page ? widePageTop : wideQuoteTop,
              under: kind == TearKind.page ? widePageUnder : wideQuoteUnder,
              tearKind: kind,
              theme: themeEntry.value,
            );

            final boundaryOrigin = tester.getTopLeft(find.byKey(boundaryKey));
            final pageRect = tester.getRect(find.byKey(PadFrame.pageKey));
            final edge1Rect = tester.getRect(find.byKey(PadFrame.edgeKeys[0]));

            // Well inside the page's own paper, away from any corner.
            final paperRef =
                Offset(pageRect.center.dx, pageRect.bottom - 20) -
                boundaryOrigin;
            // Well inside edge sheet 1's own flat middle, away from its
            // own (further down) rounded corners and its 1dp bottom
            // divider border.
            final edgeRef =
                Offset(edge1Rect.center.dx, edge1Rect.bottom - 2) -
                boundaryOrigin;
            final bottomLeft =
                Offset(pageRect.left + 1, pageRect.bottom - 1) - boundaryOrigin;
            final bottomRight =
                Offset(pageRect.right - 1, pageRect.bottom - 1) -
                boundaryOrigin;

            final paperColor = colorAt(data, imageWidth, paperRef);
            final edgeColor = colorAt(data, imageWidth, edgeRef);

            for (final corner in [bottomLeft, bottomRight]) {
              final cornerColor = colorAt(data, imageWidth, corner);
              expect(
                cornerColor,
                isNot(paperColor),
                reason: 'corner $corner should not show page paper',
              );
              expect(
                cornerColor,
                edgeColor,
                reason: 'corner $corner should show the edge sheet colour',
              );
            }
          },
        );
      }
    }
  });

  group('the torn paper moves in front of the pad (D8, task 15)', () {
    // The moving sheet's overlay visual is wrapped in `IgnorePointer`
    // (contract F2 correction): hit-testing it no longer proves it paints
    // above its surroundings, so these checks instead capture the actual
    // composited pixels and confirm the sheet's paint changes what was
    // there at rest.
    final boundaryKey = GlobalKey();

    Future<ValueNotifier<int>> pumpCapturablePad(
      WidgetTester tester, {
      required PadPage top,
      required PadPage under,
      required TearKind tearKind,
    }) async {
      final tornCount = ValueNotifier(0);
      await tester.pumpWidget(
        RepaintBoundary(
          key: boundaryKey,
          child: padTestApp(
            CalendarPad(
              top: top,
              under: under,
              tearKind: tearKind,
              revision: 0,
              onTornAway: () => tornCount.value++,
              locale: const Locale('en', 'US'),
            ),
          ),
        ),
      );
      return tornCount;
    }

    Future<(ByteData, int)> captureFrame(WidgetTester tester) async {
      final boundary = tester.renderObject<RenderRepaintBoundary>(
        find.byKey(boundaryKey),
      );
      final result = await tester.runAsync(() async {
        final image = await boundary.toImage();
        final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        return (data!, image.width);
      });
      return result!;
    }

    Color sampleColor(
      (ByteData, int) frame,
      Offset boundaryOrigin,
      Offset point,
    ) {
      final (data, imageWidth) = frame;
      final local = point - boundaryOrigin;
      final x = local.dx.round();
      final y = local.dy.round();
      final index = (y * imageWidth + x) * 4;
      return Color.fromARGB(
        data.getUint8(index + 3),
        data.getUint8(index),
        data.getUint8(index + 1),
        data.getUint8(index + 2),
      );
    }

    Future<Color> pixelAt(WidgetTester tester, Offset point) async {
      final frame = await captureFrame(tester);
      final origin = tester.getTopLeft(find.byKey(boundaryKey));
      return sampleColor(frame, origin, point);
    }

    HitTestResult hitTestAt(WidgetTester tester, Offset point) {
      final result = HitTestResult();
      tester.binding.renderViews.single.hitTest(result, position: point);
      return result;
    }

    bool pathIncludes(HitTestResult result, RenderObject target) =>
        result.path.any((entry) => entry.target == target);

    testWidgets(
      'a page tear springing back reaches above the binding, unclipped',
      (tester) async {
        await pumpCapturablePad(
          tester,
          top: pageTop,
          under: pageUnder,
          tearKind: TearKind.page,
        );
        final bindingCenter = tester
            .getRect(find.byKey(PadFrame.bindingKey))
            .center;
        final restColor = await pixelAt(tester, bindingCenter);

        final gesture = await tester.startGesture(
          tester.getCenter(find.text('24')),
        );
        // ~0.95 of the threshold: short of tearing, so releasing springs
        // back; `Curves.elasticOut` then overshoots well past rest,
        // carrying the sheet up over the binding for part of the animation.
        await gesture.moveBy(const Offset(0, 123.5));
        await tester.pump();
        await gesture.up();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 66));

        final duringColor = await pixelAt(tester, bindingCenter);
        expect(
          duringColor,
          isNot(restColor),
          reason:
              'the springing-back sheet should now be painting over the '
              'static binding',
        );

        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'a page tear flying away extends past the whole pad, unclipped',
      (tester) async {
        // Constrained to well under the test window so there is on-screen
        // room below the pad for the fly-away to reach into.
        final padKey = GlobalKey<CalendarPadState>();
        await tester.pumpWidget(
          RepaintBoundary(
            key: boundaryKey,
            child: padTestApp(
              Align(
                alignment: Alignment.topCenter,
                child: SizedBox(
                  height: 300,
                  width: 400,
                  child: CalendarPad(
                    key: padKey,
                    top: pageTop,
                    under: pageUnder,
                    tearKind: TearKind.page,
                    revision: 0,
                    onTornAway: () {},
                    locale: const Locale('en', 'US'),
                  ),
                ),
              ),
            ),
          ),
        );
        final pageBottom = tester.getRect(find.byKey(PadFrame.pageKey)).bottom;
        final finder = find.descendant(
          of: find.byType(TearSheet),
          matching: find.byType(RepaintBoundary),
        );

        // Captured before the fly starts, so it holds whatever painted at
        // rest at every coordinate — including wherever the sheet's own
        // content ends up once it has flown, sampled below.
        final restFrame = await captureFrame(tester);
        final boundaryOrigin = tester.getTopLeft(find.byKey(boundaryKey));

        unawaited(padKey.currentState!.tearAway());
        await tester.pump();
        // Past the whole pad already (contract-required geometry) but
        // still short of full transparency, so the paint-order check below
        // has a visible colour to compare — `_flyAway`'s opacity fade
        // reaches 0 by ~160ms into the 260ms flight.
        await tester.pump(const Duration(milliseconds: 140));

        final point = tester.getCenter(finder);
        expect(point.dy, greaterThan(pageBottom));

        final restColor = sampleColor(restFrame, boundaryOrigin, point);
        final duringColor = await pixelAt(tester, point);
        expect(
          duringColor,
          isNot(restColor),
          reason:
              'the flying sheet should now be painting below the pad, '
              'past where it was clipped before',
        );

        await tester.pumpAndSettle();
      },
    );

    testWidgets(
      'a quote tear springing back reaches above the header, unclipped',
      (tester) async {
        await pumpCapturablePad(
          tester,
          top: quoteTop,
          under: quoteUnder,
          tearKind: TearKind.quote,
        );
        final headerRect = tester.getRect(find.byType(PageHeader));
        final justInsideHeader = Offset(
          headerRect.center.dx,
          headerRect.bottom - 5,
        );
        final restColor = await pixelAt(tester, justInsideHeader);

        final gesture = await tester.startGesture(
          tester.getCenter(find.text('Top quote')),
        );
        await gesture.moveBy(const Offset(0, 123.5));
        await tester.pump();
        await gesture.up();
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 66));

        final duringColor = await pixelAt(tester, justInsideHeader);
        expect(
          duringColor,
          isNot(restColor),
          reason:
              'the springing-back sheet should now be painting over the '
              'static header',
        );

        await tester.pumpAndSettle();
      },
    );

    testWidgets('at rest, the binding is still painted above the page', (
      tester,
    ) async {
      await pumpPad(
        tester,
        top: pageTop,
        under: pageUnder,
        tearKind: TearKind.page,
      );
      final bindingRect = tester.getRect(find.byKey(PadFrame.bindingKey));
      final bindingRender = tester.renderObject(
        find.byKey(PadFrame.bindingKey),
      );

      expect(
        pathIncludes(hitTestAt(tester, bindingRect.center), bindingRender),
        isTrue,
      );
    });
  });
}
