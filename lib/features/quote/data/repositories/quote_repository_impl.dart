import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/quote/data/data_sources/local/quote_local_data_source.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/domain/repositories/quote_repository.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  QuoteRepositoryImpl({required this.localDataSource});

  final QuoteLocalDataSource localDataSource;

  @override
  Future<Either<Failure, Quote>> getQuote() async {
    try {
      final model = await localDataSource.getRandomQuote();
      return right(Quote.fromModel(model));
    } on Object catch (e) {
      return left(
        UnknownFailure(message: e.toString(), cause: e is Exception ? e : null),
      );
    }
  }
}
