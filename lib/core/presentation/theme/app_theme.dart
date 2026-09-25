import 'package:flutter/material.dart';
import 'package:kuwot/core/presentation/theme/app_fonts.dart';
import 'package:kuwot/core/presentation/theme/app_palette.dart';

/// Builds a [ThemeData] carrying [p] as a registered [AppPalette] extension.
ThemeData buildAppTheme(AppPalette p, Brightness b) => ThemeData(
  colorScheme: ColorScheme.fromSeed(
    seedColor: p.ink,
    surface: p.paper,
    brightness: b,
  ),
  scaffoldBackgroundColor: p.desk,
  useMaterial3: true,
  fontFamily: AppFonts.spaceGroteskFamily,
  extensions: [p],
);

/// App light theme
final ThemeData lightTheme = buildAppTheme(AppPalette.light, Brightness.light);

/// App dark theme
final ThemeData darkTheme = buildAppTheme(AppPalette.dark, Brightness.dark);
