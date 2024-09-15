import 'package:pi_mobile/data/auth_state.dart';
import 'package:pi_mobile/utility/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part "auth_provider.g.dart";

@riverpod
class Auth extends _$Auth {
  static const keyName = "auth";

  @override
  Future<AuthState?> build() async {
    final preferences = SharedPreferencesAsync();
    return await preferences.getFromJson(keyName, AuthState.fromJson);
  }

  Future<void> logOff() async {
    print("Logging off...");
    final preferences = SharedPreferencesAsync();
    await preferences.remove(keyName);

    ref.invalidateSelf();
  }
}
