import 'package:freezed_annotation/freezed_annotation.dart';

part 'quote_model.freezed.dart';
part 'quote_model.g.dart';

@freezed
abstract class QuoteModel with _$QuoteModel {
  @JsonSerializable(fieldRename: FieldRename.snake)
  const factory QuoteModel({
    required int id,
    required String text,
    required String author,
  }) = _QuoteModel;

  factory QuoteModel.fromJson(Map<String, dynamic> json) =>
      _$QuoteModelFromJson(json);
}
