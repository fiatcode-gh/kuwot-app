import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:kuwot/core/router/app_router.gr.dart';
import 'package:kuwot/features/quote/presentation/bloc/background_bloc.dart';
import 'package:kuwot/features/quote/presentation/bloc/quote_bloc.dart';
import 'package:kuwot/features/quote/presentation/widgets/background_widget.dart';
import 'package:kuwot/features/quote/presentation/widgets/quote_widget.dart';
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

  late QuoteBloc _dailyQuoteBloc;
  late BackgroundBloc _backgroundBloc;

  // The background is decoupled from the quote: it is seeded once from the
  // first loaded quote (so each launch varies), then only the background
  // button changes it. Getting a new quote leaves the background untouched.
  bool _backgroundSeeded = false;

  @override
  void initState() {
    super.initState();

    _dailyQuoteBloc = context.read<QuoteBloc>();
    _backgroundBloc = context.read<BackgroundBloc>();

    _dailyQuoteBloc.add(const GetQuoteEvent());
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
          BlocListener<QuoteBloc, QuoteState>(
            listenWhen: (_, s) => s is QuoteLoadedState && !_backgroundSeeded,
            listener: (context, s) {
              if (s is QuoteLoadedState) {
                _backgroundSeeded = true;
                _backgroundBloc.add(SetQuoteBackground(s.quote.id));
              }
            },
            child: const BackgroundWidget(),
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
    _backgroundBloc.add(const CycleBackground());
  }

  Future<void> _shareQuote() async {
    final image = await _screenshotController.capture();
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
