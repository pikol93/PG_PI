import "dart:convert";

import "package:pi_mobile/data/routine_schema.dart";
import "package:pi_mobile/data/strength_exercise_schema.dart";
import "package:pi_mobile/data/strength_exercise_set_schema.dart";
import "package:pi_mobile/data/workout_schema.dart";
import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "routines_provider.g.dart";

@Riverpod(keepAlive: true)
class Routines extends _$Routines with Logger {
  static const _keyName = "routines2";

  @override
  Future<List<RoutineSchema>> build() async {
    final preferences = SharedPreferencesAsync();
    final jsonList = await preferences.getStringList(_keyName) ?? [];
    final routineSchemas = jsonList
        .map((json) => RoutineSchema.fromJson(jsonDecode(json)))
        .toList();

    logger.debug("Read ${routineSchemas.length} workouts");
    return routineSchemas;
  }

  Future<void> addRoutine(RoutineSchema routineSchema) async {
    final list = await ref.read(routinesProvider.future);
    list.add(routineSchema);

    final preferences = SharedPreferencesAsync();
    final jsonList = list.map(jsonEncode).toList();
    await preferences.setStringList(_keyName, jsonList);

    ref.invalidateSelf();
  }

  Future<List<WorkoutSchema>> getWorkouts(String routineUuid) async {
    final list = await ref.read(routinesProvider.future);
    return list.firstWhere((routine) => routineUuid == routine.uuid).workouts;
  }

  Future<WorkoutSchema> getWorkout(
      String routineUuid, String workoutUuid,) async {
    final list = await ref.read(routinesProvider.future);
    return list
        .firstWhere((routine) => routineUuid == routine.uuid)
        .workouts
        .firstWhere((workout) => workoutUuid == workout.uuid);
  }

  Future<void> addWorkout(String routineUuid, WorkoutSchema workout) async {
    final routines = await ref.read(routinesProvider.future);

    final updatedRoutines = routines.toList().map((routine) {
      if (routine.uuid == routineUuid) {
        final newListOfWorkouts = routine.workouts + [workout];
        return routine.copyWith(workouts: newListOfWorkouts);
      }
      return routine;
    }).toList();

    final preferences = SharedPreferencesAsync();
    final jsonList = updatedRoutines.map(jsonEncode).toList();
    await preferences.setStringList(_keyName, jsonList);

    ref.invalidateSelf();
  }

  Future<void> updateWorkout(
    String routineUuid,
    WorkoutSchema updatedWorkout,
  ) async {
    final routines = await ref.read(routinesProvider.future);

    final updatedRoutines = routines.toList().map((routine) {
      if (routine.uuid == routineUuid) {
        final updatedWorkouts = routine.workouts.map((workout) {
          if (workout.uuid == updatedWorkout.uuid) {
            return workout.copyWith(name: updatedWorkout.name);
          }
          return workout;
        }).toList();
        return routine.copyWith(workouts: updatedWorkouts);
      }
      return routine;
    }).toList();

    final preferences = SharedPreferencesAsync();
    final jsonList = updatedRoutines.map(jsonEncode).toList();
    await preferences.setStringList(_keyName, jsonList);

    ref.invalidateSelf();
  }

  Future<List<StrengthExerciseSchema>> getExercises(
    String routineUuid,
    String workoutUuid,
  ) async {
    final routines = await ref.read(routinesProvider.future);
    final routine = routines.firstWhere((r) => r.uuid == routineUuid);
    final workout = routine.workouts.firstWhere((w) => w.uuid == workoutUuid);
    return workout.exercisesSchemas;
  }

  Future<StrengthExerciseSchema> getExercise(
    String routineUuid,
    String workoutUuid,
    String exerciseUuid,
  ) async {
    final routines = await ref.read(routinesProvider.future);
    final routine = routines.firstWhere((r) => r.uuid == routineUuid);
    final workout = routine.workouts.firstWhere((w) => w.uuid == workoutUuid);
    final exercise =
        workout.exercisesSchemas.firstWhere((e) => e.uuid == exerciseUuid);
    return exercise;
  }

  Future<void> addExercise(
    String routineUuid,
    String workoutUuid,
    StrengthExerciseSchema exercise,
  ) async {
    final routines = await ref.read(routinesProvider.future);

    final updatedRoutines = routines.toList().map((routine) {
      if (routine.uuid == routineUuid) {
        final updatedWorkouts = routine.workouts.map((workout) {
          if (workout.uuid == workoutUuid) {
            final updatedExercises = workout.exercisesSchemas + [exercise];
            return workout.copyWith(exercisesSchemas: updatedExercises);
          }
          return workout;
        }).toList();
        return routine.copyWith(workouts: updatedWorkouts);
      }
      return routine;
    }).toList();

    final preferences = SharedPreferencesAsync();
    final jsonList = updatedRoutines.map(jsonEncode).toList();
    await preferences.setStringList(_keyName, jsonList);

    ref.invalidateSelf();
  }

