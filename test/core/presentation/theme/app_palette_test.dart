import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/core/presentation/theme/app_palette.dart';
import 'package:kuwot/core/presentation/theme/app_theme.dart';

/// Relative luminance with sRGB linearisation, per WCAG 2.x. `Color.r/g/b`
/// are already normalised to 0.0–1.0 in this SDK.
double _relativeLuminance(Color c) {
  double linearize(double channel) {
    return channel <= 0.04045
        ? channel / 12.92
        : math.pow((channel + 0.055) / 1.055, 2.4).toDouble();
  }

  return 0.2126 * linearize(c.r) +
      0.7152 * linearize(c.g) +
      0.0722 * linearize(c.b);
}

/// WCAG contrast ratio between two colors, order-independent by construction
/// (the lighter luminance is always the numerator).
double _contrast(Color a, Color b) {
  final lA = _relativeLuminance(a);
  final lB = _relativeLuminance(b);
  final lighter = math.max(lA, lB);
  final darker = math.min(lA, lB);
  return (lighter + 0.05) / (darker + 0.05);
}

void main() {
  for (final entry in {
    'light': AppPalette.light,
    'dark': AppPalette.dark,
  }.entries) {
    final name = entry.key;
    final p = entry.value;

    test('$name palette: ink/paper contrast meets WCAG AA (>= 4.5)', () {
      expect(_contrast(p.ink, p.paper), greaterThanOrEqualTo(4.5));
    });

    test('$name palette: inkMuted/paper contrast meets WCAG AA (>= 4.5)', () {
      expect(_contrast(p.inkMuted, p.paper), greaterThanOrEqualTo(4.5));
    });

    test('$name palette: ink/desk contrast meets WCAG AA (>= 4.5)', () {
      expect(_contrast(p.ink, p.desk), greaterThanOrEqualTo(4.5));
    });

    test('$name palette: inkMuted/desk contrast meets WCAG AA (>= 4.5)', () {
      expect(_contrast(p.inkMuted, p.desk), greaterThanOrEqualTo(4.5));
    });
  }

  test('lightTheme registers AppPalette.light as its extension', () {
    expect(lightTheme.extension<AppPalette>(), same(AppPalette.light));
  });

  test('darkTheme registers AppPalette.dark as its extension', () {
    expect(darkTheme.extension<AppPalette>(), same(AppPalette.dark));
  });
}
