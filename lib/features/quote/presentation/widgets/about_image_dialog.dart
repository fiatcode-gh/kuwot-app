import 'package:auto_route/auto_route.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuwot/features/quote/domain/entities/background_image.dart';
import 'package:url_launcher/url_launcher_string.dart';

class AboutImageDialog extends StatelessWidget {
  final BackgroundImage image;

  const AboutImageDialog({required this.image, super.key});

  @override
  Widget build(BuildContext context) {
    final header = Padding(
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text('About Image', style: GoogleFonts.sriracha(fontSize: 24)),
          IconButton(
            onPressed: () {
              context.router.maybePop();
            },
            icon: const FaIcon(FontAwesomeIcons.xmark),
          ),
        ],
      ),
    );

    final info = Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          CircleAvatar(
            radius: 40,
            child: ClipOval(
              child: CachedNetworkImage(
                imageUrl: image.authorProfileImageUrl,
                placeholder: (context, url) => CircularProgressIndicator(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            image.authorName,
            style: Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          Text(image.authorBio, textAlign: TextAlign.center),
          const SizedBox(height: 4),
          Wrap(
            alignment: WrapAlignment.center,
            children: [
              _buildUserInfoChip(
                icon: FontAwesomeIcons.locationDot,
                text: image.authorLocation,
              ),
              _buildUserInfoChip(
                icon: FontAwesomeIcons.cameraRetro,
                text: '${image.authorTotalPhotos} photos',
              ),
              _buildUserInfoChip(
                icon: FontAwesomeIcons.thumbsUp,
                text: '${image.authorTotalLikes} likes',
              ),
              image.authorIsForHire
                  ? _buildUserInfoChip(
                      icon: FontAwesomeIcons.handshake,
                      text: 'For hire',
                    )
                  : const SizedBox.shrink(),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            image.description,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );

    final footer = Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: () {
              launchUrlString(image.authorUrl);
            },
            child: const Text('Author profile'),
          ),
          TextButton(
            onPressed: () {
              launchUrlString(image.originUrl);
            },
            child: const Text('Original image'),
          ),
        ],
      ),
    );

    return Dialog(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [header, const Divider(height: 1), info, footer],
      ),
    );
  }

  Widget _buildUserInfoChip({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          FaIcon(icon, size: 16),
          const SizedBox(width: 4),
          Flexible(child: Text(text)),
        ],
      ),
    );
  }
}
