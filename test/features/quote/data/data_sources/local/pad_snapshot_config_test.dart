import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/features/quote/data/data_sources/local/pad_snapshot_config.dart';
import 'package:kuwot/features/quote/domain/entities/pad_day.dart';
import 'package:kuwot/features/quote/domain/entities/pad_snapshot.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<PadSnapshotConfig> _configWithRaw(String? raw) async {
  SharedPreferences.setMockInitialValues(
    raw == null ? {} : {padSnapshotConfigKey: raw},
  );
  return PadSnapshotConfig(
    sharedPreferences: await SharedPreferences.getInstance(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('round-trips a snapshot without a reroll', () async {
    const snapshot = PadSnapshot(day: PadDay(2026, 2, 5), quoteId: 3);
    final config = await _configWithRaw(null);

    await config.set(snapshot);
    final loaded = await config.get();

    expect(loaded, snapshot);
  });

  test('round-trips a snapshot with a reroll', () async {
    const snapshot = PadSnapshot(
      day: PadDay(2026, 2, 5),
      quoteId: 3,
      reroll: HeaderReroll(PadDay(2026, 2, 5), 2),
    );
    final config = await _configWithRaw(null);

    await config.set(snapshot);
    final loaded = await config.get();

    expect(loaded, snapshot);
  });

  test('returns null when nothing is stored', () async {
    final config = await _configWithRaw(null);

    expect(await config.get(), isNull);
  });

  group('malformed stored value throws FormatException', () {
    test('not JSON', () async {
      final config = await _configWithRaw('not json');
      expect(config.get(), throwsFormatException);
    });

    test('unsupported version', () async {
      final config = await _configWithRaw(
        '{"v":2,"day":"2026-02-05","quoteId":3,"reroll":null}',
      );
      expect(config.get(), throwsFormatException);
    });

    test('malformed day shape', () async {
      final config = await _configWithRaw(
        '{"v":1,"day":"2026-2-5","quoteId":3,"reroll":null}',
      );
      expect(config.get(), throwsFormatException);
    });

    test('impossible calendar date', () async {
      final config = await _configWithRaw(
        '{"v":1,"day":"2026-02-30","quoteId":3,"reroll":null}',
      );
      expect(config.get(), throwsFormatException);
    });

    test('quoteId is not an int', () async {
      final config = await _configWithRaw(
        '{"v":1,"day":"2026-02-05","quoteId":"7","reroll":null}',
      );
      expect(config.get(), throwsFormatException);
    });

    test('reroll variant is below 1', () async {
      final config = await _configWithRaw(
        '{"v":1,"day":"2026-02-05","quoteId":3,'
        '"reroll":{"day":"2026-02-05","variant":0}}',
      );
      expect(config.get(), throwsFormatException);
    });
  });
}
