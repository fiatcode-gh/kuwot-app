import 'dart:math' as math;

import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart' show Alignment, Color;
import 'package:kuwot/features/quote/domain/entities/background_style.dart';

/// A fully seed-driven description of a background, painted with Flutter's
/// built-in (GPU) gradients — no per-pixel work, so it renders instantly and
/// synchronously and is captured by `toImage` reliably.
///
/// The seed first selects one of [engineCount] *engines* (soft blobs, linear,
/// sweep, radial, duotone, corner mesh) and then drives every parameter inside
/// it — angle, centres, radii, stops, colour order — continuously, so different
/// seeds never repeat even though the primitives are simple.
///
/// Every colour comes from the palette, so the legibility guarantee holds:
/// gradients only interpolate between palette colours (and toward transparency),
/// which stays within the palette's luminance. Pure and deterministic — the same
/// `(seed, palette)` always yields an equal recipe.
class BackgroundRecipe extends Equatable {
  const BackgroundRecipe({
    required this.engine,
    required this.colors,
    required this.angle,
    required this.points,
    required this.radii,
    required this.stops,
  });

  /// Number of engines the seed chooses between.
  static const int engineCount = 6;

  /// Selected engine index.
  final int engine;

  /// Palette colours the engine paints with, in use order. Engine-specific
  /// meaning (e.g. blobs: `[base0, base1, blob0, blob1, …]`).
  final List<Color> colors;

  /// Primary direction / rotation in radians (linear, sweep, duotone).
  final double angle;

  /// Gradient centres / focal points (blobs, radial, sweep, corner mesh).
  final List<Alignment> points;

  /// Radii as a fraction of the shortest side (blobs, radial, corner mesh).
  final List<double> radii;

  /// Ascending gradient stop positions (linear, duotone).
  final List<double> stops;

  /// Which engine a seed selects. Matches [fromSeed]'s first draw.
  static int engineFor(int seed) => math.Random(seed).nextInt(engineCount);

  factory BackgroundRecipe.fromSeed(int seed, Palette palette) {
    final rng = math.Random(seed);
    final engine = rng.nextInt(engineCount);
    // engineFor() must select the same engine for this seed; keep the two in
    // lockstep (fails loudly in debug if a draw is ever inserted before this).
    assert(engine == engineFor(seed), 'engineFor diverged from fromSeed');
    final pal = _shuffled(palette.colors, rng);
    return switch (engine) {
      0 => _softBlobs(engine, pal, rng),
      1 => _linear(engine, pal, rng),
      2 => _sweep(engine, pal, rng),
      3 => _radial(engine, pal, rng),
      4 => _duotone(engine, pal, rng),
      _ => _cornerMesh(engine, pal, rng),
    };
  }

  // --- Engine 0: soft blobs (mesh-lite / aurora) -----------------------------

  static BackgroundRecipe _softBlobs(
    int engine,
    List<Color> pal,
    math.Random rng,
  ) {
    final blobCount = 3 + rng.nextInt(3); // 3..5
    final colors = <Color>[pal[0], pal[1 % pal.length]]; // base gradient pair
    final points = <Alignment>[];
    final radii = <double>[];
    for (var i = 0; i < blobCount; i++) {
      colors.add(pal[i % pal.length]);
      points.add(_alignment(rng));
      radii.add(0.5 + rng.nextDouble() * 0.7); // 0.5..1.2
    }
    return BackgroundRecipe(
      engine: engine,
      colors: colors,
      angle: rng.nextDouble() * 2 * math.pi,
      points: points,
      radii: radii,
      stops: const [],
    );
  }

  // --- Engine 1: linear gradient ---------------------------------------------

  static BackgroundRecipe _linear(
    int engine,
    List<Color> pal,
    math.Random rng,
  ) {
    final n = math.min(pal.length, 2 + rng.nextInt(2)); // 2..3 stops
    final colors = [for (var i = 0; i < n; i++) pal[i]];
    return BackgroundRecipe(
      engine: engine,
      colors: colors,
      angle: rng.nextDouble() * 2 * math.pi,
      points: const [],
      radii: const [],
      stops: _spreadStops(n, rng),
    );
  }

