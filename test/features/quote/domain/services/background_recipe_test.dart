import 'package:flutter/painting.dart' show Color;
import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/features/quote/domain/entities/background_style.dart';
import 'package:kuwot/features/quote/domain/entities/palettes.dart';
import 'package:kuwot/features/quote/domain/services/background_recipe.dart';

void main() {
  const palette = Palette([Color(0xFF1A2980), Color(0xFF26D0CE)]);

  /// First seed whose selected engine is [engine].
  int seedForEngine(int engine) {
    for (var s = 0; s < 100000; s++) {
      if (BackgroundRecipe.engineFor(s) == engine) return s;
    }
    fail('no seed found for engine $engine');
  }

  test('is deterministic for the same (seed, palette) — every engine', () {
    for (var engine = 0; engine < BackgroundRecipe.engineCount; engine++) {
      final seed = seedForEngine(engine);
      final a = BackgroundRecipe.fromSeed(seed, palette);
      final b = BackgroundRecipe.fromSeed(seed, palette);
      expect(a, b, reason: 'engine $engine not deterministic');
      expect(a.engine, engine);
    }
  });

  test('different seeds produce different recipes', () {
    final a = BackgroundRecipe.fromSeed(1, palette);
    final b = BackgroundRecipe.fromSeed(2, palette);
    expect(a, isNot(b));
  });

  test(
    'engineFor is deterministic, in range, and every engine is reachable',
    () {
      expect(BackgroundRecipe.engineFor(42), BackgroundRecipe.engineFor(42));
      final seen = <int>{};
      for (var s = 0; s < 2000; s++) {
        final e = BackgroundRecipe.engineFor(s);
        expect(e, inInclusiveRange(0, BackgroundRecipe.engineCount - 1));
        seen.add(e);
      }
      expect(
        seen.length,
        BackgroundRecipe.engineCount,
        reason: 'unreachable engine',
      );
    },
  );

  test('every engine only paints with palette colours (legibility holds)', () {
    // Gradients only interpolate between these colours (and toward transparency),
    // so if every source colour is a curated palette colour (all luminance < 0.6),
    // no painted pixel can exceed the palette's luminance. This guards against a
    // future engine introducing a lightened/off-palette colour.
    for (var engine = 0; engine < BackgroundRecipe.engineCount; engine++) {
      final baseSeed = seedForEngine(engine);
      for (final p in kPalettes) {
        for (final seed in [baseSeed, baseSeed + 500, baseSeed + 5000]) {
          if (BackgroundRecipe.engineFor(seed) != engine) continue;
          final recipe = BackgroundRecipe.fromSeed(seed, p);
          for (final c in recipe.colors) {
            expect(
              p.colors,
              contains(c),
              reason: 'engine $engine used an off-palette colour',
            );
            expect(c.computeLuminance(), lessThan(0.6));
          }
        }
      }
    }
  });
}
