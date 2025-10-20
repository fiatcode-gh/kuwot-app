import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/domain/no_params.dart';
import 'package:kuwot/core/domain/use_case.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/quote/domain/entities/translation.dart';
import 'package:kuwot/features/quote/domain/repositories/quote_repository.dart';

class GetTranslations extends UseCase<List<Translation>, NoParams> {
  final QuoteRepository _repository;

  GetTranslations(QuoteRepository repository) : _repository = repository;

  @override
  Future<Either<Failure, List<Translation>>> call(NoParams params) {
    return _repository.getTranslations();
  }
}
