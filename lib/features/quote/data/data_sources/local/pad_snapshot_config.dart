import 'dart:convert';

import 'package:kuwot/core/data/local/config.dart';
import 'package:kuwot/features/quote/domain/entities/pad_day.dart';
import 'package:kuwot/features/quote/domain/entities/pad_snapshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Pad snapshot shared preferences key.
const padSnapshotConfigKey = 'padSnapshot';

/// Pad snapshot configuration, backed by [SharedPreferences].
class PadSnapshotConfig extends Config<PadSnapshot> {
  PadSnapshotConfig({required this.sharedPreferences});

  /// Shared preferences instance
  final SharedPreferences sharedPreferences;

  @override
  Future<PadSnapshot?> get() async {
    final raw = sharedPreferences.getString(padSnapshotConfigKey);
    if (raw == null) return null;

    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      throw FormatException('Pad snapshot is not a JSON object', raw);
    }

    if (decoded['v'] != 1) {
      throw FormatException('Unsupported pad snapshot version', raw);
    }

    final dayValue = decoded['day'];
    if (dayValue is! String) {
      throw FormatException('Pad snapshot day is not a string', raw);
    }
    final day = PadDay.parse(dayValue);

    final quoteId = decoded['quoteId'];
    if (quoteId is! int || quoteId < 0) {
      throw FormatException('Pad snapshot quoteId is invalid', raw);
    }

    final reroll = _parseReroll(decoded['reroll'], raw);

    return PadSnapshot(day: day, quoteId: quoteId, reroll: reroll);
  }

  HeaderReroll? _parseReroll(Object? rerollValue, String raw) {
    if (rerollValue == null) return null;
    if (rerollValue is! Map) {
      throw FormatException('Pad snapshot reroll is not a JSON object', raw);
    }

    final dayValue = rerollValue['day'];
    if (dayValue is! String) {
      throw FormatException('Pad snapshot reroll day is not a string', raw);
    }
    final day = PadDay.parse(dayValue);

    final variant = rerollValue['variant'];
    if (variant is! int || variant < 1) {
      throw FormatException('Pad snapshot reroll variant is invalid', raw);
    }

    return HeaderReroll(day, variant);
  }

  @override
  Future<void> set(PadSnapshot value) async {
    await sharedPreferences.setString(
      padSnapshotConfigKey,
      jsonEncode(_toJson(value)),
    );
  }

  @override
  Future<void> remove() async {
    await sharedPreferences.remove(padSnapshotConfigKey);
  }

  Map<String, Object?> _toJson(PadSnapshot value) {
    final reroll = value.reroll;
    return {
      'v': 1,
      'day': value.day.toIso(),
      'quoteId': value.quoteId,
      'reroll': reroll == null
          ? null
          : {'day': reroll.day.toIso(), 'variant': reroll.variant},
    };
  }
}
