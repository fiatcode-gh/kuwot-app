import 'package:flutter/painting.dart' show Color;
import 'package:kuwot/features/quote/domain/entities/background_style.dart';

/// Curated header background palettes. Print-ink families only, no scrim —
/// every colour must stay legible painted directly under [AppPalette.headerInk]
/// text and against [AppPalette.dark]'s paper, so contrast comes from *hue and
/// depth*, not a darkening overlay. Verified numerically (Ottosson OKLCH,
/// WCAG contrast) against the G6 constraints, each with margin:
/// - contrast ≥ 4.5 against `AppPalette.headerInk`;
/// - contrast ≥ 1.4 against `AppPalette.dark.paper`;
/// - OKLCH chroma ≥ 0.025 (never a flat near-black);
/// - no OKLCH hue in [70°, 115°] (muddy ochre/olive);
/// - no HSL hue in [250°, 335°] (the existing purple ban).
const kPalettes = <Palette>[
  Palette([
    Color(0xFF6A1925),
    Color(0xFF9D0208),
    Color(0xFFC83F00),
  ]), // oxblood→burnt orange
  Palette([Color(0xFF1B4332), Color(0xFF2D6A4F), Color(0xFF2B7D59)]), // forest
  Palette([
    Color(0xFF173380),
    Color(0xFF0075B4),
    Color(0xFF1374A3),
  ]), // ink blue deep
  Palette([
    Color(0xFF0E3A63),
    Color(0xFF2A6F97),
    Color(0xFF2C7796),
  ]), // ink blue steel
  Palette([Color(0xFF34364C), Color(0xFF434C5E), Color(0xFF576079)]), // slate
  Palette([
    Color(0xFF213C45),
    Color(0xFF2C5364),
    Color(0xFF396B7C),
  ]), // teal deep
  Palette([Color(0xFF1D2E85), Color(0xFF037C7B)]), // ink blue→teal
  Palette([Color(0xFF343C4C), Color(0xFF2F5FC4)]), // slate→ink blue
  Palette([
    Color(0xFF603205),
    Color(0xFF854408),
    Color(0xFFA45519),
  ]), // amber (replaces ochre)
];
