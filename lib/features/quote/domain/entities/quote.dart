import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuwot/features/quote/data/models/quote_model.dart';

part 'quote.freezed.dart';

@freezed
abstract class Quote with _$Quote {
  const factory Quote({
    required int id,
    required String author,
    required String body,
  }) = _Quote;

  static Quote fromModel(QuoteModel model) =>
      Quote(id: model.id, author: model.author, body: model.text);
}
