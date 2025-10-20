import 'package:freezed_annotation/freezed_annotation.dart';

part 'translation_model.freezed.dart';
part 'translation_model.g.dart';

@freezed
abstract class TranslationModel with _$TranslationModel {
  const factory TranslationModel({required String id, required String lang}) =
      _TranslationModel;

  factory TranslationModel.fromJson(Map<String, dynamic> json) =>
      _$TranslationModelFromJson(json);
}
