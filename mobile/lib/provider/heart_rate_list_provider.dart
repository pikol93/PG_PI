import "package:pi_mobile/data/heart_rate_entry.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "heart_rate_list_provider.g.dart";

@Riverpod(keepAlive: true)
class HeartRateList extends _$HeartRateList {
  @override
  Future<List<HeartRateEntry>> build() async => [];
}
