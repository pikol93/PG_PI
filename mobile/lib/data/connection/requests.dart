import "package:freezed_annotation/freezed_annotation.dart";
import "package:pi_mobile/data/connection/shared_data.dart";

part "requests.g.dart";
part "requests.freezed.dart";

@freezed
class ShareRequest with _$ShareRequest {
  const factory ShareRequest({
    required int validityMillis,
    required SharedData sharedData,
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
