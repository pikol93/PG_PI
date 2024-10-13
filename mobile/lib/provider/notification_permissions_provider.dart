import "package:flutter_foreground_task/flutter_foreground_task.dart";
import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "notification_permissions_provider.g.dart";

@riverpod
class NotificationPermissions extends _$NotificationPermissions with Logger {
  @override
  Future<NotificationPermission> build() async {
    final notificationPermission =
        await FlutterForegroundTask.checkNotificationPermission();
    logger.debug("Notification permission: $notificationPermission");

    return notificationPermission;
  }

  Future<void> request() async {
    final notificationPermission =
        await FlutterForegroundTask.requestNotificationPermission();
    logger.debug(
      "Notification permission after "
      "requesting: $notificationPermission",
    );

    ref.invalidateSelf();
  }
}
