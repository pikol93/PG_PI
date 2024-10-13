import "dart:io";

import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "overlays_permissions_provider.g.dart";

@riverpod
class OverlaysPermissions extends _$OverlaysPermissions with Logger {
  @override
  Future<bool> build() async {
    if (Platform.isAndroid) {
      // TODO: iOS does not require overlays permission. This is not an
      //  equivalent to acquiring such permission. Handle this case.
      return true;
    }

    final overlaysPermission = await FlutterForegroundTask.canDrawOverlays;
    logger.debug("Overlays permission: $overlaysPermission");

    return overlaysPermission;
  }

  Future<void> request() async {
    final overlaysPermission = await FlutterForegroundTask.canDrawOverlays;
    logger.debug(
      "Overlays permission after "
      "requesting: $overlaysPermission",
    );

    ref.invalidateSelf();
  }
}
