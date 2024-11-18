import "package:isar/isar.dart";
import "package:path_provider/path_provider.dart";
import "package:pi_mobile/data/collections/heart_rate.dart";
import "package:pi_mobile/data/collections/one_rep_max_history.dart";
import "package:pi_mobile/data/collections/track.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "isar_provider.g.dart";

@Riverpod(keepAlive: true)
class IsarInstance extends _$IsarInstance {
  static const schemas = [
    HeartRateSchema,
    TrackSchema,
    OneRepMaxHistorySchema,
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
