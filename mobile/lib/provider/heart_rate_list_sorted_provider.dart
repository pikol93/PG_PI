import "package:collection/collection.dart";
import "package:pi_mobile/data/heart_rate_entry.dart";
import "package:pi_mobile/provider/heart_rate_list_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "heart_rate_list_sorted_provider.g.dart";

@Riverpod(keepAlive: true)
class SortedHeartRateList extends _$SortedHeartRateList {
  @override
  List<HeartRateEntry> build() => ref
      .watch(heartRateListProvider)
      .sortedBy((entry) => entry.dateTime)
      .reversed
      .toList();
}
