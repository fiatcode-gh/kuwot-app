import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/domain/no_params.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/core/presentation/bloc/error_state.dart';
import 'package:kuwot/core/time.dart';
import 'package:kuwot/features/quote/domain/entities/background_style.dart';
import 'package:kuwot/features/quote/domain/entities/pad_day.dart';
import 'package:kuwot/features/quote/domain/entities/pad_page.dart';
import 'package:kuwot/features/quote/domain/entities/pad_snapshot.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/domain/entities/tear_kind.dart';
import 'package:kuwot/features/quote/domain/services/background_generator.dart';
import 'package:kuwot/features/quote/domain/services/pad_calendar.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_quote.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_quote_by_id.dart';
import 'package:kuwot/features/quote/domain/use_cases/load_pad_snapshot.dart';
import 'package:kuwot/features/quote/domain/use_cases/save_pad_snapshot.dart';

part 'pad_events.dart';
part 'pad_states.dart';

/// Drives the tear-off pad: which quote/header sit on top and underneath,
/// which side the next tear removes, and the persisted last-viewed state.
/// All events are serialised through a single handler (G1-G4, G9).
class PadBloc extends Bloc<PadEvent, PadState> {
  PadBloc({
    required this.getQuote,
    required this.getQuoteById,
    required this.loadPadSnapshot,
    required this.savePadSnapshot,
    required this.generator,
    required this.time,
  }) : super(const PadLoading()) {
    on<PadEvent>(_onEvent, transformer: sequential());
  }

  final GetQuote getQuote;
  final GetQuoteById getQuoteById;
  final LoadPadSnapshot loadPadSnapshot;
  final SavePadSnapshot savePadSnapshot;
  final BackgroundGenerator generator;
  final Time time;

  HeaderReroll? _reroll;
  PadSnapshot? _lastSaved;
  int _revision = 0;

  Future<void> _onEvent(PadEvent event, Emitter<PadState> emit) async {
    switch (event) {
      case PadStarted():
        await _onStarted(event, emit);
      case PadTearCommitted():
        await _onTearCommitted(event, emit);
      case PadRestyled():
        _onRestyled(event, emit);
      case PadDayChecked():
        await _onDayChecked(event, emit);
    }
  }

  Future<void> _onStarted(PadStarted event, Emitter<PadState> emit) async {
    if (state is! PadLoading) emit(const PadLoading());

    final today = PadDay.from(time.now());
    final loadResult = await loadPadSnapshot(const NoParams());
    final saved = loadResult.fold((_) => null, (value) => value);
    _lastSaved = saved;
    _reroll = saved?.reroll;

    final PadDay topDay;
    final Either<Failure, Quote> topQuoteResult;
    if (saved == null) {
      topDay = today;
      topQuoteResult = await getQuote(const NoParams());
    } else {
      topDay = saved.day.isAfter(today) ? today : saved.day;
      topQuoteResult = await _quoteById(saved.quoteId);
    }

    if (topQuoteResult.isLeft()) {
      _emitFailure(emit, topQuoteResult);
      return;
    }
    final topQuote = _rightValue(topQuoteResult);
    final top = PadPage(day: topDay, quote: topQuote, header: _header(topDay));
    final kind = PadCalendar.tearKind(pageDay: topDay, today: today);

    final underResult = await _drawUnder(top, kind, today);
    if (underResult.isLeft()) {
      _emitFailure(emit, underResult);
      return;
    }
    final under = _rightValue(underResult);

    emit(
      PadReady(top: top, under: under, tearKind: kind, revision: ++_revision),
    );
    _persist(top);
  }

  Future<void> _onTearCommitted(
    PadTearCommitted event,
    Emitter<PadState> emit,
  ) async {
    final current = state;
    if (current is! PadReady || event.revision != current.revision) return;

    final today = PadDay.from(time.now());
    var newTop = current.under;
    if (newTop.day.isAfter(today)) {
      newTop = PadPage(day: today, quote: newTop.quote, header: _header(today));
    }

    final kind = PadCalendar.tearKind(pageDay: newTop.day, today: today);
    final underResult = await _drawUnder(newTop, kind, today);
    if (underResult.isLeft()) {
      _emitFailure(emit, underResult);
      return;
    }
    final under = _rightValue(underResult);

    emit(
      PadReady(
        top: newTop,
        under: under,
        tearKind: kind,
        revision: ++_revision,
      ),
    );
    _persist(newTop);
  }

