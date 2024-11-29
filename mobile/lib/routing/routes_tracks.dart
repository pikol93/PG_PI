import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:pi_mobile/data/permissions/battery_permissions_provider.dart";
import "package:pi_mobile/data/permissions/location_permissions_provider.dart";
import "package:pi_mobile/data/permissions/notification_permissions_provider.dart";
import "package:pi_mobile/data/permissions/overlays_permissions_provider.dart";
import "package:pi_mobile/utility/location_permission.dart";
import "package:pi_mobile/utility/notification_permission.dart";
import "package:pi_mobile/widgets/tracks/permissions/request_battery_permission_screen.dart";
import "package:pi_mobile/widgets/tracks/permissions/request_location_permission_screen.dart";
import "package:pi_mobile/widgets/tracks/permissions/request_notification_permission_screen.dart";
import "package:pi_mobile/widgets/tracks/permissions/request_overlays_permission_screen.dart";
import "package:pi_mobile/widgets/tracks/record_track_screen.dart";
import "package:pi_mobile/widgets/tracks/track_details_screen.dart";
import "package:pi_mobile/widgets/tracks/tracks_screen.dart";

part "routes_tracks.g.dart";

@TypedGoRoute<TracksRoute>(
  path: "/tracks",
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<TrackDetailsRoute>(path: "details/:trackId"),
    TypedGoRoute<RecordTrackRoute>(path: "record"),
    TypedGoRoute<RequestLocationPermissionRoute>(
      path: "request_permission_location",
    ),
    TypedGoRoute<RequestNotificationPermissionRoute>(
      path: "request_permission_notification",
    ),
    TypedGoRoute<RequestOverlaysPermissionRoute>(
      path: "request_permission_overlays",
    ),
    TypedGoRoute<RequestBatteryPermissionRoute>(
      path: "request_permission_battery",
    ),
  ],
)
class TracksRoute extends GoRouteData {
  const TracksRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const TracksScreen();
}

class TrackDetailsRoute extends GoRouteData {
  final int trackId;

  const TrackDetailsRoute({required this.trackId});

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      TrackDetailsScreen(
        trackId: trackId,
      );
}

class RecordTrackRoute extends GoRouteData {
  const RecordTrackRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) async {
    final providerContainer = ProviderScope.containerOf(context);

    final locationPermission =
        await providerContainer.read(locationPermissionsProvider.future);
    if (locationPermission.isFailure) {
      return const RequestLocationPermissionRoute().location;
    }

    final notificationPermission =
        await providerContainer.read(notificationPermissionsProvider.future);
    if (notificationPermission.isFailure) {
      return const RequestNotificationPermissionRoute().location;
    }

    final overlaysPermission =
        await providerContainer.read(overlaysPermissionsProvider.future);
    if (!overlaysPermission) {
      return const RequestOverlaysPermissionRoute().location;
    }

    final batteryPermission =
        await providerContainer.read(batteryPermissionsProvider.future);
    if (!batteryPermission) {
      return const RequestBatteryPermissionRoute().location;
    }

    return null;
  }

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      const RecordTrackScreen();
}

class RequestLocationPermissionRoute extends GoRouteData {
  const RequestLocationPermissionRoute();

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      const RequestLocationPermissionScreen();
}

class RequestNotificationPermissionRoute extends GoRouteData {
  const RequestNotificationPermissionRoute();

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      const RequestNotificationPermissionScreen();
}

class RequestOverlaysPermissionRoute extends GoRouteData {
  const RequestOverlaysPermissionRoute();

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      const RequestOverlaysPermissionScreen();
}

class RequestBatteryPermissionRoute extends GoRouteData {
  const RequestBatteryPermissionRoute();

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      const RequestBatteryPermissionScreen();
}
