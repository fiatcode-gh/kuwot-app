import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:kuwot/core/data/local/config.dart';
import 'package:kuwot/features/in_app_purchase/presentation/bloc/in_app_purchase_bloc.dart';
import 'package:kuwot/features/quote/domain/entities/quote_group.dart';

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

/// A mocked [InAppPurchaseBloc] whose state can be fixed with [whenListen],
/// so widget tests can pump [TipJarSection] (and anything embedding it) at
/// an exact bloc state without touching platform channels.
class MockInAppPurchaseBloc
    extends MockBloc<InAppPurchaseEvent, InAppPurchaseState>
    implements InAppPurchaseBloc {}
