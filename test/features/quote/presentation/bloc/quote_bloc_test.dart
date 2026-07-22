import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kuwot/core/domain/no_params.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_quote.dart';
import 'package:kuwot/features/quote/presentation/bloc/quote_bloc.dart';

class _MockGetQuote extends Mock implements GetQuote {}

void main() {
  late _MockGetQuote getQuote;

  setUpAll(() => registerFallbackValue(const NoParams()));
  setUp(() => getQuote = _MockGetQuote());

  blocTest<QuoteBloc, QuoteState>(
    'emits [Loading, Loaded] on GetQuoteEvent success',
    build: () {
      when(() => getQuote(any())).thenAnswer(
        (_) async => right(const Quote(id: 1, author: 'A', body: 'B')),
      );
      return QuoteBloc(getQuote: getQuote);
    },
    act: (bloc) => bloc.add(const GetQuoteEvent()),
    wait: const Duration(milliseconds: 50),
    expect: () => [
      const QuoteLoadingState(),
      const QuoteLoadedState(
        quote: Quote(id: 1, author: 'A', body: 'B'),
      ),
    ],
  );

  blocTest<QuoteBloc, QuoteState>(
    'emits [Loading, Error] on GetQuoteEvent failure',
    build: () {
      when(
        () => getQuote(any()),
      ).thenAnswer((_) async => left(const UnknownFailure(message: 'boom')));
      return QuoteBloc(getQuote: getQuote);
    },
    act: (bloc) => bloc.add(const GetQuoteEvent()),
    wait: const Duration(milliseconds: 50),
    expect: () => [
      const QuoteLoadingState(),
      const QuoteErrorState(message: 'boom'),
    ],
  );
}
