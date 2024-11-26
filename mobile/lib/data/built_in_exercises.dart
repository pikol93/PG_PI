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
  }) = _BuiltInExercise;
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
    secondaryMuscleGroups: [
      MuscleGroup.triceps,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000002,
    identifier: "cableChestPress",
    primaryMuscleGroups: [
      MuscleGroup.chest,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.frontDeltoid,
      MuscleGroup.triceps,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000003,
    identifier: "dumbbellChestFly",
    primaryMuscleGroups: [
      MuscleGroup.chest,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.frontDeltoid,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000004,
    identifier: "dumbbellChestPress",
    primaryMuscleGroups: [
      MuscleGroup.chest,
      MuscleGroup.frontDeltoid,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.triceps,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000005,
    identifier: "dumbbellPullover",
    primaryMuscleGroups: [
      MuscleGroup.chest,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.lats,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000006,
    identifier: "pecDeck",
    primaryMuscleGroups: [
      MuscleGroup.chest,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.frontDeltoid,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000007,
    identifier: "pushUp",
    primaryMuscleGroups: [
      MuscleGroup.chest,
      MuscleGroup.frontDeltoid,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.triceps,
      MuscleGroup.abs,
    ],
    isOneRepMaxMeasurable: false,
  ),
  BuiltInExercise(
    id: 1000000008,
    identifier: "resistanceBandChestFly",
    primaryMuscleGroups: [
      MuscleGroup.chest,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.frontDeltoid,
    ],
    isOneRepMaxMeasurable: false,
  ),
  BuiltInExercise(
    id: 1000000009,
    identifier: "crunches",
    primaryMuscleGroups: [
      MuscleGroup.abs,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.obliques,
    ],
    isOneRepMaxMeasurable: false,
  ),
  BuiltInExercise(
    id: 1000000010,
    identifier: "squat",
    primaryMuscleGroups: [
      MuscleGroup.quads,
      MuscleGroup.adductors,
      MuscleGroup.glutes,
      MuscleGroup.lowerBack,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.calves,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000011,
    identifier: "deadlift",
    primaryMuscleGroups: [
      MuscleGroup.glutes,
      MuscleGroup.lowerBack,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.quads,
      MuscleGroup.hamstrings,
      MuscleGroup.adductors,
      MuscleGroup.trapezius,
      MuscleGroup.forearmFlexors,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000012,
    identifier: "overheadPress",
    primaryMuscleGroups: [
      MuscleGroup.frontDeltoid,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.triceps,
      MuscleGroup.lateralDeltoid,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000013,
    identifier: "barbellRows",
    primaryMuscleGroups: [
      MuscleGroup.lats,
      MuscleGroup.trapezius,
      MuscleGroup.rearDeltoids,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.biceps,
      MuscleGroup.lowerBack,
      MuscleGroup.forearmFlexors,
      MuscleGroup.rotatorCuffs,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000014,
    identifier: "cableCrunch",
    primaryMuscleGroups: [
      MuscleGroup.abs,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.obliques,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000015,
    identifier: "dumbbellRow",
    primaryMuscleGroups: [
      MuscleGroup.lats,
      MuscleGroup.trapezius,
      MuscleGroup.rearDeltoids,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.biceps,
      MuscleGroup.forearmFlexors,
      MuscleGroup.rotatorCuffs,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000016,
    identifier: "dumbbellLateralRaise",
    primaryMuscleGroups: [
      MuscleGroup.lateralDeltoid,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.frontDeltoid,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000017,
    identifier: "cableRow",
    primaryMuscleGroups: [
      MuscleGroup.lats,
      MuscleGroup.trapezius,
      MuscleGroup.rearDeltoids,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.biceps,
      MuscleGroup.forearmFlexors,
      MuscleGroup.rotatorCuffs,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000018,
    identifier: "legExtension",
    primaryMuscleGroups: [
      MuscleGroup.quads,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000019,
    identifier: "machineGluteKickback",
    primaryMuscleGroups: [
      MuscleGroup.glutes,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.hamstrings,
      MuscleGroup.adductors,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000020,
    identifier: "tricepPushdown",
    primaryMuscleGroups: [
      MuscleGroup.triceps,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000021,
    identifier: "calfRaise",
    primaryMuscleGroups: [
      MuscleGroup.calves,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000022,
    identifier: "cableCurl",
    primaryMuscleGroups: [
      MuscleGroup.biceps,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.forearmFlexors,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000023,
    identifier: "seatedLegCurl",
    primaryMuscleGroups: [
      MuscleGroup.hamstrings,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000024,
    identifier: "dumbbellShoulderPress",
    primaryMuscleGroups: [
      MuscleGroup.frontDeltoid,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.triceps,
      MuscleGroup.lateralDeltoid,
    ],
    isOneRepMaxMeasurable: true,
  ),
  BuiltInExercise(
    id: 1000000025,
    identifier: "hammerCurl",
    primaryMuscleGroups: [
      MuscleGroup.biceps,
    ],
    secondaryMuscleGroups: [
      MuscleGroup.forearmFlexors,
    ],
    isOneRepMaxMeasurable: true,
  ),
];
