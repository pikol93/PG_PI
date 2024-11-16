import "dart:convert";

import "package:pi_mobile/data/one_rep_max.dart";
import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "one_rep_max_provider.g.dart";

@Riverpod(keepAlive: true)
class OneRepMaxs extends _$OneRepMaxs with Logger {
  static const _keyName = "oneRepMaxs";

  @override
  Future<List<OneRepMax>> build() async {
    final preferences = SharedPreferencesAsync();
    final jsonList = await preferences.getStringList(_keyName) ?? [];
    final oneRepMaxs =
        jsonList.map((json) => OneRepMax.fromJson(jsonDecode(json))).toList();
    logger.debug("Read ${oneRepMaxs.length} oneRepMax entries");
    return oneRepMaxs;
  }

  Future<OneRepMax> getLatestOneRepMaxMap() async {
    final list = await ref.read(oneRepMaxsProvider.future);
    if (list.isNotEmpty) {
      list.sort((a, b) => b.date.compareTo(a.date));
      return list.first;
    }
    final initObject =
        OneRepMax(oneRepMaxMap: <String, double>{}, date: DateTime.now());
    list.add(initObject);
    final preferences = SharedPreferencesAsync();
    final jsonList = list.map(jsonEncode).toList();
    await preferences.setStringList(_keyName, jsonList);

    ref.invalidateSelf();
    return initObject;
  }

  Future<void> updateOneRepMaxs(String exerciseName, double oneRepMax) async {
    final list = await ref.read(oneRepMaxsProvider.future);
    final oneRepMaxsObject = await getLatestOneRepMaxMap();
    final updatedMap = Map<String, double>.from(oneRepMaxsObject.oneRepMaxMap);

    updatedMap[exerciseName] = oneRepMax;
    final newOneRepMax =
        OneRepMax(oneRepMaxMap: updatedMap, date: DateTime.now());
    list.add(newOneRepMax);

    final preferences = SharedPreferencesAsync();
    final jsonList = list.map(jsonEncode).toList();
    await preferences.setStringList(_keyName, jsonList);

    ref.invalidateSelf();
  }

  Future<double> getCertainOneRepMax(String exercise) async {
    final oneRepMaxsObject = await getLatestOneRepMaxMap();
    if (oneRepMaxsObject.oneRepMaxMap.containsKey(exercise)) {
      return oneRepMaxsObject.oneRepMaxMap[exercise]!;
    } else {
      return 0;
    }
  }

  int getPercentageOfRepMax(int reps) {
    switch (reps) {
      case 1:
        return 100;
      case 2:
        return 92;
      case 3:
        return 90;
      case 4:
        return 87;
      case 5:
        return 85;
      case 6:
        return 82;
      case 7:
        return 75;
      case 8:
        return 75;
      case 9:
        return 70;
      case 10:
        return 70;
      case 11:
        return 65;
      case 12:
        return 65;
      case 13:
        return 60;
      case 14:
        return 60;
      case 15:
        return 60;
      default:
        return 0;
    }
  }
}
