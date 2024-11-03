import "dart:convert";

import "package:pi_mobile/data/workload.dart";
import "package:pi_mobile/data/workout.dart";
import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "workouts_provider.g.dart";

@Riverpod(keepAlive: true)
class Workouts extends _$Workouts with Logger {
  static const _keyName = "workouts3";

  @override
  Future<List<Workout>> build() async {
    final preferences = SharedPreferencesAsync();
    final jsonList = await preferences.getStringList(_keyName) ?? [];
    final workouts =
        jsonList.map((json) => Workout.fromJson(jsonDecode(json))).toList();

    logger.debug("Read ${workouts.length} workouts");
    return workouts;
  }

  Future<void> addWorkout(Workout workout) async {
    final list = await ref.read(workoutsProvider.future);
    list.add(workout);

    final preferences = SharedPreferencesAsync();
    final jsonList = list.map(jsonEncode).toList();
    await preferences.setStringList(_keyName, jsonList);

    ref.invalidateSelf();
  }

  Future<void> addWorkload(String workoutUuid, Workload workload) async {
    final workouts = await ref.read(workoutsProvider.future);

    final newWorkouts = workouts.toList().map((workout) {
      if (workout.uuid == workoutUuid) {
        final newListOfExercises = workout.exercises + [workload];
        return workout.copyWith(exercises: newListOfExercises);
      }
      return workout;
    }).toList();

    final preferences = SharedPreferencesAsync();
    final jsonList = newWorkouts.map(jsonEncode).toList();
    await preferences.setStringList(_keyName, jsonList);

    ref.invalidateSelf();
  }
}
