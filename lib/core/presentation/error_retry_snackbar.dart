import 'package:flutter/material.dart';

class ErrorRetrySnackbar {
  final BuildContext context;
  final String errorMessage;
  final VoidCallback onRetry;

  const ErrorRetrySnackbar(
    this.context, {
    required this.errorMessage,
    required this.onRetry,
  });

  SnackBar _build() {
    return SnackBar(
      behavior: SnackBarBehavior.floating,
      duration: const Duration(days: 1),
      backgroundColor: Colors.red[600],
      content: Text(errorMessage),
      action: SnackBarAction(
        textColor: Colors.white,
        label: 'RETRY',
        onPressed: () {
          onRetry();
          ScaffoldMessenger.of(context).hideCurrentSnackBar();
        },
      ),
    );
  }

  static void show(
    BuildContext context, {
    required String errorMessage,
    required VoidCallback onRetry,
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      ErrorRetrySnackbar(
        context,
        errorMessage: errorMessage,
        onRetry: onRetry,
      )._build(),
    );
  }
}
