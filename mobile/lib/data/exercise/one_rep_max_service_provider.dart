import "package:collection/collection.dart";
import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:isar/isar.dart";
import "package:pi_mobile/data/exercise/one_rep_max_history.dart";
import "package:pi_mobile/data/isar_provider.dart";
import "package:pi_mobile/logger.dart";
import "package:pi_mobile/utility/datetime.dart";
import "package:pi_mobile/utility/iterable.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:table_calendar/table_calendar.dart";

part "one_rep_max_service_provider.g.dart";

@riverpod
Future<OneRepMaxService> oneRepMaxService(Ref ref) async {
  final isar = await ref.watch(isarInstanceProvider.future);
  return OneRepMaxService(
    ref: ref,
    isar: isar,
  );
}

class OneRepMaxService with Logger {
  final Ref ref;
  final Isar isar;

  OneRepMaxService({
    required this.ref,
    required this.isar,
  });

  Task<Option<OneRepMaxHistory>> findOneRepMaxHistoryForExercise(
    int exerciseId,
  ) =>
      Task(() async {
        final oneRepMax = await isar.oneRepMaxHistorys
            .where()
            .exerciseIdEqualTo(exerciseId)
            .findFirst();

        return Option.fromNullable(oneRepMax);
      });

  Task<Option<double>> getOneRepMax(int exerciseId, DateTime dateTime) =>
      Task(() async {
        final oneRepMaxHistory = await isar.oneRepMaxHistorys
            .where()
            .exerciseIdEqualTo(exerciseId)
            .findFirst();

        if (oneRepMaxHistory == null) {
          return const Option.none();
        }

        final oneRepMaxEntry = oneRepMaxHistory.oneRepMaxHistory
            .firstWhereOrNull((item) => isSameDay(item.dateTime, dateTime));

        if (oneRepMaxEntry == null) {
          return const Option.none();
        }

        return Option.of(oneRepMaxEntry.value);
      });

  Task<void> insertEntry(
    int exerciseId,
    DateTime date,
    double value,
  ) =>
      Task(() async {
        logger.debug("Inserting 1RM entry: $exerciseId, $date, $value");
        await isar.writeTxn(() async {
          final history = await isar.oneRepMaxHistorys
                  .where()
                  .exerciseIdEqualTo(exerciseId)
                  .findFirst() ??
              OneRepMaxHistory.emptyWithExerciseId(exerciseId);

          final newEntry = OneRepMaxEntry()
            ..dateTime = date.toMidnightSameDay()
            ..value = value;

          // Clone the existing history so that the fixed-length array does
          // not get modified.
          history.oneRepMaxHistory = List.filled(1, newEntry)
              .concat(history.oneRepMaxHistory)
              .uniqueByKey((item) => item.dateTime)
              .sortBy(
                Order.by((item) => item.dateTime, Order.orderDate.reverse),
              )
              .toList();

          await isar.oneRepMaxHistorys.put(history);
        });

        ref.invalidateSelf();
      });

  Task<void> removeEntry(
    int exerciseId,
    DateTime date,
  ) =>
      Task(() async {
        logger.debug("Removing entry for $exerciseId, $date");

        await isar.writeTxn(() async {
          final history = await isar.oneRepMaxHistorys
              .where()
              .exerciseIdEqualTo(exerciseId)
              .findFirst();

          if (history == null) {
            logger.debug("No entry to remove: $exerciseId, $date");
            return;
          }

          // Clone the existing history so that the fixed-length array does
          // not get modified.
          history.oneRepMaxHistory = history.oneRepMaxHistory
              .where((item) => !isSameDay(item.dateTime, date))
              .toList();

          await isar.oneRepMaxHistorys.put(history);
        });

        ref.invalidateSelf();
      });

  Task<void> clear() => Task(() async {
        await isar.writeTxn(() async {
          await isar.oneRepMaxHistorys.clear();
        });

        ref.invalidateSelf();
      });
}
