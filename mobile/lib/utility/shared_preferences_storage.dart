import 'package:cookie_jar/cookie_jar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesStorage extends Storage {
  const SharedPreferencesStorage();

  @override
  Future<void> init(bool persistSession, bool ignoreExpires) {
    return Future.value(null);
  }

  @override
  Future<String?> read(String key) async {
    final sharedPreferences = SharedPreferencesAsync();
    return await sharedPreferences.getString(key);
  }

  @override
  Future<void> write(String key, String value) async {
    final sharedPreferences = SharedPreferencesAsync();
    await sharedPreferences.setString(key, value);
  }

  @override
  Future<void> delete(String key) async {
    final sharedPreferences = SharedPreferencesAsync();
    await sharedPreferences.remove(key);
  }

  @override
  Future<void> deleteAll(List<String> keys) async {
    final sharedPreferences = SharedPreferencesAsync();
    final futures = keys.map((key) => sharedPreferences.remove(key));

    await Future.wait(futures);
  }
}
