import "dart:io";

import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:pi_mobile/provider/dio_instance_provider.dart";
import "package:pi_mobile/provider/proof_of_work_service_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "sharing_service_provider.g.dart";

part "sharing_service_provider.freezed.dart";

@riverpod
Future<SharingService> sharingService(SharingServiceRef ref) async {
  final dio = await ref.watch(dioInstanceProvider.future);
  final proofOfWorkService = await ref.watch(proofOfWorkServiceProvider.future);
  return SharingService(
    ref: ref,
    dio: dio,
    proofOfWorkService: proofOfWorkService,
  );
}

class SharingService {
  final Ref ref;
  final Dio dio;
  final ProofOfWorkService proofOfWorkService;

  SharingService({
    required this.ref,
    required this.dio,
    required this.proofOfWorkService,
  });

  TaskEither<String, ()> share(DataToShare data) => proofOfWorkService
      .requestToken()
      .map((token) => _sendShareRequest(token, data))
      .flatMap((value) => value);

  TaskEither<String, ()> _sendShareRequest(String token, DataToShare data) =>
      TaskEither.tryCatch(
        () async {
          final result = await dio.post(
            "/share/$token",
            data: data.toJson(),
          );

          if (result.statusCode != HttpStatus.ok) {
            throw StateError("Returned invalid HTTP status.");
          }

          return ();
        },
        (e, stackTrace) => "$e",
      );
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
