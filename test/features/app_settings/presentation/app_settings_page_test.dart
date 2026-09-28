import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kuwot/core/presentation/bloc/config/theme_mode_cubit.dart';
import 'package:kuwot/core/presentation/theme/app_theme.dart';
import 'package:kuwot/features/app_settings/presentation/app_settings_page.dart';
import 'package:kuwot/features/in_app_purchase/presentation/bloc/in_app_purchase_bloc.dart';
import 'package:kuwot/features/quote/domain/entities/quote_group.dart';
import 'package:kuwot/features/quote/presentation/bloc/quote_groups_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../helpers/load_app_fonts.dart';
import '../../../helpers/settings_fakes.dart';

final _sampleProducts = [
  ProductDetails(
    id: 'small_coffee',
    title: 'Small Coffee',
    description: 'A small coffee tip',
    price: r'$1.00',
    rawPrice: 1.0,
    currencyCode: 'USD',
  ),
];

/// Pumps [AppSettingsPage] at 360x640 with a real [ThemeModeCubit], a real
/// [QuoteGroupsCubit] seeded with [initialGroups] (defaulting to every
/// group) over a [FakeQuoteGroupsConfig], and a mocked [InAppPurchaseBloc]
/// fixed at [purchaseState] (or replaying [stream], defaulting to empty, on
/// top of it), and waits for the first load to settle. Returns the mock
/// bloc, the cubit and its fake config so callers can make assertions.
Future<
  ({
    MockInAppPurchaseBloc purchaseBloc,
    QuoteGroupsCubit cubit,
    FakeQuoteGroupsConfig config,
  })
