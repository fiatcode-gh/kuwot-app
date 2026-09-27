import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:kuwot/core/presentation/theme/app_fonts.dart';
import 'package:kuwot/core/presentation/theme/app_palette.dart';
import 'package:kuwot/features/quote/domain/entities/tear_kind.dart';

/// The pad's own toolbar: tear off the current page or quote, restyle the
/// header, share, and open Settings. The tear button always runs the pad's
/// current [tearKind], so it can never disagree with a completed drag
/// gesture (contract G9). A `null` callback disables its button: dimmed, no
/// ink response, and marked unavailable to assistive technology.
class ControlDock extends StatelessWidget {
  const ControlDock({
    super.key,
    required this.tearKind,
    required this.onTear,
    required this.onRestyle,
    required this.onShare,
    required this.onSettings,
  });

  final TearKind? tearKind;
  final VoidCallback? onTear;
  final VoidCallback? onRestyle;
  final VoidCallback? onShare;
  final VoidCallback onSettings;

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final isPage = tearKind == TearKind.page;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: palette.divider)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: [
            Expanded(
              child: _DockButton(
                icon: isPage
                    ? FontAwesomeIcons.calendarDay
                    : FontAwesomeIcons.scissors,
                label: isPage ? 'Today' : 'New quote',
                palette: palette,
                onPressed: onTear,
              ),
            ),
            Expanded(
              child: _DockButton(
                icon: FontAwesomeIcons.wandMagicSparkles,
                label: 'Restyle',
                palette: palette,
                onPressed: onRestyle,
              ),
            ),
            Expanded(
              child: _DockButton(
                icon: FontAwesomeIcons.shareNodes,
                label: 'Share',
                palette: palette,
                onPressed: onShare,
              ),
            ),
            Expanded(
              child: _DockButton(
                icon: FontAwesomeIcons.sliders,
                label: 'Settings',
                palette: palette,
                onPressed: onSettings,
                tooltip: 'Settings',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DockButton extends StatelessWidget {
  const _DockButton({
    required this.icon,
    required this.label,
    required this.palette,
    required this.onPressed,
    this.tooltip,
  });

  final FaIconData icon;
  final String label;
  final AppPalette palette;
  final VoidCallback? onPressed;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;
    final button = Semantics(
      enabled: enabled,
      button: true,
      label: label,
      excludeSemantics: true,
      onTap: onPressed,
      child: Opacity(
        opacity: enabled ? 1 : 0.38,
        child: InkWell(
          onTap: onPressed,
          borderRadius: BorderRadius.circular(12),
          child: ConstrainedBox(
            constraints: const BoxConstraints(minHeight: 48, minWidth: 48),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FaIcon(icon, size: 20, color: palette.ink),
                  const SizedBox(height: 6),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      label.toUpperCase(),
                      maxLines: 1,
                      softWrap: false,
                      style: AppFonts.label(
                        size: 10.5,
                        color: palette.inkMuted,
                        weight: 600,
                        letterSpacing: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final tooltipMessage = tooltip;
    if (tooltipMessage == null) return button;
    return Tooltip(
      message: tooltipMessage,
      excludeFromSemantics: true,
      child: button,
    );
  }
}
