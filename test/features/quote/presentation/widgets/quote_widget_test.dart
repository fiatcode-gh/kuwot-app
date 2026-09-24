import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/presentation/bloc/quote_bloc.dart';
import 'package:kuwot/features/quote/presentation/widgets/quote_widget.dart';

class _MockQuoteBloc extends MockBloc<QuoteEvent, QuoteState>
    implements QuoteBloc {}

const _long =
    'The huge modern heresy is to alter the human soul to fit modern '
    'social conditions, instead of altering modern social conditions to '
    'fit the human soul.';

Future<void> pumpQuote(WidgetTester tester, Size size) async {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  final bloc = _MockQuoteBloc();
  whenListen(
    bloc,
    const Stream<QuoteState>.empty(),
    initialState: const QuoteLoadedState(
      quote: Quote(id: 1, author: 'G.K. Chesterton', body: _long),
    ),
  );

  await tester.pumpWidget(
    MaterialApp(
      home: Scaffold(
        body: BlocProvider<QuoteBloc>.value(
          value: bloc,
          child: const Align(alignment: Alignment.center, child: QuoteWidget()),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('fits a short window and scrolls to the author', (tester) async {
    await pumpQuote(tester, const Size(900, 220));

    expect(tester.takeException(), isNull);
    await tester.scrollUntilVisible(
      find.text('- G.K. Chesterton'),
      50,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      tester.getRect(find.text('- G.K. Chesterton')).bottom,
      lessThanOrEqualTo(220),
    );
  });

  testWidgets('caps the quote card width on wide windows', (tester) async {
    await pumpQuote(tester, const Size(1400, 900));

    expect(tester.getSize(find.text(_long)).width, lessThanOrEqualTo(600));
  });

  testWidgets('keeps full width on phone-sized windows', (tester) async {
    await pumpQuote(tester, const Size(360, 800));

    expect(tester.getSize(find.text(_long)).width, 296);
  });
}
