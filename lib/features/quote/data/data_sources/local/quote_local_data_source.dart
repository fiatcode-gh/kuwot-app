import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;
import 'package:kuwot/features/quote/data/models/quote_model.dart';

const _quotesAssetPath = 'assets/data/quotes.json';

abstract class QuoteLocalDataSource {
  Future<QuoteModel> getRandomQuote();
}

class QuoteLocalDataSourceImpl implements QuoteLocalDataSource {
  QuoteLocalDataSourceImpl({AssetBundle? bundle, Random? random})
    : _bundle = bundle ?? rootBundle,
      _random = random ?? Random();

  final AssetBundle _bundle;
  final Random _random;

  List<QuoteModel>? _cache;

  Future<List<QuoteModel>> _load() async {
    final cached = _cache;
    if (cached != null) return cached;

    final raw = await _bundle.loadString(_quotesAssetPath);
    final list = jsonDecode(raw) as List<dynamic>;
    final quotes = <QuoteModel>[];
    for (var i = 0; i < list.length; i++) {
      final map = list[i] as Map<String, dynamic>;
      quotes.add(
        QuoteModel(id: i, text: map['q'] as String, author: map['a'] as String),
      );
    }
    _cache = quotes;
    return quotes;
  }

  @override
  Future<QuoteModel> getRandomQuote() async {
    final quotes = await _load();
    return quotes[_random.nextInt(quotes.length)];
  }
}
