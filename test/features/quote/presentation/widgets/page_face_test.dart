import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kuwot/core/presentation/theme/app_theme.dart';
import 'package:kuwot/features/quote/domain/entities/background_style.dart';
import 'package:kuwot/features/quote/domain/entities/pad_day.dart';
import 'package:kuwot/features/quote/domain/entities/pad_page.dart';
import 'package:kuwot/features/quote/domain/entities/palettes.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/presentation/widgets/page_face.dart';
import 'package:kuwot/features/quote/presentation/widgets/page_header.dart';
import 'package:kuwot/features/quote/presentation/widgets/quote_type_block.dart';
import 'package:kuwot/features/quote/presentation/widgets/share_page_card.dart';

import '../../../../helpers/load_app_fonts.dart';
import '../../../../helpers/pad_test_app.dart';
import '../../../../helpers/quote_fixtures.dart';

// A Friday; only relevant so the locale assertions below have a known
// expected weekday name.
const _day = PadDay(2026, 9, 25);

void main() {
  setUpAll(() async {
    await loadAppFonts();
    await initializeDateFormatting();
  });

  final style = BackgroundStyle(seed: _day.seed, palette: kPalettes.first);

  group('PageHeader date locale (G11)', () {
    testWidgets('reads the weekday and month from the device locale', (
      tester,
    ) async {
      tester.platformDispatcher.localeTestValue = const Locale('id', 'ID');
      addTearDown(tester.platformDispatcher.clearLocaleTestValue);

      await tester.pumpWidget(padTestApp(PageHeader(day: _day, style: style)));

      expect(find.text('JUMAT'), findsOneWidget);
      expect(find.text('SEPTEMBER'), findsOneWidget);
    });

    testWidgets('reads English labels for en_US', (tester) async {
      tester.platformDispatcher.localeTestValue = const Locale('en', 'US');
      addTearDown(tester.platformDispatcher.clearLocaleTestValue);

      await tester.pumpWidget(padTestApp(PageHeader(day: _day, style: style)));

      expect(find.text('FRIDAY'), findsOneWidget);
    });
  });

  testWidgets(
    'PageHeader scales its content down instead of overflowing at a large '
    'text scale',
    (tester) async {
      await tester.pumpWidget(
        padTestApp(
          SizedBox(
            width: 320,
            height: 140,
            child: PageHeader(day: _day, style: style),
          ),
          textScale: 2.0,
        ),
      );

      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'QuoteTypeBlock does not overflow the longest quote at a large text '
    'scale',
    (tester) async {
      await tester.pumpWidget(
        padTestApp(
          SizedBox(
            width: 320,
            height: 300,
            child: QuoteTypeBlock(
              body: kLongestBodyQuote.body,
              author: kLongestBodyQuote.author,
              ink: Colors.black,
              inkMuted: Colors.black54,
            ),
          ),
          textScale: 2.0,
        ),
      );

      expect(tester.takeException(), isNull);
    },
  );

  group('SharePageCard (G10)', () {
    final themes = {'light': lightTheme, 'dark': darkTheme};
    final quotes = [kLongestBodyQuote, kLongestAuthorQuote];

    for (final themeEntry in themes.entries) {
      for (final quote in quotes) {
        testWidgets(
          'fits the whole page at 360x640, ${themeEntry.key} theme, quote '
          '${quote.id}, at a large text scale',
          (tester) async {
            tester.view.physicalSize = const Size(800, 1400);
            tester.view.devicePixelRatio = 1.0;
            addTearDown(tester.view.reset);

            final page = PadPage(day: _day, quote: quote, header: style);

            await tester.pumpWidget(
              padTestApp(
                Center(child: SharePageCard(page: page)),
                theme: themeEntry.value,
                textScale: 2.0,
              ),
            );

            expect(
              tester.getSize(find.byType(SharePageCard)),
              const Size(360, 640),
            );
            expect(tester.takeException(), isNull);
            expect(find.byType(SingleChildScrollView), findsNothing);
            expect(find.text(quote.body), findsOneWidget);
            expect(find.text('— ${quote.author}'), findsOneWidget);
          },
        );
      }
    }
  });

  group(
    'QuoteTypeBlock.measuredTextHeight pins the real rendered height '
    '(regression: Text merges the ambient DefaultTextStyle, so a bare '
    "AppFonts style alone under-measures whichever fields it doesn't set)",
    () {
      Future<void> expectMeasurementPinsRender(
        WidgetTester tester,
        Widget host,
        Quote quote,
      ) async {
        tester.view.physicalSize = const Size(800, 1600);
        tester.view.devicePixelRatio = 1.0;
        addTearDown(tester.view.reset);

        await tester.pumpWidget(host);

        expect(tester.takeException(), isNull);
        expect(find.byType(SingleChildScrollView), findsNothing);

        final bodyFinder = find.text(quote.body);
        final authorFinder = find.text('— ${quote.author}');
        expect(bodyFinder, findsOneWidget);
        expect(authorFinder, findsOneWidget);

        // The rendered `Text`'s own (un-merged) style and size: `Text`'s
        // default `textWidthBasis` is `TextWidthBasis.parent`, so its
        // reported width is exactly the constraint it wrapped against —
        // safe to feed straight back into `measuredTextHeight`.
        final bodyText = tester.widget<Text>(bodyFinder);
        final authorText = tester.widget<Text>(authorFinder);
        final bodyRenderSize = tester.getSize(bodyFinder);
        final authorRenderSize = tester.getSize(authorFinder);
        final context = tester.element(bodyFinder);
        final textScaler = MediaQuery.textScalerOf(context);

        final measuredBodyHeight = QuoteTypeBlock.measuredTextHeight(
          context: context,
          text: quote.body,
          style: bodyText.style!,
          maxWidth: bodyRenderSize.width,
          textScaler: textScaler,
        );
        final measuredAuthorHeight = QuoteTypeBlock.measuredTextHeight(
          context: context,
          text: '— ${quote.author}',
          style: authorText.style!,
          maxWidth: authorRenderSize.width,
          textScaler: textScaler,
        );

        expect(
          (measuredBodyHeight - bodyRenderSize.height).abs(),
          lessThanOrEqualTo(1.0),
          reason:
              'body: measured $measuredBodyHeight vs rendered '
              '${bodyRenderSize.height}',
        );
        expect(
          (measuredAuthorHeight - authorRenderSize.height).abs(),
          lessThanOrEqualTo(1.0),
          reason:
              'author: measured $measuredAuthorHeight vs rendered '
              '${authorRenderSize.height}',
        );
      }

      for (final quote in [kLongestBodyQuote, kLongestAuthorQuote]) {
        testWidgets('SharePageCard box (360x640), quote ${quote.id}', (
          tester,
        ) async {
          final page = PadPage(day: _day, quote: quote, header: style);
          await expectMeasurementPinsRender(
            tester,
            padTestApp(Center(child: SharePageCard(page: page))),
            quote,
          );
        });

        testWidgets('360x640 phone page, quote ${quote.id}', (tester) async {
          final page = PadPage(day: _day, quote: quote, header: style);
          await expectMeasurementPinsRender(
            tester,
            padTestApp(
              SizedBox(width: 360, height: 640, child: PageFace(page: page)),
            ),
            quote,
          );
        });

        testWidgets('412x915 phone page, quote ${quote.id}', (tester) async {
          final page = PadPage(day: _day, quote: quote, header: style);
          await expectMeasurementPinsRender(
            tester,
            padTestApp(
              SizedBox(width: 412, height: 915, child: PageFace(page: page)),
            ),
            quote,
          );
        });
      }
    },
  );
}
