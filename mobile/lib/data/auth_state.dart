import 'package:freezed_annotation/freezed_annotation.dart';

part "auth_state.g.dart";
part "auth_state.freezed.dart";

@freezed
class AuthState with _$AuthState {
  const factory AuthState({
    required String username,
  }) = _AuthState;

  factory AuthState.fromJson(Map<String, Object?> json) =>
      _$AuthStateFromJson(json);
}