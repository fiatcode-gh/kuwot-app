part of 'background_bloc.dart';

abstract class BackgroundEvent extends Equatable {
  const BackgroundEvent();

  @override
  List<Object> get props => [];
}

class SetQuoteBackground extends BackgroundEvent {
  const SetQuoteBackground(this.quoteId);

  final int quoteId;

  @override
  List<Object> get props => [quoteId];
}

class CycleBackground extends BackgroundEvent {
  const CycleBackground();
}
