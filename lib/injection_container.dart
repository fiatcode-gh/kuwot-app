import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kuwot/core/app_updater.dart';
import 'package:kuwot/core/data/local/config.dart';
import 'package:kuwot/core/data/local/theme_mode_config.dart';
import 'package:kuwot/core/env.dart';
import 'package:kuwot/core/presentation/bloc/config/theme_mode_cubit.dart';
import 'package:kuwot/core/time.dart';
import 'package:kuwot/features/in_app_purchase/data/data_sources/remote/in_app_purchase_remote_data_source.dart';
import 'package:kuwot/features/in_app_purchase/data/repositories/in_app_purchase_repository_impl.dart';
import 'package:kuwot/features/in_app_purchase/domain/repositories/in_app_purchase_repository.dart';
import 'package:kuwot/features/in_app_purchase/domain/use_case/get_consumable_products.dart';
import 'package:kuwot/features/in_app_purchase/domain/use_case/listen_purchase.dart';
import 'package:kuwot/features/in_app_purchase/domain/use_case/purchase_consumable_product.dart';
import 'package:kuwot/features/in_app_purchase/presentation/bloc/in_app_purchase_bloc.dart';
import 'package:kuwot/features/in_app_purchase/presentation/bloc/purchase_details_cubit.dart';
import 'package:kuwot/features/in_app_update/presentation/bloc/in_app_update_bloc.dart';
import 'package:kuwot/features/quote/data/data_sources/local/quote_local_data_source.dart';
import 'package:kuwot/features/quote/data/repositories/quote_repository_impl.dart';
import 'package:kuwot/features/quote/domain/repositories/quote_repository.dart';
import 'package:kuwot/features/quote/domain/services/background_generator.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_quote.dart';
import 'package:kuwot/features/quote/presentation/bloc/background_bloc.dart';
import 'package:kuwot/features/quote/presentation/bloc/quote_bloc.dart';
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

  // data sources
  getIt.registerLazySingleton<QuoteLocalDataSource>(
    () => QuoteLocalDataSourceImpl(),
  );
  getIt.registerLazySingleton<InAppPurchaseRemoteDataSource>(
    () => InAppPurchaseRemoteDataSourceImpl(iap: getIt()),
  );

  // repositories
  getIt.registerLazySingleton<QuoteRepository>(
    () => QuoteRepositoryImpl(localDataSource: getIt()),
  );
  getIt.registerLazySingleton<InAppPurchaseRepository>(
    () => InAppPurchaseRepositoryImpl(inAppPurchaseDataSource: getIt()),
  );

  // use cases
  getIt.registerLazySingleton<GetQuote>(() => GetQuote(getIt()));
  getIt.registerLazySingleton<BackgroundGenerator>(
    () => const BackgroundGenerator(),
  );
  getIt.registerLazySingleton<GetConsumableProducts>(
    () => GetConsumableProducts(getIt()),
  );
  getIt.registerLazySingleton<PurchaseConsumableProduct>(
    () => PurchaseConsumableProduct(getIt()),
  );
  getIt.registerLazySingleton<ListenPurchase>(() => ListenPurchase(getIt()));

  // blocs
  getIt.registerSingletonAsync<ThemeModeCubit>(() async {
    final initialThemeMode = await getIt<Config<ThemeMode>>().get();
    return ThemeModeCubit(
      themeModeConfig: getIt(),
      initialThemeMode: initialThemeMode ?? ThemeMode.system,
    );
  }, dependsOn: [SharedPreferences, Config<ThemeMode>]);
  getIt.registerLazySingleton<InAppUpdateBloc>(
    () => InAppUpdateBloc(appUpdater: getIt()),
  );
  getIt.registerLazySingleton<InAppPurchaseBloc>(
    () => InAppPurchaseBloc(
      getConsumableProducts: getIt(),
      purchaseConsumableProduct: getIt(),
    ),
  );
  getIt.registerLazySingleton<PurchaseDetailsCubit>(
    () => PurchaseDetailsCubit(getIt()),
  );
  getIt.registerFactory<QuoteBloc>(() => QuoteBloc(getQuote: getIt()));
  getIt.registerFactory<BackgroundBloc>(
    () => BackgroundBloc(generator: getIt()),
  );

  // others
  getIt.registerLazySingleton<AppUpdater>(() => AppUpdaterImpl());
  getIt.registerLazySingleton<Time>(() => TimeImpl());
  getIt.registerLazySingleton<InAppPurchase>(() => InAppPurchase.instance);
  getIt.registerLazySingleton<GlobalKey<ScaffoldMessengerState>>(
    () => GlobalKey<ScaffoldMessengerState>(),
  );
}

MultiBlocProvider getMultiBlocProvider({required Widget child}) {
  return MultiBlocProvider(
    providers: [
      BlocProvider<ThemeModeCubit>(create: (context) => getIt()),
      BlocProvider<InAppUpdateBloc>(create: (context) => getIt()),
      BlocProvider<InAppPurchaseBloc>(create: (context) => getIt()),
      BlocProvider<PurchaseDetailsCubit>(create: (context) => getIt()),
      BlocProvider<QuoteBloc>(create: (context) => getIt()),
      BlocProvider<BackgroundBloc>(create: (context) => getIt()),
    ],
    child: child,
  );
}
