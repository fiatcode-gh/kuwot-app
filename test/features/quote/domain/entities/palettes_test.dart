import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/core/presentation/theme/app_palette.dart';
import 'package:kuwot/features/quote/domain/entities/palettes.dart';

/// Ottosson's OKLCH conversion, linear-sRGB → L, C, h (degrees, `[0, 360)`).
({double l, double c, double h}) _oklch(Color color) {
  double linear(double channel) => channel <= 0.04045
      ? channel / 12.92
      : math.pow((channel + 0.055) / 1.055, 2.4).toDouble();
  final r = linear(color.r);
  final g = linear(color.g);
  final b = linear(color.b);
  final l = 0.4122214708 * r + 0.5363325363 * g + 0.0514459929 * b;
  final m = 0.2119034982 * r + 0.6806995451 * g + 0.1073969566 * b;
  final s = 0.0883024619 * r + 0.2817188376 * g + 0.6299787005 * b;
  final l_ = math.pow(l, 1 / 3).toDouble();
  final m_ = math.pow(m, 1 / 3).toDouble();
  final s_ = math.pow(s, 1 / 3).toDouble();
  final okL = 0.2104542553 * l_ + 0.7936177850 * m_ - 0.0040720468 * s_;
  final a = 1.9779984951 * l_ - 2.4285922050 * m_ + 0.4505937099 * s_;
  final bChan = 0.0259040371 * l_ + 0.7827717662 * m_ - 0.8086757660 * s_;
  final c = math.sqrt(a * a + bChan * bChan);
  var h = math.atan2(bChan, a) * 180 / math.pi;
  if (h < 0) h += 360;
  return (l: okL, c: c, h: h);
}

/// WCAG relative-luminance contrast ratio, `[1, 21]`.
double _contrast(Color a, Color b) {
  final lighter = math.max(a.computeLuminance(), b.computeLuminance());
  final darker = math.min(a.computeLuminance(), b.computeLuminance());
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  final allColors = [for (final p in kPalettes) ...p.colors];

  test('there are several curated palettes', () {
    expect(kPalettes.length, greaterThanOrEqualTo(8));
  });

  test('every palette has 2-4 colors', () {
    for (final p in kPalettes) {
      expect(p.colors.length, inInclusiveRange(2, 4));
    }
  });

  test('every colour clears 4.5:1 contrast against AppPalette.headerInk', () {
    for (final c in allColors) {
      expect(
        _contrast(c, AppPalette.headerInk),
        greaterThanOrEqualTo(4.5),
        reason: 'color $c fails contrast against headerInk',
      );
    }
  });

  test('every colour clears 1.4:1 contrast against AppPalette.dark.paper', () {
    for (final c in allColors) {
      expect(
        _contrast(c, AppPalette.dark.paper),
        greaterThanOrEqualTo(1.4),
        reason: 'color $c fails contrast against dark.paper',
      );
    }
  });

  test('every colour has OKLCH chroma >= 0.025 (never flat near-black)', () {
    for (final c in allColors) {
      expect(
        _oklch(c).c,
        greaterThanOrEqualTo(0.025),
        reason: 'color $c is too low-chroma',
      );
    }
  });

  test('no colour has an OKLCH hue in [70, 115] (muddy ochre/olive)', () {
    for (final c in allColors) {
      final h = _oklch(c).h;
      expect(
        h >= 70 && h <= 115,
        isFalse,
        reason: 'color $c has muddy OKLCH hue $h',
      );
    }
  });

  test('no colour has an HSL hue in [250, 335] (the purple ban)', () {
    for (final c in allColors) {
      final h = HSLColor.fromColor(c).hue;
      expect(
        h >= 250 && h <= 335,
        isFalse,
        reason: 'color $c has banned HSL hue $h',
      );
    }
  });
}
