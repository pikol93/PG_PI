import "package:flutter_riverpod/flutter_riverpod.dart";
import "package:pi_mobile/provider/routine/built_in_routines_provider.dart";
import "package:pi_mobile/provider/routine/routine.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "routines_provider.g.dart";

@riverpod
Future<List<Routine>> routines(Ref ref) async =>
    ref.watch(builtInRoutinesProvider);

@riverpod
Future<Map<int, Routine>> routinesMap(Ref ref) async {
  final routines = await ref.watch(routinesProvider.future);

  final entries = routines.map((item) => MapEntry(item.id, item));
  return Map.fromEntries(entries);
}
