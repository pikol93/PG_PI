import 'package:pi_mobile/service/stored_locale_service.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part "stored_locale_provider.g.dart";

// Please note that this provider does not update the locale of this
// application. Instead the purpose of this class is to update relevant widgets.
@riverpod
class StoredLocale extends _$StoredLocale {
  static const _keyName = StoredLocaleService.keyName;

  @override
  Future<String?> build() async {
    final preferences = SharedPreferencesAsync();
    return preferences.getString(_keyName);
  }

  void forceRebuild() {
    ref.invalidateSelf();
  }
}