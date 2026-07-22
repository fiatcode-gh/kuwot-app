import 'package:equatable/equatable.dart';
import 'package:flutter/painting.dart' show Color;

class Palette extends Equatable {
  const Palette(this.colors);

  final List<Color> colors;

  @override
  List<Object?> get props => [colors];
}

class BackgroundStyle extends Equatable {
  const BackgroundStyle({required this.seed, required this.palette});

  final int seed;
  final Palette palette;

  @override
  List<Object?> get props => [seed, palette];
}
