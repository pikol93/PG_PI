import "package:freezed_annotation/freezed_annotation.dart";
import "package:pi_mobile/data/muscle_group.dart";

part "built_in_exercises.freezed.dart";

@freezed
class BuiltInExercise with _$BuiltInExercise {
  const factory BuiltInExercise({
    required int id,
    required String identifier,
    required List<MuscleGroup> primaryMuscleGroups,
    List<MuscleGroup>? secondaryMuscleGroups,
    @Default(false) bool countOneRepMax,
    @Default(false) bool isOneRepMaxMeasurable,
  }) = _BuildInExercise;
}

const List<BuiltInExercise> builtInExercises = [
  BuiltInExercise(
    id: 1000000000,
    identifier: "barDips",
    primaryMuscleGroups: [
      MuscleGroup.chest,
      MuscleGroup.frontDeltoid,
      MuscleGroup.triceps,
    ],
  ),
  BuiltInExercise(
    id: 1000000001,
    identifier: "benchPress",
    primaryMuscleGroups: [
      MuscleGroup.chest,
      MuscleGroup.frontDeltoid,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000002,
    identifier: "benchPress2",
    primaryMuscleGroups: [
      MuscleGroup.chest,
      MuscleGroup.frontDeltoid,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.triceps,
    ],
    isOneRepMaxMeasurable: true,
  ),
];
