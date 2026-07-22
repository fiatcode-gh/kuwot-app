import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/domain/no_params.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/domain/repositories/quote_repository.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_quote.dart';
import 'package:mocktail/mocktail.dart';

class MockQuoteRepository extends Mock implements QuoteRepository {}

void main() {
  late MockQuoteRepository mockQuoteRepository;
  late GetQuote useCase;

  setUp(() {
    mockQuoteRepository = MockQuoteRepository();
    useCase = GetQuote(mockQuoteRepository);
  });

  test('should get quote', () async {
    // arrange
    const tQuote = Quote(id: 1, author: 'author', body: 'text');
    when(
      () => mockQuoteRepository.getQuote(),
    ).thenAnswer((_) async => right(tQuote));

    // act
    final result = await useCase(const NoParams());

    // assert
    expect(result, right(tQuote));
    verify(() => mockQuoteRepository.getQuote());
    verifyNoMoreInteractions(mockQuoteRepository);
  });
}
