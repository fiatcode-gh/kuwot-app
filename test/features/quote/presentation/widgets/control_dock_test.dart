import 'dart:ui' show TextDirection, Tristate;

import 'package:flutter/material.dart'
    show InkWell, RichText, Size, TextPainter;
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/features/quote/domain/entities/tear_kind.dart';
import 'package:kuwot/features/quote/presentation/widgets/control_dock.dart';

import '../../../../helpers/load_app_fonts.dart';
import '../../../../helpers/pad_test_app.dart';

void main() {
  testWidgets(
    'the dock shows four buttons in order: tear, Restyle, Share, Settings, '
    'each exposing exactly one label with a working tap action',
    (tester) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        padTestApp(
          ControlDock(
            tearKind: TearKind.quote,
            onTear: () {},
            onRestyle: () {},
            onShare: () {},
            onSettings: () {},
          ),
        ),
      );

      final order = ['New quote', 'Restyle', 'Share', 'Settings'];
      for (final label in order) {
        final node = tester.getSemantics(find.text(label.toUpperCase()));
        expect(node.getSemanticsData().label, label);
        expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
      }

      final centers = order
          .map((label) => tester.getCenter(find.text(label.toUpperCase())).dx)
          .toList();
      expect(
        centers,
        equals([...centers]..sort()),
        reason: 'buttons must render left-to-right in the locked order',
      );

      semantics.dispose();
    },
  );

  testWidgets(
    'a disabled Restyle button is announced as disabled with no tap action',
    (tester) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        padTestApp(
          ControlDock(
            tearKind: TearKind.page,
            onTear: () {},
            onRestyle: null,
            onShare: () {},
            onSettings: () {},
          ),
        ),
      );

      final node = tester.getSemantics(find.text('RESTYLE'));
      final data = node.getSemanticsData();
      expect(data.label, 'Restyle');
      expect(data.flagsCollection.isEnabled, Tristate.isFalse);
      expect(data.hasAction(SemanticsAction.tap), isFalse);

      semantics.dispose();
    },
  );

  testWidgets('tapping Settings calls onSettings', (tester) async {
    var tapped = false;

    await tester.pumpWidget(
      padTestApp(
        ControlDock(
          tearKind: TearKind.quote,
          onTear: () {},
          onRestyle: () {},
          onShare: () {},
          onSettings: () => tapped = true,
        ),
      ),
    );

    await tester.tap(find.text('SETTINGS'));
    await tester.pump();

    expect(tapped, isTrue);
  });

  testWidgets('Settings carries a "Settings" tooltip', (tester) async {
    await tester.pumpWidget(
      padTestApp(
        ControlDock(
          tearKind: TearKind.quote,
          onTear: () {},
          onRestyle: () {},
          onShare: () {},
          onSettings: () {},
        ),
      ),
    );

    expect(find.byTooltip('Settings'), findsOneWidget);
  });

  group('label fit at 360x640, real fonts', () {
    setUpAll(loadAppFonts);

    const order = ['New quote', 'Restyle', 'Share', 'Settings'];

    /// The label's natural, unwrapped size: the same [RichText] the widget
    /// actually painted (so it carries the real merged style, font and text
    /// scaler), laid out with no width limit. `FittedBox` lays its child
    /// out the same way, so comparing a button's rendered height against
    /// this is a direct wrap-vs-no-wrap check, independent of scale-down.
    Size naturalLabelSize(WidgetTester tester, Finder finder) {
      final richText = tester.widget<RichText>(
        find.descendant(of: finder, matching: find.byType(RichText)),
      );
      final painter = TextPainter(
        text: richText.text,
        textDirection: richText.textDirection ?? TextDirection.ltr,
        textScaler: richText.textScaler,
      )..layout();
      final size = painter.size;
      painter.dispose();
      return size;
    }

    for (final scale in [1.0, 2.0]) {
      testWidgets('every label renders on one line and fits its button at '
          '${scale}x text scale', (tester) async {
        tester.view.physicalSize = const Size(360, 640);
        tester.view.devicePixelRatio = 1;
        addTearDown(tester.view.resetPhysicalSize);
        addTearDown(tester.view.resetDevicePixelRatio);

        await tester.pumpWidget(
          padTestApp(
            ControlDock(
              tearKind: TearKind.quote,
              onTear: () {},
              onRestyle: () {},
              onShare: () {},
              onSettings: () {},
            ),
            textScale: scale,
          ),
        );
        await tester.pump();

        expect(tester.takeException(), isNull);

        for (final label in order) {
          final finder = find.text(label.toUpperCase());
          final natural = naturalLabelSize(tester, finder);

          expect(
            tester.getSize(finder).height,
            closeTo(natural.height, 0.5),
            reason: '$label must render on one line, not wrap mid-word',
          );

          final buttonWidth = tester
              .getRect(
                find.ancestor(of: finder, matching: find.byType(InkWell)),
              )
              .width;
          expect(
            tester.getRect(finder).width,
            lessThanOrEqualTo(buttonWidth),
            reason: '$label must fit inside its dock button',
          );

          if (scale == 1.0) {
            expect(
              tester.getRect(finder).width,
              closeTo(natural.width, 0.5),
              reason: '$label must stay full size at 1.0x, not shrunk',
            );
          }
        }
      });
    }
  });
}
