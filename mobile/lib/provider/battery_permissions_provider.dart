import "dart:io";

import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "battery_permissions_provider.g.dart";

@riverpod
class BatteryPermissions extends _$BatteryPermissions with Logger {
  @override
  Future<bool> build() async {
    if (Platform.isAndroid) {
      // TODO: iOS does not require overlays permission. This is not an
      //  equivalent to acquiring such permission. Handle this case.
      return true;
    }

    final batteryPermission =
        await FlutterForegroundTask.isIgnoringBatteryOptimizations;
    logger.debug("Battery permission: $batteryPermission");

    return batteryPermission;
  }

  Future<void> request() async {
    final batteryPermission =
        await FlutterForegroundTask.requestIgnoreBatteryOptimization();
    logger.debug("Battery permission after requesting: $batteryPermission");

    ref.invalidateSelf();
  }
}
