import 'package:bloc_test/bloc_test.dart';
import 'package:kuwot/features/quote/domain/services/background_generator.dart';
import 'package:kuwot/features/quote/presentation/bloc/background_bloc.dart';

void main() {
  const generator = BackgroundGenerator();

  blocTest<BackgroundBloc, BackgroundState>(
    'SetQuoteBackground emits a ready state with the quote seed',
    build: () => BackgroundBloc(generator: generator),
    act: (bloc) => bloc.add(const SetQuoteBackground(42)),
    expect: () => [BackgroundReady(generator.generate(42, 0))],
  );

  blocTest<BackgroundBloc, BackgroundState>(
    'CycleBackground advances the variant for the current quote',
    build: () => BackgroundBloc(generator: generator),
    act: (bloc) {
      bloc.add(const SetQuoteBackground(42));
      bloc.add(const CycleBackground());
    },
    expect: () => [
      BackgroundReady(generator.generate(42, 0)),
      BackgroundReady(generator.generate(42, 1)),
    ],
  );
}
