import 'dart:math';

import 'package:kuwot/features/quote/domain/entities/background_style.dart';
import 'package:kuwot/features/quote/domain/entities/palettes.dart';

/// Generates a [BackgroundStyle] as a pure function of `(seed, variant)`:
/// the same inputs always produce the same style, in this process and in any
/// future one. `Random(mixed)` is Dart's documented, spec-stable linear
/// congruential generator, so — unlike `Object.hash`, which is only
/// guaranteed stable within a single process run — this stays stable across
/// process restarts.
class BackgroundGenerator {
  const BackgroundGenerator({this.palettes = kPalettes});

  final List<Palette> palettes;

  BackgroundStyle generate(int seed, int variant) {
    final mixed = seed * 1000003 + variant;
    final rng = Random(mixed);
    final palette = palettes[rng.nextInt(palettes.length)];
    return BackgroundStyle(seed: mixed, palette: palette);
  }
}
