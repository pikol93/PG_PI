import "package:freezed_annotation/freezed_annotation.dart";

part "routine.freezed.dart";

@freezed
class Routine with _$Routine {
  const factory Routine({
    required int id,
    required String name,
    required String author,
    required List<Workout> workouts,
  }) = _Routine;
}

@freezed
class Workout with _$Workout {
  const factory Workout({
    required int id,
    required String name,
    required List<WorkoutExercise> exercises,
  }) = _Workout;
}

@freezed
class WorkoutExercise with _$WorkoutExercise {
  const factory WorkoutExercise({
    required int exerciseId,
    required List<ExerciseSet> sets,
  }) = _WorkoutExercise;
}

@freezed
class ExerciseSet with _$ExerciseSet {
  const factory ExerciseSet({
    required double intensity,
    required int reps,
    @Default(false) bool isAmrap,
  }) = _ExerciseSet;
}
