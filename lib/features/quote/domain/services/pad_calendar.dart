import 'package:kuwot/features/quote/domain/entities/pad_day.dart';
import 'package:kuwot/features/quote/domain/entities/pad_snapshot.dart';
import 'package:kuwot/features/quote/domain/entities/tear_kind.dart';

/// Pure calendar rules shared by [PadBloc] handlers.
abstract final class PadCalendar {
  /// Which side of the pad the next tear removes, given the page currently
  /// on top and today's date.
  static TearKind tearKind({required PadDay pageDay, required PadDay today}) =>
      pageDay.isBefore(today) ? TearKind.page : TearKind.quote;

  /// The header variant for [day]: the pending [reroll]'s variant when it
  /// targets [day], otherwise the base variant `0`.
  static int headerVariant(PadDay day, HeaderReroll? reroll) =>
      reroll != null && reroll.day == day ? reroll.variant : 0;
}
