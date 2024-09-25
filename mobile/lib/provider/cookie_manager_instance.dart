import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:pi_mobile/logger.dart';
import 'package:pi_mobile/utility/shared_preferences_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part "cookie_manager_instance.g.dart";

@Riverpod(keepAlive: true)
class CookieManagerInstance extends _$CookieManagerInstance with Logger {
  @override
  Future<CookieManager> build() async {
    logger.debug("Building cookie manager");

    return CookieManager(
      PersistCookieJar(
        storage: const SharedPreferencesStorage(),
      ),
    );
  }
}
