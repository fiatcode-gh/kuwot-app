import 'package:equatable/equatable.dart';

/// A calendar day in local time, with no time-of-day component.
class PadDay extends Equatable implements Comparable<PadDay> {
  const PadDay(this.year, this.month, this.day);

  /// Build from a local [DateTime], dropping the time-of-day.
  factory PadDay.from(DateTime local) =>
      PadDay(local.year, local.month, local.day);

  /// Strict 'yyyy-MM-dd'; throws [FormatException] for any other shape or an
  /// impossible date (e.g. 2026-02-30).
  factory PadDay.parse(String iso) {
    if (!_isoPattern.hasMatch(iso)) {
      throw FormatException('Not a yyyy-MM-dd date', iso);
    }
    final year = int.parse(iso.substring(0, 4));
    final month = int.parse(iso.substring(5, 7));
    final day = int.parse(iso.substring(8, 10));
    final roundTrip = DateTime(year, month, day);
    if (roundTrip.year != year ||
        roundTrip.month != month ||
        roundTrip.day != day) {
      throw FormatException('Not a valid calendar date', iso);
    }
    return PadDay(year, month, day);
  }

  static final _isoPattern = RegExp(r'^\d{4}-\d{2}-\d{2}$');

  final int year;
  final int month;
  final int day;

  /// A stable per-day integer, monotonic with the date.
  int get seed => year * 10000 + month * 100 + day;

  /// Midnight local time on this day.
  DateTime toDateTime() => DateTime(year, month, day);

  /// Zero-padded 'yyyy-MM-dd'.
  String toIso() {
    final y = year.toString().padLeft(4, '0');
    final m = month.toString().padLeft(2, '0');
    final d = day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  bool isBefore(PadDay other) => seed < other.seed;

  bool isAfter(PadDay other) => seed > other.seed;

  @override
  int compareTo(PadDay other) => seed.compareTo(other.seed);

  @override
  List<Object> get props => [year, month, day];
}
