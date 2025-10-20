import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuwot/core/data/local/config.dart';
import 'package:kuwot/core/data/local/translation_target_config.dart';
import 'package:kuwot/core/presentation/bloc/error_state.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_quote.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_translated_quote.dart';

part 'quote_events.dart';
part 'quote_states.dart';

class QuoteBloc extends Bloc<QuoteEvent, QuoteState> {
  final GetQuote getQuote;
  final GetTranslatedQuote getTranslatedQuote;
  final Config<TranslationTarget> translationTargetConfig;

  int _originalQuoteId = -1;

  QuoteBloc({
    required this.getQuote,
    required this.getTranslatedQuote,
    required this.translationTargetConfig,
  }) : super(const QuoteInitialState()) {
    on<GetQuoteEvent>(_onGetQuoteEvent, transformer: droppable());
    on<GetTranslatedQuoteEvent>(
      _onGetTranslatedQuoteEvent,
      transformer: droppable(),
    );
  }

  Future<void> _onGetQuoteEvent(
    QuoteEvent event,
    Emitter<QuoteState> emit,
  ) async {
    emit(const QuoteLoadingState());

    // add delay to limit the number of api calls
    await Future.delayed(const Duration(seconds: 1));

    // check if need to translate the quote
    final translationTarget = await translationTargetConfig.get();

    // get quote
    final result = await getQuote(GetQuoteParams(translationTarget));
    result.fold((failure) => emit(QuoteErrorState(message: failure.message)), (
      quote,
    ) {
      _originalQuoteId = quote.id;
      emit(QuoteLoadedState(quote: quote));
    });
  }

  Future<void> _onGetTranslatedQuoteEvent(
    GetTranslatedQuoteEvent event,
    Emitter<QuoteState> emit,
  ) async {
    emit(const QuoteLoadingState());

    // add delay to limit the number of api calls
    await Future.delayed(const Duration(seconds: 1));

    // get translation target
    final translationTarget = await translationTargetConfig.get();
    if (translationTarget == null) {
      emit(const QuoteErrorState(message: 'Translation target is not set'));
      return;
    }

    // get translated quote
    final result = await getTranslatedQuote(
      GetTranslatedQuoteParams(
        id: _originalQuoteId,
        translationTarget: translationTarget,
      ),
    );
    result.fold(
      (failure) => emit(QuoteErrorState(message: failure.message)),
      (quote) => emit(QuoteLoadedState(quote: quote)),
    );
  }
}
