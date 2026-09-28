import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/features/quote/data/data_sources/local/quote_local_data_source.dart';
import 'package:kuwot/features/quote/domain/entities/quote_group.dart';

class _FakeBundle extends CachingAssetBundle {
  _FakeBundle(this._data);
  final String _data;

  @override
  Future<ByteData> load(String key) async {
    final bytes = utf8.encode(_data);
    return ByteData.view(Uint8List.fromList(bytes).buffer);
  }
}

void main() {
  const json =
      '[{"text":"Alpha quote","group":"grow"},'
      '{"text":"Beta quote","group":"rest"}]';

  test('getRandomQuote returns a quote whose id is its array index', () async {
    // arrange — Random(0).nextInt(2) is deterministic
    final ds = QuoteLocalDataSourceImpl(
      bundle: _FakeBundle(json),
      random: Random(0),
    );

    // act
    final quote = await ds.getRandomQuote(QuoteGroup.values.toSet());

    // assert
    expect(quote.id, anyOf(0, 1));
    if (quote.id == 0) {
      expect(quote.text, 'Alpha quote');
      expect(quote.group, QuoteGroup.grow);
    } else {
      expect(quote.text, 'Beta quote');
      expect(quote.group, QuoteGroup.rest);
    }
  });

  test('getQuoteById(1) returns the quote at that index', () async {
    // arrange
    final ds = QuoteLocalDataSourceImpl(
      bundle: _FakeBundle(json),
      random: Random(0),
    );

    // act
    final quote = await ds.getQuoteById(1);

    // assert
    expect(quote.id, 1);
    expect(quote.text, 'Beta quote');
    expect(quote.group, QuoteGroup.rest);
  });

  test('getQuoteById throws RangeError when the id is out of range', () async {
    // arrange
    final ds = QuoteLocalDataSourceImpl(
      bundle: _FakeBundle(json),
      random: Random(0),
    );

    // act & assert
    expect(() => ds.getQuoteById(5), throwsA(isA<RangeError>()));
  });

  test('getQuoteById throws FormatException when the stored group id is '
      'unknown', () async {
    // arrange
    final ds = QuoteLocalDataSourceImpl(
      bundle: _FakeBundle('[{"text":"Alpha quote","group":"nope"}]'),
      random: Random(0),
    );

    // act & assert
    expect(() => ds.getQuoteById(0), throwsA(isA<FormatException>()));
  });

  test('parses the asset only once across calls', () async {
    // arrange
    final bundle = _CountingBundle(json);
    final ds = QuoteLocalDataSourceImpl(bundle: bundle, random: Random(1));

    // act
    await ds.getRandomQuote(QuoteGroup.values.toSet());
    await ds.getRandomQuote(QuoteGroup.values.toSet());

    // assert
    expect(bundle.loadCount, 1);
  });

  const groupedJson =
      '[{"text":"Grow 1","group":"grow"},'
      '{"text":"Grow 2","group":"grow"},'
      '{"text":"Grow 3","group":"grow"},'
      '{"text":"Rest 1","group":"rest"},'
      '{"text":"Courage 1","group":"courage"}]';

  test('getRandomQuote(groups) returns only quotes from the selected group and '
      'hits every quote in it', () async {
    // arrange
    final ds = QuoteLocalDataSourceImpl(
      bundle: _FakeBundle(groupedJson),
      random: Random(0),
    );

    // act
    final seenIds = <int>{};
    for (var i = 0; i < 50; i++) {
      final quote = await ds.getRandomQuote({QuoteGroup.grow});
      expect(quote.group, QuoteGroup.grow);
      seenIds.add(quote.id);
    }

    // assert
    expect(seenIds, {0, 1, 2});
  });

  test('getRandomQuote(groups) over several groups draws from their union and '
      'never from an excluded group', () async {
    // arrange
    final ds = QuoteLocalDataSourceImpl(
      bundle: _FakeBundle(groupedJson),
      random: Random(1),
    );

    // act
    final seenGroups = <QuoteGroup>{};
    for (var i = 0; i < 50; i++) {
      final quote = await ds.getRandomQuote({QuoteGroup.grow, QuoteGroup.rest});
      expect(quote.group, isNot(QuoteGroup.courage));
      seenGroups.add(quote.group);
    }

    // assert
    expect(seenGroups, {QuoteGroup.grow, QuoteGroup.rest});
  });

  test('getRandomQuote throws ArgumentError for an empty group set', () async {
    // arrange
    final ds = QuoteLocalDataSourceImpl(
      bundle: _FakeBundle(groupedJson),
      random: Random(0),
    );

    // act & assert
    expect(
      () => ds.getRandomQuote(<QuoteGroup>{}),
      throwsA(isA<ArgumentError>()),
    );
  });

  test('getRandomQuote throws StateError when the selected groups have no '
      'quotes', () async {
    // arrange
    final ds = QuoteLocalDataSourceImpl(
      bundle: _FakeBundle(groupedJson),
      random: Random(0),
    );

    // act & assert
    expect(
      () => ds.getRandomQuote({QuoteGroup.people}),
      throwsA(isA<StateError>()),
    );
  });
}

class _CountingBundle extends AssetBundle {
  _CountingBundle(this._data);
  final String _data;
  int loadCount = 0;

  @override
  Future<ByteData> load(String key) async {
    throw UnimplementedError('load() should not be called; use loadString()');
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loadCount++;
    return _data;
  }
}
