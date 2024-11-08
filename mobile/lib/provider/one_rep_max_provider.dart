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

  Future<void> updateOneRepMaxs(MapEntry<String, double> newValue) async {
    final list = await ref.read(oneRepMaxsProvider.future);
    final oneRepMaxsObject = await getLatestOneRepMaxMap();
    final updatedMap = Map<String, double>.from(oneRepMaxsObject.oneRepMaxMap);

    updatedMap[newValue.key] = newValue.value;
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
}
