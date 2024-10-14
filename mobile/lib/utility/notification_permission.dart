import "package:flutter_foreground_task/models/notification_permission.dart";

extension NotificationPermissionExtension on NotificationPermission {
  bool get isSuccess => this == NotificationPermission.granted;

  bool get isFailure => !isSuccess;
}
