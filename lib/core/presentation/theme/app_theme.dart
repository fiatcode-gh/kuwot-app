import 'package:flutter/material.dart';
import 'package:kuwot/core/presentation/theme/app_fonts.dart';
import 'package:kuwot/core/presentation/theme/app_palette.dart';

/// Builds a [ThemeData] carrying [p] as a registered [AppPalette] extension,
/// with every Material component themed from the same paper/ink tokens so
/// the chrome around the pad (app bars, cards, snackbars, dividers) reads as
/// one surface rather than a default Material theme wrapped around a
/// differently-styled pad.
ThemeData buildAppTheme(AppPalette p, Brightness b) => ThemeData(
  colorScheme: ColorScheme.fromSeed(seedColor: p.ink, brightness: b).copyWith(
    surface: p.paper,
    onSurface: p.ink,
    onSurfaceVariant: p.inkMuted,
    primary: p.ink,
    onPrimary: p.paper,
    outline: p.divider,
    outlineVariant: p.divider,
  ),
  scaffoldBackgroundColor: p.desk,
  useMaterial3: true,
  fontFamily: AppFonts.spaceGroteskFamily,
  appBarTheme: AppBarTheme(
    backgroundColor: p.desk,
    foregroundColor: p.ink,
    elevation: 0,
    scrolledUnderElevation: 0,
    centerTitle: false,
    titleTextStyle: TextStyle(
      fontFamily: AppFonts.frauncesFamily,
      fontSize: 22,
      color: p.ink,
      fontVariations: const [
        FontVariation('wght', 600),
        FontVariation('opsz', 22),
      ],
    ),
  ),
  cardTheme: CardThemeData(
    color: p.paper,
    elevation: 0,
    margin: const EdgeInsets.symmetric(vertical: 6),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.zero,
      side: BorderSide(color: p.divider),
    ),
  ),
  dividerTheme: DividerThemeData(color: p.divider),
  progressIndicatorTheme: ProgressIndicatorThemeData(
    color: p.ink,
    linearTrackColor: p.divider,
  ),
  snackBarTheme: SnackBarThemeData(
    backgroundColor: p.ink,
    contentTextStyle: AppFonts.body(size: 14, color: p.paper),
    actionTextColor: p.paper,
    behavior: SnackBarBehavior.floating,
    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
  ),
  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(foregroundColor: p.ink),
  ),
  segmentedButtonTheme: SegmentedButtonThemeData(
    style: SegmentedButton.styleFrom(foregroundColor: p.ink),
  ),
  dropdownMenuTheme: DropdownMenuThemeData(textStyle: TextStyle(color: p.ink)),
  extensions: [p],
);

/// App light theme
final ThemeData lightTheme = buildAppTheme(AppPalette.light, Brightness.light);

/// App dark theme
final ThemeData darkTheme = buildAppTheme(AppPalette.dark, Brightness.dark);
