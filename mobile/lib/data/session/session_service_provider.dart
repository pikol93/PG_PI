import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:isar/isar.dart";
import "package:pi_mobile/data/isar_provider.dart";
import "package:pi_mobile/data/session/session.dart";
import "package:pi_mobile/utility/task.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "session_service_provider.g.dart";

@riverpod
Future<List<Session>> sessions(Ref ref) async {
  final service = await ref.watch(sessionServiceProvider.future);
  return service.readAllSortedByDateDescending().run();
}

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

  Task<List<Session>> readList(List<int> sessionIds) => sessionIds
      .map(
        (id) => Task(
          () => isar.sessions.where().idEqualTo(id).findFirst(),
        ),
      )
      .joinAll()
      .map(
        (list) =>
            list.where((item) => item != null).map((item) => item!).toList(),
      );
}
