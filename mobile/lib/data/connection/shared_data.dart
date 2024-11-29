import "package:freezed_annotation/freezed_annotation.dart";

part "shared_data.g.dart";

part "shared_data.freezed.dart";

@freezed
class SharedData with _$SharedData {
  const factory SharedData({
    required DateTime shareDate,
    required List<SharedSession> sessions,
    required List<SharedExercise> exercises,
    required List<SharedRoutine> routines,
  }) = _SharedData;

  factory SharedData.fromJson(Map<String, Object?> json) =>
      _$SharedDataFromJson(json);
}

@freezed
class SharedSession with _$SharedSession {
  const factory SharedSession({
    required int id,
    required int routineId,
    required int workoutId,
    required DateTime startDate,
    required List<SharedSessionExercise> exercises,
  }) = _SharedSession;

  factory SharedSession.fromJson(Map<String, Object?> json) =>
      _$SharedSessionFromJson(json);
}

@freezed
class SharedSessionExercise with _$SharedSessionExercise {
  const factory SharedSessionExercise({
    required int exerciseId,
    required List<SharedSet> sets,
  }) = _SharedSessionExercise;

  factory SharedSessionExercise.fromJson(Map<String, Object?> json) =>
      _$SharedSessionExerciseFromJson(json);
}

@freezed
class SharedSet with _$SharedSet {
  const factory SharedSet({
    required int reps,
    required double weight,
    required double rpe,
    required int restSecs,
  }) = _SharedSet;

  factory SharedSet.fromJson(Map<String, Object?> json) =>
      _$SharedSetFromJson(json);
}

@freezed
class SharedExercise with _$SharedExercise {
  const factory SharedExercise({
    required int id,
    required String name,
  }) = _SharedExercise;

  factory SharedExercise.fromJson(Map<String, Object?> json) =>
      _$SharedExerciseFromJson(json);
}

@freezed
class SharedRoutine with _$SharedRoutine {
  const factory SharedRoutine({
    required int id,
    required String name,
    required List<SharedWorkout> workouts,
  }) = _SharedRoutine;

  factory SharedRoutine.fromJson(Map<String, Object?> json) =>
      _$SharedRoutineFromJson(json);
}

@freezed
class SharedWorkout with _$SharedWorkout {
  const factory SharedWorkout({
    required int id,
    required String name,
    required List<SharedWorkoutExercise> exercises,
  }) = _SharedWorkout;

  factory SharedWorkout.fromJson(Map<String, Object?> json) =>
      _$SharedWorkoutFromJson(json);
}

@freezed
class SharedWorkoutExercise with _$SharedWorkoutExercise {
  const factory SharedWorkoutExercise({
    required int exerciseId,
    required List<SharedExerciseSet> sets,
  }) = _SharedWorkoutExercise;

  factory SharedWorkoutExercise.fromJson(Map<String, Object?> json) =>
      _$SharedWorkoutExerciseFromJson(json);
}

@freezed
class SharedExerciseSet with _$SharedExerciseSet {
  const factory SharedExerciseSet({
    required double intensity,
    required int reps,
    @Default(false) bool isAmrap,
  }) = _SharedExerciseSet;

  factory SharedExerciseSet.fromJson(Map<String, Object?> json) =>
      _$SharedExerciseSetFromJson(json);
}
