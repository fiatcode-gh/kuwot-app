import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuwot/features/quote/domain/entities/background_style.dart';
import 'package:kuwot/features/quote/domain/services/background_generator.dart';

part 'background_events.dart';
part 'background_states.dart';

class BackgroundBloc extends Bloc<BackgroundEvent, BackgroundState> {
  BackgroundBloc({required this.generator}) : super(const BackgroundInitial()) {
    on<SetQuoteBackground>(_onSet);
    on<CycleBackground>(_onCycle);
  }

  final BackgroundGenerator generator;

  int _quoteId = 0;
  int _variant = 0;

  void _onSet(SetQuoteBackground event, Emitter<BackgroundState> emit) {
    _quoteId = event.quoteId;
    _variant = 0;
    emit(BackgroundReady(generator.generate(_quoteId, _variant)));
  }

  void _onCycle(CycleBackground event, Emitter<BackgroundState> emit) {
    _variant++;
    emit(BackgroundReady(generator.generate(_quoteId, _variant)));
  }
}
