import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuwot/features/quote/data/models/translation_model.dart';

part 'translation.freezed.dart';

@freezed
abstract class Translation with _$Translation {
  const factory Translation({required String id, required String language}) =
      _Translation;

  static Translation fromModel(TranslationModel model) {
    return Translation(id: model.id, language: model.lang);
  }
}
