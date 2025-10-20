import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/domain/no_params.dart';
import 'package:kuwot/features/quote/domain/entities/translation.dart';
import 'package:kuwot/features/quote/domain/repositories/quote_repository.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_translations.dart';
import 'package:mocktail/mocktail.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  late MockQuoteRepository mockQuoteRepository;
  late GetTranslations useCase;

  setUp(() {
    mockQuoteRepository = MockQuoteRepository();
    useCase = GetTranslations(mockQuoteRepository);
  });

  test('should get translations', () async {
    // arrange
    final tExpected = <Translation>[];
    when(
      () => mockQuoteRepository.getTranslations(),
    ).thenAnswer((_) async => right(tExpected));

    // act
    final result = await useCase(const NoParams());

    // assert
    expect(result, right(tExpected));
    verify(() => mockQuoteRepository.getTranslations());
    verifyNoMoreInteractions(mockQuoteRepository);
  });
}
