import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/features/quote/domain/entities/background_style.dart';
import 'package:kuwot/features/quote/domain/services/background_generator.dart';

void main() {
  const generator = BackgroundGenerator();

  test('is deterministic for the same (quoteId, variant)', () {
    final a = generator.generate(42, 0);
    final b = generator.generate(42, 0);
    expect(a, b);
  });

  test('different variants produce different seeds', () {
    final a = generator.generate(42, 0);
    final b = generator.generate(42, 1);
    expect(a.seed, isNot(b.seed));
  });

  test('picks a kind and palette from the configured sets', () {
    final style = generator.generate(7, 3);
    expect(BackgroundKind.values, contains(style.kind));
  });
}
