import "package:freezed_annotation/freezed_annotation.dart";

part "strength_exercise_set_schema.g.dart";
part "strength_exercise_set_schema.freezed.dart";

@freezed
class StrengthExerciseSetSchema with _$StrengthExerciseSetSchema {
  const factory StrengthExerciseSetSchema({
    required String uuid,
    required int intensity,
    required int reps,
  }) = _StrengthExerciseSetSchema;

  factory StrengthExerciseSetSchema.fromJson(Map<String, Object?> json) =>
      _$StrengthExerciseSetSchemaFromJson(json);
}
