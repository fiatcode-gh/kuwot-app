import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/domain/no_params.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/quote/domain/entities/background_image.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_background_images.dart';
import 'package:kuwot/features/quote/presentation/bloc/background_images_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetBackgroundImages extends Mock implements GetBackgroundImages {}

class FakeNoParams extends Fake implements NoParams {}

void main() {
  late MockGetBackgroundImages mockGetBackgroundImages;
  late BackgroundImagesBloc backgroundImagesBloc;

  setUpAll(() {
    registerFallbackValue(FakeNoParams());
  });

  setUp(() {
    mockGetBackgroundImages = MockGetBackgroundImages();
    backgroundImagesBloc = BackgroundImagesBloc(
      getBackgroundImages: mockGetBackgroundImages,
    );
  });

  test('initial state is BackgroundImagesInitial', () {
    // assert
    expect(backgroundImagesBloc.state, const BackgroundImagesInitialState());
  });

  group('GetBackgroundImages', () {
    test(
      'should get background photos from GetBackgroundImages use case',
      () async {
        // arrange
        when(
          () => mockGetBackgroundImages(any()),
        ).thenAnswer((_) async => right(const <BackgroundImage>[]));

        // act
        backgroundImagesBloc.add(const GetBackgroundImagesEvent());
        await untilCalled(() => mockGetBackgroundImages(any()));

        // assert
        verify(() => mockGetBackgroundImages(any())).called(1);
        verifyNoMoreInteractions(mockGetBackgroundImages);
      },
    );

    test(
      'should emit [BackgroundImagesLoading, BackgroundImagesLoaded] when data is gotten successfully',
      () async {
        // arrange
        const tBackgroundImages = <BackgroundImage>[];
        when(
          () => mockGetBackgroundImages(any()),
        ).thenAnswer((_) async => right(tBackgroundImages));

        // assert later
        final expected = [
          const BackgroundImagesLoadingState(),
          const BackgroundImagesLoadedState(tBackgroundImages),
        ];
        expectLater(backgroundImagesBloc.stream, emitsInOrder(expected));

        // act
        backgroundImagesBloc.add(const GetBackgroundImagesEvent());
      },
    );

    test(
      'should emit [BackgroundImagesLoading, BackgroundImagesError] when getting data fails',
      () async {
        // arrange
        const tFailure = UnknownFailure(message: 'Unknown Failure');
        when(
          () => mockGetBackgroundImages(any()),
        ).thenAnswer((_) async => left(tFailure));

        // assert later
        final expected = [
          const BackgroundImagesLoadingState(),
          BackgroundImagesErrorState(message: tFailure.message),
        ];
        expectLater(backgroundImagesBloc.stream, emitsInOrder(expected));

        // act
        backgroundImagesBloc.add(const GetBackgroundImagesEvent());
      },
    );
  });
}
