import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart' show Color;

enum BackgroundKind {
  linearGradient,
  radialGradient,
  sweepGradient,
  blobs,
  waves,
  lowPoly,
  stripes,
}

class Palette extends Equatable {
  const Palette(this.colors);

  final List<Color> colors;

  @override
  List<Object?> get props => [colors];
}

class BackgroundStyle extends Equatable {
  const BackgroundStyle({
    required this.seed,
    required this.kind,
    required this.palette,
  });

  final int seed;
  final BackgroundKind kind;
  final Palette palette;

  @override
  List<Object?> get props => [seed, kind, palette];
}
