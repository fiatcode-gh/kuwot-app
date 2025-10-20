part of 'background_images_bloc.dart';

abstract class BackgroundImagesEvent extends Equatable {
  const BackgroundImagesEvent();
}

class GetBackgroundImagesEvent extends BackgroundImagesEvent {
  const GetBackgroundImagesEvent();

  @override
  List<Object> get props => [];
}
