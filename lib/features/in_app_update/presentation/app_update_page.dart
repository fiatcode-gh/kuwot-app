import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:kuwot/core/router/app_router.gr.dart';
import 'package:kuwot/features/in_app_update/presentation/bloc/in_app_update_bloc.dart';

@RoutePage()
class AppUpdatePage extends StatefulWidget {
  const AppUpdatePage({super.key});

  @override
  State<AppUpdatePage> createState() => _AppUpdatePageState();
}

class _AppUpdatePageState extends State<AppUpdatePage> {
  @override
  void initState() {
    // check for update
    context.read<InAppUpdateBloc>().add(const InAppUpdateCheckEvent());

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InAppUpdateBloc, InAppUpdateState>(
      listener: (context, state) {
        if (state is InAppUpdateAvailableState) {
          context.read<InAppUpdateBloc>().add(const InAppUpdateStartEvent());
        }

        if (state is InAppUpdateUnavailableState) {
          AutoRouter.of(context).replace(const QuoteRoute());
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'assets/svgs/chat-quote.svg',
                colorFilter: ColorFilter.mode(
                  Theme.of(context).colorScheme.onSurface,
                  BlendMode.srcIn,
                ),
                height: 100,
              ),
              const SizedBox(height: 20),
              const SizedBox(width: 100, child: LinearProgressIndicator()),
            ],
          ),
        ),
      ),
    );
  }
}
