import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/notification_permissions_provider.dart";
import "package:pi_mobile/routing/routes_tracks.dart";
import "package:pi_mobile/utility/notification_permission.dart";

class RequestNotificationPermissionScreen extends ConsumerWidget with Logger {
  const RequestNotificationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(notificationPermissionsProvider).when(
            data: (notificationPermissions) {
              if (notificationPermissions.isSuccess) {
                logger.debug("Acquired notification permissions. Routing.");
                const RecordTrackRoute().go(context);
              }

              return Scaffold(
                appBar: AppBar(
                  backgroundColor: context.colors.scaffoldBackground,
                  title: Text(context.t.tracks.permissions.request),
                ),
                body: Center(
                  child: Column(
                    children: [
                      Text(context.t.tracks.permissions.notification),
                      TextButton(
                        onPressed: () => _onAllowPressed(ref),
                        child: Text(context.t.tracks.permissions.allow),
                      ),
                    ],
                  ),
                ),
              );
            },
            error: (a, b) => Center(
              child: Text(context.t.tracks.permissions.couldNotGetPermissions),
            ),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
          );

  void _onAllowPressed(WidgetRef ref) {
    logger.debug("Allow pressed for request location screen.");
    ref.read(notificationPermissionsProvider.notifier).request();
  }
}
