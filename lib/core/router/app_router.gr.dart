// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes

import 'package:auto_route/auto_route.dart' as _i4;
import 'package:kuwot/features/app_settings/presentation/app_settings_page.dart'
    as _i1;
import 'package:kuwot/features/in_app_update/presentation/app_update_page.dart'
    as _i2;
import 'package:kuwot/features/quote/presentation/quote_page.dart' as _i3;

/// generated route for
/// [_i1.AppSettingsPage]
class AppSettingsRoute extends _i4.PageRouteInfo<void> {
  const AppSettingsRoute({List<_i4.PageRouteInfo>? children})
    : super(AppSettingsRoute.name, initialChildren: children);

  static const String name = 'AppSettingsRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i1.AppSettingsPage();
    },
  );
}

/// generated route for
/// [_i2.AppUpdatePage]
class AppUpdateRoute extends _i4.PageRouteInfo<void> {
  const AppUpdateRoute({List<_i4.PageRouteInfo>? children})
    : super(AppUpdateRoute.name, initialChildren: children);

  static const String name = 'AppUpdateRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i2.AppUpdatePage();
    },
  );
}

/// generated route for
/// [_i3.QuotePage]
class QuoteRoute extends _i4.PageRouteInfo<void> {
  const QuoteRoute({List<_i4.PageRouteInfo>? children})
    : super(QuoteRoute.name, initialChildren: children);

  static const String name = 'QuoteRoute';

  static _i4.PageInfo page = _i4.PageInfo(
    name,
    builder: (data) {
      return const _i3.QuotePage();
    },
  );
}
