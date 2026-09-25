import 'package:equatable/equatable.dart';
import 'package:kuwot/features/quote/domain/entities/pad_day.dart';

/// A pending header restyle for a specific day.
class HeaderReroll extends Equatable {
  const HeaderReroll(this.day, this.variant);

  final PadDay day;
  final int variant;

  @override
  List<Object> get props => [day, variant];
}

/// The last-viewed pad state, persisted across app restarts.
class PadSnapshot extends Equatable {
  const PadSnapshot({required this.day, required this.quoteId, this.reroll});

  final PadDay day;
  final int quoteId;
  final HeaderReroll? reroll;

  @override
  List<Object?> get props => [day, quoteId, reroll];
}
