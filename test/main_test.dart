import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/main.dart';

void main() {
  group('preferredOrientationsFor', () {
    test('locks portrait for a phone-sized shortest side', () {
      expect(preferredOrientationsFor(const Size(360, 800)), const [
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    });

    test('no lock for a tablet-sized shortest side', () {
      expect(preferredOrientationsFor(const Size(800, 1280)), isEmpty);
    });

    test('no lock exactly at the 600 dp boundary', () {
      expect(preferredOrientationsFor(const Size(600, 1000)), isEmpty);
    });

    test('never decides a lock from a zero size', () {
      expect(preferredOrientationsFor(Size.zero), isEmpty);
    });
  });

  testWidgets(
    'OrientationLock re-evaluates on a fold-like metrics change: portrait '
    'lock on a phone-sized view, no lock once it grows to tablet size',
    (tester) async {
      final calls = <List<String>>[];
      tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        SystemChannels.platform,
        (methodCall) async {
          if (methodCall.method == 'SystemChrome.setPreferredOrientations') {
            calls.add((methodCall.arguments as List).cast<String>());
          }
          return null;
        },
      );
      addTearDown(
        () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
          SystemChannels.platform,
          null,
        ),
      );

      tester.view.physicalSize = const Size(1080, 2400);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const MaterialApp(home: OrientationLock(child: SizedBox.shrink())),
      );
      await tester.pump();

      expect(calls, isNotEmpty);
      expect(calls.last, [
        DeviceOrientation.portraitUp.toString(),
        DeviceOrientation.portraitDown.toString(),
      ]);

      calls.clear();
      tester.view.physicalSize = const Size(2560, 1600);
      tester.view.devicePixelRatio = 2;
      await tester.pump();

      expect(calls, isNotEmpty);
      expect(calls.last, isEmpty);
    },
  );
}
