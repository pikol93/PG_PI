import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/notification_permissions_provider.dart";
import "package:pi_mobile/routing/routes.dart";
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
                  title: const Text("Request permissions"), // TODO: I18N
                ),
                body: Center(
                  child: Column(
                    children: [
                      const Text(
                        "In order to record your tracks, you need to allow the "
                        "application to create a notification",
                      ), // TODO: I18N
                      TextButton(
                        onPressed: () => _onAllowPressed(ref),
                        child: const Text("Allow"), // TODO: I18N
                      ),
                    ],
                  ),
                ),
              );
            },
            error: (a, b) => const Center(
              child: Text("Could not get permissions."),
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
