import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/domain/no_params.dart';
import 'package:kuwot/core/domain/use_case.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/domain/repositories/quote_repository.dart';

class GetQuote extends UseCase<Quote, NoParams> {
  GetQuote(QuoteRepository repository) : _repository = repository;

  final QuoteRepository _repository;

  @override
  Future<Either<Failure, Quote>> call(NoParams params) {
    return _repository.getQuote();
  }
}
