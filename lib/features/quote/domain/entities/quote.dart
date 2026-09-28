import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuwot/features/quote/data/models/quote_model.dart';
import 'package:kuwot/features/quote/domain/entities/quote_group.dart';

part 'quote.freezed.dart';

@freezed
abstract class Quote with _$Quote {
  const factory Quote({
    required int id,
    required String body,
    required QuoteGroup group,
  }) = _Quote;

  static Quote fromModel(QuoteModel model) =>
      Quote(id: model.id, body: model.text, group: model.group);
}
