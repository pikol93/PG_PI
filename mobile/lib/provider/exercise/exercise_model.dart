import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/provider/exercise/muscle_group.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "exercise_model.g.dart";

class ExerciseModel {
  final int id;
  final String name;
  final List<String> steps;
  final List<MuscleGroup> primaryMuscleGroups;
  final List<MuscleGroup>? secondaryMuscleGroups;
  final String? author;
  final bool isDeletable;
  final bool isOneRepMaxMeasurable;

  ExerciseModel({
    required this.id,
    required this.name,
    required this.steps,
    required this.primaryMuscleGroups,
    required this.secondaryMuscleGroups,
    this.author,
    this.isDeletable = false,
    this.isOneRepMaxMeasurable = false,
  });
}

@riverpod
BuiltInExerciseService builtInExerciseService(Ref ref) =>
    BuiltInExerciseService(ref: ref);

class BuiltInExerciseService {
  final Ref ref;

  BuiltInExerciseService({
    required this.ref,
  });
}
