import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:kuwot/core/app_updater.dart';

part 'in_app_update_bloc_events.dart';
part 'in_app_update_bloc_states.dart';

class InAppUpdateBloc extends Bloc<InAppUpdateEvent, InAppUpdateState> {
  InAppUpdateBloc({required this.appUpdater})
    : super(const InAppUpdateInitialState()) {
    on<InAppUpdateCheckEvent>(_onInAppUpdateCheckEvent);
    on<InAppUpdateStartEvent>(_onInAppUpdateStartEvent);
  }

  final AppUpdater appUpdater;

  Future<void> _onInAppUpdateCheckEvent(
    InAppUpdateCheckEvent event,
    Emitter<InAppUpdateState> emit,
  ) async {
    try {
      emit(const InAppUpdateCheckingState());
      final updateInfo = await appUpdater.checkForUpdate();
      if (updateInfo.updateAvailability == UpdateAvailability.updateAvailable) {
        emit(const InAppUpdateAvailableState());
      } else {
        emit(const InAppUpdateUnavailableState());
      }
    } on Exception catch (_) {
      emit(const InAppUpdateUnavailableState());
    }
  }

  Future<void> _onInAppUpdateStartEvent(
    InAppUpdateStartEvent event,
    Emitter<InAppUpdateState> emit,
  ) async {
    await appUpdater.update();
  }
}
