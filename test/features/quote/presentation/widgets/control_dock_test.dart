import 'dart:ui' show Tristate;

import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/features/quote/domain/entities/tear_kind.dart';
import 'package:kuwot/features/quote/presentation/widgets/control_dock.dart';

import '../../../../helpers/pad_test_app.dart';

void main() {
  testWidgets(
    'each dock button exposes exactly one label with a working tap action',
    (tester) async {
      final semantics = tester.ensureSemantics();

      await tester.pumpWidget(
        padTestApp(
          ControlDock(
            tearKind: TearKind.quote,
            onTear: () {},
            onRestyle: () {},
            onShare: () {},
          ),
        ),
      );

      for (final label in ['New quote', 'Restyle', 'Share']) {
        final node = tester.getSemantics(find.text(label.toUpperCase()));
        expect(node.getSemanticsData().label, label);
        expect(node.getSemanticsData().hasAction(SemanticsAction.tap), isTrue);
      }

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
}
