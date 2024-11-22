import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/data/routine/built_in_routines.dart" as temp;
import "package:pi_mobile/data/routine/routine.dart";
import "package:pi_mobile/provider/routine/routine_i18n_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "built_in_routines_provider.g.dart";

@riverpod
List<Routine> builtInRoutines(Ref ref) {
  final routineI18N = ref.watch(routineI18NProvider);

  return temp.builtInRoutines
      .map(
        (routine) => Routine(
          id: routine.id,
          name: routineI18N
              .name(routine.identifier)
              .getOrElse(() => "MISSING TRANSLATION: ${routine.identifier}"),
          author: "",
          workouts: routine.workouts
              .map(
                (workout) => Workout(
                  id: workout.id,
                  name: routineI18N
                      .workoutName(routine.identifier, workout.identifier)
                      .getOrElse(
                        () => "MISSING TRANSLATION: "
                            "${routine.identifier} "
                            "${workout.identifier}",
                      ),
                  exercises: workout.exercises,
                ),
              )
              .toList(),
        ),
      )
      .toList();
}
