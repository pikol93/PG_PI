import "dart:convert";

import "package:pi_mobile/data/routine_schema.dart";
import "package:pi_mobile/data/workout_schema.dart";
import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "routines_provider.g.dart";

@Riverpod(keepAlive: true)
class Routines extends _$Routines with Logger {
  static const _keyName = "routines";

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
}
