import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart' show AssetBundle, rootBundle;
import 'package:kuwot/features/quote/data/models/quote_model.dart';
import 'package:kuwot/features/quote/domain/entities/quote_group.dart';

const _quotesAssetPath = 'assets/data/quotes.json';

abstract class QuoteLocalDataSource {
  Future<QuoteModel> getRandomQuote(Set<QuoteGroup> groups);
  Future<QuoteModel> getQuoteById(int id);
}

class QuoteLocalDataSourceImpl implements QuoteLocalDataSource {
  QuoteLocalDataSourceImpl({AssetBundle? bundle, Random? random})
    : _bundle = bundle ?? rootBundle,
      _random = random ?? Random();

  final AssetBundle _bundle;
  final Random _random;

  List<QuoteModel>? _cache;
  Map<QuoteGroup, List<QuoteModel>>? _byGroup;

  Future<List<QuoteModel>> _load() async {
    final cached = _cache;
    if (cached != null) return cached;

    final raw = await _bundle.loadString(_quotesAssetPath);
    final list = jsonDecode(raw) as List<dynamic>;
    final quotes = <QuoteModel>[];
    final byGroup = <QuoteGroup, List<QuoteModel>>{
      for (final group in QuoteGroup.values) group: <QuoteModel>[],
    };
    for (var i = 0; i < list.length; i++) {
      final map = list[i] as Map<String, dynamic>;
      final groupId = map['group'] as String;
      final group =
          QuoteGroup.tryParse(groupId) ??
          (throw FormatException('Unknown quote group', groupId));
      final quote = QuoteModel(
        id: i,
        text: map['text'] as String,
        group: group,
      );
      quotes.add(quote);
      byGroup[group]!.add(quote);
    }
    _cache = quotes;
    _byGroup = byGroup;
    return quotes;
  }

  @override
  Future<QuoteModel> getRandomQuote(Set<QuoteGroup> groups) async {
    if (groups.isEmpty) {
      throw ArgumentError.value(groups, 'groups', 'must not be empty');
    }
    await _load();
    final byGroup = _byGroup!;

    var total = 0;
    for (final group in groups) {
      total += byGroup[group]!.length;
    }
    if (total == 0) {
      throw StateError('No quotes in the selected groups');
    }

    var index = _random.nextInt(total);
    for (final group in groups) {
      final quotesInGroup = byGroup[group]!;
      if (index < quotesInGroup.length) return quotesInGroup[index];
      index -= quotesInGroup.length;
    }
    throw StateError('unreachable: index exceeded selected groups\' total');
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
