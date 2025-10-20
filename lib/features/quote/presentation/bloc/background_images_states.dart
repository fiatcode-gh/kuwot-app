part of 'background_images_bloc.dart';

abstract class BackgroundImagesState extends Equatable {
  const BackgroundImagesState();

  @override
  String toString() => runtimeType.toString();
}

class BackgroundImagesInitialState extends BackgroundImagesState {
  const BackgroundImagesInitialState();

  @override
  List<Object> get props => [];
}

class BackgroundImagesLoadingState extends BackgroundImagesState {
  const BackgroundImagesLoadingState();

  @override
  List<Object> get props => [];
}

class BackgroundImagesLoadedState extends BackgroundImagesState {
  final List<BackgroundImage> backgroundImages;

  const BackgroundImagesLoadedState(this.backgroundImages);

  @override
  List<Object> get props => [backgroundImages];
}

class BackgroundImagesErrorState extends BackgroundImagesState
    implements ErrorState {
  @override
  final String message;

  @override
  final Exception? cause;

  const BackgroundImagesErrorState({required this.message, this.cause});

  @override
  List<Object?> get props => [message, cause];
}
