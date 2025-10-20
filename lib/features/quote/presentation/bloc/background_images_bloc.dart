import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuwot/core/domain/no_params.dart';
import 'package:kuwot/core/presentation/bloc/error_state.dart';
import 'package:kuwot/features/quote/domain/entities/background_image.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_background_images.dart';

part 'background_images_events.dart';
part 'background_images_states.dart';

class BackgroundImagesBloc
    extends Bloc<BackgroundImagesEvent, BackgroundImagesState> {
  final GetBackgroundImages getBackgroundImages;

  BackgroundImagesBloc({required this.getBackgroundImages})
    : super(const BackgroundImagesInitialState()) {
    on<GetBackgroundImagesEvent>(_onGetBackgroundImages);
  }

  Future<void> _onGetBackgroundImages(
    GetBackgroundImagesEvent event,
    Emitter<BackgroundImagesState> emit,
  ) async {
    emit(const BackgroundImagesLoadingState());

    final result = await getBackgroundImages(const NoParams());
    result.fold(
      (failure) => emit(
        BackgroundImagesErrorState(
          message: failure.message,
          cause: failure.cause,
        ),
      ),
      (photos) => emit(BackgroundImagesLoadedState(photos)),
    );
  }
}
