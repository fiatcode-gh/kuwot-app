import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/features/quote/data/data_sources/local/quote_local_data_source.dart';

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
  const json = '[{"q":"Alpha quote","a":"A"},{"q":"Beta quote","a":"B"}]';

  test('getRandomQuote returns a quote whose id is its array index', () async {
    // arrange — Random(0).nextInt(2) is deterministic
    final ds = QuoteLocalDataSourceImpl(
      bundle: _FakeBundle(json),
      random: Random(0),
    );

    // act
    final quote = await ds.getRandomQuote();

    // assert
    expect(quote.id, anyOf(0, 1));
    if (quote.id == 0) {
      expect(quote.text, 'Alpha quote');
      expect(quote.author, 'A');
    } else {
      expect(quote.text, 'Beta quote');
      expect(quote.author, 'B');
    }
  });

  test('parses the asset only once across calls', () async {
    // arrange
    final bundle = _CountingBundle(json);
    final ds = QuoteLocalDataSourceImpl(bundle: bundle, random: Random(1));

    // act
    await ds.getRandomQuote();
    await ds.getRandomQuote();

    // assert
    expect(bundle.loadCount, 1);
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