>
_pumpSettings(
  WidgetTester tester, {
  required ThemeData theme,
  required InAppPurchaseState purchaseState,
  double textScale = 1.0,
  Stream<InAppPurchaseState>? stream,
  Set<QuoteGroup>? initialGroups,
}) async {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final purchaseBloc = MockInAppPurchaseBloc();
  whenListen(
    purchaseBloc,
    stream ?? const Stream<InAppPurchaseState>.empty(),
    initialState: purchaseState,
  );
  final config = FakeQuoteGroupsConfig();
  final cubit = QuoteGroupsCubit(
    config: config,
    initialGroups: initialGroups ?? QuoteGroup.values.toSet(),
  );

  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      home: Builder(
        builder: (context) {
          final mediaQuery = MediaQuery.of(context);
          return MediaQuery(
            data: mediaQuery.copyWith(textScaler: TextScaler.linear(textScale)),
            child: MultiBlocProvider(
              providers: [
                BlocProvider<ThemeModeCubit>(
                  create: (_) => ThemeModeCubit(
                    themeModeConfig: FakeThemeModeConfig(),
                    initialThemeMode: ThemeMode.system,
                  ),
                ),
                BlocProvider<QuoteGroupsCubit>.value(value: cubit),
                BlocProvider<InAppPurchaseBloc>.value(value: purchaseBloc),
              ],
              child: const AppSettingsPage(),
            ),
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
  return (purchaseBloc: purchaseBloc, cubit: cubit, config: config);
}

void main() {
  setUpAll(() async {
    await loadAppFonts();
    PackageInfo.setMockInitialValues(
      appName: 'Kuwot',
      packageName: 'dev.fiatcode.kuwot',
      version: '1.0.0',
      buildNumber: '1',
      buildSignature: '',
    );
  });

  final themes = {'light': lightTheme, 'dark': darkTheme};

  for (final themeEntry in themes.entries) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'the Theme control at 360x640, ${themeEntry.key} theme, ${scale}x '
        'text scale does not overflow',
        (tester) async {
          await _pumpSettings(
            tester,
            theme: themeEntry.value,
            textScale: scale,
            purchaseState: const ConsumableProductsLoadedState([]),
          );

          expect(tester.takeException(), isNull);
        },
      );

      testWidgets(
        'the Tip jar section with products at 360x640, ${themeEntry.key} '
        'theme, ${scale}x text scale does not overflow',
        (tester) async {
          await _pumpSettings(
            tester,
            theme: themeEntry.value,
            textScale: scale,
            purchaseState: ConsumableProductsLoadedState(_sampleProducts),
          );

          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets(
      'the Tip jar section error state at 360x640, ${themeEntry.key} theme '
      'does not overflow',
      (tester) async {
        await _pumpSettings(
          tester,
          theme: themeEntry.value,
          purchaseState: const PurchaseErrorState(message: 'boom'),
        );

        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('the Tip jar section renders the products from a mocked '
      'InAppPurchaseBloc state', (tester) async {
    await _pumpSettings(
      tester,
      theme: lightTheme,
      purchaseState: ConsumableProductsLoadedState(_sampleProducts),
    );

    expect(find.text('Small Coffee'), findsOneWidget);
    expect(find.text(r'$1.00'), findsOneWidget);
  });

  testWidgets('the Tip jar section shows the products once the bloc moves from '
      'Getting to Loaded on first open, and dispatches the load exactly once', (
    tester,
  ) async {
    final harness = await _pumpSettings(
      tester,
      theme: lightTheme,
      purchaseState: const InAppPurchaseInitialState(),
      stream: Stream<InAppPurchaseState>.fromIterable([
        const GettingConsumableProductsState(),
        ConsumableProductsLoadedState(_sampleProducts),
      ]),
    );

    expect(find.text('Small Coffee'), findsOneWidget);
    verify(() => harness.purchaseBloc.add(const GetConsumableProductsEvent()))
        .called(1);
  });

  group('Quote groups', () {
    testWidgets('lists the 12 groups in order', (tester) async {
      await _pumpSettings(
        tester,
        theme: lightTheme,
        purchaseState: const ConsumableProductsLoadedState([]),
      );

      final chips = tester.widgetList<FilterChip>(find.byType(FilterChip));
      final labels = chips.map((chip) => (chip.label as Text).data).toList();

      expect(labels, [
        'Perspective',
        'Keep going',
        'Heavy days',
        'Do the work',
        'Begin again',
        'Breathe',
        'Grow',
        'Courage',
        'Small joys',
        'People',
        'Believe in yourself',
        'Rest',
      ]);
      expect(chips.every((chip) => chip.selected), isTrue);
    });

    testWidgets('tapping the Rest chip turns it off', (tester) async {
      final harness = await _pumpSettings(
        tester,
        theme: lightTheme,
        purchaseState: const ConsumableProductsLoadedState([]),
      );

      await tester.tap(find.widgetWithText(FilterChip, 'Rest'));
      await tester.pumpAndSettle();

      final chip = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, 'Rest'),
      );
      expect(chip.selected, isFalse);
      expect(harness.cubit.state.contains(QuoteGroup.rest), isFalse);
      expect(harness.config.saved?.contains(QuoteGroup.rest), isFalse);
    });

    testWidgets('the only selected group chip cannot be turned off', (
      tester,
    ) async {
      final harness = await _pumpSettings(
        tester,
        theme: lightTheme,
        purchaseState: const ConsumableProductsLoadedState([]),
        initialGroups: const {QuoteGroup.rest},
      );

      final chip = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, 'Rest'),
      );
      expect(chip.onSelected, isNull);

      await tester.tap(find.widgetWithText(FilterChip, 'Rest'));
      await tester.pumpAndSettle();

      expect(harness.cubit.state, {QuoteGroup.rest});
      final chipAfter = tester.widget<FilterChip>(
        find.widgetWithText(FilterChip, 'Rest'),
      );
      expect(chipAfter.selected, isTrue);
    });
  });

  testWidgets('sections appear in order: Theme, Quote groups, Tip jar, About', (
    tester,
  ) async {
    await _pumpSettings(
      tester,
      theme: lightTheme,
      purchaseState: const ConsumableProductsLoadedState([]),
    );

    // The list is taller than the 640-tall viewport, so 'Links & Credits'
    // isn't built until scrolled into view. `dy` alone isn't comparable
    // across scroll positions, so add the Scrollable's current offset to
    // get each section's position in the (scroll-invariant) list content.
    final scrollable = tester.state<ScrollableState>(find.byType(Scrollable));
    double contentY(Finder finder) =>
        tester.getTopLeft(finder).dy + scrollable.position.pixels;

    final themeY = contentY(find.text('Theme'));
    final quoteGroupsY = contentY(find.text('Quote groups'));
    final tipJarY = contentY(find.text('Tip jar'));
    expect(themeY, lessThan(quoteGroupsY));
    expect(quoteGroupsY, lessThan(tipJarY));

    await tester.scrollUntilVisible(find.text('Links & Credits'), 200);
    final aboutY = contentY(find.text('Links & Credits'));
    expect(tipJarY, lessThan(aboutY));
  });
}
