import "package:freezed_annotation/freezed_annotation.dart";

part "strength_exercise.g.dart";
part "strength_exercise.freezed.dart";

@freezed
class StrengthExercise with _$StrengthExercise {
  const factory StrengthExercise({
    required String name,
    required String imageLink,
  }) = _StrengthExercise;

  factory StrengthExercise.fromJson(Map<String, Object?> json) =>
      _$StrengthExerciseFromJson(json);
}
