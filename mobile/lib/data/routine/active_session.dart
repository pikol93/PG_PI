import "package:fpdart/fpdart.dart";
import "package:freezed_annotation/freezed_annotation.dart";

part "active_session.g.dart";

part "active_session.freezed.dart";

@freezed
class ActiveSession with _$ActiveSession {
  const factory ActiveSession({
    required DateTime startingDate,
    required int routineId,
    required int workoutId,
    required List<ActiveSessionExercise> exercises,
    @Default(Option.none()) Option<int> currentExerciseIndex,
  }) = _ActiveSession;

  factory ActiveSession.fromJson(Map<String, Object?> json) =>
      _$ActiveSessionFromJson(json);
}

@freezed
class ActiveSessionExercise with _$ActiveSessionExercise {
  const factory ActiveSessionExercise({
    required int exerciseId,
    required List<ActiveSessionSet> sets,
  }) = _ActiveSessionExercise;

  factory ActiveSessionExercise.fromJson(Map<String, Object?> json) =>
      _$ActiveSessionExerciseFromJson(json);
}

@freezed
class ActiveSessionSet with _$ActiveSessionSet {
  const factory ActiveSessionSet({
    required double expectedIntensity,
    required int expectedReps,
    required int expectedRestTimeSeconds,
    @Default(ActiveSessionSetResultUnion.toBeDone())
    ActiveSessionSetResultUnion result,
  }) = _ActiveSessionSet;

  factory ActiveSessionSet.fromJson(Map<String, Object?> json) =>
      _$ActiveSessionSetFromJson(json);
}

@freezed
sealed class ActiveSessionSetResultUnion with _$ActiveSessionSetResultUnion {
  const factory ActiveSessionSetResultUnion.completed(
    ActiveSessionSetResult value,
  ) = Completed;

  const factory ActiveSessionSetResultUnion.skipped() = Skipped;

  const factory ActiveSessionSetResultUnion.toBeDone() = ToBeDone;

  factory ActiveSessionSetResultUnion.fromJson(Map<String, dynamic> json) =>
      _$ActiveSessionSetResultUnionFromJson(json);
}

@freezed
class ActiveSessionSetResult with _$ActiveSessionSetResult {
  const factory ActiveSessionSetResult({
    required double weight,
    required int reps,
    required double rpe,
    required int restTimeSeconds,
  }) = _ActiveSessionSetResult;

  factory ActiveSessionSetResult.fromJson(Map<String, Object?> json) =>
      _$ActiveSessionSetResultFromJson(json);
}
