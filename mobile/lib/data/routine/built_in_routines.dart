import "package:freezed_annotation/freezed_annotation.dart";
import "package:pi_mobile/data/routine/routine.dart";

part "built_in_routines.freezed.dart";

@freezed
class BuiltInRoutine with _$BuiltInRoutine {
  const factory BuiltInRoutine({
    required int id,
    required String identifier,
    required List<BuiltInWorkout> workouts,
  }) = _BuiltInRoutine;
}

@freezed
class BuiltInWorkout with _$BuiltInWorkout {
  const factory BuiltInWorkout({
    required int id,
    required String identifier,
    required List<WorkoutExercise> exercises,
  }) = _BuiltInWorkout;
}

const builtInRoutines = [
  BuiltInRoutine(
    id: 2000000000,
    identifier: "routine531ForBeginners",
    workouts: [
      BuiltInWorkout(
        id: 3000000000,
        identifier: "week1Monday",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000010,
            sets: [
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.85, reps: 5, isAmrap: true),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000001,
            sets: [
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.85, reps: 5, isAmrap: true),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000001,
        identifier: "week1Wednesday",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000011,
            sets: [
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.85, reps: 5, isAmrap: true),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000012,
            sets: [
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.85, reps: 5, isAmrap: true),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000002,
        identifier: "week1Friday",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000001,
            sets: [
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.85, reps: 5, isAmrap: true),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000010,
            sets: [
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.85, reps: 5, isAmrap: true),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000003,
        identifier: "week2Monday",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000010,
            sets: [
              ExerciseSet(intensity: 0.7, reps: 3),
              ExerciseSet(intensity: 0.8, reps: 3),
              ExerciseSet(intensity: 0.9, reps: 3, isAmrap: true),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000001,
            sets: [
              ExerciseSet(intensity: 0.7, reps: 3),
              ExerciseSet(intensity: 0.8, reps: 3),
              ExerciseSet(intensity: 0.9, reps: 3, isAmrap: true),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000004,
        identifier: "week2Wednesday",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000011,
            sets: [
              ExerciseSet(intensity: 0.7, reps: 3),
              ExerciseSet(intensity: 0.8, reps: 3),
              ExerciseSet(intensity: 0.9, reps: 3, isAmrap: true),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000012,
            sets: [
              ExerciseSet(intensity: 0.7, reps: 3),
              ExerciseSet(intensity: 0.8, reps: 3),
              ExerciseSet(intensity: 0.9, reps: 3, isAmrap: true),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000005,
        identifier: "week2Friday",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000010,
            sets: [
              ExerciseSet(intensity: 0.7, reps: 3),
              ExerciseSet(intensity: 0.8, reps: 3),
              ExerciseSet(intensity: 0.9, reps: 3, isAmrap: true),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000001,
            sets: [
              ExerciseSet(intensity: 0.7, reps: 3),
              ExerciseSet(intensity: 0.8, reps: 3),
              ExerciseSet(intensity: 0.9, reps: 3, isAmrap: true),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000006,
        identifier: "week3Monday",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000010,
            sets: [
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.85, reps: 3),
              ExerciseSet(intensity: 0.95, reps: 1, isAmrap: true),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000001,
            sets: [
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.85, reps: 3),
              ExerciseSet(intensity: 0.95, reps: 1, isAmrap: true),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000007,
        identifier: "week3Wednesday",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000011,
            sets: [
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.85, reps: 3),
              ExerciseSet(intensity: 0.95, reps: 1, isAmrap: true),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000012,
            sets: [
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.85, reps: 3),
              ExerciseSet(intensity: 0.95, reps: 1, isAmrap: true),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000008,
        identifier: "week3Friday",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000001,
            sets: [
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.85, reps: 3),
              ExerciseSet(intensity: 0.95, reps: 1, isAmrap: true),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000010,
            sets: [
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.85, reps: 3),
              ExerciseSet(intensity: 0.95, reps: 1, isAmrap: true),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
            ],
          ),
        ],
      ),
    ],
  ),
  BuiltInRoutine(
    id: 2000000001,
    identifier: "routine531BoringButBig",
    workouts: [
      // Week 1
      BuiltInWorkout(
        id: 3000000009,
        identifier: "week1Day1",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000012,
            sets: [
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5, isAmrap: true),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000013,
            sets: [
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000010,
        identifier: "week1Day2",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000011,
            sets: [
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5, isAmrap: true),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000014,
            sets: [
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000011,
        identifier: "week1Day3",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000001,
            sets: [
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5),
              ExerciseSet(intensity: 0.85, reps: 5, isAmrap: true),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.65, reps: 5),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000013,
            sets: [
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000012,
        identifier: "week1Day4",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000010,
            sets: [
              ExerciseSet(intensity: 0.65, reps: 5),
              ExerciseSet(intensity: 0.7, reps: 5),
              ExerciseSet(intensity: 0.75, reps: 5, isAmrap: true),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000014,
            sets: [
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000013,
        identifier: "week2Day1",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000012,
            sets: [
              ExerciseSet(intensity: 0.75, reps: 3),
              ExerciseSet(intensity: 0.80, reps: 3),
              ExerciseSet(intensity: 0.85, reps: 3, isAmrap: true),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000013,
            sets: [
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000014,
        identifier: "week2Day2",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000011,
            sets: [
              ExerciseSet(intensity: 0.75, reps: 3),
              ExerciseSet(intensity: 0.8, reps: 3),
              ExerciseSet(intensity: 0.85, reps: 3, isAmrap: true),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000014,
            sets: [
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000015,
        identifier: "week2Day3",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000001,
            sets: [
              ExerciseSet(intensity: 0.75, reps: 3),
              ExerciseSet(intensity: 0.8, reps: 3),
              ExerciseSet(intensity: 0.85, reps: 3, isAmrap: true),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000013,
            sets: [
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000016,
        identifier: "week2Day4",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000010,
            sets: [
              ExerciseSet(intensity: 0.75, reps: 3),
              ExerciseSet(intensity: 0.8, reps: 3),
              ExerciseSet(intensity: 0.85, reps: 3, isAmrap: true),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000014,
            sets: [
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000017,
        identifier: "week3Day1",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000012,
            sets: [
              ExerciseSet(intensity: 0.85, reps: 5),
              ExerciseSet(intensity: 0.90, reps: 3),
              ExerciseSet(intensity: 0.95, reps: 1, isAmrap: true),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000013,
            sets: [
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000018,
        identifier: "week3Day2",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000011,
            sets: [
              ExerciseSet(intensity: 0.85, reps: 5),
              ExerciseSet(intensity: 0.90, reps: 3),
              ExerciseSet(intensity: 0.95, reps: 1, isAmrap: true),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000014,
            sets: [
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000019,
        identifier: "week3Day3",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000001,
            sets: [
              ExerciseSet(intensity: 0.85, reps: 5),
              ExerciseSet(intensity: 0.90, reps: 3),
              ExerciseSet(intensity: 0.95, reps: 1, isAmrap: true),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000013,
            sets: [
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000020,
        identifier: "week3Day4",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000010,
            sets: [
              ExerciseSet(intensity: 0.85, reps: 5),
              ExerciseSet(intensity: 0.90, reps: 3),
              ExerciseSet(intensity: 0.95, reps: 1, isAmrap: true),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
              ExerciseSet(intensity: 0.50, reps: 10),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000014,
            sets: [
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000021,
        identifier: "week4Day1",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000012,
            sets: [
              ExerciseSet(intensity: 0.4, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.6, reps: 5, isAmrap: true),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000013,
            sets: [
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000022,
        identifier: "week4Day2",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000011,
            sets: [
              ExerciseSet(intensity: 0.4, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.6, reps: 5, isAmrap: true),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000014,
            sets: [
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000023,
        identifier: "week4Day3",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000001,
            sets: [
              ExerciseSet(intensity: 0.4, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.6, reps: 5, isAmrap: true),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000013,
            sets: [
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
            ],
          ),
        ],
      ),
      BuiltInWorkout(
        id: 3000000024,
        identifier: "week4Day4",
        exercises: [
          WorkoutExercise(
            exerciseId: 1000000010,
            sets: [
              ExerciseSet(intensity: 0.4, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.6, reps: 5, isAmrap: true),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
              ExerciseSet(intensity: 0.5, reps: 5),
            ],
          ),
          WorkoutExercise(
            exerciseId: 1000000014,
            sets: [
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
              ExerciseSet(intensity: 0.5, reps: 10),
            ],
          ),
        ],
      ),
    ],
  ),
];
