import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pi_mobile/logger.dart';
import 'package:pi_mobile/provider/auth_provider.dart';
import 'package:pi_mobile/provider/dio_instance_provider.dart';

final authServiceProvider = Provider((ref) => AuthService(ref: ref));

enum LoginError {
  unauthorized,
  noResponse,
  unknownError,
}

class AuthService with Logger {
  final Ref ref;

  AuthService({required this.ref});

  Future<LoginError?> logIn(String username) async {
    logger.debug("Logging in as $username");
    final dio = await ref.read(dioInstanceProvider.future);
    final Response<String> response;
    try {
      response = await dio.post<String>(
        "/login",
        data: {
          "name": username,
        },
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
    } on DioException catch (ex) {
      logger.warning("Exception: $ex");
      final response = ex.response;
      if (response == null) {
        return LoginError.noResponse;
      }

      if (response.statusCode == HttpStatus.unauthorized) {
        return LoginError.unauthorized;
      }

      return LoginError.unknownError;
    }

    if (response.statusCode != HttpStatus.ok) {
      logger.warning("Status code is not valid.");
      return LoginError.unknownError;
    }

    ref.read(authProvider.notifier).logIn(username);
    return null;
  }

  void invalidateAuthentication() {
    ref.read(authProvider.notifier).logOff();
  }
}
