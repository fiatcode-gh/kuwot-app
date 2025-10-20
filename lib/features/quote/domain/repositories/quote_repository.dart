import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/data/local/translation_target_config.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/quote/domain/entities/background_image.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/domain/entities/translation.dart';

abstract class QuoteRepository {
  Future<Either<Failure, List<BackgroundImage>>> getBackgroundImages();

  Future<Either<Failure, Quote>> getQuote(TranslationTarget? translationTarget);

  Future<Either<Failure, Quote>> getTranslatedQuote(
    int id,
    TranslationTarget translationTarget,
  );

  Future<Either<Failure, List<Translation>>> getTranslations();
}
