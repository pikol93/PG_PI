import "package:collection/collection.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/data/routine/routine_with_usage.dart";
import "package:pi_mobile/provider/routine/routines_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "routines_with_usage_provider.g.dart";

@riverpod
Future<List<RoutineWithUsage>> routinesWithUsage(Ref ref) async {
  final routines = await ref.watch(routinesProvider.future);

  return routines
      .map(
        (item) => RoutineWithUsage(
          routine: item,
          usages: [],
        ),
      )
      .toList();
}

@riverpod
Future<List<RoutineWithUsage>> routinesWithUsageSortedByName(Ref ref) async {
  final routines = await ref.watch(routinesWithUsageProvider.future);

  return routines.sortWith(
    (item) => item.routine.name,
    Order.from(compareNatural),
  );
}

@riverpod
Future<List<RoutineWithUsage>> routinesWithUsageSortedByTime(Ref ref) async {
  final epoch0DateTime = DateTime.fromMillisecondsSinceEpoch(0);
  final routines = await ref.watch(routinesWithUsageProvider.future);

  return routines
      .sortWithDate(
        (item) => item.getMostRecentDateTime().getOrElse(() => epoch0DateTime),
      )
      .toList();
}

@riverpod
Future<List<RoutineWithUsage>> routinesWithUsageLastMonthSortedByTime(
  Ref ref,
) async {
  final routines =
      await ref.watch(routinesWithUsageSortedByTimeProvider.future);
  final lastMonthDate = DateTime.now().subtract(const Duration(days: 30));

  return routines
      .where(
        (item) => item
            .getMostRecentDateTime()
            .map((date) => date.isAfter(lastMonthDate))
            .getOrElse(() => false),
      )
      .toList();
}
