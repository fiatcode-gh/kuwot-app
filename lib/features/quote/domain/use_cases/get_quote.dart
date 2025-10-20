import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/data/local/translation_target_config.dart';
import 'package:kuwot/core/domain/use_case.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/domain/repositories/quote_repository.dart';

class GetQuote extends UseCase<Quote, GetQuoteParams> {
  final QuoteRepository _repository;

  GetQuote(QuoteRepository repository) : _repository = repository;

  @override
  Future<Either<Failure, Quote>> call(GetQuoteParams params) {
    return _repository.getQuote(params.translationTarget);
  }
}

class GetQuoteParams extends Equatable {
  final TranslationTarget? translationTarget;

  const GetQuoteParams(this.translationTarget);

  @override
  List<Object?> get props => [translationTarget];
}
