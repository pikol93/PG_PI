import "package:dio/dio.dart";
import "package:pi_mobile/data/connection/connection_settings_provider.dart";
import "package:pi_mobile/data/connection/cookie_manager_instance.dart";
import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "dio_instance_provider.g.dart";

@Riverpod(keepAlive: true)
class DioInstance extends _$DioInstance with Logger {
  @override
  Future<Dio> build() async {
    final cookieManager = await ref.watch(cookieManagerInstanceProvider.future);
    final serverAddress = await ref.watch(serverAddressProvider.future);

    logger.debug("Building dio: $serverAddress");
    final dio = Dio(
      BaseOptions(
        baseUrl: serverAddress,
        connectTimeout: const Duration(seconds: 10),
      ),
    );

    dio.interceptors.add(cookieManager);

    return dio;
  }
}
