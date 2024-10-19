import "package:freezed_annotation/freezed_annotation.dart";
import "package:pi_mobile/data/workout_schema.dart";

part "routine_schema.g.dart";
part "routine_schema.freezed.dart";

@freezed
class RoutineSchema with _$RoutineSchema {
  const factory RoutineSchema({
    required String uuid,
    required String name,
    required String description,
    required List<WorkoutSchema> workouts,
  }) = _RoutineSchema;

  factory RoutineSchema.fromJson(Map<String, Object?> json) =>
      _$RoutineSchemaFromJson(json);
}
