import 'dart:ui' show Tristate;

import 'package:flutter/material.dart' show Size;
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/features/quote/domain/entities/tear_kind.dart';
import 'package:kuwot/features/quote/presentation/widgets/control_dock.dart';

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

  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'the four labels do not overflow at 360dp width, ${scale}x text scale',
      (tester) async {
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
      },
    );
  }
}
