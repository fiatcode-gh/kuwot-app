import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kuwot/core/presentation/theme/app_theme.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/presentation/quote_page.dart';
import 'package:kuwot/features/quote/presentation/widgets/calendar_pad.dart';
import 'package:kuwot/features/quote/presentation/widgets/control_dock.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/load_app_fonts.dart';
import '../../../helpers/pad_fakes.dart';
import '../../../helpers/quote_fixtures.dart';

/// Pumps a fresh [QuotePage] at [size] and [textScale] with [quote] as the
/// first drawn (and therefore top) quote, and returns once the first load
/// has settled.
Future<void> _pumpAt(
  WidgetTester tester, {
  required Size size,
  required ThemeData theme,
  required Quote quote,
  double textScale = 1.0,
}) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  SharedPreferences.setMockInitialValues({});
  final bloc = await buildPadBloc(
    time: FakeTime(DateTime(2026, 9, 25)),
    quotes: FakeQuoteRepository(queue: [quote]),
  );

  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      home: Builder(
        builder: (context) {
          final mediaQuery = MediaQuery.of(context);
          return MediaQuery(
            data: mediaQuery.copyWith(textScaler: TextScaler.linear(textScale)),
            child: BlocProvider.value(value: bloc, child: const QuotePage()),
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    await initializeDateFormatting();
  });

  const sizes = {
    '360x640': Size(360, 640),
    '411x914': Size(411, 914),
    '800x1280': Size(800, 1280),
    '1280x800': Size(1280, 800),
  };
  final themes = {'light': lightTheme, 'dark': darkTheme};
  const quotes = {
    'longest body': kLongestBodyQuote,
    'longest author': kLongestAuthorQuote,
  };

  for (final sizeEntry in sizes.entries) {
    for (final themeEntry in themes.entries) {
      for (final quoteEntry in quotes.entries) {
        testWidgets(
          '${sizeEntry.key} ${themeEntry.key} ${quoteEntry.key} does not '
          'overflow',
          (tester) async {
            await _pumpAt(
              tester,
              size: sizeEntry.value,
              theme: themeEntry.value,
              quote: quoteEntry.value,
            );

            expect(tester.takeException(), isNull);
            if (sizeEntry.key != '360x640') {
              expect(find.byType(SingleChildScrollView), findsNothing);
            }
          },
        );
      }
    }
  }

  testWidgets('411x914 at 2x text scale with the longest author quote does not '
      'overflow (scroll fallback allowed)', (tester) async {
    await _pumpAt(
      tester,
      size: const Size(411, 914),
      theme: lightTheme,
      quote: kLongestAuthorQuote,
      textScale: 2.0,
    );

    expect(tester.takeException(), isNull);
  });

  group('dock spacing (D5)', () {
    for (final sizeEntry in sizes.entries) {
      testWidgets(
        '${sizeEntry.key}: the gap between the lowest pad edge and the '
        'dock separator is 20dp',
        (tester) async {
          await _pumpAt(
            tester,
            size: sizeEntry.value,
            theme: lightTheme,
            quote: kLongestBodyQuote,
          );

          final padBottom = tester
              .getBottomLeft(find.byKey(PadFrame.edgeKeys[1]))
              .dy;
          final dockTop = tester.getTopLeft(find.byType(ControlDock)).dy;

          expect(dockTop - padBottom, closeTo(20, 0.5));
        },
      );
    }
  });
}
