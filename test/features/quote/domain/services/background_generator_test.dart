import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/features/quote/domain/entities/palettes.dart';
import 'package:kuwot/features/quote/domain/services/background_generator.dart';

void main() {
  const generator = BackgroundGenerator();

  test('is deterministic for the same (seed, variant)', () {
    final a = generator.generate(42, 0);
    final b = generator.generate(42, 0);
    expect(a, b);
  });

  test('different variants produce different seeds', () {
    final a = generator.generate(42, 0);
    final b = generator.generate(42, 1);
    expect(a.seed, isNot(b.seed));
  });

  test('picks a palette from the configured set', () {
    final style = generator.generate(7, 3);
    expect(kPalettes, contains(style.palette));
  });

  test('seed is a fixed linear mix, stable across process runs', () {
    // Object.hash is only guaranteed stable within one process run and was
    // measured to change between runs — this arithmetic mix is the only
    // in-process observable proof that the seed itself never depends on it.
    expect(
      const BackgroundGenerator().generate(20260925, 2).seed,
      20260925 * 1000003 + 2,
    );
  });
}
