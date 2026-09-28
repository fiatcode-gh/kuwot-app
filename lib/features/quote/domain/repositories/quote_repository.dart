import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/domain/entities/quote_group.dart';

abstract class QuoteRepository {
  Future<Either<Failure, Quote>> getQuote(Set<QuoteGroup> groups);
  Future<Either<Failure, Quote>> getQuoteById(int id);
}
