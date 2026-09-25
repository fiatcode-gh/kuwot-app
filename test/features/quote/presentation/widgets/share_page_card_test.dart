import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kuwot/core/presentation/theme/app_theme.dart';
import 'package:kuwot/features/quote/domain/entities/background_style.dart';
import 'package:kuwot/features/quote/domain/entities/pad_day.dart';
import 'package:kuwot/features/quote/domain/entities/pad_page.dart';
import 'package:kuwot/features/quote/domain/entities/palettes.dart';
import 'package:kuwot/features/quote/presentation/widgets/share_page_card.dart';

import '../../../../helpers/load_app_fonts.dart';
import '../../../../helpers/pad_test_app.dart';
import '../../../../helpers/quote_fixtures.dart';

// A Friday; the exact date is irrelevant here, only that it is a valid day.
const _day = PadDay(2026, 9, 25);

const _pngSignature = [137, 80, 78, 71, 13, 10, 26, 10];

void main() {
  setUpAll(() async {
    await loadAppFonts();
    await initializeDateFormatting();
  });

  final style = BackgroundStyle(seed: _day.seed, palette: kPalettes.first);
  final page = PadPage(day: _day, quote: kLongestAuthorQuote, header: style);

  for (final themeEntry in {'light': lightTheme, 'dark': darkTheme}.entries) {
    testWidgets(
      'renderSharePage captures a 1080x1920 PNG, ${themeEntry.key} theme',
      (tester) async {
        late BuildContext capturedContext;
        await tester.pumpWidget(
          padTestApp(
            Builder(
              builder: (context) {
                capturedContext = context;
                return const SizedBox.shrink();
              },
            ),
            theme: themeEntry.value,
          ),
        );

        final bytes = await tester.runAsync(
          () => renderSharePage(
            capturedContext,
            page,
            locale: const Locale('en', 'US'),
          ),
        );

        expect(bytes, isNotNull);
        expect(bytes!.sublist(0, 8), _pngSignature);

        final ihdr = ByteData.sublistView(bytes);
        expect(ihdr.getUint32(16), 1080);
        expect(ihdr.getUint32(20), 1920);
      },
    );
  }
}
