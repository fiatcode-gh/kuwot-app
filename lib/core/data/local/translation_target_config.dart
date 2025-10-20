import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:kuwot/core/data/local/config.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'translation_target_config.freezed.dart';
part 'translation_target_config.g.dart';

const translationTargetConfigKey = 'translationTarget';
const defaultTranslationTarget = TranslationTarget(id: 'en', name: 'English');

@freezed
abstract class TranslationTarget with _$TranslationTarget {
  const factory TranslationTarget({required String id, required String name}) =
      _TranslationTarget;

  factory TranslationTarget.fromJson(Map<String, dynamic> json) =>
      _$TranslationTargetFromJson(json);
}

class TranslationTargetConfig extends Config<TranslationTarget> {
  TranslationTargetConfig({required this.sharedPreferences});

  final SharedPreferences sharedPreferences;

  @override
  Future<TranslationTarget?> get() async {
    final data = sharedPreferences.getString(translationTargetConfigKey);
    return data != null ? TranslationTarget.fromJson(jsonDecode(data)) : null;
  }

  @override
  Future<void> set(TranslationTarget value) async {
    await sharedPreferences.setString(
      translationTargetConfigKey,
      jsonEncode(value.toJson()),
    );
  }

  @override
  Future<void> remove() async {
    await sharedPreferences.remove(translationTargetConfigKey);
  }
}
