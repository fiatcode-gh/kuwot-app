import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/core/data/local/config.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/quote/data/repositories/pad_repository_impl.dart';
import 'package:kuwot/features/quote/domain/entities/pad_day.dart';
import 'package:kuwot/features/quote/domain/entities/pad_snapshot.dart';

class _ThrowingConfig extends Config<PadSnapshot> {
  @override
  Future<PadSnapshot?> get() async => throw Exception('boom');

  @override
  Future<void> set(PadSnapshot value) async => throw Exception('boom');

  @override
  Future<void> remove() async {}
}

class _HangingConfig extends Config<PadSnapshot> {
  @override
  Future<PadSnapshot?> get() => Completer<PadSnapshot?>().future;

  @override
  Future<void> set(PadSnapshot value) => Completer<void>().future;

  @override
  Future<void> remove() async {}
}

class _FakeConfig extends Config<PadSnapshot> {
  PadSnapshot? stored;
  PadSnapshot? lastSaved;

  @override
  Future<PadSnapshot?> get() async => stored;

  @override
  Future<void> set(PadSnapshot value) async {
    lastSaved = value;
  }

  @override
  Future<void> remove() async {
    stored = null;
  }
}

void main() {
  const tSnapshot = PadSnapshot(day: PadDay(2026, 2, 5), quoteId: 3);

  test('load returns Left(UnknownFailure) when the config throws', () async {
    final repository = PadRepositoryImpl(config: _ThrowingConfig());

    final result = await repository.load();

    expect(result.isLeft(), isTrue);
    expect(result.getLeft().toNullable(), isA<UnknownFailure>());
  });

  test(
    'load returns Left when the config never completes, within the timeout',
    () async {
      final repository = PadRepositoryImpl(
        config: _HangingConfig(),
        timeout: const Duration(milliseconds: 50),
      );

      final result = await repository.load();

      expect(result.isLeft(), isTrue);
    },
  );

  test('save returns Left(UnknownFailure) when the config throws', () async {
    final repository = PadRepositoryImpl(config: _ThrowingConfig());

    final result = await repository.save(tSnapshot);

    expect(result.isLeft(), isTrue);
    expect(result.getLeft().toNullable(), isA<UnknownFailure>());
  });

  test('load returns Right with the stored snapshot', () async {
    final config = _FakeConfig()..stored = tSnapshot;
    final repository = PadRepositoryImpl(config: config);

    final result = await repository.load();

    expect(result.isRight(), isTrue);
    expect(result.getRight().toNullable(), tSnapshot);
  });

  test('load returns Right(null) when nothing is stored', () async {
    final repository = PadRepositoryImpl(config: _FakeConfig());

    final result = await repository.load();

    expect(result.isRight(), isTrue);
    expect(result.getRight().toNullable(), isNull);
  });

  test('save returns Right(unit) and persists the snapshot', () async {
    final config = _FakeConfig();
    final repository = PadRepositoryImpl(config: config);

    final result = await repository.save(tSnapshot);

    expect(result.isRight(), isTrue);
    expect(config.lastSaved, tSnapshot);
  });
}
