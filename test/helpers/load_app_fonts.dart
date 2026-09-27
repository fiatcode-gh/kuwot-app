import 'dart:io';

import 'package:flutter/services.dart';
import 'package:kuwot/core/presentation/theme/app_fonts.dart';

bool _loaded = false;

/// Loads the bundled Fraunces and Space Grotesk fonts into the test
/// environment, so widget tests that measure or fit real text (FittedBox,
/// [QuoteTypeBlock]'s [TextPainter] search) see the app's actual font
/// metrics instead of `flutter_test`'s fallback test font. Idempotent —
/// safe to call from every test file's `setUpAll`.
Future<void> loadAppFonts() async {
  if (_loaded) return;
  _loaded = true;

  Future<void> load(String family, String assetPath) async {
    final bytes = await File(assetPath).readAsBytes();
    final loader = FontLoader(family)
      ..addFont(Future.value(ByteData.sublistView(bytes)));
    await loader.load();
  }

  await load(
    AppFonts.frauncesFamily,
    'assets/fonts/Fraunces/Fraunces-Variable.ttf',
  );
  await load(
    AppFonts.frauncesFamily,
    'assets/fonts/Fraunces/Fraunces-Italic-Variable.ttf',
  );
  await load(
    AppFonts.spaceGroteskFamily,
    'assets/fonts/SpaceGrotesk/SpaceGrotesk-Variable.ttf',
  );
}
