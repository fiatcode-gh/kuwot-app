import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/domain/entities/quote_group.dart';

/// The longest text in `assets/data/quotes.json` (74 characters), so layout
/// tests exercise the real worst case rather than hoping a random draw lands
/// on it.
const kLongestQuote = Quote(
  id: 9001,
  body:
      'Good work respects both the person using it and the person '
      'maintaining it.',
  group: QuoteGroup.doTheWork,
);
