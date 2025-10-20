import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuwot/core/data/local/translation_target_config.dart';
import 'package:kuwot/core/router/app_router.gr.dart';
import 'package:kuwot/features/quote/data/data_sources/remote/kuwot_api_remote_data_source.dart';
import 'package:kuwot/features/quote/presentation/bloc/background_images_bloc.dart';
import 'package:kuwot/features/quote/presentation/bloc/quote_bloc.dart';
import 'package:kuwot/features/quote/presentation/widgets/background_image_widget.dart';
import 'package:kuwot/features/quote/presentation/widgets/quote_widget.dart';
import 'package:kuwot/features/quote/presentation/widgets/translate_target_dialog.dart';
import 'package:screenshot/screenshot.dart';
import 'package:share_plus/share_plus.dart';

@RoutePage()
class QuotePage extends StatefulWidget {
  const QuotePage({super.key});

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  final _screenshotController = ScreenshotController();
  int _backgroundIndex = 0;
  bool _isSharingQuote = false;

  late QuoteBloc _dailyQuoteBloc;
  late BackgroundImagesBloc _backgroundImagesBloc;

  @override
  void initState() {
    super.initState();

    _dailyQuoteBloc = context.read<QuoteBloc>();
    _backgroundImagesBloc = context.read<BackgroundImagesBloc>();

    // get daily quote & background photos
    _dailyQuoteBloc.add(const GetQuoteEvent());
    _backgroundImagesBloc.add(const GetBackgroundImagesEvent());
  }

  @override
  Widget build(BuildContext context) {
    final header = Padding(
      padding: const EdgeInsets.fromLTRB(24, 8, 16, 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Text('Kuwot', style: GoogleFonts.sriracha(fontSize: 30)),
              const SizedBox(width: 2),
              SvgPicture.asset(
                'assets/svgs/chat-quote.svg',
                height: 24,
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              IconButton(
                onPressed: () {
                  context.router.push(const DonationRoute());
                },
                icon: const FaIcon(FontAwesomeIcons.mugHot),
              ),
              IconButton(
                onPressed: () {
                  context.router.push(const AppSettingsRoute());
                },
                icon: const FaIcon(FontAwesomeIcons.sliders),
              ),
            ],
          ),
        ],
      ),
    );

    final body = SafeArea(
      child: Stack(
        fit: StackFit.expand,
        children: [
          Align(alignment: Alignment.topLeft, child: header),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 70, 24, 24),
            child: _buildQuote(),
          ),
        ],
      ),
    );

    return Scaffold(body: body);
  }

  Widget _buildQuote() {
    final screenshotEnabledQuote = Screenshot(
      controller: _screenshotController,
      child: Stack(
        fit: StackFit.expand,
        children: [
          BackgroundPhotoWidget(
            backgroundIndex: _backgroundIndex,
            hideImageInfoButton: _isSharingQuote,
          ),
          const Align(alignment: Alignment.center, child: QuoteWidget()),
        ],
      ),
    );

    final actionButtons = [
      Expanded(
        child: _buildQuoteActionButton(
          onPressed: () {
            _dailyQuoteBloc.add(const GetQuoteEvent());
          },
          icon: const FaIcon(FontAwesomeIcons.quoteRight),
        ),
      ),
      Expanded(
        child: _buildQuoteActionButton(
          onPressed: _cycleBackground,
          icon: const FaIcon(FontAwesomeIcons.image),
        ),
      ),
      Expanded(
        child: _buildQuoteActionButton(
          onPressed: () async {
            final result = await showAdaptiveDialog<TranslationTarget?>(
              context: context,
              barrierDismissible: true,
              builder: (context) => const TranslateTargetDialog(),
            );

            if (result != null) {
              _dailyQuoteBloc.add(GetTranslatedQuoteEvent(result));
            }
          },
          icon: const FaIcon(FontAwesomeIcons.language),
        ),
      ),
      Expanded(
        child: _buildQuoteActionButton(
          onPressed: _shareQuote,
          icon: const FaIcon(FontAwesomeIcons.shareNodes),
        ),
      ),
    ];

    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.all(0),
      elevation: 12,
      child: Column(
        children: [
          Expanded(child: screenshotEnabledQuote),
          Row(children: actionButtons),
        ],
      ),
    );
  }

  Widget _buildQuoteActionButton({
    required VoidCallback onPressed,
    required Widget icon,
  }) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8),
        child: icon,
      ),
    );
  }

  void _cycleBackground() {
    setState(() {
      _backgroundIndex = ++_backgroundIndex % imagesPerPage;
    });
  }

  Future<void> _shareQuote() async {
    setState(() => _isSharingQuote = true);
    final image = await _screenshotController.capture();
    setState(() => _isSharingQuote = false);
    if (image == null) return;

    final shareParams = ShareParams(
      files: [
        XFile.fromData(
          image,
          mimeType: 'image/png',
          name: 'kuwot_${DateTime.now().millisecondsSinceEpoch}.png',
        ),
      ],
    );
    await SharePlus.instance.share(shareParams);
  }
}
