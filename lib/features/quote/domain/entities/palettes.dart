import 'package:flutter/painting.dart' show Color;
import 'package:kuwot/features/quote/domain/entities/background_style.dart';

/// Curated background palettes. All colours are mid-to-dark (luminance < 0.6,
/// enforced by test) so white text over the scrim stays legible. Contrast comes
/// from *hue*, not brightness — multi-hue 3-4 colour ramps give the gradient
/// engines something to show while staying dark enough to read against.
const kPalettes = <Palette>[
  // Vivid multi-hue ramps.
  Palette([
    Color(0xFF3A0CA3),
    Color(0xFF7209B7),
    Color(0xFFF72585),
  ]), // indigo→magenta
  Palette([
    Color(0xFF03045E),
    Color(0xFF0077B6),
    Color(0xFF00B4D8),
  ]), // deep ocean
  Palette([Color(0xFF641220), Color(0xFF9D0208), Color(0xFFE85D04)]), // ember
  Palette([Color(0xFF240046), Color(0xFF5A189A), Color(0xFF9D4EDD)]), // grape
  Palette([
    Color(0xFF10002B),
    Color(0xFF3C096C),
    Color(0xFF5A189A),
    Color(0xFF7B2CBF),
  ]), // twilight
  Palette([
    Color(0xFF012A4A),
    Color(0xFF2A6F97),
    Color(0xFF468FAF),
  ]), // steel blue
  Palette([
    Color(0xFF2B2D42),
    Color(0xFF8D2E44),
    Color(0xFFBC4749),
  ]), // slate→rose
  Palette([Color(0xFF1B4332), Color(0xFF2D6A4F), Color(0xFF40916C)]), // forest
  // Refined two-tone keepers.
  Palette([Color(0xFF1A2980), Color(0xFF26D0CE)]), // blue→cyan
  Palette([Color(0xFF4B1248), Color(0xFFF0284A)]), // plum→red
  Palette([Color(0xFF42275A), Color(0xFF734B6D)]), // mauve
  Palette([Color(0xFF16222A), Color(0xFF3A6073)]), // slate blue
  Palette([Color(0xFF373B44), Color(0xFF4286F4)]), // graphite→royal
  Palette([
    Color(0xFF0F2027),
    Color(0xFF203A43),
    Color(0xFF2C5364),
  ]), // deep teal
];
