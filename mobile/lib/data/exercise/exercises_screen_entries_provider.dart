import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/data/exercise/exercise_models_provider.dart";
import "package:pi_mobile/data/exercise/one_rep_max_history.dart";
import "package:pi_mobile/data/exercise/one_rep_max_service_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "exercises_screen_entries_provider.g.dart";

class ExercisesScreenEntry {
  final int id;
  final String name;
  final Option<OneRepMaxHistory> oneRepMaxHistory;

  ExercisesScreenEntry({
    required this.id,
    required this.name,
    required this.oneRepMaxHistory,
  });
}

@riverpod
Future<List<ExercisesScreenEntry>> exerciseScreenEntries(Ref ref) async {
  final oneRepMaxService = await ref.watch(oneRepMaxServiceProvider.future);
  final exerciseModels =
      await ref.watch(nameSortedExerciseModelsProvider.future);

  return exerciseModels
      .map(
        (item) async => ExercisesScreenEntry(
          id: item.id,
          name: item.name,
          oneRepMaxHistory: await oneRepMaxService
              .findOneRepMaxHistoryForExercise(item.id)
              .run(),
        ),
      )
      .wait;
}
