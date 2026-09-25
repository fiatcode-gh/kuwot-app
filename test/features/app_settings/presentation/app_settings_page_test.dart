import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kuwot/core/data/local/config.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/core/presentation/bloc/config/theme_mode_cubit.dart';
import 'package:kuwot/core/presentation/theme/app_theme.dart';
import 'package:kuwot/features/app_settings/presentation/app_settings_page.dart';
import 'package:kuwot/features/in_app_purchase/domain/repositories/in_app_purchase_repository.dart';
import 'package:kuwot/features/in_app_purchase/domain/use_case/get_consumable_products.dart';
import 'package:kuwot/features/in_app_purchase/domain/use_case/purchase_consumable_product.dart';
import 'package:kuwot/features/in_app_purchase/presentation/bloc/in_app_purchase_bloc.dart';
import 'package:kuwot/features/in_app_purchase/presentation/donation_page.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../helpers/load_app_fonts.dart';

class _FakeThemeModeConfig extends Config<ThemeMode> {
  @override
  Future<ThemeMode?> get() async => null;

  @override
  Future<void> set(ThemeMode value) async {}

  @override
  Future<void> remove() async {}
}

/// A no-op purchase repository: enough for [DonationPage] to build and
/// settle its initial "load products" request without touching a platform
/// channel.
class _FakeInAppPurchaseRepository implements InAppPurchaseRepository {
  @override
  Stream<List<PurchaseDetails>> get purchaseStream => const Stream.empty();

  @override
  Future<Either<Failure, List<ProductDetails>>> getConsumableProducts() async =>
      const Right([]);

  @override
  Future<Either<Failure, bool>> purchaseConsumableProduct(
    ProductDetails product,
  ) async => const Right(true);

  @override
  Future<Either<Failure, void>> completePurchase(
    PurchaseDetails purchaseDetails,
  ) async => const Right(null);
}

/// Pumps [AppSettingsPage] at 360x640 with a real [ThemeModeCubit] and
/// [textScale], and waits for the first load to settle.
Future<void> _pumpSettings(
  WidgetTester tester, {
  required ThemeData theme,
  double textScale = 1.0,
}) async {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      home: Builder(
        builder: (context) {
          final mediaQuery = MediaQuery.of(context);
          return MediaQuery(
            data: mediaQuery.copyWith(textScaler: TextScaler.linear(textScale)),
            child: BlocProvider(
              create: (_) => ThemeModeCubit(
                themeModeConfig: _FakeThemeModeConfig(),
                initialThemeMode: ThemeMode.system,
              ),
              child: const AppSettingsPage(),
            ),
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Pumps [DonationPage] (the tip jar) at 360x640 with a no-op purchase bloc.
Future<void> _pumpTipJar(
  WidgetTester tester, {
  required ThemeData theme,
}) async {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final repo = _FakeInAppPurchaseRepository();
  final bloc = InAppPurchaseBloc(
    getConsumableProducts: GetConsumableProducts(repo),
    purchaseConsumableProduct: PurchaseConsumableProduct(repo),
  );

  await tester.pumpWidget(
    MaterialApp(
      theme: theme,
      home: BlocProvider.value(value: bloc, child: const DonationPage()),
    ),
  );
  await tester.pumpAndSettle();
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
          );

          expect(tester.takeException(), isNull);
        },
      );
    }

    testWidgets('the tip jar page at 360x640, ${themeEntry.key} theme does not '
        'overflow', (tester) async {
      await _pumpTipJar(tester, theme: themeEntry.value);

      expect(tester.takeException(), isNull);
    });
  }
}
