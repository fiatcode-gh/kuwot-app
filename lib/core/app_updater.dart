import 'package:in_app_update/in_app_update.dart';

/// A wrapper of in-app update plugin
abstract class AppUpdater {
  /// Check for in-app update
  Future<AppUpdateInfo> checkForUpdate();

  /// Start update process
  Future<AppUpdateResult> update();
}

class AppUpdaterImpl implements AppUpdater {
  @override
  Future<AppUpdateInfo> checkForUpdate() async {
    return InAppUpdate.checkForUpdate();
  }

  @override
  Future<AppUpdateResult> update() async {
    return InAppUpdate.performImmediateUpdate();
  }
}
