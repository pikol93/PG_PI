import "dart:async";

import "package:flutter/material.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:go_router/go_router.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/battery_permissions_provider.dart";
import "package:pi_mobile/provider/location_permissions_provider.dart";
import "package:pi_mobile/provider/notification_permissions_provider.dart";
import "package:pi_mobile/provider/overlays_permissions_provider.dart";
import "package:pi_mobile/utility/location_permission.dart";
import "package:pi_mobile/utility/notification_permission.dart";
import "package:pi_mobile/widgets/exercises/exercises_screen.dart";
import "package:pi_mobile/widgets/exercises/routines/edit/edit_exercise_schema_screen.dart";
import "package:pi_mobile/widgets/exercises/routines/edit/edit_exercise_set_schema_screen.dart";
import "package:pi_mobile/widgets/exercises/routines/edit/edit_routine_schema_screen.dart";
import "package:pi_mobile/widgets/exercises/routines/edit/edit_workout_schema_screen.dart";
import "package:pi_mobile/widgets/exercises/routines/routine_schema_screen.dart";
import "package:pi_mobile/widgets/exercises/routines/routines_screen.dart";
import "package:pi_mobile/widgets/exercises/session/history_screen.dart";
import "package:pi_mobile/widgets/heart_rate/heart_rate_screen.dart";
import "package:pi_mobile/widgets/heart_rate/modify_heart_rate_screen.dart";
import "package:pi_mobile/widgets/home/home_screen.dart";
import "package:pi_mobile/widgets/settings/settings_screen.dart";
import "package:pi_mobile/widgets/tracks/record_track_screen.dart";
import "package:pi_mobile/widgets/tracks/request_battery_permission_screen.dart";
import "package:pi_mobile/widgets/tracks/request_location_permission_screen.dart";
import "package:pi_mobile/widgets/tracks/request_notification_permission_screen.dart";
import "package:pi_mobile/widgets/tracks/request_overlays_permission_screen.dart";
import "package:pi_mobile/widgets/tracks/track_details_screen.dart";
import "package:pi_mobile/widgets/tracks/tracks_screen.dart";

part "routes.g.dart";

@TypedGoRoute<SplashRoute>(path: "/")
class SplashRoute extends GoRouteData {
  const SplashRoute();

  @override
  FutureOr<String?> redirect(BuildContext context, GoRouterState state) =>
      const HomeRoute().location;
}

@TypedGoRoute<HomeRoute>(path: "/home")
class HomeRoute extends GoRouteData with Logger {
  const HomeRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("home route");
    return const HomeScreen();
  }
}

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
class TracksRoute extends GoRouteData with Logger {
  const TracksRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("tracks route");
    return const TracksScreen();
  }
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

@TypedGoRoute<ExercisesRoute>(
  path: "/exercises",
  routes: <TypedGoRoute<GoRouteData>>[
    TypedGoRoute<HistoryRoute>(path: "history"),
    TypedGoRoute<RoutinesRoute>(
      path: "routines",
      routes: <TypedGoRoute<GoRouteData>>[
        TypedGoRoute<EditRoutineSchemaRoute>(
          path: "edit/:routineUuid",
          routes: <TypedGoRoute<GoRouteData>>[
            TypedGoRoute<EditWorkoutSchemaRoute>(
              path: ":workoutUuid",
              routes: <TypedGoRoute<GoRouteData>>[
                TypedGoRoute<EditExerciseSchemaRoute>(
                  path: ":exerciseUuid",
                  routes: <TypedGoRoute<GoRouteData>>[
                    TypedGoRoute<EditExerciseSetSchemaRoute>(
                      path: "exerciseSetUuid",
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        TypedGoRoute<OpenRoutineSchemaRoute>(path: ":routineUuid"),
      ],
    ),
  ],
)
class ExercisesRoute extends GoRouteData with Logger {
  const ExercisesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("exercises route");
    return const ExercisesScreen();
  }
}

class HistoryRoute extends GoRouteData with Logger {
  const HistoryRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("history route");
    return const HistoryScreen();
  }
}

class RoutinesRoute extends GoRouteData with Logger {
  const RoutinesRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("routines route");
    return const RoutinesScreen();
  }
}

class EditRoutineSchemaRoute extends GoRouteData with Logger {
  const EditRoutineSchemaRoute({required this.routineUuid});

  final String routineUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("routines route");
    return EditRoutineSchemaScreen(routineUuid: routineUuid);
  }
}

class EditWorkoutSchemaRoute extends GoRouteData with Logger {
  const EditWorkoutSchemaRoute({
    required this.routineUuid,
    required this.workoutUuid,
  });

  final String routineUuid;
  final String workoutUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("workouts route");
    return EditWorkoutSchemaScreen(
      routineUuid: routineUuid,
      workoutUuid: workoutUuid,
    );
  }
}

class OpenRoutineSchemaRoute extends GoRouteData with Logger {
  const OpenRoutineSchemaRoute({required this.routineUuid});

  final String routineUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("execute routines route");
    return RoutineSchemaScreen(routineUuid: routineUuid);
  }
}

class EditExerciseSchemaRoute extends GoRouteData with Logger {
  const EditExerciseSchemaRoute({
    required this.routineUuid,
    required this.workoutUuid,
    required this.exerciseUuid,
  });

  final String routineUuid;
  final String workoutUuid;
  final String exerciseUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("workouts route");
    return EditExerciseSchemaScreen(
      routineUuid: routineUuid,
      workoutUuid: workoutUuid,
      exerciseUuid: exerciseUuid,
    );
  }
}

class EditExerciseSetSchemaRoute extends GoRouteData with Logger {
  const EditExerciseSetSchemaRoute({
    required this.routineUuid,
    required this.workoutUuid,
    required this.exerciseUuid,
    required this.exerciseSetUuid,
  });

  final String routineUuid;
  final String workoutUuid;
  final String exerciseUuid;
  final String exerciseSetUuid;

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("workouts route");
    return EditExerciseSetSchemaScreen(
      routineUuid: routineUuid,
      workoutUuid: workoutUuid,
      exerciseUuid: exerciseUuid,
      exerciseSetUuid: exerciseSetUuid,
    );
  }
}

@TypedGoRoute<HeartRateRoute>(
  path: "/heart_rate",
  routes: <TypedGoRoute>[
    TypedGoRoute<AddHeartRateRoute>(path: "add"),
    TypedGoRoute<ModifyHeartRateRoute>(path: "modify/:entryId"),
  ],
)
class HeartRateRoute extends GoRouteData {
  const HeartRateRoute();

  @override
  Widget build(
    BuildContext context,
    GoRouterState state,
  ) =>
      const HeartRateScreen();
}

class AddHeartRateRoute extends GoRouteData {
  const AddHeartRateRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ModifyHeartRateScreen();
}

class ModifyHeartRateRoute extends GoRouteData {
  final int entryId;

  const ModifyHeartRateRoute({
    required this.entryId,
  });

  @override
  Widget build(BuildContext context, GoRouterState state) =>
      ModifyHeartRateScreen(
        entryId: entryId,
      );
}

@TypedGoRoute<SettingsRoute>(path: "/settings")
class SettingsRoute extends GoRouteData with Logger {
  const SettingsRoute();

  @override
  Widget build(BuildContext context, GoRouterState state) {
    logger.debug("settings route");
    return const SettingsScreen();
  }
}
