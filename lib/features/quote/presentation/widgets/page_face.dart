import 'package:flutter/material.dart';
import 'package:kuwot/features/quote/domain/entities/pad_page.dart';
import 'package:kuwot/features/quote/presentation/widgets/page_header.dart';
import 'package:kuwot/features/quote/presentation/widgets/perforation_line.dart';
import 'package:kuwot/features/quote/presentation/widgets/quote_strip.dart';

/// Flex weights splitting a [PageFace] between its header and its quote
/// strip. Also the same-day tear boundary: [PerforationLine] marks it.
const kHeaderFlex = 9;
const kQuoteFlex = 13;

/// The full face of one pad page: header (date and generated background),
/// perforation, then the quote. Used both for the on-screen top page and, at
/// a fixed size, for [SharePageCard].
class PageFace extends StatelessWidget {
  const PageFace({super.key, required this.page, required this.locale});

  final PadPage page;
  final Locale locale;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: kHeaderFlex,
          child: PageHeader(day: page.day, style: page.header, locale: locale),
        ),
        const PerforationLine(),
        Expanded(
          flex: kQuoteFlex,
          child: QuoteStrip(quote: page.quote),
        ),
      ],
    );
  }
}