  // --- Engine 2: sweep / conic gradient --------------------------------------

  static BackgroundRecipe _sweep(int engine, List<Color> pal, math.Random rng) {
    // Push the cone's centre well outside the rect so only a gentle arc shows —
    // no on-screen pinch point, no hard wrap seam. Reads as a smooth curved glow.
    final dir = rng.nextDouble() * 2 * math.pi;
    final dist = 2.2 + rng.nextDouble() * 1.0; // 2.2..3.2 (rect spans ±1)
    return BackgroundRecipe(
      engine: engine,
      colors: pal,
      angle: rng.nextDouble() * 2 * math.pi,
      points: [Alignment(math.cos(dir) * dist, math.sin(dir) * dist)],
      radii: const [],
      stops: const [],
    );
  }

  // --- Engine 3: radial spotlight --------------------------------------------

  static BackgroundRecipe _radial(
    int engine,
    List<Color> pal,
    math.Random rng,
  ) {
    final colors = rng.nextBool() ? pal.reversed.toList() : pal;
    return BackgroundRecipe(
      engine: engine,
      colors: colors,
      angle: 0,
      points: [_alignment(rng, 0.6)], // off-centre focal point
      radii: [1.0 + rng.nextDouble() * 0.8], // 1.0..1.8
      stops: const [],
    );
  }

  // --- Engine 4: duotone diagonal split --------------------------------------

  static BackgroundRecipe _duotone(
    int engine,
    List<Color> pal,
    math.Random rng,
  ) {
    final colors = [pal[0], pal[1 % pal.length]];
    final mid = 0.35 + rng.nextDouble() * 0.3; // 0.35..0.65
    final seam = 0.04 + rng.nextDouble() * 0.06; // soft transition width
    return BackgroundRecipe(
      engine: engine,
      colors: colors,
      angle: rng.nextDouble() * 2 * math.pi,
      points: const [],
      radii: const [],
      stops: [(mid - seam).clamp(0.0, 1.0), (mid + seam).clamp(0.0, 1.0)],
    );
  }

  // --- Engine 5: corner mesh (colour pulled to the corners) ------------------

  static BackgroundRecipe _cornerMesh(
    int engine,
    List<Color> pal,
    math.Random rng,
  ) {
    const corners = [
      Alignment.topLeft,
      Alignment.topRight,
      Alignment.bottomLeft,
      Alignment.bottomRight,
    ];
    return BackgroundRecipe(
      engine: engine,
      colors: [for (var i = 0; i < 4; i++) pal[i % pal.length]],
      angle: 0,
      points: corners,
      radii: [for (var i = 0; i < 4; i++) 1.1 + rng.nextDouble() * 0.6],
      stops: const [],
    );
  }

  // --- Helpers ---------------------------------------------------------------

  static List<Color> _shuffled(List<Color> colors, math.Random rng) {
    final list = List<Color>.of(colors);
    list.shuffle(rng);
    return list;
  }

  /// A random alignment in `[-range, range]` on each axis (range 1 = full rect).
  static Alignment _alignment(math.Random rng, [double range = 1.0]) {
    return Alignment(
      (rng.nextDouble() * 2 - 1) * range,
      (rng.nextDouble() * 2 - 1) * range,
    );
  }

  /// `n` ascending stops spanning [0, 1] with jittered interior positions.
  static List<double> _spreadStops(int n, math.Random rng) {
    if (n <= 2) return const [0.0, 1.0];
    final interior = [
      for (var i = 0; i < n - 2; i++) 0.2 + rng.nextDouble() * 0.6,
    ]..sort();
    return [0.0, ...interior, 1.0];
  }

  @override
  List<Object?> get props => [engine, colors, angle, points, radii, stops];
}
