part of 'pad_bloc.dart';

abstract class PadState extends Equatable {
  const PadState();

  @override
  String toString() => runtimeType.toString();
}

class PadLoading extends PadState {
  const PadLoading();

  @override
  List<Object> get props => [];
}

class PadReady extends PadState {
  const PadReady({
    required this.top,
    required this.under,
    required this.tearKind,
    required this.revision,
  });

  final PadPage top;
  final PadPage under;
  final TearKind tearKind;
  final int revision;

  @override
  List<Object> get props => [top, under, tearKind, revision];
}

class PadFailed extends PadState implements ErrorState {
  const PadFailed({required this.message, this.cause});

  @override
  final String message;

  @override
  final Exception? cause;

  @override
  List<Object?> get props => [message, cause];
}
