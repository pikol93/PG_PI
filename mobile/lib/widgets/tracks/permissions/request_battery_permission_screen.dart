import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/permissions/battery_permissions_provider.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/routing/routes_tracks.dart";

class RequestBatteryPermissionScreen extends ConsumerWidget with Logger {
  const RequestBatteryPermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(batteryPermissionsProvider).when(
            data: (batteryPermissions) {
              if (batteryPermissions) {
                logger.debug("Acquired battery permissions. Routing.");
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
                      Text(context.t.tracks.permissions.battery),
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
    logger.debug("Allow pressed for request battery screen.");
    ref.read(batteryPermissionsProvider.notifier).request();
  }
}