import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kuwot/core/presentation/theme/app_palette.dart';

/// The screen's only chrome outside the pad: tip jar and settings, kept
/// small and quiet so the pad stays the focus.
class PadTopBar extends StatelessWidget {
  const PadTopBar({
    super.key,
    required this.onTipJar,
    required this.onSettings,
  });

  final VoidCallback onTipJar;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            onPressed: onTipJar,
            tooltip: 'Tip jar',
            icon: FaIcon(
              FontAwesomeIcons.mugHot,
              size: 18,
              color: palette.inkMuted,
            ),
          ),
          IconButton(
            onPressed: onSettings,
            tooltip: 'Settings',
            icon: FaIcon(
              FontAwesomeIcons.sliders,
              size: 18,
              color: palette.inkMuted,
            ),
          ),
        ],
      ),
    );
  }
}
