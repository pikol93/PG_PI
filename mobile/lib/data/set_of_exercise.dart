import 'package:freezed_annotation/freezed_annotation.dart';

part "set_of_exercise.g.dart";
part "set_of_exercise.freezed.dart";

@freezed
class SetOfExercise with _$SetOfExercise {
  const factory SetOfExercise({
    required int reps,
    required double weight,
    required int rpe,
  }) = _SetOfExercise;

  factory SetOfExercise.fromJson(Map<String, Object?> json) =>
      _$SetOfExerciseFromJson(json);
}
