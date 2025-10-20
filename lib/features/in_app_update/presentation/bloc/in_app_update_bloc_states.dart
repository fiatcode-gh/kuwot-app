part of 'in_app_update_bloc.dart';

abstract class InAppUpdateState extends Equatable {
  const InAppUpdateState();
}

class InAppUpdateInitialState extends InAppUpdateState {
  const InAppUpdateInitialState();

  @override
  List<Object> get props => [];
}

class InAppUpdateCheckingState extends InAppUpdateState {
  const InAppUpdateCheckingState();

  @override
  List<Object> get props => [];
}

class InAppUpdateAvailableState extends InAppUpdateState {
  const InAppUpdateAvailableState();

  @override
  List<Object> get props => [];
}

class InAppUpdateUnavailableState extends InAppUpdateState {
  const InAppUpdateUnavailableState();

  @override
  List<Object> get props => [];
}
