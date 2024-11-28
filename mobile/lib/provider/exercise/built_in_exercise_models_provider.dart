import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/exercise/built_in_exercises.dart";
import "package:pi_mobile/provider/exercise/exercise_model.dart";
import "package:pi_mobile/provider/preferences/date_formatter_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "built_in_exercise_models_provider.g.dart";

@riverpod
class BuiltInExerciseModels extends _$BuiltInExerciseModels with Logger {
  @override
  List<ExerciseModel> build() {
    final exercisesTranslationMap =
        ref.watch(currentLocaleProvider).translations.exercises.exercises;

    return builtInExercises.map((item) {
      final translationMap = exercisesTranslationMap[item.identifier];
      if (translationMap == null) {
        logger.warning(
          "No translation for \"${item.identifier}\" (${item.id}}",
        );

        return ExerciseModel(
          id: item.id,
          name: "MISSING TRANSLATION FOR \"${item.identifier}\" (${item.id})",
          steps: [],
          primaryMuscleGroups: item.primaryMuscleGroups,
          secondaryMuscleGroups: item.secondaryMuscleGroups,
          isOneRepMaxMeasurable: item.isOneRepMaxMeasurable,
        );
      }

      final name = translationMap.name;
      final steps = translationMap.steps;

      return ExerciseModel(
        id: item.id,
        name: name,
        steps: steps,
        primaryMuscleGroups: item.primaryMuscleGroups,
        secondaryMuscleGroups: item.secondaryMuscleGroups,
        isOneRepMaxMeasurable: item.isOneRepMaxMeasurable,
      );
    }).toList();
  }
}
