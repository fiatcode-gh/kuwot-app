import 'package:sentry_flutter/sentry_flutter.dart';

/// Report error to Sentry
void reportError({required dynamic error, StackTrace? stackTrace}) {
  if (error == null) return;

  Sentry.captureException(error, stackTrace: stackTrace);
}
