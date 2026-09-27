import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kuwot/core/presentation/bloc/config/theme_mode_cubit.dart';
import 'package:kuwot/core/presentation/theme/app_theme.dart';
import 'package:kuwot/features/app_settings/presentation/app_settings_page.dart';
import 'package:kuwot/features/in_app_purchase/presentation/bloc/in_app_purchase_bloc.dart';
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

/// Pumps [AppSettingsPage] at 360x640 with a real [ThemeModeCubit] and a
/// mocked [InAppPurchaseBloc] fixed at [purchaseState] (or replaying
/// [stream], defaulting to empty, on top of it), and waits for the first
/// load to settle. Returns the mock bloc so callers can verify dispatches.
Future<MockInAppPurchaseBloc> _pumpSettings(
  WidgetTester tester, {
  required ThemeData theme,
  required InAppPurchaseState purchaseState,
  double textScale = 1.0,
  Stream<InAppPurchaseState>? stream,
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
  return purchaseBloc;
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
    final purchaseBloc = await _pumpSettings(
      tester,
      theme: lightTheme,
      purchaseState: const InAppPurchaseInitialState(),
      stream: Stream<InAppPurchaseState>.fromIterable([
        const GettingConsumableProductsState(),
        ConsumableProductsLoadedState(_sampleProducts),
      ]),
    );

    expect(find.text('Small Coffee'), findsOneWidget);
    verify(() => purchaseBloc.add(const GetConsumableProductsEvent()))
        .called(1);
  });

  testWidgets('sections appear in order: Theme, Tip jar, About', (
    tester,
  ) async {
    await _pumpSettings(
      tester,
      theme: lightTheme,
      purchaseState: const ConsumableProductsLoadedState([]),
    );

    final themeY = tester.getTopLeft(find.text('Theme')).dy;
    final tipJarY = tester.getTopLeft(find.text('Tip jar')).dy;
    final aboutY = tester.getTopLeft(find.text('Links & Credits')).dy;

    expect(themeY, lessThan(tipJarY));
    expect(tipJarY, lessThan(aboutY));
  });
}
