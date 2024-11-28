import "dart:math";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/provider/exercise/exercise_model.dart";
import "package:pi_mobile/provider/exercise/exercise_models_provider.dart";
import "package:pi_mobile/provider/exercise/one_rep_max_service_provider.dart";
import "package:pi_mobile/utility/random.dart";
import "package:pi_mobile/utility/task.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "exercise_model_service_provider.g.dart";

@riverpod
Future<ExerciseModelService> exerciseModelService(Ref ref) async {
  final oneRepMaxService = await ref.watch(oneRepMaxServiceProvider.future);
  final modelsMap = await ref.watch(exerciseModelsMapProvider.future);

  return ExerciseModelService(
    oneRepMaxService: oneRepMaxService,
    modelsMap: modelsMap,
  );
}

class ExerciseModelService {
  final OneRepMaxService oneRepMaxService;
  final Map<int, ExerciseModel> modelsMap;

  ExerciseModelService({
    required this.oneRepMaxService,
    required this.modelsMap,
  });

  Task<List<int>> generateData() => modelsMap.entries
      .map((item) {
        if (!item.value.isOneRepMaxMeasurable) {
          return null;
        }

        return _generateDataForSpecificExercise(item.key);
      })
      .where((item) => item != null)
      .map((item) => item!)
      .joinAll();

  Task<int> _generateDataForSpecificExercise(int exerciseId) => Task(() async {
        const processLength = Duration(days: 210);
        const durationMin = Duration(days: 20);
        const durationMax = Duration(days: 40);
        const minOneRepMax = 60.0;
        const minDelta = 2.0;
        const maxDelta = 4.0;

        final random = Random();
        final startTime = DateTime.now().subtract(processLength);
        final endTime = DateTime.now();

        var currentTime = startTime;
        var lastOneRepMax = minOneRepMax;
        while (currentTime.isBefore(endTime)) {
          lastOneRepMax += random.nextRangeDouble(minDelta, maxDelta);

          await oneRepMaxService
              .insertEntry(
                exerciseId,
                currentTime,
                lastOneRepMax,
              )
              .run();

          final nextDuration = random.nextDuration(durationMin, durationMax);
          currentTime = currentTime.add(nextDuration);
        }

        return exerciseId;
      });
}
