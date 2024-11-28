import "package:flutter_test/flutter_test.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/data/routine/built_in_routines.dart";
import "package:pi_mobile/utility/iterable.dart";

void main() {
  test("Built in routines should not contain duplicate IDs", () {
    final actualLength = builtInRoutines.length;
    final expectedLength =
        builtInRoutines.uniqueByKey((item) => item.id).length;

    expect(actualLength, expectedLength);
  });

  test("Built in routines should not contain duplicate identifiers", () {
    final actualLength = builtInRoutines.length;
    final expectedLength =
        builtInRoutines.uniqueByKey((item) => item.identifier).length;

    expect(actualLength, expectedLength);
  });

  test("Every built in routine should have an ID of at least two billion", () {
    final item =
        builtInRoutines.where((item) => item.id < 2000000000).firstOrNull;

    expect(null, item);
  });

  test("Built in workouts should not contain duplicate IDs", () {
    final actualLength =
        builtInRoutines.flatMap((routine) => routine.workouts).length;
    final expectedLength = builtInRoutines
        .flatMap((routine) => routine.workouts)
        .uniqueByKey((item) => item.id)
        .length;

    expect(actualLength, expectedLength);
  });

  test("Built in workouts should not contain duplicate identifiers", () {
    final actualLength =
        builtInRoutines.flatMap((routine) => routine.workouts).length;
    final expectedLength = builtInRoutines
        .flatMap((routine) => routine.workouts)
        .uniqueByKey((item) => item.identifier)
        .length;

    expect(actualLength, expectedLength);
  });

  test("Every built in workout should have an ID of at least three billion",
      () {
    final item = builtInRoutines
        .flatMap((routine) => routine.workouts)
        .where((item) => item.id < 3000000000)
        .firstOrNull;

    expect(null, item);
  });

  test("Every routine should have a non-zero amount of workouts", () {
    final isAnySetListEmpty = builtInRoutines
        .flatMap((routine) => routine.workouts)
        .map((exercise) => exercise.exercises)
        .any((exerciseList) => exerciseList.isEmpty);

    expect(false, isAnySetListEmpty);
  });

  test("Every workout should have a non-zero amount of sets", () {
    final isAnySetListEmpty = builtInRoutines
        .flatMap((routine) => routine.workouts)
        .flatMap((workout) => workout.exercises)
        .map((exercise) => exercise.sets)
        .any((setList) => setList.isEmpty);

    expect(false, isAnySetListEmpty);
  });
}
