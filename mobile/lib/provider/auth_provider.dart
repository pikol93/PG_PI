import 'package:pi_mobile/data/auth_state.dart';
import 'package:pi_mobile/utility/shared_preferences.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part "auth_provider.g.dart";

@riverpod
class Auth extends _$Auth {
  @override
  Future<AuthState?> build() async {
    final preferences = SharedPreferencesAsync();
    return await preferences.getFromJson("auth", AuthState.fromJson);
  }
}
