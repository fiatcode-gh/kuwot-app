import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kuwot/core/presentation/error_retry_snackbar.dart';
import 'package:kuwot/features/quote/presentation/bloc/quote_bloc.dart';

class QuoteWidget extends StatelessWidget {
  const QuoteWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<QuoteBloc, QuoteState>(
      // Surface fetch errors with a retry action.
      listenWhen: (_, state) => state is QuoteErrorState,
      listener: (context, state) {
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
      // Only repaint when a new quote is loaded, so the previous quote stays on
      // screen during the (offline, near-instant) loading frame — no flicker.
      buildWhen: (_, state) => state is QuoteLoadedState,
      builder: (context, state) {
        final quote = state is QuoteLoadedState ? state.quote : null;

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
              SvgPicture.asset(
                'assets/svgs/chat-quote-fill.svg',
                height: 54,
                colorFilter: const ColorFilter.mode(
                  Colors.white54,
                  BlendMode.srcIn,
                ),
              ),
              const SizedBox(height: 30),
              Text(
                quote?.body ?? '...',
                style: Theme.of(
                  context,
                ).textTheme.headlineSmall?.copyWith(color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              Text(
                '- ${quote?.author ?? 'Kuwot'}',
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
}
