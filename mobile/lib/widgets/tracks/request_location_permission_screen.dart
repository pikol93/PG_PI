import "package:awesome_flutter_extensions/awesome_flutter_extensions.dart";
import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/location_permissions_provider.dart";
import "package:pi_mobile/routing/routes_tracks.dart";
import "package:pi_mobile/utility/location_permission.dart";

class RequestLocationPermissionScreen extends ConsumerWidget with Logger {
  const RequestLocationPermissionScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) =>
      ref.watch(locationPermissionsProvider).when(
            data: (locationPermissions) {
              if (locationPermissions.isSuccess) {
                logger.debug("Acquired location permissions. Routing.");
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
                        "application to access your precise location.",
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
    ref.read(locationPermissionsProvider.notifier).request();
  }
}
