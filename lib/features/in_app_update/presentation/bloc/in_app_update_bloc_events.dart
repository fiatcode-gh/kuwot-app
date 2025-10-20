part of 'in_app_update_bloc.dart';

abstract class InAppUpdateEvent extends Equatable {
  const InAppUpdateEvent();
}

class InAppUpdateCheckEvent extends InAppUpdateEvent {
  const InAppUpdateCheckEvent();

  @override
  List<Object?> get props => [];
}

class InAppUpdateStartEvent extends InAppUpdateEvent {
  const InAppUpdateStartEvent();

  @override
  List<Object?> get props => [];
}
