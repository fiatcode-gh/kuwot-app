import 'package:flutter/material.dart';
import 'package:kuwot/core/data/local/config.dart';
import 'package:kuwot/features/quote/domain/entities/quote_group.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

/// A [Config] that never persists a theme mode, for tests that need a real
/// [ThemeModeCubit] without touching [SharedPreferences].
class FakeThemeModeConfig extends Config<ThemeMode> {
  @override
  Future<ThemeMode?> get() async => null;

  @override
  Future<void> set(ThemeMode value) async {}

  @override
  Future<void> remove() async {}
}

/// An in-memory [Config] for the quote group selection; [saved] is the
/// last set value.
class FakeQuoteGroupsConfig extends Config<Set<QuoteGroup>> {
  Set<QuoteGroup>? saved;

  @override
  Future<Set<QuoteGroup>?> get() async => saved;

  @override
  Future<void> set(Set<QuoteGroup> value) async => saved = value;

  @override
  Future<void> remove() async => saved = null;
}

/// Stands in for the url_launcher plugin: records every launch and answers
/// with [result], or throws [error] when set.
class FakeUrlLauncher extends UrlLauncherPlatform {
  final launches = <({String url, PreferredLaunchMode mode})>[];
  bool result = true;
  Exception? error;

  @override
  LinkDelegate? get linkDelegate => null;

  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launches.add((url: url, mode: options.mode));
    if (error case final e?) throw e;
    return result;
  }
}
