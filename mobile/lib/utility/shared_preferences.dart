import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

extension SharedPreferencesAsyncExtension on SharedPreferencesAsync {
  Future<T?> getFromJson<T>(
    String key,
    T? Function(Map<String, Object?>) constructor,
  ) async {
    final jsonString = await getString(key);
    if (jsonString == null) {
      print("No stored string value for key $key");
      return null;
    }

    final map = jsonDecode(jsonString);
    final constructed = constructor(map);
    if (map == null) {
      print(
          "Could not construct object of type $T from key $key and string $json");
    }

    return constructed;
  }

  Future<void> setToJson<T>(
    String key,
    T obj,
  ) async {
    final json = jsonEncode(obj);
    await setString(key, json);
  }
}
