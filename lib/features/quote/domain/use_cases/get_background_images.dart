import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/domain/no_params.dart';
import 'package:kuwot/core/domain/use_case.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/quote/domain/entities/background_image.dart';
import 'package:kuwot/features/quote/domain/repositories/quote_repository.dart';

class GetBackgroundImages extends UseCase<List<BackgroundImage>, NoParams> {
  final QuoteRepository _repository;

  GetBackgroundImages(QuoteRepository repository) : _repository = repository;

  @override
  Future<Either<Failure, List<BackgroundImage>>> call(NoParams params) async {
    return await _repository.getBackgroundImages();
  }
}
