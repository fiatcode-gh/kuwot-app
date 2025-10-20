import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void showSnackbar(String message) {
  final scaffoldMessenger =
      GetIt.I<GlobalKey<ScaffoldMessengerState>>().currentState;
  scaffoldMessenger?.showSnackBar(SnackBar(content: Text(message)));
}

Color getColorFromHexString(String hexString) {
  if (hexString.startsWith('#')) {
    hexString = hexString.substring(1);
  }

  if (hexString.length == 6) {
    hexString = 'FF$hexString';
  }

  return Color(int.parse(hexString, radix: 16) | 0xFF000000);
}
