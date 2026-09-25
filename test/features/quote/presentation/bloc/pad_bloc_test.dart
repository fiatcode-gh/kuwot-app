import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/core/data/local/config.dart';
import 'package:kuwot/features/quote/data/data_sources/local/pad_snapshot_config.dart';
import 'package:kuwot/features/quote/domain/entities/pad_day.dart';
import 'package:kuwot/features/quote/domain/entities/pad_snapshot.dart';
import 'package:kuwot/features/quote/domain/entities/tear_kind.dart';
import 'package:kuwot/features/quote/domain/services/background_generator.dart';
import 'package:kuwot/features/quote/presentation/bloc/pad_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../helpers/pad_fakes.dart';

class _ThrowingGetConfig extends Config<PadSnapshot> {
  PadSnapshot? lastSaved;

  @override
  Future<PadSnapshot?> get() async => throw Exception('read boom');

  @override
  Future<void> set(PadSnapshot value) async => lastSaved = value;

  @override
  Future<void> remove() async {}
}

class _HangingGetConfig extends Config<PadSnapshot> {
  @override
  Future<PadSnapshot?> get() => Completer<PadSnapshot?>().future;

  @override
  Future<void> set(PadSnapshot value) async {}

  @override
  Future<void> remove() async {}
}

class _ThrowingSetConfig extends Config<PadSnapshot> {
  @override
  Future<PadSnapshot?> get() async => null;

  @override
  Future<void> set(PadSnapshot value) async => throw Exception('write boom');

  @override
  Future<void> remove() async {}
}

class _HangingSetConfig extends Config<PadSnapshot> {
  @override
  Future<PadSnapshot?> get() async => null;

  @override
  Future<void> set(PadSnapshot value) => Completer<void>().future;

  @override
  Future<void> remove() async {}
}

