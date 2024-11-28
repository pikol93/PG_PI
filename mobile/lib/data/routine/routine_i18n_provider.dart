import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/data/preferences/date_formatter_provider.dart";
import "package:pi_mobile/utility/map.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "routine_i18n_provider.g.dart";

@riverpod
RoutineI18N routineI18N(Ref ref) {
  final translationMap =
      ref.watch(currentLocaleProvider).translations.routines.routines;

  return RoutineI18N(
    translationMap: translationMap,
  );
}

class RoutineI18N {
  final Map<String, dynamic> translationMap;

  RoutineI18N({required this.translationMap});

  Option<String> name(String identifier) => routineMap(identifier)
      .map((routineMap) => routineMap.get("name"))
      .flatMap((value) => value)
      .filter((value) => value is String)
      .map((value) => value as String);

  Option<String> workoutName(String identifier, String workoutIdentifier) =>
      routineMap(identifier)
          .map((routineMap) => routineMap.get("workouts"))
          .flatMap((routineMap) => routineMap)
          .filter((workoutMap) => workoutMap is Map<String, dynamic>)
          .map((workoutMap) => workoutMap as Map<String, dynamic>)
          .map((workoutMap) => workoutMap.get(workoutIdentifier))
          .flatMap((value) => value)
          .filter((value) => value is String)
          .map((value) => value as String);

  Option<Map<String, dynamic>> routineMap(String identifier) => translationMap
      .get(identifier)
      .filter((routineMap) => routineMap is Map<String, dynamic>)
      .map((routineMap) => routineMap as Map<String, dynamic>);
}
