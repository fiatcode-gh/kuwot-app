import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/features/quote/domain/entities/palettes.dart';

void main() {
  test('there are several curated palettes', () {
    expect(kPalettes.length, greaterThanOrEqualTo(8));
  });

  test('every palette has 2-4 colors', () {
    for (final p in kPalettes) {
      expect(p.colors.length, inInclusiveRange(2, 4));
    }
  });

  test(
    'every palette color is mid-to-dark (reads under white text in greyscale)',
    () {
      // White text sits over a black54 scrim, but the exposed background must
      // still read distinctly in greyscale — keep luminance below 0.6.
      for (final p in kPalettes) {
        for (final c in p.colors) {
          expect(
            c.computeLuminance(),
            lessThan(0.6),
            reason: 'palette color $c too light: ${c.computeLuminance()}',
          );
        }
      }
    },
  );
}
