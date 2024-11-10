import "package:freezed_annotation/freezed_annotation.dart";
import "package:pi_mobile/data/training_exercise_set.dart";

part "training_exercise.g.dart";
part "training_exercise.freezed.dart";

@freezed
class TrainingExercise with _$TrainingExercise {
  const factory TrainingExercise({
    required String trainingExerciseUuid,
    required String exerciseSchemaUuid,
    required String name,
    required bool wasStarted,
    required bool isFinished,
    required List<TrainingExerciseSet> exerciseSets,
  }) = _TrainingExercise;

  factory TrainingExercise.fromJson(Map<String, Object?> json) =>
      _$TrainingExerciseFromJson(json);
}
