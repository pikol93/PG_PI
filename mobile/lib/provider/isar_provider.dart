import "package:isar/isar.dart";
import "package:path_provider/path_provider.dart";
import "package:pi_mobile/provider/exercise/one_rep_max_history.dart";
import "package:pi_mobile/provider/heart_rate/heart_rate.dart";
import "package:pi_mobile/provider/session/session.dart";
import "package:pi_mobile/provider/tracks/track.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "isar_provider.g.dart";

@Riverpod(keepAlive: true)
class IsarInstance extends _$IsarInstance {
  static const schemas = [
    HeartRateSchema,
    TrackSchema,
    OneRepMaxHistorySchema,
    SessionSchema,
  ];

  @override
  Future<Isar> build() async {
    final a = await getApplicationDocumentsDirectory();
    return Isar.open(
      schemas,
      directory: a.path,
    );
  }
}
