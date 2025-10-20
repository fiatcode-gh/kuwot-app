import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:kuwot/core/domain/no_params.dart';
import 'package:kuwot/core/error/failure.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_translations.dart';
import 'package:kuwot/features/quote/presentation/bloc/translations_bloc.dart';
import 'package:mocktail/mocktail.dart';

class MockGetTranslations extends Mock implements GetTranslations {}

class FakeNoParams extends Fake implements NoParams {}

void main() {
  late MockGetTranslations mockGetTranslations;
  late TranslationsBloc translationsBloc;

  setUpAll(() {
    registerFallbackValue(FakeNoParams());
  });

  setUp(() {
    mockGetTranslations = MockGetTranslations();
    translationsBloc = TranslationsBloc(getTranslations: mockGetTranslations);
  });

  group('GetTranslations', () {
    test('should get translations from GetTranslations use case', () async {
      // arrange
      when(() => mockGetTranslations(any())).thenAnswer((_) async => right([]));

      // act
      translationsBloc.add(const GetTranslationsEvent());
      await untilCalled(() => mockGetTranslations(any()));

      // assert
      verify(() => mockGetTranslations(any()));
      verifyNoMoreInteractions(mockGetTranslations);
    });

    test('should emit [Loading, Loaded] when successful', () async {
      // arrange
      when(() => mockGetTranslations(any())).thenAnswer((_) async => right([]));

      // assert later
      final expected = [
        const TranslationsLoadingState(),
        const TranslationsLoadedState(translations: []),
      ];
      expectLater(translationsBloc.stream, emitsInOrder(expected));

      // act
      translationsBloc.add(const GetTranslationsEvent());
    });

    test('should emit [Loading, Error] when unsuccessful', () async {
      // arrange
      when(() => mockGetTranslations(any())).thenAnswer(
        (_) async => left(const UnknownFailure(message: 'Unknown Failure')),
      );

      // assert later
      final expected = [
        const TranslationsLoadingState(),
        const TranslationsErrorState(message: 'Unknown Failure'),
      ];
      expectLater(translationsBloc.stream, emitsInOrder(expected));

      // act
      translationsBloc.add(const GetTranslationsEvent());
    });
  });
}
