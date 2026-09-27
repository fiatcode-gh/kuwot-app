import 'package:equatable/equatable.dart';
import 'package:kuwot/features/quote/domain/entities/background_style.dart';
import 'package:kuwot/features/quote/domain/entities/pad_day.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';

/// A single day's pad content: date, quote, and header style.
class PadPage extends Equatable {
  const PadPage({required this.day, required this.quote, required this.header});

  final PadDay day;
  final Quote quote;
  final BackgroundStyle header;

  PadPage copyWith({PadDay? day, Quote? quote, BackgroundStyle? header}) {
    return PadPage(
      day: day ?? this.day,
      quote: quote ?? this.quote,
      header: header ?? this.header,
    );
  }

  @override
  List<Object> get props => [day, quote, header];
}
