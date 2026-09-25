import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/presentation/bloc/pad_bloc.dart';
import 'package:kuwot/features/quote/presentation/quote_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/load_app_fonts.dart';
import '../../../helpers/pad_fakes.dart';
import '../../../helpers/pad_test_app.dart';

const _staleQuoteId = 100;
const _staleQuote = Quote(
  id: _staleQuoteId,
  author: 'Yesterday Author',
  body: 'Yesterday Quote',
);

const _stalePrefs = {
  'padSnapshot':
      '{"v":1,"day":"2026-09-24","quoteId":$_staleQuoteId,"reroll":null}',
};

/// Pumps the real [QuotePage] on top of a real [PadBloc], the way it runs in
/// the app, and waits for the first load to settle.
Future<PadBloc> _pumpQuotePage(
  WidgetTester tester, {
  required FakeTime time,
  FakeQuoteRepository? quotes,
  Map<String, Object> initialPrefs = const {},
}) async {
  SharedPreferences.setMockInitialValues(initialPrefs);
  final bloc = await buildPadBloc(time: time, quotes: quotes);
  await tester.pumpWidget(
    padTestApp(BlocProvider.value(value: bloc, child: const QuotePage())),
  );
  await tester.pumpAndSettle();
  return bloc;
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    await initializeDateFormatting();
  });

  group('same day', () {
    testWidgets(
      'drag past the threshold shows a new quote, same date and header',
      (tester) async {
        final bloc = await _pumpQuotePage(
          tester,
          time: FakeTime(DateTime(2026, 9, 25)),
        );
        final headerBefore = (bloc.state as PadReady).top.header;

        await tester.timedDrag(
          find.text('Quote 1'),
          const Offset(0, 200),
          const Duration(milliseconds: 600),
        );
        await tester.pumpAndSettle();

        expect(find.text('Quote 1'), findsNothing);
        expect(find.text('Quote 2'), findsOneWidget);
        expect(find.text('25'), findsOneWidget);
        expect((bloc.state as PadReady).top.header, headerBefore);
      },
    );

    testWidgets('a short drag springs back without tearing', (tester) async {
      final bloc = await _pumpQuotePage(
        tester,
        time: FakeTime(DateTime(2026, 9, 25)),
      );
      final revisionBefore = (bloc.state as PadReady).revision;

      await tester.timedDrag(
        find.text('Quote 1'),
        const Offset(0, 60),
        const Duration(milliseconds: 600),
      );
      await tester.pumpAndSettle();

      expect(find.text('Quote 1'), findsOneWidget);
      expect((bloc.state as PadReady).revision, revisionBefore);
    });

    testWidgets(
      'the control reads NEW QUOTE and tapping it draws a new quote',
      (tester) async {
        await _pumpQuotePage(tester, time: FakeTime(DateTime(2026, 9, 25)));

        expect(find.text('NEW QUOTE'), findsOneWidget);

        await tester.tap(find.text('NEW QUOTE'));
        await tester.pumpAndSettle();

        expect(find.text('Quote 1'), findsNothing);
        expect(find.text('Quote 2'), findsOneWidget);
        expect(find.text('25'), findsOneWidget);
      },
    );
  });

  group('stale page', () {
    testWidgets(
      'shows the leftover day and quote, TODAY control, Restyle disabled; '
      'tapping TODAY reveals today and a new quote',
      (tester) async {
        final bloc = await _pumpQuotePage(
          tester,
          time: FakeTime(DateTime(2026, 9, 25)),
          quotes: FakeQuoteRepository(seed: const {_staleQuoteId: _staleQuote}),
          initialPrefs: _stalePrefs,
        );

        expect(find.text('24'), findsOneWidget);
        expect(find.text('Yesterday Quote'), findsOneWidget);
        expect(find.text('TODAY'), findsOneWidget);

        final stateBefore = bloc.state;
        await tester.tap(find.text('RESTYLE'));
        await tester.pumpAndSettle();
        expect(bloc.state, stateBefore);

        await tester.tap(find.text('TODAY'));
        await tester.pumpAndSettle();

        expect(find.text('25'), findsOneWidget);
        expect(find.text('Yesterday Quote'), findsNothing);
        expect(find.text('NEW QUOTE'), findsOneWidget);
      },
    );

    testWidgets(
      'dragging the leftover page reveals today; the next drag is a quote '
      'tear that leaves the day unchanged',
      (tester) async {
        await _pumpQuotePage(
          tester,
          time: FakeTime(DateTime(2026, 9, 25)),
          quotes: FakeQuoteRepository(seed: const {_staleQuoteId: _staleQuote}),
          initialPrefs: _stalePrefs,
        );

        await tester.timedDrag(
          find.text('24'),
          const Offset(0, 200),
          const Duration(milliseconds: 600),
        );
        await tester.pumpAndSettle();

        expect(find.text('25'), findsOneWidget);

        await tester.timedDrag(
          find.text('Quote 1'),
          const Offset(0, 200),
          const Duration(milliseconds: 600),
        );
        await tester.pumpAndSettle();

        expect(find.text('Quote 1'), findsNothing);
        expect(find.text('Quote 2'), findsOneWidget);
        expect(find.text('25'), findsOneWidget);
      },
    );
  });

  testWidgets('mid-drag reveals the under content underneath', (tester) async {
    final bloc = await _pumpQuotePage(
      tester,
      time: FakeTime(DateTime(2026, 9, 25)),
    );

    final gesture = await tester.startGesture(
      tester.getCenter(find.text('Quote 1')),
    );
    await gesture.moveBy(const Offset(0, 100));
    await tester.pump();

    final ready = bloc.state as PadReady;
    expect(find.text(ready.under.quote.body), findsOneWidget);

    await gesture.up();
    await tester.pumpAndSettle();
  });
}
