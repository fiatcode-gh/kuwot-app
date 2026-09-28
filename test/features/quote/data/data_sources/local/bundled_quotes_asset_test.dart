import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/features/quote/data/data_sources/local/quote_local_data_source.dart';
import 'package:kuwot/features/quote/domain/entities/quote_group.dart';

import '../../../../../helpers/quote_fixtures.dart';

/// An [AssetBundle] that serves the real repository asset file, like
/// [File.readAsString] in `load_app_fonts.dart` reads font files directly
/// off disk rather than through a mocked test bundle.
class _FileBundle extends CachingAssetBundle {
  @override
  Future<ByteData> load(String key) async {
    final bytes = await File(key).readAsBytes();
    return ByteData.sublistView(bytes);
  }
}

void main() {
  late List<dynamic> quotes;

  setUpAll(() {
    final raw = File('assets/data/quotes.json').readAsStringSync();
    quotes = jsonDecode(raw) as List<dynamic>;
  });

  test('has exactly 1,400 entries, each with only text and group', () {
    expect(quotes, hasLength(1400));
    for (final entry in quotes) {
      final map = entry as Map<String, dynamic>;
      expect(map.keys.toSet(), {'text', 'group'});
      expect(map['text'] as String, isNotEmpty);
    }
  });

  test('every entry parses to a known QuoteGroup with the contract counts', () {
    final counts = <QuoteGroup, int>{};
    for (final entry in quotes) {
      final map = entry as Map<String, dynamic>;
      final group = QuoteGroup.tryParse(map['group'] as String);
      expect(group, isNotNull, reason: 'unknown group ${map['group']}');
      counts[group!] = (counts[group] ?? 0) + 1;
    }

    for (final group in const [
      QuoteGroup.perspective,
      QuoteGroup.keepGoing,
      QuoteGroup.heavyDays,
      QuoteGroup.doTheWork,
    ]) {
      expect(counts[group], 150, reason: 'group $group');
    }
    for (final group in const [
      QuoteGroup.beginAgain,
      QuoteGroup.breathe,
      QuoteGroup.grow,
      QuoteGroup.courage,
      QuoteGroup.smallJoys,
      QuoteGroup.people,
      QuoteGroup.believeInYourself,
      QuoteGroup.rest,
    ]) {
      expect(counts[group], 100, reason: 'group $group');
    }
    expect(counts.keys.toSet(), QuoteGroup.values.toSet());
  });

  test('the longest entry equals the pinned layout worst-case fixture', () {
    final longest = quotes
        .map((entry) => (entry as Map<String, dynamic>)['text'] as String)
        .reduce((a, b) => a.length >= b.length ? a : b);

    expect(longest, kLongestQuote.body);
  });

  test(
    'QuoteLocalDataSourceImpl reads the real bundled asset end to end',
    () async {
      final ds = QuoteLocalDataSourceImpl(
        bundle: _FileBundle(),
        random: Random(),
      );

      final last = await ds.getQuoteById(1399);
      expect(last.id, 1399);

      expect(() => ds.getQuoteById(1400), throwsA(isA<RangeError>()));
    },
  );
}
