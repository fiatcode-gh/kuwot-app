import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/data/local/translation_target_config.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/domain/repositories/quote_repository.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_translated_quote.dart';
import 'package:mocktail/mocktail.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

class FakeTranslationTarget extends Fake implements TranslationTarget {}

void main() {
  late MockQuoteRepository mockQuoteRepository;
  late GetTranslatedQuote useCase;

  setUpAll(() {
    registerFallbackValue(FakeTranslationTarget());
  });

  setUp(() {
    mockQuoteRepository = MockQuoteRepository();
    useCase = GetTranslatedQuote(mockQuoteRepository);
  });

  test('should get translated quote', () async {
    // arrange
    const tQuote = Quote(id: 1, author: 'author', body: 'text');
    const tTarget = TranslationTarget(id: 'en', name: 'English');
    when(
      () => mockQuoteRepository.getTranslatedQuote(any(), any()),
    ).thenAnswer((_) async => right(tQuote));

    // act
    final result = await useCase(
      const GetTranslatedQuoteParams(id: 1, translationTarget: tTarget),
    );

    // assert
    expect(result, right(tQuote));
    verify(() => mockQuoteRepository.getTranslatedQuote(tQuote.id, tTarget));
    verifyNoMoreInteractions(mockQuoteRepository);
  });
}
