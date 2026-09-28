import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:kuwot/core/app_updater.dart';
import 'package:kuwot/core/data/local/config.dart';
import 'package:kuwot/core/data/local/theme_mode_config.dart';
import 'package:kuwot/core/env.dart';
import 'package:kuwot/core/presentation/bloc/config/theme_mode_cubit.dart';
import 'package:kuwot/core/time.dart';
import 'package:kuwot/features/in_app_update/presentation/bloc/in_app_update_bloc.dart';
import 'package:kuwot/features/quote/data/data_sources/local/pad_snapshot_config.dart';
import 'package:kuwot/features/quote/data/data_sources/local/quote_groups_config.dart';
import 'package:kuwot/features/quote/data/data_sources/local/quote_local_data_source.dart';
import 'package:kuwot/features/quote/data/repositories/pad_repository_impl.dart';
import 'package:kuwot/features/quote/data/repositories/quote_repository_impl.dart';
import 'package:kuwot/features/quote/domain/entities/pad_snapshot.dart';
import 'package:kuwot/features/quote/domain/entities/quote_group.dart';
import 'package:kuwot/features/quote/domain/repositories/pad_repository.dart';
import 'package:kuwot/features/quote/domain/repositories/quote_repository.dart';
import 'package:kuwot/features/quote/domain/services/background_generator.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_quote.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_quote_by_id.dart';
import 'package:kuwot/features/quote/domain/use_cases/load_pad_snapshot.dart';
import 'package:kuwot/features/quote/domain/use_cases/save_pad_snapshot.dart';
import 'package:kuwot/features/quote/presentation/bloc/pad_bloc.dart';
import 'package:kuwot/features/quote/presentation/bloc/quote_groups_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

void setup() {
  // shared preferences
  getIt.registerSingletonAsync<SharedPreferences>(() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  });

  // env
  getIt.registerLazySingleton<Env>(() => EnvImpl());

  // configs
  getIt.registerSingletonWithDependencies<Config<ThemeMode>>(
    () => ThemeModeConfig(sharedPreferences: getIt()),
    dependsOn: [SharedPreferences],
  );
  getIt.registerSingletonWithDependencies<Config<PadSnapshot>>(
    () => PadSnapshotConfig(sharedPreferences: getIt()),
    dependsOn: [SharedPreferences],
  );
  getIt.registerSingletonWithDependencies<Config<Set<QuoteGroup>>>(
    () => QuoteGroupsConfig(sharedPreferences: getIt()),
    dependsOn: [SharedPreferences],
  );

  // data sources
  getIt.registerLazySingleton<QuoteLocalDataSource>(
    () => QuoteLocalDataSourceImpl(),
  );

  // repositories
  getIt.registerLazySingleton<QuoteRepository>(
    () => QuoteRepositoryImpl(localDataSource: getIt()),
  );
  getIt.registerLazySingleton<PadRepository>(
    () => PadRepositoryImpl(config: getIt()),
  );

  // use cases
  getIt.registerLazySingleton<GetQuote>(() => GetQuote(getIt()));
  getIt.registerLazySingleton<GetQuoteById>(() => GetQuoteById(getIt()));
  getIt.registerLazySingleton<LoadPadSnapshot>(() => LoadPadSnapshot(getIt()));
  getIt.registerLazySingleton<SavePadSnapshot>(() => SavePadSnapshot(getIt()));
  getIt.registerLazySingleton<BackgroundGenerator>(
    () => const BackgroundGenerator(),
  );

  // blocs
  getIt.registerSingletonAsync<ThemeModeCubit>(() async {
    final initialThemeMode = await getIt<Config<ThemeMode>>().get();
    return ThemeModeCubit(
      themeModeConfig: getIt(),
      initialThemeMode: initialThemeMode ?? ThemeMode.system,
    );
  }, dependsOn: [SharedPreferences, Config<ThemeMode>]);
  getIt.registerSingletonAsync<QuoteGroupsCubit>(() async {
    final initial = await getIt<Config<Set<QuoteGroup>>>().get();
    return QuoteGroupsCubit(
      config: getIt(),
      initialGroups: initial ?? QuoteGroup.values.toSet(),
    );
  }, dependsOn: [SharedPreferences, Config<Set<QuoteGroup>>]);
  getIt.registerLazySingleton<InAppUpdateBloc>(
    () => InAppUpdateBloc(appUpdater: getIt()),
  );
  getIt.registerFactory<PadBloc>(
    () => PadBloc(
      getQuote: getIt(),
      getQuoteById: getIt(),
      loadPadSnapshot: getIt(),
      savePadSnapshot: getIt(),
      generator: getIt(),
      time: getIt(),
      groups: getIt<QuoteGroupsCubit>().state,
    ),
  );

  // others
  getIt.registerLazySingleton<AppUpdater>(() => AppUpdaterImpl());
  getIt.registerLazySingleton<Time>(() => TimeImpl());
  getIt.registerLazySingleton<GlobalKey<ScaffoldMessengerState>>(
    () => GlobalKey<ScaffoldMessengerState>(),
  );
}

MultiBlocProvider getMultiBlocProvider({required Widget child}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<ThemeModeCubit>(create: (context) => getIt()),
      BlocProvider<QuoteGroupsCubit>(create: (context) => getIt()),
      BlocProvider<InAppUpdateBloc>(create: (context) => getIt()),
      BlocProvider<PadBloc>(create: (context) => getIt()),
    ],
    child: child,
  );
}
