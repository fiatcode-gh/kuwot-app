import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kuwot/core/app_updater.dart';
import 'package:kuwot/core/data/local/config.dart';
import 'package:kuwot/core/data/local/theme_mode_config.dart';
import 'package:kuwot/core/data/local/translation_target_config.dart';
import 'package:kuwot/core/env.dart';
import 'package:kuwot/core/network/network.dart';
import 'package:kuwot/core/presentation/bloc/config/theme_mode_cubit.dart';
import 'package:kuwot/core/presentation/bloc/config/translation_target_cubit.dart';
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
import 'package:kuwot/features/quote/data/data_sources/remote/kuwot_api_remote_data_source.dart';
import 'package:kuwot/features/quote/data/repositories/quote_repository_impl.dart';
import 'package:kuwot/features/quote/domain/repositories/quote_repository.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_background_images.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_quote.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_translated_quote.dart';
import 'package:kuwot/features/quote/domain/use_cases/get_translations.dart';
import 'package:kuwot/features/quote/presentation/bloc/background_images_bloc.dart';
import 'package:kuwot/features/quote/presentation/bloc/quote_bloc.dart';
import 'package:kuwot/features/quote/presentation/bloc/translations_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

final getIt = GetIt.instance;

void setup() {
  // network
  getIt.registerLazySingleton<Network>(() => NetworkImpl());

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
  getIt.registerSingletonWithDependencies<Config<TranslationTarget>>(
    () => TranslationTargetConfig(sharedPreferences: getIt()),
    dependsOn: [SharedPreferences],
  );

  // data sources
  getIt.registerLazySingleton<KuwotApiRemoteDataSource>(
    () => KuwotApiRemoteApiImpl(env: getIt(), network: getIt()),
  );
  getIt.registerLazySingleton<InAppPurchaseRemoteDataSource>(
    () => InAppPurchaseRemoteDataSourceImpl(iap: getIt()),
  );

  // repositories
  getIt.registerLazySingleton<QuoteRepository>(
    () => QuoteRepositoryImpl(quoteDataSource: getIt()),
  );
  getIt.registerLazySingleton<InAppPurchaseRepository>(
    () => InAppPurchaseRepositoryImpl(inAppPurchaseDataSource: getIt()),
  );

  // use cases
  getIt.registerLazySingleton<GetQuote>(() => GetQuote(getIt()));
  getIt.registerLazySingleton<GetTranslatedQuote>(
    () => GetTranslatedQuote(getIt()),
  );
  getIt.registerLazySingleton<GetBackgroundImages>(
    () => GetBackgroundImages(getIt()),
  );
  getIt.registerLazySingleton<GetTranslations>(() => GetTranslations(getIt()));
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
  getIt.registerSingletonAsync<TranslationTargetCubit>(() async {
    final initialTranslationTarget = await getIt<Config<TranslationTarget>>()
        .get();
    return TranslationTargetCubit(
      translationTargetConfig: getIt(),
      initialTranslationTarget:
          initialTranslationTarget ?? defaultTranslationTarget,
    );
  }, dependsOn: [SharedPreferences, Config<TranslationTarget>]);
  getIt.registerFactory<QuoteBloc>(
    () => QuoteBloc(
      getQuote: getIt(),
      getTranslatedQuote: getIt(),
      translationTargetConfig: getIt(),
    ),
  );
  getIt.registerFactory<BackgroundImagesBloc>(
    () => BackgroundImagesBloc(getBackgroundImages: getIt()),
  );
  getIt.registerFactory<TranslationsBloc>(
    () => TranslationsBloc(getTranslations: getIt()),
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
      BlocProvider<TranslationTargetCubit>(create: (context) => getIt()),
      BlocProvider<QuoteBloc>(create: (context) => getIt()),
      BlocProvider<BackgroundImagesBloc>(create: (context) => getIt()),
      BlocProvider<TranslationsBloc>(create: (context) => getIt()),
    ],
    child: child,
  );
}
