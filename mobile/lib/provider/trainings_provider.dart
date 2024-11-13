import "dart:convert";

import "package:pi_mobile/data/training.dart";
import "package:pi_mobile/data/training_exercise.dart";
import "package:pi_mobile/data/training_exercise_set.dart";
import "package:pi_mobile/data/training_workload.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/one_rep_max_provider.dart";
import "package:pi_mobile/provider/schemas_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";
import "package:uuid/uuid.dart";

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

  Future<void> deleteTrainingsHistory() async {
    final list = <Training>[];
    final preferences = SharedPreferencesAsync();
    final jsonList = list.map(jsonEncode).toList();
    await preferences.setStringList(_keyName, jsonList);

    ref.invalidateSelf();
  }

  Future<void> addTraining(Training training) async {
    final list = await ref.read(trainingsProvider.future);
    list.add(training);

    final preferences = SharedPreferencesAsync();
    final jsonList = list.map(jsonEncode).toList();
    await preferences.setStringList(_keyName, jsonList);

    ref.invalidateSelf();
  }

  Future<Training> getTraining(String trainingUuid) async {
    final list = await ref.read(trainingsProvider.future);
    return list.firstWhere((training) => trainingUuid == training.uuid);
  }

  Future<TrainingWorkload> getWorkout(String trainingUuid) async {
    final list = await ref.read(trainingsProvider.future);
    return list
        .firstWhere((training) => trainingUuid == training.uuid)
        .trainingWorkload;
  }

  Future<void> endTraining(String trainingUuid) async {
    final trainings = await ref.read(trainingsProvider.future);
    final updatedTrainings = trainings.map((training) {
      if (training.uuid == trainingUuid) {
        return training.copyWith(endDate: DateTime.now(), isFinished: true);
      }
      return training;
    });

    final preferences = SharedPreferencesAsync();
    final jsonList = updatedTrainings.map(jsonEncode).toList();
    await preferences.setStringList(_keyName, jsonList);

    ref.invalidateSelf();
  }

  Future<TrainingExercise> getExercise(
    String trainingUuid,
    String exerciseUuid,
  ) async {
    final list = await ref.read(trainingsProvider.future);
    return list
        .firstWhere((training) => trainingUuid == training.uuid)
        .trainingWorkload
        .trainingExercises
        .firstWhere(
          (exercise) => exerciseUuid == exercise.trainingExerciseUuid,
        );
  }

  Future<TrainingExerciseSet> getExerciseSet(
    String trainingUuid,
    String exerciseUuid,
    String exerciseSetUuid,
  ) async {
    final list = await ref.read(trainingsProvider.future);
    return list
        .firstWhere((training) => trainingUuid == training.uuid)
        .trainingWorkload
        .trainingExercises
        .firstWhere(
          (exercise) => exerciseUuid == exercise.trainingExerciseUuid,
        )
        .exerciseSets
        .firstWhere(
          (exerciseSet) => exerciseSetUuid == exerciseSet.uuid,
        );
  }

  Future<void> updateExercise(
    String trainingUuid,
    TrainingExercise updatedExercise,
  ) async {
    final trainings = await ref.read(trainingsProvider.future);

    final updatedTrainings = trainings.map((training) {
      if (training.uuid == trainingUuid) {
        final workload = training.trainingWorkload;
        final updatedExercises = workload.trainingExercises.map((exercise) {
          if (exercise.trainingExerciseUuid ==
              updatedExercise.trainingExerciseUuid) {
            return updatedExercise;
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

  Future<void> updateExerciseSet(
    String trainingUuid,
    String exerciseUuid,
    TrainingExerciseSet updatedSet,
  ) async {
    final trainings = await ref.read(trainingsProvider.future);

    final updatedTrainings = trainings.map((training) {
      if (training.uuid == trainingUuid) {
        final workload = training.trainingWorkload;
        final updatedExercises = workload.trainingExercises.map((exercise) {
          if (exercise.trainingExerciseUuid == exerciseUuid) {
            final updatedExerciseSets = exercise.exerciseSets.map((set) {
              if (set.uuid == updatedSet.uuid) {
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

  Future<String> addEmptyTraining(
    String routineUuid,
    String workoutUuid,
  ) async {
    final routineSchema =
        await ref.read(schemasProvider.notifier).getRoutine(routineUuid);

    final workoutSchema = await ref
        .read(schemasProvider.notifier)
        .getWorkout(routineUuid, workoutUuid);

    final trainingExercisesBlank = <TrainingExercise>[];
    for (final exerciseSchema in workoutSchema.exercisesSchemas) {
      final trainingExerciseSetsBlank = <TrainingExerciseSet>[];

      final oneRepMax = await ref
          .read(oneRepMaxsProvider.notifier)
          .getCertainOneRepMax(exerciseSchema.name);

      for (final exerciseSchemaSet in exerciseSchema.sets) {
        trainingExerciseSetsBlank.add(
          TrainingExerciseSet(
            uuid: const Uuid().v4(),
            exerciseSetSchemaUuid: exerciseSchemaSet.uuid,
            exerciseName: exerciseSchema.name,
            expectedReps: exerciseSchemaSet.reps,
            expectedIntensity: exerciseSchemaSet.intensity,
            expectedWeight: (exerciseSchemaSet.intensity * 0.01 * oneRepMax)
                .floorToDouble(),
            weight: 0,
            reps: 0,
            rpe: 0,
            isFinished: false,
          ),
        );
      }

      trainingExercisesBlank.add(
        TrainingExercise(
          name: exerciseSchema.name,
          trainingExerciseUuid: const Uuid().v4(),
          exerciseSchemaUuid: exerciseSchema.uuid,
          wasStarted: false,
          isFinished: false,
          exerciseSets: trainingExerciseSetsBlank,
        ),
      );
    }

    final emptyTraining = Training(
      uuid: const Uuid().v4(),
      trainingName: workoutSchema.name,
      routineName: routineSchema.name,
      routineSchemaUuid: routineUuid,
      workoutSchemaUuid: workoutUuid,
      startDate: DateTime.now(),
      endDate: DateTime(2023),
      isFinished: false,
      trainingWorkload: TrainingWorkload(
        uuid: const Uuid().v4(),
        trainingExercises: trainingExercisesBlank,
      ),
    );

    await addTraining(emptyTraining);
    return emptyTraining.uuid;
  }

  Future<bool> checkExerciseComplition(
    String trainingUuid,
    String exerciseUuid,
  ) async {
    final exercise = await getExercise(trainingUuid, exerciseUuid);
    final sets = exercise.exerciseSets;

    var areAllExercisesCompleted = true;

    for (var set in sets) {
      if (!set.isFinished) {
        areAllExercisesCompleted = false;
      }
    }

    if (areAllExercisesCompleted) {
      final finishedExercise = exercise.copyWith(isFinished: true);
      await updateExercise(trainingUuid, finishedExercise);
    }
    return areAllExercisesCompleted;
  }

  Future<bool> isAnyPendingTraining() async {
    final list = await ref.read(trainingsProvider.future);
    return list.any((training) => !training.isFinished);
  }
}
