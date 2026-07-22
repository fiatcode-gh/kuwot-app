import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/quote/data/data_sources/local/quote_local_data_source.dart';
import 'package:kuwot/features/quote/data/models/quote_model.dart';
import 'package:kuwot/features/quote/data/repositories/quote_repository_impl.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';

class _MockLocalDataSource extends Mock implements QuoteLocalDataSource {}

void main() {
  late _MockLocalDataSource dataSource;
  late QuoteRepositoryImpl repository;

  setUp(() {
    dataSource = _MockLocalDataSource();
    repository = QuoteRepositoryImpl(localDataSource: dataSource);
  });

  test('getQuote maps a model to a Right(Quote)', () async {
    // arrange
    when(() => dataSource.getRandomQuote()).thenAnswer(
      (_) async => const QuoteModel(id: 3, text: 'Body', author: 'Author'),
    );

    // act
    final result = await repository.getQuote();

    // assert
    expect(
      result.getRight().toNullable(),
      const Quote(id: 3, author: 'Author', body: 'Body'),
    );
  });

  test('getQuote returns Left(Failure) when the data source throws', () async {
    // arrange
    when(() => dataSource.getRandomQuote()).thenThrow(Exception('boom'));

    // act
    final result = await repository.getQuote();

    // assert
    expect(result.isLeft(), isTrue);
  });

  test('getQuote returns Left(UnknownFailure) when the data source throws '
      'an Error (e.g. from a missing asset or bad cast)', () async {
    // arrange
    when(() => dataSource.getRandomQuote()).thenThrow(TypeError());

    // act
    final result = await repository.getQuote();

    // assert
    expect(result.isLeft(), isTrue);
    expect(result.getLeft().toNullable(), isA<UnknownFailure>());
  });
}
