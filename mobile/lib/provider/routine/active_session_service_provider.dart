import "dart:convert";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:loggy/loggy.dart";
import "package:pi_mobile/data/routine/active_session.dart";
import "package:pi_mobile/data/routine/session.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/routine/routines_provider.dart";
import "package:pi_mobile/provider/routine/session_service_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "active_session_service_provider.g.dart";

const _keyName = "active_session";

@riverpod
Option<ActiveSession> activeSessionOrNone(Ref ref) =>
    ref.watch(activeSessionProvider).when(
          data: (data) => data,
          error: (obj, stackTrace) => const Option.none(),
          loading: Option.none,
        );

@riverpod
Future<Option<ActiveSession>> activeSession(Ref ref) async {
  final storedJson = await SharedPreferencesAsync().getString(_keyName);
  if (storedJson == null) {
    logDebug("No stored active session found.");
    return const Option.none();
  }

  try {
    final activeSession = ActiveSession.fromJson(jsonDecode(storedJson));
    return Option.of(activeSession);
  } catch (ex) {
    logWarning("Could not decode active session. Data: $storedJson");
    return const Option.none();
  }
}

@riverpod
ActiveSessionService activeSessionService(Ref ref) => ActiveSessionService(
      ref: ref,
    );

class ActiveSessionService with Logger {
  final Ref ref;

  ActiveSessionService({required this.ref});

  TaskEither<void, void> initiate(
    int routineId,
    int workoutId,
    Option<int> currentExerciseIndex,
  ) =>
      TaskEither.tryCatch(
        () async {
          final routinesMap = await ref.read(routinesMapProvider.future);

          final routine = routinesMap[routineId]!;
          final workout =
              routine.workouts.firstWhere((workout) => workout.id == workoutId);

          await finish().run();

          final session = ActiveSession(
            startingDate: DateTime.now(),
            routineId: routineId,
            workoutId: workoutId,
            currentExerciseIndex: currentExerciseIndex,
            exercises: workout.exercises
                .map(
                  (exercise) => ActiveSessionExercise(
                    exerciseId: exercise.exerciseId,
                    sets: exercise.sets
                        .map(
                          (set) => ActiveSessionSet(
                            expectedIntensity: set.intensity,
                            expectedReps: set.reps,
                            expectedRestTimeSeconds: 100,
                          ),
                        )
                        .toList(),
                  ),
                )
                .toList(),
          );

          await _overwrite(session).run();
        },
        (error, stackTrace) {
          logger.warning(
            "Failed initiating active session. $error, $stackTrace",
          );
        },
      );

  Task<void> update(ActiveSession session) => Task(() async {
        _overwrite(session);
        logger.debug("Updated active session");
      });

  TaskEither<void, void> finish() => TaskEither.tryCatch(
        () async {
          final activeSession = await _readState()
              .map((activeSessionOption) => activeSessionOption.toNullable()!)
              .run();

          final session = Session()
            ..startDate = activeSession.startingDate
            ..routineId = activeSession.routineId
            ..workoutId = activeSession.workoutId
            ..exercises = activeSession.exercises
                .map(
                  (exercise) => SessionExercise()
                    ..exerciseId = exercise.exerciseId
                    ..sets = exercise.sets
                        .map((set) => set.result)
                        .map(
                          (result) =>
                              result.maybeMap<Option<ActiveSessionSetResult>>(
                            completed: (item) => Option.of(item.value),
                            orElse: Option.none,
                          ),
                        )
                        .where((option) => option.isSome())
                        .map((option) => option.toNullable()!)
                        .map(
                          (result) => SessionSet()
                            ..weight = result.weight
                            ..reps = result.reps
                            ..rpe = result.rpe,
                        )
                        .toList(),
                )
                .where((exercise) => exercise.sets.isNotEmpty)
                .toList();

          if (session.exercises.isEmpty) {
            throw StateError("Cannot add session with no exercises.");
          }

          final sessionService = await ref.read(sessionServiceProvider.future);
          await sessionService.save(session).run();

          return _clear().run();
        },
        (error, stackTrace) {
          logger.debug("Could not finish active session. $error");
        },
      );

  Task<void> removeMeRemoveMeRemoveMe() => _clear();

  Task<void> _overwrite(ActiveSession activeSession) => Task(() async {
        logger.debug("Saving active session: $activeSession");
        final json = jsonEncode(activeSession);
        await SharedPreferencesAsync().setString(_keyName, json);
        return _invalidateStoredSession().run();
      });

  Task<void> _clear() => Task(() async {
        await SharedPreferencesAsync().remove(_keyName);
        return _invalidateStoredSession().run();
      });

  Task<Option<ActiveSession>> _readState() =>
      Task(() => ref.read(activeSessionProvider.future));

  Task<void> _invalidateStoredSession() => Task(() async {
        ref.invalidate(activeSessionProvider);
      });
}
