import 'dart:math';

import 'package:kuwot/features/quote/domain/entities/background_style.dart';
import 'package:kuwot/features/quote/domain/entities/palettes.dart';

class BackgroundGenerator {
  const BackgroundGenerator({this.palettes = kPalettes});

  final List<Palette> palettes;

  BackgroundStyle generate(int quoteId, int variant) {
    final seed = Object.hash(quoteId, variant);
    final rng = Random(seed);
    final palette = palettes[rng.nextInt(palettes.length)];
    return BackgroundStyle(seed: seed, palette: palette);
  }
}
