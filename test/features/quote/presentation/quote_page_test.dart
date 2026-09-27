import 'package:auto_route/auto_route.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kuwot/core/presentation/bloc/config/theme_mode_cubit.dart';
import 'package:kuwot/core/presentation/theme/app_theme.dart';
import 'package:kuwot/core/router/app_router.gr.dart';
import 'package:kuwot/features/in_app_purchase/presentation/bloc/in_app_purchase_bloc.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/presentation/bloc/pad_bloc.dart';
import 'package:kuwot/features/quote/presentation/quote_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../helpers/load_app_fonts.dart';
import '../../../helpers/pad_fakes.dart';
import '../../../helpers/pad_test_app.dart';
import '../../../helpers/settings_fakes.dart';

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

class _TestHomeRoute extends PageRouteInfo<void> {
  const _TestHomeRoute({List<PageRouteInfo>? children})
    : super(_TestHomeRoute.name, initialChildren: children);

  static const String name = 'TestHomeRoute';

  static PageInfo page = PageInfo(name, builder: (data) => const QuotePage());
}

class _TestAppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: _TestHomeRoute.page, initial: true),
    AutoRoute(page: AppSettingsRoute.page),
  ];
}

/// Pumps the real [QuotePage] behind a real (generated) route stack, so
/// tapping Settings drives an actual [StackRouter] push to
/// [AppSettingsRoute] rather than a stand-in.
Future<_TestAppRouter> _pumpQuotePageWithRouter(
  WidgetTester tester, {
  required FakeTime time,
}) async {
  SharedPreferences.setMockInitialValues({});
  final bloc = await buildPadBloc(time: time);
  final purchaseBloc = MockInAppPurchaseBloc();
  whenListen(
    purchaseBloc,
    const Stream<InAppPurchaseState>.empty(),
    initialState: const ConsumableProductsLoadedState([]),
  );
  final router = _TestAppRouter();

  await tester.pumpWidget(
    MultiBlocProvider(
      providers: [
        BlocProvider<PadBloc>.value(value: bloc),
        BlocProvider<ThemeModeCubit>(
          create: (_) => ThemeModeCubit(
            themeModeConfig: FakeThemeModeConfig(),
            initialThemeMode: ThemeMode.system,
          ),
        ),
        BlocProvider<InAppPurchaseBloc>.value(value: purchaseBloc),
      ],
      child: MaterialApp.router(
        theme: lightTheme,
        routerConfig: router.config(),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return router;
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

  group('device locale (G11)', () {
    testWidgets(
      'renders the weekday and month in the device locale, resolved once '
      'in QuotePage and threaded down rather than read from context '
      'inside PageHeader',
      (tester) async {
        tester.platformDispatcher.localeTestValue = const Locale('id', 'ID');
        addTearDown(tester.platformDispatcher.clearLocaleTestValue);

        await _pumpQuotePage(tester, time: FakeTime(DateTime(2026, 9, 25)));

        expect(find.text('JUMAT'), findsOneWidget);
        expect(find.text('SEPTEMBER'), findsOneWidget);
      },
    );
  });

  group('dock Settings (D3)', () {
    testWidgets('tapping Settings pushes AppSettingsRoute', (tester) async {
      final router = await _pumpQuotePageWithRouter(
        tester,
        time: FakeTime(DateTime(2026, 9, 25)),
      );

      await tester.tap(find.text('SETTINGS'));
      await tester.pumpAndSettle();

      expect(router.current.name, AppSettingsRoute.name);
    });

    testWidgets('there is no tip-jar or settings icon above the pad', (
      tester,
    ) async {
      await _pumpQuotePage(tester, time: FakeTime(DateTime(2026, 9, 25)));

      expect(find.byType(IconButton), findsNothing);
    });
  });
}
