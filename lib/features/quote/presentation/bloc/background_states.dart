part of 'background_bloc.dart';

abstract class BackgroundState extends Equatable {
  const BackgroundState();

  @override
  String toString() => runtimeType.toString();
}

class BackgroundInitial extends BackgroundState {
  const BackgroundInitial();

  @override
  List<Object> get props => [];
}

class BackgroundReady extends BackgroundState {
  const BackgroundReady(this.style);

  final BackgroundStyle style;

  @override
  List<Object> get props => [style];
}
