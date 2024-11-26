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
  const ActiveSessionExercise._();

  const factory ActiveSessionExercise({
    required int exerciseId,
    required List<ActiveSessionSet> sets,
  }) = _ActiveSessionExercise;

  factory ActiveSessionExercise.fromJson(Map<String, Object?> json) =>
      _$ActiveSessionExerciseFromJson(json);

  bool isCompleted() => sets.all(
        (set) => switch (set.result) {
          Completed() => true,
          Rest() => true,
          Skipped() => true,
          ToBeDone() => false,
        },
      );
}

@freezed
class ActiveSessionSet with _$ActiveSessionSet {
  const ActiveSessionSet._();

  const factory ActiveSessionSet({
    required double expectedIntensity,
    required int expectedReps,
    required int expectedRestTimeSeconds,
    required double expectedWeight,
    @Default(ActiveSessionSetResultUnion.toBeDone())
    ActiveSessionSetResultUnion result,
  }) = _ActiveSessionSet;

  Option<ActiveSessionSet> complete(
    DateTime now,
  ) =>
      switch (result) {
        Rest(:final value, :final restStart) => Option.of(
            ActiveSessionSetResultUnion.completed(
              value,
              now.difference(restStart).inSeconds,
            ),
          ),
        _ => const Option.none()
      }
          .map((resultUnion) => copyWith(result: resultUnion));

  Option<ActiveSessionSet> startResting(
    ActiveSessionSetResult result,
    DateTime now,
  ) =>
      switch (this.result) {
        ToBeDone() => Option.of(
            ActiveSessionSetResultUnion.resting(result, now),
          ),
        _ => const Option.none(),
      }
          .map((resultUnion) => copyWith(result: resultUnion));

  factory ActiveSessionSet.fromJson(Map<String, Object?> json) =>
      _$ActiveSessionSetFromJson(json);

  ActiveSessionSet skip() => copyWith(
        result: const ActiveSessionSetResultUnion.skipped(),
      );
}

@freezed
sealed class ActiveSessionSetResultUnion with _$ActiveSessionSetResultUnion {
  const factory ActiveSessionSetResultUnion.completed(
    ActiveSessionSetResult value,
    int restTimeSeconds,
  ) = Completed;

  const factory ActiveSessionSetResultUnion.resting(
    ActiveSessionSetResult value,
    DateTime restStart,
  ) = Rest;

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
  }) = _ActiveSessionSetResult;

  factory ActiveSessionSetResult.fromJson(Map<String, Object?> json) =>
      _$ActiveSessionSetResultFromJson(json);
}
