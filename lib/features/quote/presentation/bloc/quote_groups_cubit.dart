import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuwot/core/data/local/config.dart';
import 'package:kuwot/features/quote/domain/entities/quote_group.dart';

/// The quote groups new pad pages are drawn from. Never empty.
class QuoteGroupsCubit extends Cubit<Set<QuoteGroup>> {
  /// Default constructor
  QuoteGroupsCubit({
    required this.config,
    required Set<QuoteGroup> initialGroups,
  }) : super(Set.unmodifiable(initialGroups));

  /// Quote group selection config
  final Config<Set<QuoteGroup>> config;

  /// Turns [group] on or off. Turning off the only selected group is
  /// refused: at least one group always stays on.
  void setEnabled(QuoteGroup group, {required bool enabled}) {
    if (state.contains(group) == enabled) return;
    if (!enabled && state.length == 1) return;
    final next = Set<QuoteGroup>.unmodifiable(
      enabled ? {...state, group} : state.difference({group}),
    );
    unawaited(config.set(next));
    emit(next);
  }
}
