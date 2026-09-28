import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;
import 'package:kuwot/features/quote/data/models/quote_model.dart';
import 'package:kuwot/features/quote/domain/entities/quote_group.dart';

const _quotesAssetPath = 'assets/data/quotes.json';

abstract class QuoteLocalDataSource {
  Future<QuoteModel> getRandomQuote();
  Future<QuoteModel> getQuoteById(int id);
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
      final groupId = map['group'] as String;
      final group =
          QuoteGroup.tryParse(groupId) ??
          (throw FormatException('Unknown quote group', groupId));
      quotes.add(QuoteModel(id: i, text: map['text'] as String, group: group));
    }
    _cache = quotes;
    return quotes;
  }

  @override
  Future<QuoteModel> getRandomQuote() async {
    final quotes = await _load();
    return quotes[_random.nextInt(quotes.length)];
  }

  @override
  Future<QuoteModel> getQuoteById(int id) async {
    final quotes = await _load();
    if (id < 0 || id >= quotes.length) {
      throw RangeError.index(id, quotes);
    }
    return quotes[id];
  }
}
