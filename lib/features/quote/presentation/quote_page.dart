import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kuwot/core/presentation/error_retry_snackbar.dart';
import 'package:kuwot/core/presentation/theme/app_palette.dart';
import 'package:kuwot/core/router/app_router.gr.dart';
import 'package:kuwot/features/quote/domain/entities/tear_kind.dart';
import 'package:kuwot/features/quote/presentation/bloc/pad_bloc.dart';
import 'package:kuwot/features/quote/presentation/widgets/calendar_pad.dart';
import 'package:kuwot/features/quote/presentation/widgets/control_dock.dart';
import 'package:kuwot/features/quote/presentation/widgets/pad_top_bar.dart';

@RoutePage()
class QuotePage extends StatefulWidget {
  const QuotePage({super.key});

  @override
  State<QuotePage> createState() => _QuotePageState();
}

class _QuotePageState extends State<QuotePage> {
  final _padKey = GlobalKey<CalendarPadState>();
  late final PadBloc _bloc;
  late final AppLifecycleListener _lifecycle;

  @override
  void initState() {
    super.initState();
    _bloc = context.read<PadBloc>()..add(const PadStarted());
    _lifecycle = AppLifecycleListener(
      onResume: () => _bloc.add(const PadDayChecked()),
    );
  }

  @override
  void dispose() {
    _lifecycle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final palette = AppPalette.of(context);
    final brightness = Theme.of(context).brightness;
    final isTablet = MediaQuery.sizeOf(context).shortestSide >= 600;
    final maxWidth = isTablet ? 560.0 : 420.0;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: brightness == Brightness.dark
          ? SystemUiOverlayStyle.light
          : SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: palette.desk,
        body: SafeArea(
          child: Column(
            children: [
              PadTopBar(
                onTipJar: () => context.router.push(const DonationRoute()),
                onSettings: () => context.router.push(const AppSettingsRoute()),
              ),
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxWidth: maxWidth,
                      maxHeight: isTablet ? maxWidth / 0.58 : double.infinity,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                      child: BlocConsumer<PadBloc, PadState>(
                        listener: (context, state) {
                          if (state is PadFailed) {
                            ErrorRetrySnackbar.show(
                              context,
                              errorMessage: state.message,
                              onRetry: () => _bloc.add(const PadStarted()),
                            );
                          }
                        },
                        builder: (context, state) {
                          if (state is PadReady) {
                            return CalendarPad(
                              key: _padKey,
                              top: state.top,
                              under: state.under,
                              tearKind: state.tearKind,
                              revision: state.revision,
                              onTornAway: () =>
                                  _bloc.add(PadTearCommitted(state.revision)),
                            );
                          }
                          return PadFrame(
                            page: ColoredBox(color: palette.paper),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: maxWidth),
                child: BlocBuilder<PadBloc, PadState>(
                  builder: (context, state) {
                    final ready = state is PadReady ? state : null;
                    return ControlDock(
                      tearKind: ready?.tearKind,
                      onTear: ready == null
                          ? null
                          : () => _padKey.currentState?.tearAway(),
                      onRestyle: ready?.tearKind == TearKind.quote
                          ? () => _bloc.add(const PadRestyled())
                          : null,
                      onShare: null,
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
