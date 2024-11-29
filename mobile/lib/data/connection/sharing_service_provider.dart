import "dart:io";

import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:pi_mobile/data/connection/dio_instance_provider.dart";
import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "sharing_service_provider.freezed.dart";
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

@freezed
class ShareRequest with _$ShareRequest {
  const factory ShareRequest({
    required int validityMillis,
    required DataToShare dataToShare,
  }) = _ShareRequest;

  factory ShareRequest.fromJson(Map<String, Object?> json) =>
      _$ShareRequestFromJson(json);
}

@freezed
class ShareResponse with _$ShareResponse {
  const factory ShareResponse({
    required String id,
  }) = _ShareResponse;

  factory ShareResponse.fromJson(Map<String, Object?> json) =>
      _$ShareResponseFromJson(json);
}

@freezed
class DataToShare with _$DataToShare {
  const factory DataToShare({
    required String something,
    required String something2,
  }) = _DataToShare;

  factory DataToShare.fromJson(Map<String, Object?> json) =>
      _$DataToShareFromJson(json);
}
