import "dart:io";

import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/data/connection/connection_settings_provider.dart";
import "package:pi_mobile/data/connection/dio_instance_provider.dart";
import "package:pi_mobile/data/connection/requests.dart";
import "package:pi_mobile/data/connection/shared_data.dart";
import "package:pi_mobile/data/exercise/exercise_models_provider.dart";
import "package:pi_mobile/data/routine/routines_provider.dart";
import "package:pi_mobile/data/session/session_service_provider.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/utility/either.dart";
import "package:pi_mobile/utility/iterable.dart";
import "package:pi_mobile/utility/map.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "sharing_service_provider.g.dart";

@riverpod
Future<SharingService> sharingService(Ref ref) async {
  final dio = await ref.watch(dioInstanceProvider.future);
  return SharingService(
    ref: ref,
    dio: dio,
  );
}

class SharingService with Logger {
  final Ref ref;
  final Dio dio;

  SharingService({
    required this.ref,
    required this.dio,
  });

  TaskEither<String, Uri> share(List<int> sessionIds) => TaskEither.tryCatch(
        () async {
          final sharedDataFuture = await prepareData(sessionIds).run();
          final sharedData = sharedDataFuture.unwrap();

          final result = await dio.post<Map<String, dynamic>>(
            "/share",
            data: ShareRequest(
              validityMillis: 2592000000,
              sharedData: sharedData,
            ).toJson(),
          );

          if (result.statusCode != HttpStatus.ok) {
            throw StateError("Returned invalid HTTP status.");
          }

          final response = ShareResponse.fromJson(result.data!);
          logger.debug("Response: $response");

          final connectionSettings =
              await ref.read(connectionSettingsProvider.future);

          return connectionSettings
              .createSessionEndpointUrl(response.id)
              .fold((exception) => throw exception, (uri) => uri);
        },
        (e, stackTrace) {
          if (e is DioException) {
            logger.debug("DioException: ${e.response}");
          }
          logger.debug("Failed sharing. $e $stackTrace");
          return "$e";
        },
      );

  TaskEither<(), SharedData> prepareData(List<int> sessionIds) =>
      TaskEither.tryCatch(
        () async {
          final routinesMap = await ref.read(routinesMapProvider.future);
          final exerciseMap = await ref.read(exerciseModelsMapProvider.future);
          final sessionService = await ref.read(sessionServiceProvider.future);
          final sessions = await sessionService.readList(sessionIds).run();

          return SharedData(
            shareTimestamp: DateTime.now().millisecondsSinceEpoch,
            sessions: sessions
                .map(
                  (session) => SharedSession(
                    id: session.id,
                    routineId: session.routineId,
                    workoutId: session.workoutId,
                    startTimestamp: session.startDate.millisecondsSinceEpoch,
                    exercises: session.exercises
                        .map(
                          (exercise) => SharedSessionExercise(
                            exerciseId: exercise.exerciseId,
                            sets: exercise.sets
                                .map(
                                  (set) => SharedSet(
                                    reps: set.reps,
                                    weight: set.weight,
                                    rpe: set.rpe,
                                    restSecs: set.restTimeSeconds,
                                  ),
                                )
                                .toList(),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
            exercises: sessions
                .flatMap((session) => session.exercises)
                .map((exercise) => exercise.exerciseId)
                .unique()
                .map(exerciseMap.get)
                .flattenOptions()
                .map(
                  (exercise) => SharedExercise(
                    id: exercise.id,
                    name: exercise.name,
                  ),
                )
                .toList(),
            routines: sessions
                .map((session) => session.routineId)
                .unique()
                .map(routinesMap.get)
                .flattenOptions()
                .map(
                  (routine) => SharedRoutine(
                    id: routine.id,
                    name: routine.name,
                    workouts: routine.workouts
                        .map(
                          (workout) => SharedWorkout(
                            id: workout.id,
                            name: workout.name,
                            exercises: workout.exercises
                                .map(
                                  (exercise) => SharedWorkoutExercise(
                                    exerciseId: exercise.exerciseId,
                                    sets: exercise.sets
                                        .map(
                                          (set) => SharedExerciseSet(
                                            intensity: set.intensity,
                                            reps: set.reps,
                                          ),
                                        )
                                        .toList(),
                                  ),
                                )
                                .toList(),
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          );
        },
        (error, stackTrace) {
          logger.warning("Could not create shared data. $error");
          return ();
        },
      );
}
