import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/features/quote/presentation/widgets/tear_sheet.dart';

void main() {
  Future<ValueNotifier<int>> pumpSheet(WidgetTester tester, Key key) async {
    final tornCount = ValueNotifier(0);
    await tester.pumpWidget(
      MaterialApp(
        home: TearSheet(
          key: key,
          teethSeed: 1,
          onTornAway: () => tornCount.value++,
          child: const SizedBox(width: 200, height: 200, child: Text('Page')),
        ),
      ),
    );
    return tornCount;
  }

  testWidgets(
    'a pan that starts while the control-initiated fly is in flight does '
    'not cancel it; the tear finishes exactly once after the fly duration',
    (tester) async {
      final key = GlobalKey<TearSheetState>();
      final tornCount = await pumpSheet(tester, key);

      unawaited(key.currentState!.tearAway());
      await tester.pump(const Duration(milliseconds: 50));

      final gesture = await tester.startGesture(
        tester.getCenter(find.text('Page')),
      );
      await gesture.moveBy(const Offset(0, 10));
      await gesture.up();
      await tester.pump();

      // Still within the 260 ms fly duration: the stray pan must not have
      // finished (or cancelled) the tear early.
      expect(tornCount.value, 0);

      await tester.pumpAndSettle();

      expect(tornCount.value, 1);
    },
  );
}
