import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/core/presentation/bloc/config/theme_mode_cubit.dart';
import 'package:kuwot/core/presentation/theme/app_theme.dart';
import 'package:kuwot/features/app_settings/presentation/app_settings_page.dart';
import 'package:kuwot/features/quote/domain/entities/quote_group.dart';
import 'package:kuwot/features/quote/presentation/bloc/quote_groups_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../../helpers/load_app_fonts.dart';
import '../../../helpers/settings_fakes.dart';

/// Pumps [AppSettingsPage] at 360x640 with a real [ThemeModeCubit], a real
/// [QuoteGroupsCubit] seeded with [initialGroups] (defaulting to every
/// group) over a [FakeQuoteGroupsConfig], and a fresh [FakeUrlLauncher]
/// installed as [UrlLauncherPlatform.instance], and waits for the first
/// load to settle. Returns the cubit, its fake config and the fake
/// launcher so callers can make assertions.
Future<
  ({
    QuoteGroupsCubit cubit,
    FakeQuoteGroupsConfig config,
    FakeUrlLauncher launcher,
  })
>
_pumpSettings(
  WidgetTester tester, {
  required ThemeData theme,
  double textScale = 1.0,
  Set<QuoteGroup>? initialGroups,
}) async {
  tester.view.physicalSize = const Size(360, 640);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  final launcher = FakeUrlLauncher();
  final original = UrlLauncherPlatform.instance;
  UrlLauncherPlatform.instance = launcher;
  addTearDown(() => UrlLauncherPlatform.instance = original);

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
              ],
              child: const AppSettingsPage(),
            ),
          );
        },
      ),
    ),
  );
  await tester.pumpAndSettle();
  return (cubit: cubit, config: config, launcher: launcher);
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
  }

  group('Quote groups', () {
    testWidgets('lists the 12 groups in order', (tester) async {
      await _pumpSettings(tester, theme: lightTheme);

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
      final harness = await _pumpSettings(tester, theme: lightTheme);

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
    await _pumpSettings(tester, theme: lightTheme);

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

  group('tip jar', () {
    Future<void> scrollToTipJarAction(WidgetTester tester) async {
      await tester.scrollUntilVisible(
        find.text('Buy me a coffee'),
        200,
        scrollable: find.byType(Scrollable).first,
      );
      await tester.pumpAndSettle();
    }

    testWidgets('shows the message and one action', (tester) async {
      await _pumpSettings(tester, theme: lightTheme);
      await scrollToTipJarAction(tester);

      expect(find.text('Tip jar'), findsOneWidget);
      expect(
        find.textContaining('I built this app with love and coffee'),
        findsOneWidget,
      );
      expect(
        find.widgetWithText(FilledButton, 'Buy me a coffee'),
        findsOneWidget,
      );
    });

    testWidgets('tap launches the BMC page in the external browser', (
      tester,
    ) async {
      final harness = await _pumpSettings(tester, theme: lightTheme);
      await scrollToTipJarAction(tester);

      await tester.tap(find.text('Buy me a coffee'));
      await tester.pumpAndSettle();

      expect(harness.launcher.launches, [
        (
          url: 'https://buymeacoffee.com/fiatcode',
          mode: PreferredLaunchMode.externalApplication,
        ),
      ]);
      expect(find.byType(SnackBar), findsNothing);
    });

    testWidgets('refused launch shows a snackbar, no crash', (tester) async {
      final harness = await _pumpSettings(tester, theme: lightTheme);
      await scrollToTipJarAction(tester);
      harness.launcher.result = false;

      await tester.tap(find.text('Buy me a coffee'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750));

      expect(
        find.text('Could not open buymeacoffee.com/fiatcode.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets('throwing launch shows a snackbar, no crash', (tester) async {
      final harness = await _pumpSettings(tester, theme: lightTheme);
      await scrollToTipJarAction(tester);
      harness.launcher.error = PlatformException(code: 'ACTIVITY_NOT_FOUND');

      await tester.tap(find.text('Buy me a coffee'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 750));

      expect(
        find.text('Could not open buymeacoffee.com/fiatcode.'),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    for (final themeEntry in {'light': lightTheme, 'dark': darkTheme}.entries) {
      for (final scale in [1.0, 2.0]) {
        testWidgets('the Tip jar action at 360x640, ${themeEntry.key} theme, '
            '${scale}x text scale does not overflow', (tester) async {
          await _pumpSettings(
            tester,
            theme: themeEntry.value,
            textScale: scale,
          );
          await scrollToTipJarAction(tester);

          expect(tester.takeException(), isNull);
        });
      }
    }
  });
}
