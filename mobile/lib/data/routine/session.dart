import "package:isar/isar.dart";

part "session.g.dart";

@collection
class Session {
  Id id = Isar.autoIncrement;
  @Index(type: IndexType.value)
  @Index(composite: [CompositeIndex("workoutId")])
  late int routineId;
  late int workoutId;
  @Index(type: IndexType.value)
  late DateTime startDate;
  late List<SessionExercise> exercises;
}

@embedded
class SessionExercise {
  late int exerciseId;
  late List<SessionSet> sets;
}

@embedded
class SessionSet {
  late double weight;
  late int reps;
  late double rpe;
  late int restTimeSeconds;
}
