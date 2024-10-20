import "package:fl_chart/fl_chart.dart";
import "package:pi_mobile/provider/heart_rate_list_provider.dart";
import "package:riverpod_annotation/riverpod_annotation.dart";

part "heart_rate_chart_data_provider.g.dart";

@Riverpod(keepAlive: true)
class HeartRateChartData extends _$HeartRateChartData {
  @override
  List<FlSpot> build() {
    final heartRateList = ref.watch(heartRateListProvider);
    return heartRateList
        .map(
          (entry) => FlSpot(
            entry.dateTime.millisecondsSinceEpoch.toDouble(),
            entry.beatsPerMinute,
          ),
        )
        .toList();
  }
}