Future<List<PadState>> _statesDuring(PadBloc bloc, PadEvent event) async {
  final states = <PadState>[];
  final sub = bloc.stream.listen(states.add);
  bloc.add(event);
  await pumpEventQueue();
  await sub.cancel();
  return states;
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<PadSnapshot?> readSnapshot() async {
    final prefs = await SharedPreferences.getInstance();
    return PadSnapshotConfig(sharedPreferences: prefs).get();
  }

  test(
    'first launch is Ready on today and persists (today, quoteId, null)',
    () async {
      final time = FakeTime(DateTime(2026, 3, 10));
      final bloc = await buildPadBloc(time: time);

      bloc.add(const PadStarted());
      await pumpEventQueue();

      final ready = bloc.state as PadReady;
      expect(ready.top.day, const PadDay(2026, 3, 10));
      expect(ready.tearKind, TearKind.quote);

      final saved = await readSnapshot();
      expect(
        saved,
        PadSnapshot(
          day: const PadDay(2026, 3, 10),
          quoteId: ready.top.quote.id,
        ),
      );

      await bloc.close();
    },
  );

  test('a same-day commit swaps in the drawn quote, keeps day and header; a '
      'stale-revision commit is ignored', () async {
    final time = FakeTime(DateTime(2026, 3, 10));
    final bloc = await buildPadBloc(time: time);
    bloc.add(const PadStarted());
    await pumpEventQueue();

    final first = bloc.state as PadReady;
    final drawnUnder = first.under;

    bloc.add(PadTearCommitted(first.revision));
    await pumpEventQueue();

    final second = bloc.state as PadReady;
    expect(second.top.quote, drawnUnder.quote);
    expect(second.top.day, first.top.day);
    expect(second.top.header, first.top.header);
    expect(second.tearKind, TearKind.quote);
    expect(second.revision, first.revision + 1);

    final statesOnStaleCommit = await _statesDuring(
      bloc,
      PadTearCommitted(first.revision),
    );
    expect(statesOnStaleCommit, isEmpty);

    await bloc.close();
  });

  Future<void> newDayGap(int gapDays) async {
    final time = FakeTime(DateTime(2026, 3, 10));
    final quotes = FakeQuoteRepository();

    final firstBloc = await buildPadBloc(time: time, quotes: quotes);
    firstBloc.add(const PadStarted());
    await pumpEventQueue();
    final dayD = (firstBloc.state as PadReady).top.day;
    final dQuoteId = (firstBloc.state as PadReady).top.quote.id;
    await firstBloc.close();

    final newToday = DateTime(2026, 3, 10 + gapDays);
    time.current = newToday;
    final restarted = await buildPadBloc(time: time, quotes: quotes);
    restarted.add(const PadStarted());
    await pumpEventQueue();

    final afterRestart = restarted.state as PadReady;
    expect(afterRestart.top.day, dayD);
    expect(afterRestart.top.quote.id, dQuoteId);
    expect(afterRestart.tearKind, TearKind.page);
    expect(afterRestart.under.day, PadDay.from(newToday));

    restarted.add(PadTearCommitted(afterRestart.revision));
    await pumpEventQueue();
    final afterFirstCommit = restarted.state as PadReady;
    expect(afterFirstCommit.top.day, PadDay.from(newToday));
    expect(afterFirstCommit.top.quote.id, isNot(dQuoteId));
    expect(afterFirstCommit.tearKind, TearKind.quote);

    restarted.add(PadTearCommitted(afterFirstCommit.revision));
    await pumpEventQueue();
    final afterSecondCommit = restarted.state as PadReady;
    expect(afterSecondCommit.top.day, PadDay.from(newToday));
    expect(afterSecondCommit.top.header, afterFirstCommit.top.header);

    await restarted.close();
  }

  test(
    'new day, one day gap: a page tear lands on the new day, then quote '
    'tears follow',
    () => newDayGap(1),
  );

  test(
    'new day, five day gap: a page tear lands on the new day, then quote '
    'tears follow',
    () => newDayGap(5),
  );

  test(
    'restart on the same day keeps the last-viewed quote and rerolled header',
    () async {
      final time = FakeTime(DateTime(2026, 3, 10));
      final quotes = FakeQuoteRepository();

      final firstBloc = await buildPadBloc(time: time, quotes: quotes);
      firstBloc.add(const PadStarted());
      await pumpEventQueue();
      firstBloc.add(PadTearCommitted((firstBloc.state as PadReady).revision));
      await pumpEventQueue();

      firstBloc.add(const PadRestyled());
      await pumpEventQueue();
      final restyled = firstBloc.state as PadReady;
      await firstBloc.close();

      final secondBloc = await buildPadBloc(time: time, quotes: quotes);
      secondBloc.add(const PadStarted());
      await pumpEventQueue();
      final restarted = secondBloc.state as PadReady;

      expect(restarted.top.quote.id, restyled.top.quote.id);
      expect(restarted.top.header, restyled.top.header);

      await secondBloc.close();
    },
  );

  test('clock backwards at startup snaps to the earlier clock day', () async {
    final time = FakeTime(DateTime(2026, 3, 10));
    final quotes = FakeQuoteRepository();

    final firstBloc = await buildPadBloc(time: time, quotes: quotes);
    firstBloc.add(const PadStarted());
    await pumpEventQueue();
    final onDayD = firstBloc.state as PadReady;
    await firstBloc.close();

    time.current = DateTime(2026, 3, 5);
    final secondBloc = await buildPadBloc(time: time, quotes: quotes);
    secondBloc.add(const PadStarted());
    await pumpEventQueue();
    final ready = secondBloc.state as PadReady;

    expect(ready.top.day, const PadDay(2026, 3, 5));
    expect(ready.top.quote.id, onDayD.top.quote.id);
    expect(ready.tearKind, TearKind.quote);

    final saved = await readSnapshot();
    expect(saved?.day, const PadDay(2026, 3, 5));

    await secondBloc.close();
  });

  test(
    'restyle changes only the header; the reroll survives a commit and the '
    'next-day restart, and restyle is refused while a page tear is pending',
    () async {
      final time = FakeTime(DateTime(2026, 3, 10));
      final quotes = FakeQuoteRepository();

      final bloc = await buildPadBloc(time: time, quotes: quotes);
      bloc.add(const PadStarted());
      await pumpEventQueue();
      final before = bloc.state as PadReady;

      bloc.add(const PadRestyled());
      await pumpEventQueue();
      final restyled = bloc.state as PadReady;
      expect(restyled.top.day, before.top.day);
      expect(restyled.top.quote, before.top.quote);
      expect(restyled.top.header, isNot(before.top.header));

      bloc.add(PadTearCommitted(restyled.revision));
      await pumpEventQueue();
      final committed = bloc.state as PadReady;
      expect(committed.top.header, restyled.top.header);
      await bloc.close();

      time.current = DateTime(2026, 3, 11);
      final restartedBloc = await buildPadBloc(time: time, quotes: quotes);
      restartedBloc.add(const PadStarted());
      await pumpEventQueue();
      final restarted = restartedBloc.state as PadReady;

      expect(restarted.top.day, committed.top.day);
      expect(restarted.top.header, committed.top.header);
      expect(restarted.tearKind, TearKind.page);
      expect(
        restarted.under.header,
        const BackgroundGenerator().generate(const PadDay(2026, 3, 11).seed, 0),
      );

      final statesOnRestyle = await _statesDuring(
        restartedBloc,
        const PadRestyled(),
      );
      expect(statesOnRestyle, isEmpty);

      await restartedBloc.close();
    },
  );

  group('storage failures never block Ready or later commits', () {
    test('get() throwing still reaches Ready on today', () async {
      final time = FakeTime(DateTime(2026, 3, 10));
      final bloc = await buildPadBloc(time: time, config: _ThrowingGetConfig());

      bloc.add(const PadStarted());
      await pumpEventQueue();

      expect(bloc.state, isA<PadReady>());
      expect((bloc.state as PadReady).top.day, const PadDay(2026, 3, 10));
      await bloc.close();
    });

    test(
      'get() hanging past the repository timeout still reaches Ready',
      () async {
        final time = FakeTime(DateTime(2026, 3, 10));
        final bloc = await buildPadBloc(
          time: time,
          config: _HangingGetConfig(),
          timeout: const Duration(milliseconds: 50),
        );

        bloc.add(const PadStarted());
        await Future<void>.delayed(const Duration(milliseconds: 150));
        await pumpEventQueue();

        expect(bloc.state, isA<PadReady>());
        await bloc.close();
      },
    );

    test('set() throwing does not block a later commit', () async {
      final time = FakeTime(DateTime(2026, 3, 10));
      final bloc = await buildPadBloc(time: time, config: _ThrowingSetConfig());
      bloc.add(const PadStarted());
      await pumpEventQueue();
      final ready = bloc.state as PadReady;

      bloc.add(PadTearCommitted(ready.revision));
      await pumpEventQueue();

      final after = bloc.state as PadReady;
      expect(after.revision, ready.revision + 1);
      await bloc.close();
    });

    test('set() hanging for 10s never blocks a later commit within the normal '
        'test pump', () async {
      final time = FakeTime(DateTime(2026, 3, 10));
      final bloc = await buildPadBloc(
        time: time,
        config: _HangingSetConfig(),
        timeout: const Duration(seconds: 10),
      );
      bloc.add(const PadStarted());
      await pumpEventQueue();
      final ready = bloc.state as PadReady;

      final stopwatch = Stopwatch()..start();
      bloc.add(PadTearCommitted(ready.revision));
      await pumpEventQueue();
      stopwatch.stop();

      expect(stopwatch.elapsed, lessThan(const Duration(seconds: 1)));
      final after = bloc.state as PadReady;
      expect(after.revision, ready.revision + 1);
      await bloc.close();
    });

    test('malformed JSON in prefs still reaches Ready on today', () async {
      SharedPreferences.setMockInitialValues({
        padSnapshotConfigKey: 'not json',
      });
      final time = FakeTime(DateTime(2026, 3, 10));
      final bloc = await buildPadBloc(time: time);

      bloc.add(const PadStarted());
      await pumpEventQueue();

      expect(bloc.state, isA<PadReady>());
      expect((bloc.state as PadReady).top.day, const PadDay(2026, 3, 10));
      await bloc.close();
    });
  });

  test(
    'an unknown saved quote id falls back to a random quote on the saved day',
    () async {
      final prefs = await SharedPreferences.getInstance();
      final config = PadSnapshotConfig(sharedPreferences: prefs);
      await config.set(
        const PadSnapshot(day: PadDay(2026, 3, 10), quoteId: 999),
      );

      final time = FakeTime(DateTime(2026, 3, 10));
      final bloc = await buildPadBloc(time: time, config: config);

      bloc.add(const PadStarted());
      await pumpEventQueue();

      final ready = bloc.state as PadReady;
      expect(ready.top.day, const PadDay(2026, 3, 10));
      expect(ready.top.quote.id, isNot(999));
      await bloc.close();
    },
  );

  group('PadDayChecked', () {
    test(
      'crossing midnight turns a pending quote tear into a page tear',
      () async {
        final time = FakeTime(DateTime(2026, 3, 10));
        final bloc = await buildPadBloc(time: time);
        bloc.add(const PadStarted());
        await pumpEventQueue();
        final before = bloc.state as PadReady;
        expect(before.tearKind, TearKind.quote);

        time.current = DateTime(2026, 3, 11);
        bloc.add(const PadDayChecked());
        await pumpEventQueue();

        final after = bloc.state as PadReady;
        expect(after.top.day, before.top.day);
        expect(after.tearKind, TearKind.page);
        expect(after.under.day, const PadDay(2026, 3, 11));
        await bloc.close();
      },
    );

    test('the clock moving back snaps the top to today', () async {
      final time = FakeTime(DateTime(2026, 3, 10));
      final bloc = await buildPadBloc(time: time);
      bloc.add(const PadStarted());
      await pumpEventQueue();
      final before = bloc.state as PadReady;

      time.current = DateTime(2026, 3, 5);
      bloc.add(const PadDayChecked());
      await pumpEventQueue();

      final after = bloc.state as PadReady;
      expect(after.top.day, const PadDay(2026, 3, 5));
      expect(after.top.quote.id, before.top.quote.id);
      await bloc.close();
    });

    test('the same day emits nothing', () async {
      final time = FakeTime(DateTime(2026, 3, 10));
      final bloc = await buildPadBloc(time: time);
      bloc.add(const PadStarted());
      await pumpEventQueue();

      final states = await _statesDuring(bloc, const PadDayChecked());

      expect(states, isEmpty);
      await bloc.close();
    });
  });

  test(
    'a failed random draw at startup fails; retrying after recovery succeeds',
    () async {
      final time = FakeTime(DateTime(2026, 3, 10));
      final quotes = FakeQuoteRepository()..failRandom = true;
      final bloc = await buildPadBloc(time: time, quotes: quotes);

      bloc.add(const PadStarted());
      await pumpEventQueue();
      expect(bloc.state, isA<PadFailed>());

      quotes.failRandom = false;
      bloc.add(const PadStarted());
      await pumpEventQueue();
      expect(bloc.state, isA<PadReady>());

      await bloc.close();
    },
  );
}
