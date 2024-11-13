import "package:freezed_annotation/freezed_annotation.dart";

part "training_exercise_set.g.dart";
part "training_exercise_set.freezed.dart";

@freezed
class TrainingExerciseSet with _$TrainingExerciseSet {
  const factory TrainingExerciseSet({
    required String uuid,
    required String exerciseSetSchemaUuid,
    required String exerciseName,
    required int expectedReps,
    required double expectedWeight,
    required int expectedIntensity,
    required double weight,
    required int reps,
    required int rpe,
    required bool isFinished,
  }) = _TrainingExerciseSet;

  factory TrainingExerciseSet.fromJson(Map<String, Object?> json) =>
      _$TrainingExerciseSetFromJson(json);
}
