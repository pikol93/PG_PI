import 'package:freezed_annotation/freezed_annotation.dart';

part "connection_settings_state.g.dart";
part "connection_settings_state.freezed.dart";

@freezed
class ConnectionSettingsState with _$ConnectionSettingsState {
  const factory ConnectionSettingsState({
    required String serverAddress,
  }) = _ConnectionSettingsState;

  factory ConnectionSettingsState.fromJson(Map<String, Object?> json) =>
      _$ConnectionSettingsStateFromJson(json);
}
