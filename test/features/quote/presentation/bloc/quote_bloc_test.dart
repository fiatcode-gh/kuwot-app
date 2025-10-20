import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/data/local/config.dart';
import 'package:kuwot/core/data/local/translation_target_config.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_quote.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_translated_quote.dart';
import 'package:kuwot/features/quote/presentation/bloc/quote_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetQuote extends Mock implements GetQuote {}

class MockGetTranslatedQuote extends Mock implements GetTranslatedQuote {}

class MockTranslationTargetConfig extends Mock
    implements Config<TranslationTarget> {}

class FakeQuoteParams extends Fake implements GetQuoteParams {}

class FakeTranslatedQuoteParams extends Fake
    implements GetTranslatedQuoteParams {}

void main() {
  late MockGetQuote mockGetQuote;
  late MockGetTranslatedQuote mockGetTranslatedQuote;
  late MockTranslationTargetConfig mockTranslationTargetConfig;
  late QuoteBloc quoteBloc;

  setUpAll(() {
    registerFallbackValue(FakeQuoteParams());
    registerFallbackValue(FakeTranslatedQuoteParams());
  });

  setUp(() {
    mockGetQuote = MockGetQuote();
    mockGetTranslatedQuote = MockGetTranslatedQuote();
    mockTranslationTargetConfig = MockTranslationTargetConfig();

    quoteBloc = QuoteBloc(
      getQuote: mockGetQuote,
      getTranslatedQuote: mockGetTranslatedQuote,
      translationTargetConfig: mockTranslationTargetConfig,
    );
  });

  const tTranslationTarget = TranslationTarget(id: 'en', name: 'English');
  const tQuote = Quote(id: 1, author: 'author', body: 'text');
  const tFailure = UnknownFailure(message: 'Unknown Failure');

  test('initial state is QuoteInitial', () {
    // assert
    expect(quoteBloc.state, const QuoteInitialState());
  });

  group('GetQuote', () {
    test('should get quote from GetQuote use case', () async {
      // arrange
      when(() => mockGetQuote(any())).thenAnswer((_) async => right(tQuote));
      when(
        () => mockTranslationTargetConfig.get(),
      ).thenAnswer((_) async => tTranslationTarget);

      // act
      quoteBloc.add(const GetQuoteEvent());
      await untilCalled(() => mockTranslationTargetConfig.get());
      await untilCalled(() => mockGetQuote(any()));

      // assert
      verify(() => mockGetQuote(any()));
      verifyNoMoreInteractions(mockGetQuote);
    });

    test(
      'should emit [QuoteLoading, QuoteLoaded] when data is gotten successfully',
      () async {
        // arrange
        when(() => mockGetQuote(any())).thenAnswer((_) async => right(tQuote));
        when(
          () => mockTranslationTargetConfig.get(),
        ).thenAnswer((_) async => tTranslationTarget);

        // assert later
        const expected = [QuoteLoadingState(), QuoteLoadedState(quote: tQuote)];
        expectLater(quoteBloc.stream, emitsInOrder(expected));

        // act
        quoteBloc.add(const GetQuoteEvent());
      },
    );

    test(
      'should emit [QuoteLoading, QuoteError] when getting data fails',
      () async {
        // arrange
        when(() => mockGetQuote(any())).thenAnswer((_) async => left(tFailure));
        when(
          () => mockTranslationTargetConfig.get(),
        ).thenAnswer((_) async => tTranslationTarget);

        // assert later
        final expected = [
          const QuoteLoadingState(),
          QuoteErrorState(message: tFailure.message),
        ];
        expectLater(quoteBloc.stream, emitsInOrder(expected));

        // act
        quoteBloc.add(const GetQuoteEvent());
      },
    );
  });

  group('GetTranslatedQuote', () {
    test(
      'should get translated quote from GetTranslatedQuote use case',
      () async {
        // arrange
        when(
          () => mockGetTranslatedQuote(any()),
        ).thenAnswer((_) async => right(tQuote));
        when(
          () => mockTranslationTargetConfig.get(),
        ).thenAnswer((_) async => tTranslationTarget);

        // act
        quoteBloc.add(const GetTranslatedQuoteEvent(tTranslationTarget));
        await untilCalled(() => mockTranslationTargetConfig.get());
        await untilCalled(() => mockGetTranslatedQuote(any()));

        // assert
        verify(() => mockGetTranslatedQuote(any()));
        verifyNoMoreInteractions(mockGetTranslatedQuote);
      },
    );

    test(
      'should emit [QuoteLoading, QuoteLoaded] when data is gotten successfully',
      () async {
        // arrange
        when(
          () => mockGetTranslatedQuote(any()),
        ).thenAnswer((_) async => right(tQuote));
        when(
          () => mockTranslationTargetConfig.get(),
        ).thenAnswer((_) async => tTranslationTarget);

        // assert later
        const expected = [QuoteLoadingState(), QuoteLoadedState(quote: tQuote)];
        expectLater(quoteBloc.stream, emitsInOrder(expected));

        // act
        quoteBloc.add(const GetTranslatedQuoteEvent(tTranslationTarget));
      },
    );

    test(
      'should emit [QuoteLoading, QuoteError] when getting data fails',
      () async {
        // arrange
        when(
          () => mockGetTranslatedQuote(any()),
        ).thenAnswer((_) async => left(tFailure));
        when(
          () => mockTranslationTargetConfig.get(),
        ).thenAnswer((_) async => tTranslationTarget);

        // assert later
        final expected = [
          const QuoteLoadingState(),
          QuoteErrorState(message: tFailure.message),
        ];
        expectLater(quoteBloc.stream, emitsInOrder(expected));

        // act
        quoteBloc.add(const GetTranslatedQuoteEvent(tTranslationTarget));
      },
    );
  });
}
