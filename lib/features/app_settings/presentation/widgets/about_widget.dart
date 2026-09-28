import 'package:flutter/material.dart';
import 'package:kuwot/core/presentation/theme/app_fonts.dart';
import 'package:kuwot/core/presentation/theme/app_palette.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Links & Credits',
          style: AppFonts.label(size: 12, color: palette.inkMuted),
        ),
        const Divider(),
        _buildCreditItem(
          palette: palette,
          title: 'Kuwot App Source',
          description: 'Source code for this app. Any suggestions or contributions are welcome.',
          url: 'https://github.com/dhemasnurjaya/kuwot-app',
        ),
        _buildCreditItem(
          palette: palette,
          title: 'Quotes',
          description: 'An original set written for Kuwot.',
        ),
      ],
    );
  }

  Widget _buildCreditItem({
    required AppPalette palette,
    required String title,
    required String description,
    String? url,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: AppFonts.frauncesFamily,
            fontSize: 16,
            color: palette.ink,
            fontVariations: const [FontVariation('wght', 600)],
          ),
        ),
        const SizedBox(height: 4),
        Text(
          description,
          style: AppFonts.body(size: 14, color: palette.inkMuted),
        ),
        if (url != null) ...[
          const SizedBox(height: 4),
          InkWell(
            onTap: () async {
              await launchUrlString(url);
            },
            child: ConstrainedBox(
              constraints: const BoxConstraints(minHeight: 48),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  url,
                  style: AppFonts.body(size: 14, color: palette.ink).copyWith(
                    decoration: TextDecoration.underline,
                    decorationColor: palette.ink,
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
