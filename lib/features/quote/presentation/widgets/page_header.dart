import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:kuwot/core/presentation/theme/app_fonts.dart';
import 'package:kuwot/core/presentation/theme/app_palette.dart';
import 'package:kuwot/features/quote/domain/entities/background_style.dart';
import 'package:kuwot/features/quote/domain/entities/pad_day.dart';
import 'package:kuwot/features/quote/presentation/widgets/background_painter.dart';

/// The weekday and month labels for [day], formatted in the **device**
/// locale (`View.of(context).platformDispatcher.locale`), not the app's
/// [Localizations] locale — the app ships no localization delegates, so
/// [Localizations] would always resolve to `en_US` regardless of the
/// device's actual setting (contract G11). Falls back to the bare language
/// code, then to `en`, if `intl` has no data for the full locale tag.
({String weekday, String month}) padDateLabels(
  BuildContext context,
  PadDay day,
) {
  final locale = View.of(context).platformDispatcher.locale;
  final tag = Intl.canonicalizedLocale(locale.toLanguageTag());
  final String resolved;
  if (DateFormat.localeExists(tag)) {
    resolved = tag;
  } else if (DateFormat.localeExists(locale.languageCode)) {
    resolved = locale.languageCode;
  } else {
    resolved = 'en';
  }
  final date = day.toDateTime();
  return (
    weekday: DateFormat.EEEE(resolved).format(date).toUpperCase(),
    month: DateFormat.MMMM(resolved).format(date).toUpperCase(),
  );
}

/// The fixed top block of a page: the generated background, the day-of-month
/// numeral, and the weekday/month labels. Stays on screen across a same-day
/// quote tear; only a whole-page tear takes it away.
///
/// No scrim — [AppPalette.headerInk] is chosen so every curated palette
/// clears WCAG AA against it directly (contract G6). Text is wrapped in a
/// [FittedBox] rather than sized to a fixed budget: the day numeral and
/// labels must never overflow, even at a large text scale factor, so they
/// scale down together instead.
class PageHeader extends StatelessWidget {
  const PageHeader({super.key, required this.day, required this.style});

  final PadDay day;
  final BackgroundStyle style;

  @override
  Widget build(BuildContext context) {
    final labels = padDateLabels(context, day);
    return LayoutBuilder(
      builder: (context, constraints) {
        final numeralSize = (constraints.maxWidth * 0.34).clamp(64.0, 132.0);
        return Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(painter: BackgroundPainter(style)),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Center(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        labels.month,
                        style: AppFonts.label(
                          size: 13,
                          color: AppPalette.headerInk,
                        ),
                      ),
                      Text(
                        '${day.day}',
                        style: AppFonts.dayNumeral(
                          size: numeralSize,
                          color: AppPalette.headerInk,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        labels.weekday,
                        style: AppFonts.label(
                          size: 13,
                          color: AppPalette.headerInk,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
