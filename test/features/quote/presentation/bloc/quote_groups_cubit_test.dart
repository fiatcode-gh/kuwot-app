import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/features/quote/domain/entities/quote_group.dart';
import 'package:kuwot/features/quote/presentation/bloc/quote_groups_cubit.dart';

import '../../../../helpers/settings_fakes.dart';

void main() {
  test(
    'turning a group off emits the remaining groups and persists them',
    () async {
      final config = FakeQuoteGroupsConfig();
      final cubit = QuoteGroupsCubit(
        config: config,
        initialGroups: QuoteGroup.values.toSet(),
      );
      final expected = QuoteGroup.values.toSet()..remove(QuoteGroup.rest);
      final states = <Set<QuoteGroup>>[];
      final sub = cubit.stream.listen(states.add);

      cubit.setEnabled(QuoteGroup.rest, enabled: false);
      await Future<void>.delayed(Duration.zero);

      expect(states, [expected]);
      expect(config.saved, expected);
      await sub.cancel();
      await cubit.close();
    },
  );

  test(
    'turning a group on emits the widened selection and persists it',
    () async {
      final config = FakeQuoteGroupsConfig();
      final cubit = QuoteGroupsCubit(
        config: config,
        initialGroups: {QuoteGroup.grow},
      );
      final states = <Set<QuoteGroup>>[];
      final sub = cubit.stream.listen(states.add);

      cubit.setEnabled(QuoteGroup.rest, enabled: true);
      await Future<void>.delayed(Duration.zero);

      expect(states, [
        {QuoteGroup.grow, QuoteGroup.rest},
      ]);
      expect(config.saved, {QuoteGroup.grow, QuoteGroup.rest});
      await sub.cancel();
      await cubit.close();
    },
  );

  test('refuses to turn off the only selected group', () async {
    final config = FakeQuoteGroupsConfig();
    final cubit = QuoteGroupsCubit(
      config: config,
      initialGroups: {QuoteGroup.rest},
    );
    final states = <Set<QuoteGroup>>[];
    final sub = cubit.stream.listen(states.add);

    cubit.setEnabled(QuoteGroup.rest, enabled: false);
    await Future<void>.delayed(Duration.zero);

    expect(states, isEmpty);
    expect(cubit.state, {QuoteGroup.rest});
    expect(config.saved, isNull);
    await sub.cancel();
    await cubit.close();
  });

  test('turning on an already-selected group is a no-op', () async {
    final config = FakeQuoteGroupsConfig();
    final cubit = QuoteGroupsCubit(
      config: config,
      initialGroups: {QuoteGroup.grow, QuoteGroup.rest},
    );
    final states = <Set<QuoteGroup>>[];
    final sub = cubit.stream.listen(states.add);

    cubit.setEnabled(QuoteGroup.grow, enabled: true);
    await Future<void>.delayed(Duration.zero);

    expect(states, isEmpty);
    expect(config.saved, isNull);
    await sub.cancel();
    await cubit.close();
  });
}
