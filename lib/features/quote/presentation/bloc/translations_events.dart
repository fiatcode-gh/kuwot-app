part of 'translations_bloc.dart';

abstract class TranslationsEvent extends Equatable {
  const TranslationsEvent();
}

class GetTranslationsEvent extends TranslationsEvent {
  const GetTranslationsEvent();

  @override
  List<Object> get props => [];
}
