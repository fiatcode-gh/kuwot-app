import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/domain/use_case.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/domain/repositories/quote_repository.dart';

class GetQuoteById extends UseCase<Quote, int> {
  GetQuoteById(QuoteRepository repository) : _repository = repository;

  final QuoteRepository _repository;

  @override
  Future<Either<Failure, Quote>> call(int params) {
    return _repository.getQuoteById(params);
  }
}
