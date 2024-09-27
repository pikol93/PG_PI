import "package:freezed_annotation/freezed_annotation.dart";
import "package:pi_mobile/data/workload.dart";

part "workout.g.dart";
part "workout.freezed.dart";

@freezed
class Workout with _$Workout {
  const factory Workout({
    required DateTime date,
    required List<Workload> exercises,
  }) = _Workout;

  factory Workout.fromJson(Map<String, Object?> json) =>
      _$WorkoutFromJson(json);
}
