import 'package:flutter/painting.dart';

/// Typography for the page-a-day pad, built on two bundled OFL variable
/// fonts (see `assets/fonts/*/OFL.txt`; no runtime font fetching):
///
/// - **Fraunces** — a characterful display serif. Its `wght`/`opsz`/`SOFT`/
///   `WONK` axes are driven directly via [FontVariation] rather than through
///   Flutter's named-weight-per-asset trick, so every use gets an exact,
///   deliberate instance instead of whatever the nearest declared weight is.
///   Roman for the big day number (heavy, high optical size, a hint of
///   `WONK` for a hand-set stamp feel); italic for the quote body (lighter,
///   optical size matched to its rendered size, no wonk — a calmer, more
///   literary voice than the numeral).
/// - **Space Grotesk** — a plain grotesk sans for everything that is a label
///   rather than the "voice" of the page: weekday/month, the author line,
///   and the surrounding chrome.
class AppFonts {
  const AppFonts._();

  static const frauncesFamily = 'Fraunces';
  static const spaceGroteskFamily = 'Space Grotesk';

  /// The day-of-month numeral: heavy, large optical size, a touch of wonk.
  static TextStyle dayNumeral({required double size, required Color color}) {
    return TextStyle(
      fontFamily: frauncesFamily,
      fontSize: size,
      color: color,
      height: 1.0,
      fontVariations: const [
        FontVariation('wght', 900),
        FontVariation('opsz', 144),
        FontVariation('SOFT', 0),
        FontVariation('WONK', 1),
      ],
    );
  }

  /// The quote body: italic Fraunces, optical size matched to the rendered
  /// size so small and large quotes both look correctly drawn rather than
  /// like a scaled-up text-size instance.
  static TextStyle quoteBody({required double size, required Color color}) {
    return TextStyle(
      fontFamily: frauncesFamily,
      fontStyle: FontStyle.italic,
      fontSize: size,
      color: color,
      height: 1.28,
      fontVariations: [
        const FontVariation('wght', 420),
        FontVariation('opsz', size.clamp(9.0, 144.0).toDouble()),
        const FontVariation('SOFT', 0),
        const FontVariation('WONK', 0),
      ],
    );
  }

  /// A small letter-spaced label (weekday, month).
  static TextStyle label({
    required double size,
    required Color color,
    double weight = 600,
    double letterSpacing = 3,
  }) {
    return TextStyle(
      fontFamily: spaceGroteskFamily,
      fontSize: size,
      color: color,
      letterSpacing: letterSpacing,
      fontVariations: [FontVariation('wght', weight)],
    );
  }

  /// Body-weight Space Grotesk (author line, control captions).
  static TextStyle body({
    required double size,
    required Color color,
    double weight = 500,
  }) {
    return TextStyle(
      fontFamily: spaceGroteskFamily,
      fontSize: size,
      color: color,
      fontVariations: [FontVariation('wght', weight)],
    );
  }
}
