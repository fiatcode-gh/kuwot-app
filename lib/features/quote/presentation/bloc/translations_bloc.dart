import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuwot/core/domain/no_params.dart';
import 'package:kuwot/core/presentation/bloc/error_state.dart';
import 'package:kuwot/features/quote/domain/entities/translation.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_translations.dart';

part 'translations_events.dart';
part 'translations_states.dart';

class TranslationsBloc extends Bloc<TranslationsEvent, TranslationsState> {
  final GetTranslations getTranslations;

  TranslationsBloc({required this.getTranslations})
    : super(const TranslationsInitialState()) {
    on<GetTranslationsEvent>(_onGetTranslationEvent);
  }

  Future<void> _onGetTranslationEvent(
    TranslationsEvent event,
    Emitter<TranslationsState> emit,
  ) async {
    emit(const TranslationsLoadingState());
    final translations = await getTranslations(const NoParams());
    translations.fold(
      (failure) => emit(TranslationsErrorState(message: failure.message)),
      (translations) =>
          emit(TranslationsLoadedState(translations: translations)),
    );
  }
}
