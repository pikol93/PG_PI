import "dart:io";

import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/data/connection/dio_instance_provider.dart";
import "package:pi_mobile/data/connection/requests.dart";
import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "sharing_service_provider.g.dart";

@riverpod
Future<SharingService> sharingService(Ref ref) async {
  final dio = await ref.watch(dioInstanceProvider.future);
  return SharingService(
    ref: ref,
    dio: dio,
  );
}

class SharingService with Logger {
  final Ref ref;
  final Dio dio;

  SharingService({
    required this.ref,
    required this.dio,
  });

  TaskEither<String, String> share(ShareRequest request) => TaskEither.tryCatch(
        () async {
          final result = await dio.post<Map<String, dynamic>>(
            "/share",
            data: request.toJson(),
          );

          if (result.statusCode != HttpStatus.ok) {
            throw StateError("Returned invalid HTTP status.");
          }

          final response = ShareResponse.fromJson(result.data!);
          logger.debug("Response: $response");

          return response.id;
        },
        (e, stackTrace) {
          logger.debug("Failed sharing. $e $stackTrace");
          return "$e";
        },
      );
}
