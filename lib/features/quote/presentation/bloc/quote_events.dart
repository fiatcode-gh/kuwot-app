part of 'quote_bloc.dart';

abstract class QuoteEvent extends Equatable {
  const QuoteEvent();
}

class GetQuoteEvent extends QuoteEvent {
  const GetQuoteEvent();

  @override
  List<Object> get props => [];
}
