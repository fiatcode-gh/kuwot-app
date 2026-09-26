import 'dart:async';

import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/data/local/config.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/core/time.dart';
import 'package:kuwot/features/quote/data/data_sources/local/pad_snapshot_config.dart';
import 'package:kuwot/features/quote/data/repositories/pad_repository_impl.dart';
import 'package:kuwot/features/quote/domain/entities/pad_snapshot.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/domain/repositories/quote_repository.dart';
import 'package:kuwot/features/quote/domain/services/background_generator.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_quote.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_quote_by_id.dart';
import 'package:kuwot/features/quote/domain/use_cases/load_pad_snapshot.dart';
import 'package:kuwot/features/quote/domain/use_cases/save_pad_snapshot.dart';
import 'package:kuwot/features/quote/presentation/bloc/pad_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// A [Time] whose [now] is whatever the test last set on [current].
class FakeTime implements Time {
  FakeTime(this.current);

  DateTime current;

  @override
  DateTime now() => current;

  @override
  int getUnixTimestamp() => current.millisecondsSinceEpoch ~/ 1000;
}

/// A [QuoteRepository] that serves quotes 1, 2, 3, … in order from
/// [getQuote], and answers [getQuoteById] from every quote it has drawn so
/// far plus any [seed] quotes handed in up front. [queue] quotes are drawn
/// first, in order, before the auto-generated sequence resumes — for tests
/// that need a specific fixture (e.g. the longest quote) to land on a
/// particular draw without disturbing every other draw's id. Either call
/// can be made to fail on demand via [failRandom] / [failById]. A test can
/// make the *next* [getQuote] call wait for [releaseGetQuote] via
/// [delayNextGetQuote], to observe bloc state in the gap between a commit
/// and the redraw of the next under-page.
class FakeQuoteRepository implements QuoteRepository {
  FakeQuoteRepository({Map<int, Quote>? seed, List<Quote> queue = const []})
    : _known = {...?seed},
      _queue = List.of(queue);

  final Map<int, Quote> _known;
  final List<Quote> _queue;
  int _nextId = 1;

  bool failRandom = false;
  bool failById = false;

  Completer<void>? _gate;

  /// Makes the next call to [getQuote] wait until [releaseGetQuote] is
  /// called, instead of resolving straight away.
  void delayNextGetQuote() => _gate = Completer<void>();

  /// Lets a [getQuote] call gated by [delayNextGetQuote] resolve.
  void releaseGetQuote() => _gate?.complete();

  @override
  Future<Either<Failure, Quote>> getQuote() async {
    final gate = _gate;
    if (gate != null) {
      await gate.future;
      _gate = null;
    }
    if (failRandom) {
      return left(const UnknownFailure(message: 'random draw failed'));
    }
    final Quote quote;
    if (_queue.isNotEmpty) {
      quote = _queue.removeAt(0);
    } else {
      final id = _nextId++;
      quote = Quote(id: id, author: 'Author $id', body: 'Quote $id');
    }
    _known[quote.id] = quote;
    return right(quote);
  }

  @override
  Future<Either<Failure, Quote>> getQuoteById(int id) async {
    if (failById) {
      return left(const UnknownFailure(message: 'lookup failed'));
    }
    final quote = _known[id];
    if (quote == null) {
      return left(UnknownFailure(message: 'unknown quote id $id'));
    }
    return right(quote);
  }
}

/// Builds a [PadBloc] wired to the real [PadRepositoryImpl] and use cases,
/// so persistence round-trips actually exercise JSON encode/decode. Defaults
/// to a fresh [PadSnapshotConfig] over [SharedPreferences.getInstance]; the
/// caller must have set mock initial values first.
Future<PadBloc> buildPadBloc({
  required FakeTime time,
  FakeQuoteRepository? quotes,
  Config<PadSnapshot>? config,
  Duration timeout = const Duration(seconds: 2),
}) async {
  final quoteRepository = quotes ?? FakeQuoteRepository();
  final padConfig =
      config ??
      PadSnapshotConfig(
        sharedPreferences: await SharedPreferences.getInstance(),
      );
  final padRepository = PadRepositoryImpl(config: padConfig, timeout: timeout);

  return PadBloc(
    getQuote: GetQuote(quoteRepository),
    getQuoteById: GetQuoteById(quoteRepository),
    loadPadSnapshot: LoadPadSnapshot(padRepository),
    savePadSnapshot: SavePadSnapshot(padRepository),
    generator: const BackgroundGenerator(),
    time: time,
  );
}
