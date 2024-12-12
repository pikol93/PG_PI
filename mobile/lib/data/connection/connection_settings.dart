import "package:fpdart/fpdart.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "connection_settings.g.dart";

part "connection_settings.freezed.dart";

@freezed
class ConnectionSettings with _$ConnectionSettings {
  const ConnectionSettings._();

  const factory ConnectionSettings({
    required String serverAddress,
    required bool isSecure,
  }) = _ConnectionSettings;

  factory ConnectionSettings.fromJson(Map<String, Object?> json) =>
      _$ConnectionSettingsFromJson(json);

  String getAddress() => "${isSecure ? "https" : "http"}://$serverAddress";

  Either<FormatException, Uri> createSessionEndpointUrl(String id) =>
      Either.tryCatch(
        () => Uri.parse("${getAddress()}/ui/$id"),
        (a, b) => a as FormatException,
      );
}
