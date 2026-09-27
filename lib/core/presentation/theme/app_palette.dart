import 'package:flutter/material.dart';

/// Paper/ink colour tokens for the page-a-day pad. Registered as a
/// [ThemeExtension] so the pad's palette (paper stock, binding, stacked-page
/// hint) travels with [ThemeData] alongside Material's colour roles — the
/// pad still reads as itself against either app theme.
///
/// Contrast: `paper`/`ink` and `paper`/`inkMuted` both exceed 7:1 (WCAG AAA);
/// see the prototype design note for the measurements.
class AppPalette extends ThemeExtension<AppPalette> {
  const AppPalette({
    required this.desk,
    required this.paper,
    required this.ink,
    required this.inkMuted,
    required this.binding,
    required this.bindingHighlight,
    required this.staple,
    required this.stapleShadow,
    required this.stackA,
    required this.stackB,
    required this.divider,
  });

  /// Background behind the pad (the "desk").
  final Color desk;

  /// The page itself (paper stock).
  final Color paper;

  /// Primary text on paper.
  final Color ink;

  /// Secondary text on paper (author line).
  final Color inkMuted;

  /// The board/cardboard band holding the pad at its top.
  final Color binding;

  /// A lighter edge on the binding band for a hint of material depth.
  final Color bindingHighlight;

  /// The metal staples pressed into the binding band.
  final Color staple;
  final Color stapleShadow;

  /// The two sheets hinted at underneath the current page.
  final Color stackA;
  final Color stackB;

  /// Thin rule between the pad and the control dock.
  final Color divider;

  static const light = AppPalette(
    desk: Color(0xFFE4D9C3),
    paper: Color(0xFFF3ECDD),
    ink: Color(0xFF2B2115),
    inkMuted: Color(0xFF5B4636),
    binding: Color(0xFF4A3728),
    bindingHighlight: Color(0xFF6B4F3A),
    staple: Color(0xFFC9C6BC),
    stapleShadow: Color(0xFF716E62),
    stackA: Color(0xFFE9DEC9),
    stackB: Color(0xFFE0D3B9),
    divider: Color(0xFFCBBFA0),
  );

  static const dark = AppPalette(
    desk: Color(0xFF131110),
    paper: Color(0xFF1E1B18),
    ink: Color(0xFFEDE6D6),
    inkMuted: Color(0xFFB8AD98),
    binding: Color(0xFF0D0C0B),
    bindingHighlight: Color(0xFF2A2622),
    staple: Color(0xFF8A867C),
    stapleShadow: Color(0xFF3E3B34),
    stackA: Color(0xFF242019),
    stackB: Color(0xFF2B2620),
    divider: Color(0xFF3A352C),
  );

  /// Ink used for text painted directly over the generated header gradient.
  /// Fixed (not theme-dependent): tuned so this ink clears WCAG AA against
  /// every palette in `kPalettes` (see `BackgroundGenerator`/`AppPalette`
  /// header colour rule).
  static const headerInk = Color(0xFFFBF5EA);

  /// Convenience accessor for the palette registered on the current theme.
  static AppPalette of(BuildContext context) =>
      Theme.of(context).extension<AppPalette>()!;

  @override
  AppPalette copyWith({
    Color? desk,
    Color? paper,
    Color? ink,
    Color? inkMuted,
    Color? binding,
    Color? bindingHighlight,
    Color? staple,
    Color? stapleShadow,
    Color? stackA,
    Color? stackB,
    Color? divider,
  }) {
    return AppPalette(
      desk: desk ?? this.desk,
      paper: paper ?? this.paper,
      ink: ink ?? this.ink,
      inkMuted: inkMuted ?? this.inkMuted,
      binding: binding ?? this.binding,
      bindingHighlight: bindingHighlight ?? this.bindingHighlight,
      staple: staple ?? this.staple,
      stapleShadow: stapleShadow ?? this.stapleShadow,
      stackA: stackA ?? this.stackA,
      stackB: stackB ?? this.stackB,
      divider: divider ?? this.divider,
    );
  }

  @override
  AppPalette lerp(ThemeExtension<AppPalette>? other, double t) {
    if (other is! AppPalette) return this;
    return AppPalette(
      desk: Color.lerp(desk, other.desk, t)!,
      paper: Color.lerp(paper, other.paper, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      inkMuted: Color.lerp(inkMuted, other.inkMuted, t)!,
      binding: Color.lerp(binding, other.binding, t)!,
      bindingHighlight: Color.lerp(
        bindingHighlight,
        other.bindingHighlight,
        t,
      )!,
      staple: Color.lerp(staple, other.staple, t)!,
      stapleShadow: Color.lerp(stapleShadow, other.stapleShadow, t)!,
      stackA: Color.lerp(stackA, other.stackA, t)!,
      stackB: Color.lerp(stackB, other.stackB, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
    );
  }
}
