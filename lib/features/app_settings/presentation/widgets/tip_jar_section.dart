import 'package:flutter/material.dart';
import 'package:kuwot/core/presentation/theme/app_fonts.dart';
import 'package:kuwot/core/presentation/theme/app_palette.dart';
import 'package:url_launcher/url_launcher.dart';

/// The Settings page's tip jar: the donation message and one action that
/// opens the developer's Buy Me a Coffee page in the external browser.
class TipJarSection extends StatelessWidget {
  const TipJarSection({super.key});

  static final Uri buyMeACoffeeUrl = Uri.parse(
    'https://buymeacoffee.com/fiatcode',
  );

  static const _donationMessage =
      'I built this app with love and coffee. If you find it useful, please consider buying me a coffee. Your donation will help me keep the app running and updated. Thank you! ☕';

  Future<void> _openBuyMeACoffee(BuildContext context) async {
    bool launched;
    try {
      launched = await launchUrl(
        buyMeACoffeeUrl,
        mode: LaunchMode.externalApplication,
      );
    } on Exception {
      launched = false;
    }
    if (launched) return;
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Could not open buymeacoffee.com/fiatcode.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Tip jar', style: AppFonts.body(size: 16, color: palette.ink)),
        const SizedBox(height: 8),
        Text(
          _donationMessage,
          style: AppFonts.quoteBody(size: 18, color: palette.ink),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: () => _openBuyMeACoffee(context),
          icon: const Icon(Icons.coffee_outlined),
          label: const Text('Buy me a coffee'),
        ),
      ],
    );
  }
}
