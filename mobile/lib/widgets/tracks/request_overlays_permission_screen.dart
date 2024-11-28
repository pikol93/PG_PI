import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/permissions/overlays_permissions_provider.dart";
import "package:pi_mobile/i18n/strings.g.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/routing/routes_tracks.dart";

class RequestOverlaysPermissionScreen extends ConsumerWidget with Logger {
  const RequestOverlaysPermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(overlaysPermissionsProvider).when(
            data: (overlaysPermissions) {
              if (overlaysPermissions) {
                logger.debug("Acquired overlays permissions. Routing.");
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
                      Text(context.t.tracks.permissions.overlay),
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
    logger.debug("Allow pressed for request overlays screen.");
    ref.read(overlaysPermissionsProvider.notifier).request();
  }
}
