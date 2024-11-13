import "package:freezed_annotation/freezed_annotation.dart";
import "package:pi_mobile/data/training_exercise.dart";

part "training_workload.g.dart";
part "training_workload.freezed.dart";

@freezed
class TrainingWorkload with _$TrainingWorkload {
  const factory TrainingWorkload({
    required String uuid,
    required List<TrainingExercise> trainingExercises,
  }) = _TrainingWorkload;

  factory TrainingWorkload.fromJson(Map<String, Object?> json) =>
      _$TrainingWorkloadFromJson(json);
}
