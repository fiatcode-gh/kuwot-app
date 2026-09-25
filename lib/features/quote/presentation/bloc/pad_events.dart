part of 'pad_bloc.dart';

abstract class PadEvent extends Equatable {
  const PadEvent();
}

/// Load the persisted snapshot (or start fresh) and emit the first page.
class PadStarted extends PadEvent {
  const PadStarted();

  @override
  List<Object> get props => [];
}

/// The on-screen tear or drag gesture completed for [revision].
class PadTearCommitted extends PadEvent {
  const PadTearCommitted(this.revision);

  final int revision;

  @override
  List<Object> get props => [revision];
}

/// The header on today's page was rerolled.
class PadRestyled extends PadEvent {
  const PadRestyled();

  @override
  List<Object> get props => [];
}

/// Re-check the date, e.g. on app resume.
class PadDayChecked extends PadEvent {
  const PadDayChecked();

  @override
  List<Object> get props => [];
}
