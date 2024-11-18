import "package:collection/collection.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/data/exercise_model.dart";
import "package:pi_mobile/provider/built_in_exercise_models_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "exercise_models_provider.g.dart";

/// Intermediate object to join lists of built-in exercises and user-created
/// exercises.
///
/// TODO: Since no user-created exercises exist as of yet, this provider only
/// returns build-in exercises. This is to be changed in the future.
@riverpod
Future<List<ExerciseModel>> exerciseModels(Ref ref) async =>
    ref.watch(builtInExerciseModelsProvider);

@riverpod
Future<List<ExerciseModel>> nameSortedExerciseModels(Ref ref) async {
  final models = await ref.watch(exerciseModelsProvider.future);

  return models.sortedBy((item) => item.name);
}

@riverpod
Future<Map<int, ExerciseModel>> exerciseModelsMap(Ref ref) async {
  final models = await ref.watch(exerciseModelsProvider.future);

  return Map.fromEntries(
    models.map((item) => MapEntry(item.id, item)),
  );
}
