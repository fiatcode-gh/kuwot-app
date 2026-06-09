import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/core/env.dart';
import 'package:kuwot/core/network/network.dart';
import 'package:kuwot/features/quote/data/data_sources/remote/kuwot_api_remote_data_source.dart';
import 'package:kuwot/features/quote/data/models/image_model.dart';
import 'package:kuwot/features/quote/data/models/quote_model.dart';
import 'package:kuwot/features/quote/data/models/translation_model.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../_responses/_response.dart';

class MockEnv extends Mock implements Env {}

class MockNetwork extends Mock implements Network {}

class FakeUri extends Fake implements Uri {}

void main() {
  late MockEnv mockEnv;
  late MockNetwork mockNetwork;
  late KuwotApiRemoteDataSource dataSource;

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockEnv = MockEnv();
    mockNetwork = MockNetwork();
    dataSource = KuwotApiRemoteApiImpl(env: mockEnv, network: mockNetwork);

    // global stubs
    when(() => mockEnv.quoteApiScheme).thenReturn('http');
    when(() => mockEnv.quoteApiHost).thenReturn('10.0.2.2');
    when(() => mockEnv.quoteApiPort).thenReturn(8080);
  });

  group('getDailyQuote', () {
    test('should return random quote when response is successful', () async {
      // arrange
      final tResponse = readResponse('quote');
      when(
        () => mockNetwork.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => tResponse);
      // act
      final result = await dataSource.getQuote();
      // assert
      expect(result, isA<QuoteModel>());
    });

    test(
      'should return translated quote when response is successful',
      () async {
        // arrange
        final tResponse = readResponse('quote');
        when(
          () => mockNetwork.get(any(), headers: any(named: 'headers')),
        ).thenAnswer((_) async => tResponse);
        // act
        final result = await dataSource.getTranslatedQuote(1);
        // assert
        expect(result, isA<QuoteModel>());
      },
    );

    test('should return random images when response is successful', () async {
      // arrange
      final tResponse = readResponse('random_images');
      when(
        () => mockNetwork.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => tResponse);
      // act
      final result = await dataSource.getRandomImages();
      // assert
      expect(result, isA<List<ImageModel>>());
    });

    test('should return translations when response is successful', () async {
      // arrange
      final tResponse = readResponse('translations');
      when(
        () => mockNetwork.get(any(), headers: any(named: 'headers')),
      ).thenAnswer((_) async => tResponse);
      // act
      final result = await dataSource.getTranslations();
      // assert
      expect(result, isA<List<TranslationModel>>());
    });
  });
}
