import "package:freezed_annotation/freezed_annotation.dart";
import "package:pi_mobile/data/training_workload.dart";

part "training.g.dart";
part "training.freezed.dart";

@freezed
class Training with _$Training {
  const factory Training({
    required String initialTrainingName,
    required String initialRoutineName,
    required String trainingUuid,
    required String routineSchemaUuid,
    required String workoutSchemaUuid,
    required DateTime startDate,
    required DateTime endDate,
    required bool isFinished,
    required TrainingWorkload trainingWorkload,
  }) = _Training;

  factory Training.fromJson(Map<String, Object?> json) =>
      _$TrainingFromJson(json);
}
