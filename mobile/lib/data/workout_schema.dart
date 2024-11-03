import "package:freezed_annotation/freezed_annotation.dart";
import "package:pi_mobile/data/strength_exercise_schema.dart";

part "workout_schema.g.dart";
part "workout_schema.freezed.dart";

@freezed
class WorkoutSchema with _$WorkoutSchema {
  const factory WorkoutSchema({
    required String uuid,
    required String name,
    required List<StrengthExerciseSchema> exercisesSchemas,
  }) = _WorkoutSchema;

  factory WorkoutSchema.fromJson(Map<String, Object?> json) =>
      _$WorkoutSchemaFromJson(json);
}
