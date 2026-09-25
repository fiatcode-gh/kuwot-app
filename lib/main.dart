import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:kuwot/core/env.dart';
import 'package:kuwot/core/presentation/bloc/app_bloc_observer.dart';
import 'package:kuwot/core/presentation/bloc/config/theme_mode_cubit.dart';
import 'package:kuwot/core/presentation/theme/app_theme.dart';
import 'package:kuwot/core/router/app_router.dart';
import 'package:kuwot/features/in_app_purchase/presentation/in_app_purchase_listener.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

import 'injection_container.dart' as ic;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // load date symbol data so DateFormat works in the device's own locale,
  // not just en_US
  await initializeDateFormatting();

  // dependency injection setup
  ic.setup();
  await ic.getIt.allReady();

  // register bloc observer
  Bloc.observer = AppBlocObserver();

  // error reporting to the self-hosted Bugsink (Sentry-compatible)
  final sentryDsn = EnvImpl().sentryDsn;
  if (!kDebugMode && sentryDsn.isNotEmpty) {
    await SentryFlutter.init((options) {
      options
        ..dsn = sentryDsn
        // Bugsink only stores errors; sessions would be sent and dropped.
        ..enableAutoSessionTracking = false;
    }, appRunner: () => runApp(KuwotApp()));
  } else {
    runApp(KuwotApp());
  }
}

/// Which orientations to lock to, given the current view's logical size:
/// phones (`shortestSide` < 600 dp) lock to portrait; tablets get no lock
/// (the empty list). A `Size.zero` — seen before the platform reports real
/// view metrics — never decides a lock; the next metrics change corrects it.
@visibleForTesting
List<DeviceOrientation> preferredOrientationsFor(Size logicalSize) {
  if (logicalSize.shortestSide <= 0) return const [];
  return logicalSize.shortestSide < 600
      ? const [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]
      : const [];
}

/// Applies the portrait lock once real view metrics exist, and re-applies it
/// whenever they change (rotation doesn't change the shortest side, but a
/// fold/unfold or an external display can). Deciding this before the first
/// frame (from `platformDispatcher.views.first` pre-`runApp`) risked reading
/// a `Size.zero` and wrongly locking a tablet to portrait.
class OrientationLock extends StatefulWidget {
  const OrientationLock({super.key, required this.child});

  final Widget child;

  @override
  State<OrientationLock> createState() => _OrientationLockState();
}

class _OrientationLockState extends State<OrientationLock>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    if (kIsWeb) return;
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _apply());
  }

  @override
  void dispose() {
    if (!kIsWeb) WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    _apply();
  }

  void _apply() {
    final view = WidgetsBinding.instance.platformDispatcher.views.first;
    final logicalSize = view.physicalSize / view.devicePixelRatio;
    SystemChrome.setPreferredOrientations(
      preferredOrientationsFor(logicalSize),
    );
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

class KuwotApp extends StatelessWidget {
  KuwotApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return OrientationLock(
      child: ic.getMultiBlocProvider(
        child: InAppPurchaseListener(
          child: BlocBuilder<ThemeModeCubit, ThemeMode>(
            bloc: ic.getIt(),
            builder: (context, state) {
              return MaterialApp.router(
                scaffoldMessengerKey: ic.getIt(),
                debugShowCheckedModeBanner: false,
                title: 'Kuwot',
                theme: lightTheme,
                darkTheme: darkTheme,
                themeMode: state,
                routerConfig: _appRouter.config(),
              );
            },
          ),
        ),
      ),
    );
  }
}
