import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kuwot/core/presentation/error_retry_snackbar.dart';
import 'package:kuwot/features/quote/presentation/bloc/quote_bloc.dart';

class QuoteWidget extends StatefulWidget {
  const QuoteWidget({super.key});

  @override
  State<QuoteWidget> createState() => _QuoteWidgetState();
}

class _QuoteWidgetState extends State<QuoteWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  String? _quoteBody;
  String? _quoteAuthor;

  @override
  void initState() {
    super.initState();

    // init animation
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animationController.addListener(() => setState(() {}));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuoteBloc, QuoteState>(
      listener: (context, state) {
        // animate quote loading state
        if (state is QuoteLoadingState) {
          _animationController.repeat(reverse: true);
        } else {
          _animationController.forward();
        }

        // handle error state
        if (state is QuoteErrorState) {
          ErrorRetrySnackbar.show(
            context,
            errorMessage: state.message,
            onRetry: () {
              context.read<QuoteBloc>().add(const GetQuoteEvent());
            },
          );
        }
      },
      builder: (context, state) {
        if (state is QuoteLoadedState) {
          _quoteBody = state.quote.body;
          _quoteAuthor = state.quote.author;
        }

        return Container(
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(16),
          ),
          padding: const EdgeInsets.all(16.0),
          margin: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Opacity(
                opacity: _animationController.value,
                child: SvgPicture.asset(
                  'assets/svgs/chat-quote-fill.svg',
                  height: 54,
                  colorFilter: const ColorFilter.mode(
                    Colors.white54,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Text(
                _quoteBody ?? '...',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Text(
                '- ${_quoteAuthor ?? 'Kuwot'}',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: Colors.white),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
