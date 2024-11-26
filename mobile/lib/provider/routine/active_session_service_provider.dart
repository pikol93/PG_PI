import "dart:convert";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:loggy/loggy.dart";
import "package:pi_mobile/data/routine/active_session.dart";
import "package:pi_mobile/data/routine/session.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/one_rep_max_service_provider.dart";
import "package:pi_mobile/provider/routine/routines_provider.dart";
import "package:pi_mobile/provider/routine/session_service_provider.dart";
import "package:pi_mobile/utility/list.dart";
import "package:pi_mobile/utility/option.dart";
import "package:pi_mobile/utility/task.dart";
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

          final oneRepMaxService =
              await ref.read(oneRepMaxServiceProvider.future);

          final exercises = await workout.exercises
              .map(
                (exercise) => oneRepMaxService
                    .findOneRepMaxHistoryForExercise(exercise.exerciseId)
                    .map(
                      (oneRepMaxHistoryOption) => oneRepMaxHistoryOption
                          .map(
                            (oneRepMaxHistory) =>
                                oneRepMaxHistory.findCurrentOneRepMax(),
                          )
                          .flatten()
                          .orElse(50.0),
                    )
                    .map(
                      (oneRepMax) => ActiveSessionExercise(
                        exerciseId: exercise.exerciseId,
                        sets: exercise.sets
                            .map(
                              (set) => ActiveSessionSet(
                                expectedIntensity: set.intensity,
                                expectedReps: set.reps,
                                expectedWeight: oneRepMax * set.intensity,
                                expectedRestTimeSeconds: 100,
                              ),
                            )
                            .toList(),
                      ),
                    ),
              )
              .joinAll()
              .run();

          final session = ActiveSession(
            startingDate: DateTime.now(),
            routineId: routineId,
            workoutId: workoutId,
            currentExerciseIndex: currentExerciseIndex,
            exercises: exercises,
          );

          await _overwrite(session).run();
        },
        (error, stackTrace) {
          logger.warning(
            "Failed initiating active session. $error, $stackTrace",
          );
        },
      );

  TaskEither<void, void> finish() => TaskEither.tryCatch(
        () async {
          try {
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
                            (result) => result.maybeMap<SessionSet?>(
                              completed: (item) => SessionSet()
                                ..weight = item.value.weight
                                ..reps = item.value.reps
                                ..rpe = item.value.rpe
                                ..restTimeSeconds = item.restTimeSeconds,
                              resting: (item) => SessionSet()
                                ..weight = item.value.weight
                                ..reps = item.value.reps
                                ..rpe = item.value.rpe
                                ..restTimeSeconds = 0,
                              orElse: () => null,
                            ),
                          )
                          .where((option) => option != null)
                          .map((option) => option!)
                          .toList(),
                  )
                  .where((exercise) => exercise.sets.isNotEmpty)
                  .toList();

            if (session.exercises.isEmpty) {
              throw StateError("Cannot add session with no exercises.");
            }

            final sessionService =
                await ref.read(sessionServiceProvider.future);

            await sessionService.save(session).run();
          } finally {
            await _clear().run();
          }
        },
        (error, stackTrace) {
          logger.debug("Could not finish active session. $error");
        },
      );

  TaskEither<void, void> startExercise(int index) => TaskEither.tryCatch(
        () async {
          final state =
              await _readState().map((state) => state.toNullable()!).run();

          if (state.currentExerciseIndex.isSome()) {
            throw StateError(
              "Cannot start exercise since another "
              "exercise is already started.",
            );
          }

          final isExerciseCompleted = state.exercises[index].isCompleted();
          if (isExerciseCompleted) {
            throw StateError(
              "Cannot start exercise that has already been completed.",
            );
          }

          final newState = state.copyWith(currentExerciseIndex: Some(index));
          await _overwrite(newState).run();
        },
        (error, stackTrace) =>
            logger.debug("Failed starting exercise with index $index. $error"),
      );

  TaskEither<void, void> endExercise() => TaskEither.tryCatch(
        () async {
          final state =
              await _readState().map((value) => value.toNullable()!).run();

          if (state.currentExerciseIndex.isNone()) {
            throw StateError(
              "Cannot end exercise since no exercise is active.",
            );
          }

          final newState = state.copyWith(
            currentExerciseIndex: const Option.none(),
          );

          await _overwrite(newState).run();
        },
        (error, stackTrace) => logger.debug("Could not end exercise. $error"),
      );

  TaskEither<void, void> beginResting(
    int setIndex,
    ActiveSessionSetResult result,
  ) =>
      TaskEither.tryCatch(
        () async {
          final state =
              await _readState().map((value) => value.toNullable()!).run();

          final index = state.currentExerciseIndex.toNullable()!;

          final newExercises = state.exercises.rebuildAtIndex(
            index,
            (exercise) => exercise.copyWith(
              sets: exercise.sets.rebuildAtIndex(
                setIndex,
                (set) => set.startResting(result, DateTime.now()).toNullable()!,
              ),
            ),
          );

          final newState = state.copyWith(exercises: newExercises);

          await _overwrite(newState).run();
        },
        (error, stackTrace) => logger.debug(
          "Failed completing set $result. $error $stackTrace",
        ),
      );

  TaskEither<void, void> finishRest(int setIndex) => TaskEither.tryCatch(
        () async {
          final state =
              await _readState().map((value) => value.toNullable()!).run();

          final index = state.currentExerciseIndex.toNullable()!;

          final newExercises = state.exercises.rebuildAtIndex(
            index,
            (exercise) => exercise.copyWith(
              sets: exercise.sets.rebuildAtIndex(
                setIndex,
                (set) => set.complete(DateTime.now()).toNullable()!,
              ),
            ),
          );

          final newState = state.copyWith(exercises: newExercises);

          await _overwrite(newState).run();
        },
        (error, stackTrace) =>
            logger.debug("Failed finishing rest. $setIndex $error $stackTrace"),
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
