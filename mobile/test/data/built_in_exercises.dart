import "package:flutter_test/flutter_test.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/data/built_in_exercises.dart";

void main() {
  test("Built in exercises should not contain duplicate IDs", () {
    final idList = builtInExercises.map((item) => item.id).toList();
    final idSet = idList.toSet();
    expect(idSet.length, idList.length);
  });

  test("Built in exercises should not contain duplicate identifiers", () {
    final idList = builtInExercises.map((item) => item.identifier).toList();
    final idSet = idList.toSet();
    expect(idSet.length, idList.length);
  });

  test("Every built in exercise should contain at least one muscle group", () {
    final item = builtInExercises
        .where((item) => item.primaryMuscleGroups.isEmpty)
        .firstOrNull;

    expect(null, item);
  });

  test("Every built in exercise should have an ID of at least one billion", () {
    final item =
        builtInExercises.where((item) => item.id < 1000000000).firstOrNull;

    expect(null, item);
  });

  test(
      "Primary and secondary muscle groups should not be duplicated for any"
      " built in exercise", () {
    final item = builtInExercises
        .where(
          (item) =>
              item.primaryMuscleGroups
                  .concat(item.secondaryMuscleGroups ?? [])
                  .toList()
                  .length !=
              item.primaryMuscleGroups
                  .concat(item.secondaryMuscleGroups ?? [])
                  .toSet()
                  .length,
        )
        .firstOrNull;

    expect(null, item);
  });
}
