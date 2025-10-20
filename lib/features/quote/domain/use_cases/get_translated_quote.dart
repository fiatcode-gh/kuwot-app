import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/data/local/translation_target_config.dart';
import 'package:kuwot/core/domain/use_case.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/domain/repositories/quote_repository.dart';

class GetTranslatedQuote extends UseCase<Quote, GetTranslatedQuoteParams> {
  final QuoteRepository _repository;

  GetTranslatedQuote(QuoteRepository repository) : _repository = repository;

  @override
  Future<Either<Failure, Quote>> call(GetTranslatedQuoteParams params) async {
    return await _repository.getTranslatedQuote(
      params.id,
      params.translationTarget,
    );
  }
}

class GetTranslatedQuoteParams extends Equatable {
  final int id;
  final TranslationTarget translationTarget;

  const GetTranslatedQuoteParams({
    required this.id,
    required this.translationTarget,
  });

  @override
  List<Object?> get props => [id, translationTarget];
}
