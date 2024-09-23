import 'package:pi_mobile/data/auth_state.dart';
import 'package:pi_mobile/logger.dart';
import 'package:pi_mobile/utility/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part "auth_provider.g.dart";

@riverpod
class Auth extends _$Auth with Logger {
  static const keyName = "auth";

  @override
  Future<AuthState?> build() async {
    final preferences = SharedPreferencesAsync();
    return await preferences.getFromJson(keyName, AuthState.fromJson);
  }

  /// Logs in the user. This is to be redone in the future.
  Future<void> logIn(String username) async {
    logger.debug("Logging in as $username...");
    final preferences = SharedPreferencesAsync();
    await preferences.setToJson(keyName, AuthState(username: username));

    ref.invalidateSelf();
  }

  Future<void> logOff() async {
    logger.debug("Logging off...");
    final preferences = SharedPreferencesAsync();
    await preferences.remove(keyName);

    ref.invalidateSelf();
  }
}
