import "dart:convert";

import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:fpdart/fpdart.dart";
import "package:pi_mobile/data/routine/active_session.dart";
import "package:pi_mobile/logger.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";
import "package:shared_preferences/shared_preferences.dart";

part "active_session_service_provider.g.dart";

@riverpod
Option<ActiveSession> activeSessionOrNone(Ref ref) =>
    ref.watch(activeSessionProvider).when(
          data: (data) => data,
          error: (obj, stackTrace) => const Option.none(),
          loading: Option.none,
        );

@riverpod
Future<Option<ActiveSession>> activeSession(Ref ref) =>
    ref.watch(activeSessionServiceProvider).read().run();

@riverpod
ActiveSessionService activeSessionService(Ref ref) =>
    ActiveSessionService(ref: ref);

class ActiveSessionService with Logger {
  static const _keyName = "active_session";

  final Ref ref;

  ActiveSessionService({required this.ref});

  Task<Option<ActiveSession>> read() => Task(() async {
        final storedJson = await SharedPreferencesAsync().getString(_keyName);
        if (storedJson == null) {
          logger.debug("No stored active session found.");
          return const Option.none();
        }

        try {
          final activeSession = ActiveSession.fromJson(jsonDecode(storedJson));
          return Option.of(activeSession);
        } catch (ex) {
          logger.warning("Could not decode active session. Data: $storedJson");
          return const Option.none();
        }
      });

  Task<void> save(ActiveSession activeSession) => Task(() async {
        final json = jsonEncode(activeSession);
        await SharedPreferencesAsync().setString(_keyName, json);
        ref.invalidateSelf();
      });

  Task<void> clear() => Task(() async {
        await SharedPreferencesAsync().remove(_keyName);
        ref.invalidateSelf();
      });
}