  Future<void> updateExercise(
    String routineUuid,
    String workoutUuid,
    StrengthExerciseSchema updatedExercise,
  ) async {
    final routines = await ref.read(routinesProvider.future);

    final updatedRoutines = routines.toList().map((routine) {
      if (routine.uuid == routineUuid) {
        final updatedWorkouts = routine.workouts.map((workout) {
          if (workout.uuid == workoutUuid) {
            final updatedExercises = workout.exercisesSchemas.map((exercise) {
              if (exercise.uuid == updatedExercise.uuid) {
                return exercise.copyWith(
                  name: updatedExercise.name,
                  restTime: updatedExercise.restTime,
                );
                // return updatedExercise;
              }
              return exercise;
            }).toList();
            return workout.copyWith(exercisesSchemas: updatedExercises);
          }
          return workout;
        }).toList();
        return routine.copyWith(workouts: updatedWorkouts);
      }
      return routine;
    }).toList();

    final preferences = SharedPreferencesAsync();
    final jsonList = updatedRoutines.map(jsonEncode).toList();
    await preferences.setStringList(_keyName, jsonList);

    ref.invalidateSelf();
  }

  Future<List<StrengthExerciseSetSchema>> getExerciseSets(
    String routineUuid,
    String workoutUuid,
    String exerciseUuid,
  ) async {
    final routines = await ref.read(routinesProvider.future);
    final routine = routines.firstWhere((r) => r.uuid == routineUuid);
    final workout = routine.workouts.firstWhere((w) => w.uuid == workoutUuid);
    final exercise =
        workout.exercisesSchemas.firstWhere((e) => e.uuid == exerciseUuid);
    return exercise.sets;
  }

  Future<StrengthExerciseSetSchema> getExerciseSet(
    String routineUuid,
    String workoutUuid,
    String exerciseUuid,
    String setUuid,
  ) async {
    final routines = await ref.read(routinesProvider.future);
    final routine = routines.firstWhere((r) => r.uuid == routineUuid);
    final workout = routine.workouts.firstWhere((w) => w.uuid == workoutUuid);
    final exercise =
        workout.exercisesSchemas.firstWhere((e) => e.uuid == exerciseUuid);
    final set = exercise.sets.firstWhere((s) => s.uuid == setUuid);
    return set;
  }

  Future<void> addExerciseSet(
    String routineUuid,
    String workoutUuid,
    String exerciseUuid,
    StrengthExerciseSetSchema newSet,
  ) async {
    final routines = await ref.read(routinesProvider.future);

    final updatedRoutines = routines.map((routine) {
      if (routine.uuid == routineUuid) {
        final updatedWorkouts = routine.workouts.map((workout) {
          if (workout.uuid == workoutUuid) {
            final updatedExercises = workout.exercisesSchemas.map((exercise) {
              if (exercise.uuid == exerciseUuid) {
                final updatedSets = exercise.sets + [newSet];
                return exercise.copyWith(sets: updatedSets);
              }
              return exercise;
            }).toList();
            return workout.copyWith(exercisesSchemas: updatedExercises);
          }
          return workout;
        }).toList();
        return routine.copyWith(workouts: updatedWorkouts);
      }
      return routine;
    }).toList();

    final preferences = SharedPreferencesAsync();
    final jsonList = updatedRoutines.map(jsonEncode).toList();
    await preferences.setStringList(_keyName, jsonList);

    ref.invalidateSelf();
  }

  Future<void> updateExerciseSet(
    String routineUuid,
    String workoutUuid,
    String exerciseUuid,
    StrengthExerciseSetSchema updatedSet,
  ) async {
    final routines = await ref.read(routinesProvider.future);

    final updatedRoutines = routines.map((routine) {
      if (routine.uuid == routineUuid) {
        final updatedWorkouts = routine.workouts.map((workout) {
          if (workout.uuid == workoutUuid) {
            final updatedExercises = workout.exercisesSchemas.map((exercise) {
              if (exercise.uuid == exerciseUuid) {
                final updatedSets = exercise.sets.map((set) {
                  if (set.uuid == updatedSet.uuid) {
                    // return updatedSet;
                    return set.copyWith(
                      intensity: updatedSet.intensity,
                      reps: updatedSet.reps,);
                  }
                  return set;
                }).toList();
                return exercise.copyWith(sets: updatedSets);
              }
              return exercise;
            }).toList();
            return workout.copyWith(exercisesSchemas: updatedExercises);
          }
          return workout;
        }).toList();
        return routine.copyWith(workouts: updatedWorkouts);
      }
      return routine;
    }).toList();

    final preferences = SharedPreferencesAsync();
    final jsonList = updatedRoutines.map(jsonEncode).toList();
    await preferences.setStringList(_keyName, jsonList);

    ref.invalidateSelf();
  }
}
