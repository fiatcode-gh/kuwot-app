import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutWidget extends StatelessWidget {
  const AboutWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text('Links & Credits', style: Theme.of(context).textTheme.titleMedium),
        const Divider(),
        _buildCreditItem(
          context,
          title: 'Kuwot App Source',
          description:
              'Source code for this app. Any suggestions or contributions are welcome.',
          url: 'https://github.com/dhemasnurjaya/kuwot-app',
        ),
        _buildCreditItem(
          context,
          title: 'Quotes-500K',
          description:
              'This app ships a curated subset of the quotes dataset by Shivali Goel, Rishi Madhok, Shweta Garg. Initially created for "Proposing Contextually Relevant Quotes for Images" journal.',
          url: 'https://github.com/ShivaliGoel/Quotes-500K',
        ),
      ],
    );
  }

  Widget _buildCreditItem(
    BuildContext context, {
    required String title,
    required String description,
    required String url,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(title, style: Theme.of(context).textTheme.titleMedium),
        Text(description),
        const SizedBox(height: 4),
        GestureDetector(
          child: Text(
            url,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              decoration: TextDecoration.underline,
              color: Colors.indigoAccent,
              decorationColor: Colors.indigoAccent,
            ),
          ),
          onTap: () async {
            await launchUrlString(url);
          },
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
