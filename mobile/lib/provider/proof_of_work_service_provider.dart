import "package:dio/dio.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:freezed_annotation/freezed_annotation.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/provider/dio_instance_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "proof_of_work_service_provider.g.dart";

part "proof_of_work_service_provider.freezed.dart";

@riverpod
Future<ProofOfWorkService> proofOfWorkService(ProofOfWorkServiceRef ref) async {
  final dio = await ref.watch(dioInstanceProvider.future);
  return ProofOfWorkService(
    ref: ref,
    dio: dio,
  );
}

class ProofOfWorkService with Logger {
  final Ref ref;
  final Dio dio;

  ProofOfWorkService({
    required this.ref,
    required this.dio,
  });

  TaskEither<String, String> requestToken() => TaskEither.tryCatch(
        () async {
          logger.debug("Sending a puzzle request");
          final requestPuzzleResponse = await dio.post("/request_puzzle");
          final puzzleResponse = PuzzleResponse.fromJson(
            requestPuzzleResponse.data,
          );

          final solution = _solve(puzzleResponse.uuid);
          final solutionResponse = await dio.post(
            "/puzzle_solution",
            data: PuzzleSolutionRequest(
              uuid: puzzleResponse.uuid,
              solution: solution,
            ).toJson(),
            options: Options(
              contentType: Headers.jsonContentType,
            ),
          );

          final tokenResponse = PuzzleSolutionResponse.fromJson(
            solutionResponse.data,
          );
          return tokenResponse.token;
        },
        (e, stackTrace) => "$e",
      );

  String _solve(String uuid) => "foo result";
}

@freezed
class PuzzleResponse with _$PuzzleResponse {
  const factory PuzzleResponse({
    required String uuid,
  }) = _PuzzleResponse;

  factory PuzzleResponse.fromJson(Map<String, Object?> json) =>
      _$PuzzleResponseFromJson(json);
}

@freezed
class PuzzleSolutionRequest with _$PuzzleSolutionRequest {
  const factory PuzzleSolutionRequest({
    required String uuid,
    required String solution,
  }) = _PuzzleSolutionRequest;

  factory PuzzleSolutionRequest.fromJson(Map<String, Object?> json) =>
      _$PuzzleSolutionRequestFromJson(json);
}

@freezed
class PuzzleSolutionResponse with _$PuzzleSolutionResponse {
  const factory PuzzleSolutionResponse({
    required String token,
  }) = _PuzzleSolutionResponse;

  factory PuzzleSolutionResponse.fromJson(Map<String, Object?> json) =>
      _$PuzzleSolutionResponseFromJson(json);
}
