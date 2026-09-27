import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/features/quote/domain/entities/background_style.dart';
import 'package:kuwot/features/quote/domain/entities/palettes.dart';
import 'package:kuwot/features/quote/domain/services/background_recipe.dart';
import 'package:kuwot/features/quote/presentation/widgets/background_painter.dart';

/// The worst-case absolute per-channel difference between any two
/// horizontally or vertically adjacent pixels, with its location. A hard
/// colour band (a seam) shows up as a spike far above ordinary anti-aliased
/// gradient noise, which never exceeds a few levels per pixel step.
({int maxDiff, int x, int y, int channel}) _worstAdjacentChannelDiff(
  Uint8List rgba,
  int width,
  int height,
) {
  var worst = (maxDiff: 0, x: 0, y: 0, channel: 0);
  int at(int x, int y, int c) => rgba[(y * width + x) * 4 + c];
  for (var y = 0; y < height; y++) {
    for (var x = 0; x < width; x++) {
      for (var c = 0; c < 4; c++) {
        final v = at(x, y, c);
        if (x + 1 < width) {
          final d = (v - at(x + 1, y, c)).abs();
          if (d > worst.maxDiff) worst = (maxDiff: d, x: x, y: y, channel: c);
        }
        if (y + 1 < height) {
          final d = (v - at(x, y + 1, c)).abs();
          if (d > worst.maxDiff) worst = (maxDiff: d, x: x, y: y, channel: c);
        }
      }
    }
  }
  return worst;
}

/// The first [count] seeds whose selected engine is [engine].
List<int> _seedsForEngine(int engine, int count) {
  final seeds = <int>[];
  for (var s = 0; seeds.length < count; s++) {
    if (BackgroundRecipe.engineFor(s) == engine) seeds.add(s);
  }
  return seeds;
}

void main() {
  const sizes = [ui.Size(320, 200), ui.Size(520, 260), ui.Size(300, 300)];

  testWidgets('every engine paints without hard colour bands', (tester) async {
    await tester.runAsync(() async {
      for (var engine = 0; engine < BackgroundRecipe.engineCount; engine++) {
        for (final seed in _seedsForEngine(engine, 3)) {
          for (final palette in kPalettes) {
            for (final size in sizes) {
              final style = BackgroundStyle(seed: seed, palette: palette);
              final recorder = ui.PictureRecorder();
              final canvas = ui.Canvas(recorder, ui.Offset.zero & size);
              BackgroundPainter(style).paint(canvas, size);
              final picture = recorder.endRecording();
              final image = await picture.toImage(
                size.width.toInt(),
                size.height.toInt(),
              );
              final byteData = await image.toByteData(
                format: ui.ImageByteFormat.rawRgba,
              );
              final worst = _worstAdjacentChannelDiff(
                byteData!.buffer.asUint8List(),
                size.width.toInt(),
                size.height.toInt(),
              );
              picture.dispose();
              image.dispose();
              expect(
                worst.maxDiff,
                lessThanOrEqualTo(8),
                reason:
                    'hard band: engine $engine seed $seed palette '
                    '${palette.colors} size $size at pixel '
                    '(${worst.x}, ${worst.y}) channel ${worst.channel}',
              );
            }
          }
        }
      }
    });
  });
}
