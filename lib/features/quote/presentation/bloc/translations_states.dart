part of 'translations_bloc.dart';

abstract class TranslationsState extends Equatable {
  const TranslationsState();
}

class TranslationsInitialState extends TranslationsState {
  const TranslationsInitialState();

  @override
  List<Object> get props => [];
}

class TranslationsLoadingState extends TranslationsState {
  const TranslationsLoadingState();

  @override
  List<Object> get props => [];
}

class TranslationsLoadedState extends TranslationsState {
  final List<Translation> translations;

  const TranslationsLoadedState({required this.translations});

  @override
  List<Object> get props => [translations];
}

class TranslationsErrorState extends TranslationsState implements ErrorState {
  @override
  final String message;

  @override
  final Exception? cause;

  const TranslationsErrorState({required this.message, this.cause});

  @override
  List<Object?> get props => [message, cause];
}
