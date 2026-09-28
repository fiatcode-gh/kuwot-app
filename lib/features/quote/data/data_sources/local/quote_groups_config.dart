import 'package:kuwot/core/data/local/config.dart';
import 'package:kuwot/features/quote/domain/entities/quote_group.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Quote group selection shared preferences key.
const quoteGroupsConfigKey = 'quoteGroups';

/// The quote groups the pad draws from, backed by [SharedPreferences].
class QuoteGroupsConfig extends Config<Set<QuoteGroup>> {
  /// Default constructor
  QuoteGroupsConfig({required this.sharedPreferences});

  /// Shared preferences instance
  final SharedPreferences sharedPreferences;

  /// All groups when nothing is saved or no saved id is known; unknown ids
  /// are ignored.
  @override
  Future<Set<QuoteGroup>> get() async {
    final ids = sharedPreferences.getStringList(quoteGroupsConfigKey);
    if (ids == null) return QuoteGroup.values.toSet();
    final groups = {for (final id in ids) ?QuoteGroup.tryParse(id)};
    return groups.isEmpty ? QuoteGroup.values.toSet() : groups;
  }

  /// Saves the ids in [QuoteGroup] declaration order.
  @override
  Future<void> set(Set<QuoteGroup> value) async {
    await sharedPreferences.setStringList(quoteGroupsConfigKey, [
      for (final group in QuoteGroup.values)
        if (value.contains(group)) group.id,
    ]);
  }

  @override
  Future<void> remove() async {
    await sharedPreferences.remove(quoteGroupsConfigKey);
  }
}
