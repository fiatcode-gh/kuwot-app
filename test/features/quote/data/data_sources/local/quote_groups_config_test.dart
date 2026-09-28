import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/features/quote/data/data_sources/local/quote_groups_config.dart';
import 'package:kuwot/features/quote/domain/entities/quote_group.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<QuoteGroupsConfig> _configWithRaw(List<String>? raw) async {
  SharedPreferences.setMockInitialValues(
    raw == null ? {} : {quoteGroupsConfigKey: raw},
  );
  return QuoteGroupsConfig(
    sharedPreferences: await SharedPreferences.getInstance(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('returns all groups when nothing is saved', () async {
    final config = await _configWithRaw(null);

    expect(await config.get(), QuoteGroup.values.toSet());
  });

  test('round-trips a saved selection across a restart', () async {
    final config = await _configWithRaw(null);

    await config.set({QuoteGroup.grow, QuoteGroup.rest});
    final restarted = QuoteGroupsConfig(
      sharedPreferences: await SharedPreferences.getInstance(),
    );

    expect(await restarted.get(), {QuoteGroup.grow, QuoteGroup.rest});
  });

  test('drops unknown saved ids', () async {
    final config = await _configWithRaw(['grow', 'retired_group']);

    expect(await config.get(), {QuoteGroup.grow});
  });

  test('returns all groups when no saved id is known', () async {
    final config = await _configWithRaw(['retired_group']);

    expect(await config.get(), QuoteGroup.values.toSet());
  });

  test('returns all groups when the saved list is empty', () async {
    final config = await _configWithRaw([]);

    expect(await config.get(), QuoteGroup.values.toSet());
  });
}
