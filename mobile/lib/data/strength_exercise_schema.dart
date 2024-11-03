import "package:freezed_annotation/freezed_annotation.dart";
import "package:pi_mobile/data/strength_exercise_set_schema.dart";

part "strength_exercise_schema.g.dart";
part "strength_exercise_schema.freezed.dart";

@freezed
class StrengthExerciseSchema with _$StrengthExerciseSchema {
  const factory StrengthExerciseSchema({
    required String uuid,
    required String name,
    required int restTime,
    required List<StrengthExerciseSetSchema> sets,
  }) = _StrengthExerciseSchema;

  factory StrengthExerciseSchema.fromJson(Map<String, Object?> json) =>
      _$StrengthExerciseSchemaFromJson(json);
}
