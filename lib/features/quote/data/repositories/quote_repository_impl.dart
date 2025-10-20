import 'dart:convert';

import 'package:fpdart/fpdart.dart';
import 'package:http/http.dart';
import 'package:kuwot/core/data/local/translation_target_config.dart';
import 'package:kuwot/core/error/exception.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/core/error/server_error_model.dart';
import 'package:kuwot/features/quote/data/data_sources/remote/kuwot_api_remote_data_source.dart';
import 'package:kuwot/features/quote/domain/entities/background_image.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/domain/entities/translation.dart';
import 'package:kuwot/features/quote/domain/repositories/quote_repository.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  final KuwotApiRemoteDataSource quoteDataSource;

  QuoteRepositoryImpl({required this.quoteDataSource});

  @override
  Future<Either<Failure, List<BackgroundImage>>> getBackgroundImages() async {
    try {
      final images = await quoteDataSource.getRandomImages();
      return right(BackgroundImage.fromModels(images));
    } on ClientException catch (e) {
      return left(
        ClientFailure(message: "Failed to connect to the server", cause: e),
      );
    } on Exception catch (e) {
      return left(UnknownFailure(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Either<Failure, Quote>> getQuote(
    TranslationTarget? translationTarget,
  ) async {
    try {
      final query = translationTarget != null
          ? "lang=${translationTarget.id}"
          : null;
      final quote = await quoteDataSource.getQuote(query: query);
      return right(Quote.fromModel(quote));
    } on ClientException catch (e) {
      return left(
        ClientFailure(message: "Failed to connect to the server", cause: e),
      );
    } on ServerException catch (e) {
      final error = ServerErrorModel.fromJson(jsonDecode(e.message));
      return left(
        ServerFailure(message: '${error.message} (${error.code})', cause: e),
      );
    } on Exception catch (e) {
      return left(UnknownFailure(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Either<Failure, Quote>> getTranslatedQuote(
    int id,
    TranslationTarget translationTarget,
  ) async {
    try {
      final query = "lang=${translationTarget.id}";
      final quote = await quoteDataSource.getTranslatedQuote(id, query: query);
      return right(Quote.fromModel(quote));
    } on ClientException catch (e) {
      return left(
        ClientFailure(message: "Failed to connect to the server", cause: e),
      );
    } on Exception catch (e) {
      return left(UnknownFailure(message: e.toString(), cause: e));
    }
  }

  @override
  Future<Either<Failure, List<Translation>>> getTranslations() async {
    try {
      final translations = await quoteDataSource.getTranslations();
      return right(translations.map((e) => Translation.fromModel(e)).toList());
    } on ClientException catch (e) {
      return left(
        ClientFailure(message: "Failed to connect to the server", cause: e),
      );
    } on Exception catch (e) {
      return left(UnknownFailure(message: e.toString(), cause: e));
    }
  }
}
