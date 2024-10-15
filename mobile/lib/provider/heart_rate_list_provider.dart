import "dart:convert";

import "package:pi_mobile/data/heart_rate_entry.dart";
import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "heart_rate_list_provider.g.dart";

@Riverpod(keepAlive: true)
class HeartRateList extends _$HeartRateList with Logger {
  static const _keyName = "heart_rate";

  @override
  Future<List<HeartRateEntry>> build() async {
    final preferences = SharedPreferencesAsync();
    final jsonList = await preferences.getStringList(_keyName) ?? [];
    final tracks = jsonList
        .map((json) => HeartRateEntry.fromJson(jsonDecode(json)))
        .toList();

    logger.debug("Read ${tracks.length} tracks");
    return tracks;
  }

  Future<void> addEntry(HeartRateEntry entry) async {
    final list = await ref.read(heartRateListProvider.future);
    list.add(entry);

    final preferences = SharedPreferencesAsync();
    final jsonList = list.map(jsonEncode).toList();
    await preferences.setStringList(_keyName, jsonList);

    ref.invalidateSelf();
  }
}