  void _onRestyled(PadRestyled event, Emitter<PadState> emit) {
    final current = state;
    if (current is! PadReady || current.tearKind != TearKind.quote) return;

    final variant = PadCalendar.headerVariant(current.top.day, _reroll) + 1;
    _reroll = HeaderReroll(current.top.day, variant);
    final newHeader = _header(current.top.day);

    final newTop = current.top.copyWith(header: newHeader);
    final newUnder = current.under.day == current.top.day
        ? current.under.copyWith(header: newHeader)
        : current.under;

    emit(
      PadReady(
        top: newTop,
        under: newUnder,
        tearKind: current.tearKind,
        revision: current.revision,
      ),
    );
    _persist(newTop);
  }

  Future<void> _onDayChecked(
    PadDayChecked event,
    Emitter<PadState> emit,
  ) async {
    final current = state;
    if (current is! PadReady) return;

    final today = PadDay.from(time.now());
    final top = current.top;

    if (top.day.isAfter(today)) {
      final newTop = PadPage(
        day: today,
        quote: top.quote,
        header: _header(today),
      );
      final underResult = await _drawUnder(newTop, TearKind.quote, today);
      if (underResult.isLeft()) {
        _emitFailure(emit, underResult);
        return;
      }
      final under = _rightValue(underResult);
      emit(
        PadReady(
          top: newTop,
          under: under,
          tearKind: TearKind.quote,
          revision: ++_revision,
        ),
      );
      _persist(newTop);
      return;
    }

    if (current.tearKind == TearKind.quote && top.day.isBefore(today)) {
      final underResult = await _drawUnder(top, TearKind.page, today);
      if (underResult.isLeft()) {
        _emitFailure(emit, underResult);
        return;
      }
      final under = _rightValue(underResult);
      emit(
        PadReady(
          top: top,
          under: under,
          tearKind: TearKind.page,
          revision: ++_revision,
        ),
      );
    }
  }

  /// Resolves a saved quote by id, falling back to a random draw when the
  /// id is unknown or the lookup fails.
  Future<Either<Failure, Quote>> _quoteById(int id) async {
    final result = await getQuoteById(id);
    if (result.isRight()) return result;
    return getQuote(const NoParams());
  }

  /// Draws the page under [top]: a same-day new quote under the same header
  /// for a quote tear, or today's page under a fresh header for a page tear.
  Future<Either<Failure, PadPage>> _drawUnder(
    PadPage top,
    TearKind kind,
    PadDay today,
  ) async {
    final quoteResult = await getQuote(const NoParams());
    return quoteResult.fold(
      (failure) => left(failure),
      (quote) => right(
        kind == TearKind.quote
            ? PadPage(day: top.day, quote: quote, header: top.header)
            : PadPage(day: today, quote: quote, header: _header(today)),
      ),
    );
  }

  BackgroundStyle _header(PadDay day) =>
      generator.generate(day.seed, PadCalendar.headerVariant(day, _reroll));

  void _persist(PadPage top) {
    final snapshot = PadSnapshot(
      day: top.day,
      quoteId: top.quote.id,
      reroll: _reroll != null && _reroll!.day == top.day ? _reroll : null,
    );
    if (snapshot != _lastSaved) {
      _lastSaved = snapshot;
      unawaited(savePadSnapshot(snapshot));
    }
  }

  void _emitFailure<T>(Emitter<PadState> emit, Either<Failure, T> result) {
    final failure = _leftValue(result);
    emit(PadFailed(message: failure.message, cause: failure.cause));
  }

  T _rightValue<T>(Either<Failure, T> result) =>
      result.getRight().toNullable()!;

  Failure _leftValue<T>(Either<Failure, T> result) =>
      result.getLeft().toNullable()!;
}
