import 'package:flutter/material.dart';
import 'package:kuwot/core/presentation/theme/app_palette.dart';
import 'package:kuwot/features/quote/domain/entities/quote.dart';
import 'package:kuwot/features/quote/presentation/widgets/quote_type_block.dart';

/// The quote, on plain paper stock. Used both as part of the combined
/// whole-page face and, on its own, as the sheet that tears away from
/// underneath the fixed header on a same-day quote-only tear.
class QuoteStrip extends StatelessWidget {
  const QuoteStrip({super.key, required this.quote});

  final Quote quote;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return ColoredBox(
      color: palette.paper,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 22, 24, 20),
        child: QuoteTypeBlock(body: quote.body, ink: palette.ink),
      ),
    );
  }
}
