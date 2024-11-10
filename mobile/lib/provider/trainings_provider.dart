import "dart:convert";

import "package:pi_mobile/data/training.dart";
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
}
