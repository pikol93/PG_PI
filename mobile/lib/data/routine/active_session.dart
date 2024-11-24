import "package:freezed_annotation/freezed_annotation.dart";

part "active_session.g.dart";
part "active_session.freezed.dart";

@freezed
class ActiveSession with _$ActiveSession {
  const factory ActiveSession({
    required int workoutId,
    required List<SessionExercise> exercises,
  }) = _ActiveSession;

  factory ActiveSession.fromJson(Map<String, Object?> json) =>
      _$ActiveSessionFromJson(json);
}

@freezed
class SessionExercise with _$SessionExercise {
  const factory SessionExercise({
    required int sessionId,
  }) = _SessionExercise;

  factory SessionExercise.fromJson(Map<String, Object?> json) =>
      _$SessionExerciseFromJson(json);
}

@freezed
class SessionSet with _$SessionSet {
  const factory SessionSet({
    required int sessionId,
  }) = _SessionSet;

  factory SessionSet.fromJson(Map<String, Object?> json) =>
      _$SessionSetFromJson(json);
}
