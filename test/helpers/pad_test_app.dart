import 'package:flutter/material.dart';
import 'package:kuwot/core/presentation/theme/app_theme.dart';

/// Wraps [child] the way the real pad screen is wrapped: a themed
/// [MaterialApp] with a [Scaffold] body, and a [MediaQuery] carrying an
/// explicit text scale and animation setting so tests can exercise the pad
/// at a large text scale or with reduce-motion on without depending on the
/// host platform's own settings.
Widget padTestApp(
  Widget child, {
  ThemeData? theme,
  double textScale = 1.0,
  bool disableAnimations = false,
}) {
  return MaterialApp(
    theme: theme ?? lightTheme,
    home: Builder(
      builder: (context) {
        final mediaQuery = MediaQuery.of(context);
        return MediaQuery(
          data: mediaQuery.copyWith(
            textScaler: TextScaler.linear(textScale),
            disableAnimations: disableAnimations,
          ),
          child: Scaffold(body: child),
        );
      },
    ),
  );
}
