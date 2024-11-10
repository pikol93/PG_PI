import "dart:convert";

import "package:pi_mobile/data/training.dart";
import "package:pi_mobile/data/training_exercise.dart";
import "package:pi_mobile/data/training_exercise_set.dart";
import "package:pi_mobile/data/training_workload.dart";
import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "trainings_provider.g.dart";

@Riverpod(keepAlive: true)
class Trainings extends _$Trainings with Logger {
  static const _keyName = "trainings";

  @override
  Future<List<Training>> build() async {
    final preferences = SharedPreferencesAsync();
    final jsonList = await preferences.getStringList(_keyName) ?? [];
    final trainings =
        jsonList.map((json) => Training.fromJson(jsonDecode(json))).toList();

    logger.debug("Read ${trainings.length} trainings");
    return trainings;
  }

  Future<void> addTraining(Training training) async {
    final list = await ref.read(trainingsProvider.future);
    list.add(training);

    final preferences = SharedPreferencesAsync();
    final jsonList = list.map(jsonEncode).toList();
    await preferences.setStringList(_keyName, jsonList);

    ref.invalidateSelf();
  }

  Future<Training> readTraining(String trainingUuid) async {
    final list = await ref.read(trainingsProvider.future);
    return list.firstWhere((training) => trainingUuid == training.trainingUuid);
  }

  Future<TrainingWorkload> readWorkout(String trainingUuid) async {
    final list = await ref.read(trainingsProvider.future);
    return list
        .firstWhere((training) => trainingUuid == training.trainingUuid)
        .trainingWorkload;
  }

  Future<TrainingExercise> readExercise(
    String trainingUuid,
    String exerciseUuid,
  ) async {
    final list = await ref.read(trainingsProvider.future);
    return list
        .firstWhere((training) => trainingUuid == training.trainingUuid)
        .trainingWorkload
        .trainingExercises
        .firstWhere(
          (exercise) => exerciseUuid == exercise.trainingExerciseUuid,
        );
  }

  Future<TrainingExerciseSet> readExerciseSet(
    String trainingUuid,
    String exerciseUuid,
    String exerciseSetUuid,
  ) async {
    final list = await ref.read(trainingsProvider.future);
    return list
        .firstWhere((training) => trainingUuid == training.trainingUuid)
        .trainingWorkload
        .trainingExercises
        .firstWhere(
          (exercise) => exerciseUuid == exercise.trainingExerciseUuid,
        )
        .exerciseSets
        .firstWhere((exerciseSet) =>
            exerciseSetUuid == exerciseSet.trainingExerciseSetUuid,);
  }

  Future<void> updateExerciseSet(
    String trainingUuid,
    String exerciseUuid,
    TrainingExerciseSet updatedSet,
  ) async {
    final trainings = await ref.read(trainingsProvider.future);

    final updatedTrainings = trainings.map((training) {
      if (training.trainingUuid == trainingUuid) {
        final workload = training.trainingWorkload;
        final updatedExercises = workload.trainingExercises.map((exercise) {
          if (exercise.trainingExerciseUuid == exerciseUuid) {
            final updatedExerciseSets = exercise.exerciseSets.map((set) {
              if (set.trainingExerciseSetUuid ==
                  updatedSet.trainingExerciseSetUuid) {
                return updatedSet;
              }
              return set;
            }).toList();
            return exercise.copyWith(exerciseSets: updatedExerciseSets);
          }
          return exercise;
        }).toList();
        final updatedWorkload =
            workload.copyWith(trainingExercises: updatedExercises);
        return training.copyWith(trainingWorkload: updatedWorkload);
      }
      return training;
    }).toList();

    final preferences = SharedPreferencesAsync();
    final jsonList = updatedTrainings.map(jsonEncode).toList();
    await preferences.setStringList(_keyName, jsonList);

    ref.invalidateSelf();
  }
}
