import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuwot/core/domain/no_params.dart';
import 'package:kuwot/core/presentation/bloc/error_state.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_quote.dart';

part 'quote_events.dart';
part 'quote_states.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  QuoteBloc({required this.getQuote}) : super(const QuoteInitialState()) {
    on<GetQuoteEvent>(_onGetQuoteEvent, transformer: droppable());
  }

  final GetQuote getQuote;

  Future<void> _onGetQuoteEvent(
    GetQuoteEvent event,
    Emitter<QuoteState> emit,
  ) async {
    emit(const QuoteLoadingState());

    final result = await getQuote(const NoParams());
    result.fold(
      (failure) => emit(QuoteErrorState(message: failure.message)),
      (quote) => emit(QuoteLoadedState(quote: quote)),
    );
  }
}
