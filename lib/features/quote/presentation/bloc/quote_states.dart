part of 'quote_bloc.dart';

abstract class QuoteState extends Equatable {
  const QuoteState();

  @override
  String toString() => runtimeType.toString();
}

class QuoteInitialState extends QuoteState {
  const QuoteInitialState();

  @override
  List<Object> get props => [];
}

class QuoteLoadingState extends QuoteState {
  const QuoteLoadingState();

  @override
  List<Object> get props => [];
}

class QuoteLoadedState extends QuoteState {
  final Quote quote;

  const QuoteLoadedState({required this.quote});

  @override
  List<Object> get props => [quote];
}

class QuoteErrorState extends QuoteState implements ErrorState {
  @override
  final String message;

  @override
  final Exception? cause;

  const QuoteErrorState({required this.message, this.cause});

  @override
  List<Object?> get props => [message, cause];
}
