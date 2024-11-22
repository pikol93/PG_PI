import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/routine/built_in_routines.dart" as temp;
import "package:pi_mobile/data/routine/routine.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "built_in_routines_provider.g.dart";

@riverpod
List<Routine> builtInRoutines(Ref ref) => temp.builtInRoutines
    .map(
      (routine) => Routine(
        id: routine.id,
        name: routine.identifier, // TODO: I18N
        workouts: routine.workouts
            .map(
              (workout) => Workout(
                id: workout.id,
                name: workout.identifier, // TODO: I18N
                exercises: workout.exercises,
              ),
            )
            .toList(),
      ),
    )
    .toList();
