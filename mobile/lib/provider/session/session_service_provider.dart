import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:isar/isar.dart";
import "package:pi_mobile/provider/isar_provider.dart";
import "package:pi_mobile/provider/session/session.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "session_service_provider.g.dart";

@riverpod
Future<SessionService> sessionService(Ref ref) async {
  final isar = await ref.watch(isarInstanceProvider.future);
  return SessionService(ref: ref, isar: isar);
}

class SessionService {
  final Ref ref;
  final Isar isar;

  SessionService({required this.ref, required this.isar});

  Task<List<Session>> readAllSortedByDateDescending() => Task(
        () => isar.sessions.where().sortByStartDateDesc().findAll(),
      );

  Task<List<Session>> readAllForRoutineSortedByDateDescending(
    int routineId,
  ) =>
      Task(
        () => isar.sessions
            .where()
            .routineIdEqualTo(routineId)
            .sortByStartDateDesc()
            .findAll(),
      );

  Task<List<Session>> readAllForRoutineAndWorkoutSortedByDateDescending(
    int routineId,
    int workoutId,
  ) =>
      Task(
        () => isar.sessions
            .where()
            .routineIdWorkoutIdEqualTo(routineId, workoutId)
            .sortByStartDateDesc()
            .findAll(),
      );

  Task<void> save(Session session) => Task(
        () => isar.writeTxn(
          () => isar.sessions.put(session),
        ),
      );
}
