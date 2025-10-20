// ignore_for_file: public_member_api_docs

abstract class Env {
  String get quoteApiScheme;

  String get quoteApiHost;

  int? get quoteApiPort;

  String get authPublicKey;

  String get sentryDsn;
}

class EnvImpl implements Env {
  @override
  String get quoteApiScheme => const String.fromEnvironment('QUOTE_API_SCHEME');

  @override
  String get quoteApiHost => const String.fromEnvironment('QUOTE_API_HOST');

  @override
  int? get quoteApiPort =>
      int.tryParse(const String.fromEnvironment('QUOTE_API_PORT'));

  @override
  String get authPublicKey => const String.fromEnvironment('AUTH_PUBLIC_KEY');

  @override
  String get sentryDsn => const String.fromEnvironment('SENTRY_DSN');
}
