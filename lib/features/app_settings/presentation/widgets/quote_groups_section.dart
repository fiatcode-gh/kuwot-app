import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuwot/core/presentation/theme/app_fonts.dart';
import 'package:kuwot/core/presentation/theme/app_palette.dart';
import 'package:kuwot/features/quote/domain/entities/quote_group.dart';
import 'package:kuwot/features/quote/presentation/bloc/quote_groups_cubit.dart';

/// The "Quote groups" Settings section: a chip per [QuoteGroup], toggled
/// through [QuoteGroupsCubit]. The only selected group's chip is disabled
/// so the cubit's last-group guard is visible rather than silently refused.
class QuoteGroupsSection extends StatelessWidget {
  const QuoteGroupsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final selected = context.watch<QuoteGroupsCubit>().state;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quote groups',
          style: AppFonts.body(size: 16, color: palette.ink),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final group in QuoteGroup.values)
              FilterChip(
                label: Text(group.label),
                selected: selected.contains(group),
                // The only selected group can't be turned off.
                onSelected: selected.length == 1 && selected.contains(group)
                    ? null
                    : (on) => context.read<QuoteGroupsCubit>().setEnabled(
                        group,
                        enabled: on,
                      ),
              ),
          ],
        ),
      ],
    );
  }
}
