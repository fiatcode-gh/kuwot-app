import 'package:kuwot/features/quote/domain/entities/quote.dart';

/// The dataset maximums (`assets/data/quotes.json`): the longest body (150
/// characters) and the longest author line (219 characters), so layout
/// tests exercise the real worst case rather than hoping a random draw
/// lands on them. Text copied verbatim from
/// `proto/tear-off:lib/features/quote/domain/entities/quote_fixtures.dart`.
/// The ids are non-negative (unlike the prototype's debug-only `-1`/`-2`)
/// so a `PadSnapshot` holding them round-trips cleanly.
const kLongestBodyQuote = Quote(
  id: 9001,
  body:
      'The huge modern heresy is to alter the human soul to fit modern social '
      'conditions, instead of altering modern social conditions to fit the '
      'human soul.',
  author: 'G.K. Chesterton',
);

const kLongestAuthorQuote = Quote(
  id: 9002,
  body:
      'I hope no one who reads this book has been quite as miserable as '
      'Susan and Lucy were that night',
  author:
      "but if you have been - if you've been up all night and cried till you "
      'have no more tears left in you - you will know that there comes in '
      'the end a sort of quietness. You feel as if nothing is ever going to '
      'happen again.',
);
