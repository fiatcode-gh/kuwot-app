import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuwot/features/quote/domain/entities/quote_group.dart';

part 'quote_model.freezed.dart';

@freezed
abstract class QuoteModel with _$QuoteModel {
  const factory QuoteModel({
    required int id,
    required String text,
    required QuoteGroup group,
  }) = _QuoteModel;
}
